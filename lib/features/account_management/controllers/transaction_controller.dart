import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:six_pos/common/controllers/account_controller.dart';
import 'package:six_pos/common/controllers/cart_controller.dart';
import 'package:six_pos/data/api/api_checker.dart';
import 'package:six_pos/common/models/account_model.dart';
import 'package:six_pos/features/account_management/domain/models/transaction_model.dart';
import 'package:six_pos/features/account_management/domain/models/transaction_type_model.dart';
import 'package:six_pos/features/account_management/domain/reposotories/transaction_repo.dart';
import 'package:six_pos/features/counter/controllers/counter_controller.dart';
import 'package:six_pos/features/counter/domain/models/counter.dart';
import 'package:six_pos/helper/show_custom_snackbar_helper.dart';

class TransactionController extends GetxController implements GetxService{
  final TransactionRepo transactionRepo;
  TransactionController({required this.transactionRepo});


  bool _isLoading = false;
  bool _isFirst = true;
  int? _selectedCounterID;
  int? _transactionListLength;
  List<Transfers>? _transactionList = [];
  TransactionTypeModel? _transactionTypeModel;
  int? _transactionTypeId;
  String? _transactionTypeName;
  int? _fromAccountIndex;
  int? _toAccountIndex;
  int? _selectedFromAccountId;
  int? _selectedToAccountId = 0;
  List<int?>? _fromAccountIds;
  List<int?>? _toAccountIds;
  List<Accounts>? _accountList;
  List<Accounts>? _accountWithWalletList;
  String? _transactionExportFilePath = '';
  bool _filterIaActive = false;
  bool _filterClick = false;
  int _offset = 1;

  ScrollController scrollController = ScrollController();


  bool get isFirst => _isFirst;
  bool get isLoading => _isLoading;
  int? get selectedCounterID => _selectedCounterID;
  int? get transactionListLength => _transactionListLength;
  List<Transfers>? get transactionList => _transactionList;
  TransactionTypeModel? get transactionTypeModel => _transactionTypeModel;
  int? get transactionTypeId => _transactionTypeId;
  String? get transactionTypeName => _transactionTypeName;

  int? get fromAccountIndex => _fromAccountIndex;
  set setFromAccountIndex(int? index)=> _fromAccountIndex = index;

  int? get toAccountIndex => _toAccountIndex;

  int? get selectedFromAccountId => _selectedFromAccountId;
  set setSelectedFromAccountId(int? id)=> _selectedFromAccountId = id;

  int? get selectedToAccountId => _selectedToAccountId;
  List<int?>? get fromAccountIds => _fromAccountIds;
  List<int?>? get toAccountIds => _toAccountIds;
  List<Accounts>? get accountList =>_accountList;
  List<Accounts>? get accountWithWalletList => _accountWithWalletList;
  String? get transactionExportFilePath =>_transactionExportFilePath;
  bool get filterIaActive => _filterIaActive;
  bool get filterClick => _filterClick;
  int get offset => _offset;


  double subTotal = 0, productDiscount = 0, total = 0, payable = 0, couponAmount = 0, extraDiscount = 0, productTax = 0, xxDiscount = 0;



  @override
  void onInit() {
    super.onInit();
    scrollController.addListener(() {
      if(scrollController.position.maxScrollExtent == scrollController.position.pixels
          && transactionList != null && transactionList!.isNotEmpty && !_isLoading) {

        if(_offset < _transactionListLength! ) {
          _offset++;
         showBottomLoader();
          if(_filterIaActive){
            String selectedStartDate = '';
            String selectedEndDate = '';
            selectedStartDate = dateFormat.format(startDate!).toString();
            selectedEndDate = dateFormat.format(endDate!).toString();
            getTransactionFilter(selectedStartDate, selectedEndDate,
                Get.find<AccountController>().selectedAccountId, transactionTypeName ?? 'income', offset, reload: false );
          }else{
            Get.find<TransactionController>().getTransactionList(offset, reload: false);
          }

        }
      }

    });
  }


  Future<void> getTransactionList(int offset, {bool reload = true, bool isUpdate = true}) async {
    _offset = offset;

    if(reload || _transactionList == null || offset == 1){
      _transactionList = null;
      _isLoading = true;
      _filterClick = false;
      _filterIaActive = false;
      if(isUpdate){
        update();
      }
    }


    Response response = await transactionRepo.getTransactionList(offset);
    if(response.statusCode == 200) {
      _transactionList ??= [];
      _transactionList?.addAll(TransactionModel.fromJson(response.body).transferList ?? []);
      _transactionListLength = TransactionModel.fromJson(response.body).totalSize;
      _isLoading = false;
      _isFirst = false;
    }else {
      ApiChecker.checkApi(response);
    }
    update();
  }

  Future<void> getCustomerWiseTransactionListList(int? customerId ,int offset, {bool reload = true, bool isUpdate = true}) async {
    if(reload || _transactionList == null || offset == 1){
      _transactionList = null;
      _isFirst = true;
      if(isUpdate){
        update();
      }
    }

    _offset =offset;
    _isLoading = true;
    Response response = await transactionRepo.getCustomerWiseTransactionList(customerId, offset);
    if(response.statusCode == 200) {
      _transactionList ??=  [];
      _transactionList?.addAll(TransactionModel.fromJson(response.body).transferList ?? []);
      _transactionListLength = TransactionModel.fromJson(response.body).totalSize;
      _isLoading = false;
      _isFirst = false;
    }else {
      ApiChecker.checkApi(response);
    }
    _isLoading = false;
    update();
  }

  Future<void> getTransactionTypeList() async {
    _transactionTypeId = null;
    _transactionTypeName = null;
    Response response = await transactionRepo.getTransactionTypeList();

    if(response.statusCode == 200 && response.body != null) {
      _transactionTypeModel = TransactionTypeModel.fromJson(response.body);

    }else {
      ApiChecker.checkApi(response);
    }
    update();
  }

  Future<void> getTransactionFilter(String startDate, String endDate, int? accountId, String? accountType, int offset, {bool reload = true}) async {
    _offset =offset;
    if(reload || offset == 1 || _transactionList == null){
      _transactionList = [];
      _filterClick = true;
      _filterIaActive = true;
      update();
    }
    _isLoading = true;


    Response response = await transactionRepo.getTransactionFilter(startDate, endDate, accountId, accountType,offset);
    if(response.statusCode == 200) {
      _transactionList?.addAll(TransactionModel.fromJson(response.body).transferList ?? []);
      _transactionListLength = (TransactionModel.fromJson(response.body).totalSize!/10).ceil()+1;
      _isLoading = false;
      _isFirst = false;
      _filterClick = false;
    }else {
      _isLoading = false;
      _isFirst = false;
      _filterClick = false;
      ApiChecker.checkApi(response);
    }
    update();
  }

  Future<void> addTransaction(Transfers transfer, int? fromAccountId, int? toAccountId) async {
    _isLoading = true;
    Response response = await transactionRepo.addNewTransaction(transfer, fromAccountId, toAccountId);
    if(response.statusCode == 200) {
      getTransactionList(1);
      Get.back();
      showCustomSnackBarHelper('transaction_added_successfully'.tr,  isError: false);
      _isLoading = false;
    }else {
      _isLoading = false;
      ApiChecker.checkApi(response);
    }
    _isLoading = false;
    update();
  }

  Future<void> getTransactionAccountList( int offset) async {
    _fromAccountIndex = null;
    _toAccountIndex = null;
    _fromAccountIds = null;
    _toAccountIds = null;
    _isLoading = true;
    Response response = await transactionRepo.getTransactionAccountList(offset);
    if(response.statusCode == 200) {
      _accountList = [];
      _accountList!.addAll(AccountModel.fromJson(response.body).accountList!);
      if(_accountList!.isNotEmpty){
        for(int index = 0; index < _accountList!.length; index++) {
          _fromAccountIds ??= [];
          _fromAccountIds?.add(_accountList![index].id);
        }
      }
      if(_accountList!.isNotEmpty){
        for(int index = 0; index < _accountList!.length; index++) {
          _toAccountIds ??= [];
          _toAccountIds?.add(_accountList![index].id);
        }
        // _toAccountIndex = _toAccountIds[0];
      }

      await getAccountListWithWallet();

      _isLoading = false;
      _isFirst = false;
    }else {
      ApiChecker.checkApi(response);
    }
    update();
  }

  Future<void> getAccountListWithWallet ({bool isUpdate = true}) async{
    Accounts walletModel = Accounts(
      id: (accountList?.last.id ?? 0) + 1,
      account: 'Wallet',
      description: '', balance: 0.0, accountNumber: '',
      totalIn: 0.0, totalOut: 0.0, createdAt: '',
      updatedAt: '',
    );

    _accountWithWalletList = [];
    _accountWithWalletList?.addAll(accountList ?? []);

    final CartController cartController = Get.find();
    if(cartController.customerId != 0 && !(cartController.customerSelectedName?.startsWith('wc') ?? false)){
      _accountWithWalletList?.insert(1, walletModel);
    }

    if(isUpdate){
      update();
    }

  }

  Future<void> exportTransactionList(String startDate, String endDate, int accountId, String transactionType) async {
    _isLoading = true;
    Response response = await transactionRepo.exportTransactionList(startDate, endDate, accountId, transactionType);
    if(response.statusCode == 200) {
      Map map = response.body;
      _transactionExportFilePath = map['excel_report'];
      _isLoading = false;
    }else {
      ApiChecker.checkApi(response);
    }
    _isLoading = false;
    update();
  }

  void showBottomLoader() {
    _isLoading = true;
    update();
  }

  void removeFirstLoading() {
    _isFirst = true;
    update();
  }

  void setAccountIndex(int? index, String type , bool notify) {
    if(type == 'from'){
      _fromAccountIndex = index;
      _selectedFromAccountId = _fromAccountIndex;
    }else{
      _toAccountIndex = index;
      _selectedToAccountId = _toAccountIndex;
    }

    if(notify) {
      update();
    }
  }

  void setTransactionTypeIndex(int? id , bool notify) {
    _transactionTypeId = id;

    for(Types type in  _transactionTypeModel?.typeList ?? []) {
      if(type.id == id) {
        _transactionTypeName = type.tranType;

        if(notify) {
          update();
        }

        break;

      }
    }

  }

  DateTime? _startDate;
  DateTime? _endDate;
  final DateFormat _dateFormat = DateFormat('yyyy-MM-d');
  DateTime? get startDate => _startDate;
  DateTime? get endDate => _endDate;
  DateFormat get dateFormat => _dateFormat;

  void selectDate(String type, BuildContext context){
    showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(DateTime.now().year - 5),
      lastDate: DateTime(DateTime.now().year + 5),
    ).then((date) {
      if (type == 'start'){
        _startDate = date;
      }else{
        _endDate = date;
      }
      if(date == null){

      }
      update();
    });
  }

  void resetDate({bool isUpdate = true}){
    _startDate = null;
    _endDate = null;

    if(isUpdate) {
      update();

    }
  }

  void clearAccountIndex() {
    _fromAccountIndex = null;
  }


  void setSelectedCounterNumberID({bool isUpdate = true, int? counterID}){
    final CounterController counterController = Get.find();
    Counter? counterModel;

    for (Counter counter in counterController.activeCounterList ?? []){
      if(counter.id == selectedCounterID){
        counterModel = counter;
      }
    }

    if(_selectedCounterID == null && (counterController.activeCounterList?.isNotEmpty ?? false)){
      _selectedCounterID = counterController.activeCounterList?[0].id;

    }else if(_selectedCounterID != null
        && !(counterController.activeCounterList?.contains(counterModel) ?? true)){
      _selectedCounterID = counterController.activeCounterList?[0].id;


    }else if(counterID != null){
      _selectedCounterID = counterID;

    }

    if(isUpdate){
      update();
    }
  }





}