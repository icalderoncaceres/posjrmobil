import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:six_pos/common/controllers/category_controller.dart';
import 'package:six_pos/common/controllers/filter_controller.dart';
import 'package:six_pos/features/auth/controllers/auth_controller.dart';
import 'package:six_pos/data/api/api_checker.dart';
import 'package:six_pos/features/brand/domain/models/brand_model.dart';
import 'package:six_pos/common/models/product_model.dart';
import 'package:six_pos/features/brand/domain/reposotories/brand_repo.dart';
import 'package:six_pos/helper/show_custom_snackbar_helper.dart';
import 'package:http/http.dart' as http;

class BrandController extends GetxController implements GetxService{
  final BrandRepo brandRepo;
  BrandController({required this.brandRepo});

  bool _isLoading = false;
  bool get isLoading => _isLoading;
  int? _brandListLength;
  int? get brandListLength => _brandListLength;
  BrandModel? _brandModel;
  BrandModel? get brandModel => _brandModel;
  int? _selectedBrandId;
  int? get selectedBrandId => _selectedBrandId;
  XFile? _brandImage;
  XFile? get brandImage=> _brandImage;

  BrandModel? _productFilterBrandModel;
  BrandModel? get productFilterBrandModel => _productFilterBrandModel;

  Set<int> _selectedProductBrandFilter = {};
  Set<int> get selectedProductBrandFilter => _selectedProductBrandFilter;

  BrandModel? _brandSuggestionList;
  BrandModel? get brandSuggestionList => _brandSuggestionList;
  String? searchText;
  int brandLocalStatus = 0;
  String? oldBrandImage;


  void pickImage(bool isRemove, {bool isUpdate = true}) async {
    if(isRemove) {
      _brandImage = null;
    }else {
      _brandImage = await ImagePicker().pickImage(source: ImageSource.gallery);
    }
    if(isUpdate) {
      update();
    }
  }

  Future<http.StreamedResponse> addBrand(String brandName, int? brandId, String description, int? index) async {
    _isLoading = true;
    update();
    http.StreamedResponse response = await brandRepo.addBrand(
      brandName,brandId, _brandImage,
      Get.find<AuthController>().getUserToken(),
      description, brandLocalStatus,
      brandId != null ? _brandModel?.brandList![index!].image : null,
      isUpdate: brandId != null,
    );

    if(response.statusCode == 200) {
      _brandImage = null;
      await getBrandList(1);
      _isLoading = false;
      Get.back();
      showCustomSnackBarHelper(brandId != null ? 'brand_updated_successfully'.tr : 'brand_added_successfully'.tr, isError: false);
      _brandImage = null;

    }else {
      ApiChecker.checkApi(await ApiChecker.getResponse(response));
    }
    _isLoading = false;
    update();
    return response;
  }

  Future<void> getBrandList(int offset, {Products? product, bool isUpdate = true, int limit = 10, String? startDate, String? endDate, String? sortingType, String? searchText}) async {

    if(offset == 1) {
      _brandModel = null;

      if(isUpdate) {
        update();
      }
    }

    Response response = await brandRepo.getBrandList(offset, limit, startDate: startDate, endDate: endDate, sortingType: sortingType, searchText: searchText);

    if(response.statusCode == 200 && response.body != null) {

      if(offset == 1) {
        _brandModel = BrandModel.fromJson(response.body);

      }else {
        _brandModel?.offset = BrandModel.fromJson(response.body).offset;
        _brandModel?.totalSize = BrandModel.fromJson(response.body).totalSize;
        _brandModel?.brandList?.addAll(BrandModel.fromJson(response.body).brandList ?? []);
      }

      if(product != null){
        onChangeBrandId(product.brand!.id, false);
      }

    }else {
      ApiChecker.checkApi(response);
    }

    update();
  }

  Future<void> deleteBrand(int? brandId, int? shiftedBrandId, bool fromDetailsScreen) async {
    _isLoading = true;
    Response response = await brandRepo.deleteBrand(brandId, shiftedBrandId);
    if(response.statusCode == 200) {
      getBrandList(1);
      _isLoading = false;
      Get.back();
      if(fromDetailsScreen){
        Get.back();
      }
      showCustomSnackBarHelper('brand_deleted_successfully'.tr, isError: false);

    }else {
      ApiChecker.checkApi(response);
    }
    _isLoading = false;
    update();
  }

  void onChangeBrandId(int? index, bool notify) {
    _selectedBrandId = index;
    if(notify) {
      update();
    }
  }

  Future<void> getProductFilterBrandList(int offset, {int limit = 10}) async {

    if(offset == 1) {
      _productFilterBrandModel = null;
    }

    Response response = await brandRepo.getBrandList(offset, limit);

    if(response.statusCode == 200 && response.body != null) {

      if(offset == 1) {
        _productFilterBrandModel = BrandModel.fromJson(response.body);

      }else {
        _productFilterBrandModel?.offset = BrandModel.fromJson(response.body).offset;
        _productFilterBrandModel?.totalSize = BrandModel.fromJson(response.body).totalSize;
        _productFilterBrandModel?.brandList?.addAll(BrandModel.fromJson(response.body).brandList ?? []);
      }

    }else {
      ApiChecker.checkApi(response);
    }

    update();
  }

  void onUpdateBrandSelection(int? id){

    if(id == null) return;

    if(_selectedProductBrandFilter.contains(id)){
      _selectedProductBrandFilter.remove(id);
    }else{
      _selectedProductBrandFilter.add(id);
    }

    update();
  }

  void clearBrandFilter(){
    _selectedProductBrandFilter ={};
    update();
  }

  void getSuggestionList({String? query, String? startDate, String? endDate, String? sortingType}) async {
    searchText = query;
    _isLoading = true;
    update();
    Response response = await brandRepo.getBrandList(1, 10, startDate: startDate, endDate: endDate, sortingType: sortingType, searchText: query);

    if(response.statusCode == 200 && response.body != null) {
      _brandSuggestionList = BrandModel.fromJson(response.body);

    }else {
      ApiChecker.checkApi(response);

    }
    _isLoading = false;
    update();
  }

  void clearFilter(){
    Get.find<FilterController>().clearFilter();
    searchText = null;
    getBrandList(1);
  }

  Future<void> onChangeBrandStatus({int? brandId, required int status, int? index}) async {
    Response response = await brandRepo.updateBrandStatus(brandId, status);
    if(response.statusCode == 200){
      _brandModel?.brandList?[index!].status = status;
      showCustomSnackBarHelper('brand_status_updated_successfully'.tr, isError: false);
    }else{
      ApiChecker.checkApi(response);
    }
    update();
  }

  void onChangeBrandLocalStatus(int status, {bool isUpdate = true}){
    brandLocalStatus = status;
    if(isUpdate){
      update();
    }
  }

  void setOldBrandImage(String? image){
    oldBrandImage = image;
  }

  void pickOldImage(bool isRemove, int index){
    if(isRemove){
      _brandModel?.brandList?[index].image = null;
    }else{
      _brandImage = null;
      _brandModel?.brandList?[index].image = oldBrandImage;
    }
    update();
  }

}