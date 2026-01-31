import 'package:get/get.dart';
import 'package:six_pos/data/api/api_checker.dart';
import 'package:six_pos/features/account_management/controllers/transaction_controller.dart';
import 'package:six_pos/features/counter/domain/models/counter.dart';
import 'package:six_pos/features/counter/domain/models/counter_details_model.dart';
import 'package:six_pos/features/counter/domain/models/counter_model.dart';
import 'package:six_pos/features/counter/domain/repositories/counter_repo.dart';
import 'package:six_pos/helper/show_custom_snackbar_helper.dart';

class CounterController extends GetxController implements GetxService{
  final CounterRepo counterRepo;
  CounterController({required this.counterRepo});


  bool _isLoading = false;
  bool _isDeleteButtonLoading = false;
  CounterModel? _counterModel;
  CounterDetailsModel? _counterDetailsModel;
  List<Counter>? _activeCounterList;


  bool get isLoading => _isLoading;
  bool get isDeleteButtonLoading => _isDeleteButtonLoading;
  CounterModel? get counterModel => _counterModel;
  CounterDetailsModel? get counterDetailsModel => _counterDetailsModel;
  List<Counter>? get activeCounterList => _activeCounterList;


  Future<void> getCounterList ({int? offset, bool isUpdate = true, int limit = 10, String? searchText}) async {
    _isLoading = true;
    _counterModel = null;

    if(isUpdate){
      update(['counter-list']);
    }


    Response response = await counterRepo.getCounterList(searchText: searchText);

    if(response.statusCode == 200) {
      _counterModel = CounterModel.fromJson(response.body);
      if (_counterModel?.counter != null) {
        _activeCounterList = [];
        _activeCounterList = _counterModel!.counter!.where((items) => items.status == 1).toList();
      }
    }else {
      ApiChecker.checkApi(response);
    }
    _isLoading = false;
    update(['counter-list']);
  }


  Future<void> addCounter ({required String name, required String number, required String description}) async {
    _isLoading = true;
    update();

    Response response = await counterRepo.addCounter(name: name, number: number, description: description);
    if(response.statusCode == 200) {
      Get.back();
      await getCounterList();
      showCustomSnackBarHelper("counter_added_successfully".tr, isError: false);
    }else {
      ApiChecker.checkApi(response);
      showCustomSnackBarHelper("${response.body['errors'][0]['message']}", isError: true);
    }
    _isLoading = false;
    update();
  }

  Future<void> updateCounter ({required int id, required String name, required String number, required String description}) async {
    _isLoading = true;
    update();

    Response response = await counterRepo.updateCounter(id: id, name: name, number: number, description: description);
    if(response.statusCode == 200) {
      await getCounterList();
    }else {
      ApiChecker.checkApi(response);
    }
    _isLoading = false;
    update();
  }

  Future<void> deleteCounter ({required int id}) async {
    _isDeleteButtonLoading = true;
    update(['delete_counter']);

    Response response = await counterRepo.deleteCounter(id: id);
    if(response.statusCode == 200) {
      showCustomSnackBarHelper('counter_deleted_successfully'.tr, isError: false);
      Get.back();
      await getCounterList();
    }else {
      ApiChecker.checkApi(response);
    }
    _isDeleteButtonLoading = false;
    update(['delete_counter']);

  }

  Future<void> getCounterDetails ({required int counterID, bool isUpdate = true}) async {
    _isLoading = true;
    if(isUpdate){
      update(['counter-details']);
    }

    Response response = await counterRepo.getCounterDetails(counterID: counterID,offset: 1);
    if(response.statusCode == 200) {
      _counterDetailsModel = null;
      _counterDetailsModel = CounterDetailsModel.fromJson(response.body);

    }else {
      ApiChecker.checkApi(response);
    }
    _isLoading = false;
    update(['counter-details']);
  }


  Future<void> getCounterSearchDetails ({required int? offset, required int counterID, bool isUpdate = true, String? searchText}) async {
    _isLoading = true;
    if(isUpdate){
      update(['counter-search-details']);
    }

    Response response = await counterRepo.getCounterDetails(counterID: counterID, searchText: searchText, offset: offset);
    if(response.statusCode == 200) {
      if(offset == 1){
        _counterDetailsModel = null;
        _counterDetailsModel = CounterDetailsModel.fromJson(response.body);
      }else{
        _counterDetailsModel?.offset = CounterDetailsModel.fromJson(response.body).offset;
        _counterDetailsModel?.total = CounterDetailsModel.fromJson(response.body).total;
        _counterDetailsModel?.limit = CounterDetailsModel.fromJson(response.body).limit;
        _counterDetailsModel?.orders?.addAll(CounterDetailsModel.fromJson(response.body).orders ?? []) ;
      }

    }else {
      ApiChecker.checkApi(response);
    }
    _isLoading = false;
    update(['counter-search-details','counter-details']);
  }


  Future<void> changeStatusCounter ({required int id, required int index, required int status}) async {
    Response response = await counterRepo.changeStatusCounter(id: id);
    if(response.statusCode == 200) {
      _counterModel?.counter?[index].status = status;
      showCustomSnackBarHelper('counter_status_change_successfully'.tr, isError: false);
    }else {
      ApiChecker.checkApi(response);
    }
    update(['change_status_counter']);

    if(status == 1){
      _activeCounterList?.add(_counterModel!.counter![index]);
    }else{
      _activeCounterList?.removeWhere((counter){
        return counter.id == id;
      });
    }

    final TransactionController transactionController = Get.find();
    transactionController.setSelectedCounterNumberID();

    update(['counter-list']);

  }

}