import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:six_pos/common/models/account_model.dart';
import 'package:six_pos/common/models/customer_model.dart';
import 'package:six_pos/data/api/api_checker.dart';
import 'package:six_pos/features/account_management/controllers/transaction_controller.dart';
import 'package:six_pos/features/counter/domain/models/counter.dart';
import 'package:six_pos/features/counter/domain/models/counter_model.dart';
import 'package:six_pos/features/order/domain/models/invoice_model.dart';
import 'package:six_pos/common/models/order_model.dart';
import 'package:six_pos/features/order/domain/reposotories/order_repo.dart';
import 'package:six_pos/helper/show_custom_snackbar_helper.dart';

class OrderController extends GetxController implements GetxService{
  final OrderRepo orderRepo;
  OrderController({required this.orderRepo});

  OrderModel? _orderModel;
  OrderModel? get orderModel => _orderModel;


  Invoice? _invoice;
  Invoice? get invoice => _invoice;
  DateTime? startDate;
  DateTime? endDate;
  int tabIndex = 0;
  List<String> filterTypes = ['all','completed', 'refunded'];
  Set<int> _selectedPaymentMethodId = {};
  int? counterId;
  int? customerId;
  TextEditingController searchController = TextEditingController();
  TextEditingController customerSearchController = TextEditingController();
  CounterModel? counterModel;
  int counterSelectIndex = 0;
  CustomerModel? customerModel;
  bool isLoading = false;
  Orders? orderDetail;
  int? _selectedRefundAdminAccountId;
  List<Accounts>? _adminWalletList;
  List<Accounts>? get adminWalletList => _adminWalletList;
  int? get selectedRefundAdminAccountId => _selectedRefundAdminAccountId;
  List<String> _refundCustomerWalletList = ['cash', 'other'];
  String? _selectedWalletCustomer = 'cash';
  List<String>? get refundCustomerWalletList => _refundCustomerWalletList;
  String? get selectedWalletCustomer => _selectedWalletCustomer;
  Set<int> get selectedPaymentMethodId => _selectedPaymentMethodId;


  void onUpdateCounterId(int index){
    counterSelectIndex = index;
    counterId = counterModel?.counter?[index].id;

    update();
  }

  void onUpdateCustomerId(int? id){
    customerId = id;
  }

  void clearFilter({bool isUpdate = true, bool formOrderScreen = false}){
     counterId = null;
     customerId = null;
     if(formOrderScreen){
       startDate = null;
       endDate = null;
     }
     counterSelectIndex = 0;
     searchController.clear();
     _selectedPaymentMethodId.clear();
     if(isUpdate){
       update();
     }
  }

  void onUpdatePaymentMethod(int? id){

    if(id == null) return;

    if(_selectedPaymentMethodId.contains(id)){
      _selectedPaymentMethodId.remove(id);
    }else{
      _selectedPaymentMethodId.add(id);
    }

    update();
  }

  void onUpdateStartAndEndDate({DateTime? startDate, DateTime? endDate}){
    this.startDate = startDate;
    this.endDate = endDate;
    Get.find<OrderController>().getOrderList(1);
  }

  void onUpdateTabIndex (int index, {bool isUpdate = true}){
    tabIndex = index;
    getOrderList(1, isUpdate: isUpdate);
  }

  Future<void> getCounterList () async {
    counterModel = null;

    Response response = await orderRepo.getCounterList();

    if(response.statusCode == 200) {
      counterModel = CounterModel.fromJson(response.body);
      counterModel?.counter?.insert(0,Counter(name: 'all_counter'));
    }else {
      ApiChecker.checkApi(response);
    }
  }

  Future<void> getOrderList(int? offset, {bool isUpdate = true}) async {

    if(offset == 1) {
      _orderModel = null;

      if(isUpdate) {
        update();
      }
    }

    Response response = await orderRepo.getOrderList(
      offset,
      type: filterTypes[tabIndex],
      startDate: startDate,
      endDate: endDate,
      customerId: customerId,
      counterId: counterId,
      searchText: searchController.text,
      paymentMethod: _selectedPaymentMethodId.toList(),
    );

    if(response.statusCode == 200) {
      if(offset == 1) {
        _orderModel = OrderModel.fromJson(response.body);
      }else {
        _orderModel?.offset = OrderModel.fromJson(response.body).offset;
        _orderModel?.total = OrderModel.fromJson(response.body).total;
        _orderModel?.orders?.addAll(OrderModel.fromJson(response.body).orders ?? []);

      }
    }else {
      ApiChecker.checkApi(response);
    }
    update();
  }

  Future<void> customerSearch(String search) async {
    customerModel = null;

    Response response = await orderRepo.customerSearch(search);

    if(response.statusCode == 200 && response.body != null) {
      customerModel = CustomerModel.fromJson(response.body);

    }else {
      ApiChecker.checkApi(response);
    }
    update();
  }

  Future<void> getInvoiceData(int? orderId) async {
    Response response = await orderRepo.getInvoiceData(orderId);
    if(response.statusCode == 200) {
     _invoice = InvoiceModel.fromJson(response.body).invoice;

    }else {
      ApiChecker.checkApi(response);
    }
    update();
  }

  String? getBluetoothMacAddress() => orderRepo.getBluetoothAddress();

  void setBluetoothMacAddress(String? address) => orderRepo.setBluetoothAddress(address);


  Future<void> sendRefundRequest({required int orderId, required String orderAmount, String? orderNote, String? adminWallet, String? customerWallet, String? paymentMethod, String? paymentInfo}) async {
    isLoading = true;
    update();

    Response response = await orderRepo.sendRefundRequest(orderId: orderId, orderAmount: orderAmount,orderNote: orderNote, adminWallet: adminWallet, customerWallet: customerWallet, paymentInfo: paymentInfo, paymentMethod: paymentMethod);

    if(response.statusCode == 200 && response.body != null) {
      Get.back();
      showCustomSnackBarHelper('refund_request_send_successfully'.tr,isError: false);
      getOrderDetails(orderId: orderId);
    }else {
      ApiChecker.checkApi(response);
    }
    isLoading = false;
    update();
  }

  Future<void> getOrderDetails({required int orderId, bool isUpdate = true}) async {
    orderDetail = null;

    if(isUpdate){
      update();
    }

    Response response = await orderRepo.getOrderDetails(orderId);

    if(response.statusCode == 200 && response.body != null) {
      orderDetail = Orders.fromJson(response.body);
    }else {
      ApiChecker.checkApi(response);
    }

    getAdminWalletList();
    update();
  }

  void updateRefundAdminAccountId(int? id){
    _selectedRefundAdminAccountId = id;
    update();
  }

  void getAdminWalletList(){
    _adminWalletList = [];
    if(Get.find<TransactionController>().accountWithWalletList != null)
      _adminWalletList?.addAll(Get.find<TransactionController>().accountWithWalletList!);

    _adminWalletList?.removeWhere((accounts){
      return accounts.account == 'Wallet';
    });

    if(orderDetail?.customer?.id != 0){
      _refundCustomerWalletList = ['cash', 'wallet', 'other'];
    }else{
      _refundCustomerWalletList = ['cash', 'other'];
    }

    _selectedRefundAdminAccountId = _adminWalletList?[0].id;
    _selectedWalletCustomer = 'cash';
  }

  void updateRefundCustomerWallet(String? walletMethod){
    _selectedWalletCustomer = walletMethod;
    update();
  }

}