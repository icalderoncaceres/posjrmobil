import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:six_pos/common/controllers/filter_controller.dart';
import 'package:six_pos/features/auth/controllers/auth_controller.dart';
import 'package:six_pos/data/api/api_checker.dart';
import 'package:six_pos/features/product/domain/models/categories_product_model.dart';
import 'package:six_pos/features/category/domain/models/category_model.dart';
import 'package:six_pos/common/models/product_model.dart';
import 'package:six_pos/common/models/sub_category_model.dart';
import 'package:six_pos/common/reposotories/category_repo.dart';
import 'package:six_pos/helper/show_custom_snackbar_helper.dart';
import 'package:http/http.dart' as http;

class CategoryController extends GetxController implements GetxService{
  final CategoryRepo categoryRepo;
  CategoryController({required this.categoryRepo});

  bool _isLoading = false;
  bool get isLoading => _isLoading;


  CategoryModel? _categoryModel;
  CategoryModel? get categoryModel => _categoryModel;

  SubCategoryModel? _subCategoryModel;
  SubCategoryModel? get subCategoryModel => _subCategoryModel;

  SubCategoryModel? _shiftedSubCategoryModel;
  SubCategoryModel? get shiftedSubCategoryModel => _shiftedSubCategoryModel;

  int? _categorySelectedIndex;
  int? get categorySelectedIndex => _categorySelectedIndex;

  int? _selectedCategoryId;
  int? _selectedSubCategoryId;
  int? get selectedCategoryId => _selectedCategoryId;
  int? get selectedSubCategoryId => _selectedSubCategoryId;

  int? _shiftedCategoryId;
  int? get shiftedCategoryId => _shiftedCategoryId;


  List<CategoriesProduct>? _categoriesProductList;
  List<CategoriesProduct>? get categoriesProductList =>_categoriesProductList;

  List<Products>? _searchedProductList;
  List<Products>? get searchedProductList =>_searchedProductList;

  CategoryModel? _productFilterCategoryModel;
  CategoryModel? get productFilterCategoryModel => _productFilterCategoryModel;

  final picker = ImagePicker();
  XFile? _categoryImage;
  XFile? get categoryImage=> _categoryImage;

  String? _selectedCategoryValue;
  String?  get selectedCategoryValue => _selectedCategoryValue;

  String? _selectedSubCategoryValue;
  String?  get selectedSubCategoryValue => _selectedSubCategoryValue;

  CategoryModel? _categorySuggestionList;
  CategoryModel? get categorySuggestionList => _categorySuggestionList;

  SubCategoryModel? _subCategorySuggestionList;
  SubCategoryModel? get subCategorySuggestionList => _subCategorySuggestionList;

  SubCategoryModel? _productFilterSubCategoryModel;
  SubCategoryModel? get productFilterSubCategoryModel => _productFilterSubCategoryModel;

  Set<int> _selectedProductCategoryFilter = {};
  Set<int> get selectedProductCategoryFilter => _selectedProductCategoryFilter;

  Set<int> _selectedProductSubCategoryFilter = {};
  Set<int> get selectedProductSubCategoryFilter => _selectedProductSubCategoryFilter;

  CategoryModel? _posCategoryModel;
  CategoryModel? get posCategoryModel => _posCategoryModel;

  String? categorySearchText;
  String? subCategorySearchText;
  int categoryLocalStatus = 0;
  int subCategoryLocalStatus = 0;
  String? oldCategoryImage;

  void getSuggestionList({String? query, String? startDate, String? endDate, String? sortingType}) async {
    categorySearchText = query;
    _isLoading = true;
    update();
    Response response = await categoryRepo.getCategoryList(1, 10, startDate, endDate, sortingType, query);

    if(response.statusCode == 200 && response.body != null) {
      _categorySuggestionList = CategoryModel.fromJson(response.body);

    }else {
      ApiChecker.checkApi(response);

    }
    _isLoading = false;
    update();
  }

  void getSubSuggestionList({String? query, String? startDate, String? endDate, String? sortingType}) async {
    subCategorySearchText = query;
    _isLoading = true;
    update();
    Response response = await categoryRepo.getSubCategoryList(1, _selectedCategoryId, startDate: startDate, endDate: endDate, sortingType: sortingType, searchText: query);

    if(response.statusCode == 200 && response.body != null) {
      _subCategorySuggestionList = SubCategoryModel.fromJson(response.body);

    }else {
      ApiChecker.checkApi(response);

    }
    _isLoading = false;
    update();
  }

  void pickImage(bool isRemove, {bool isUpdate = true}) async {
    if(isRemove) {
      _categoryImage = null;
    }else {
      _categoryImage = await ImagePicker().pickImage(source: ImageSource.gallery);
    }
   if(isUpdate) {
      update();
    }
  }

  Future<http.StreamedResponse> addCategory(String categoryName, int? categoryId, bool isUpdate, String description, int? index) async {
    _isLoading = true;
    update();
    http.StreamedResponse response = await categoryRepo.addCategory(
      categoryName,categoryId, _categoryImage,
      Get.find<AuthController>().getUserToken(),
      description, categoryLocalStatus,
      isUpdate ? _categoryModel?.categoriesList![index!].image : null,
      isUpdate: isUpdate,
    );
    if(response.statusCode == 200) {
      _categoryImage = null;
      getCategoryList(1);
      _isLoading = false;
      Get.back();
      showCustomSnackBarHelper(isUpdate? 'category_updated_successfully'.tr : 'category_added_successfully'.tr, isError: false);

    }
    else {
      ApiChecker.checkApi(await ApiChecker.getResponse(response));
    }
    _isLoading = false;
    update();
    return response;
  }

  Future<void> getCategoryList(int offset, {Products? product, isUpdate = true, int limit = 10, String? startDate, String? endDate, String? sortingType, String? searchText}) async {
    if(offset == 1){
      _categoryModel = null;

      if(isUpdate) {
        update();
      }
    }

    Response response = await categoryRepo.getCategoryList(offset, limit, startDate, endDate, sortingType, searchText);

    if(response.statusCode == 200 && response.body != null) {
      if(offset == 1) {
        _categoryModel = CategoryModel.fromJson(response.body);
      }else {
        _categoryModel?.offset = CategoryModel.fromJson(response.body).offset;
        _categoryModel?.totalSize = CategoryModel.fromJson(response.body).totalSize;
        _categoryModel?.categoriesList?.addAll(CategoryModel.fromJson(response.body).categoriesList ?? []);
      }

      if(product != null && (product.categoryIds?.isNotEmpty ?? false)){
        setCategoryIndex((int.tryParse(product.categoryIds?.first.id ?? '')), false, product: product);
      }

    }else {
      ApiChecker.checkApi(response);

    }
    update();
  }

  Future<void> getCategoryWiseProductList(int? categoryId, {bool isUpdate = true}) async {
    _categoriesProductList  = null;

    if(isUpdate) {
      update();
    }

    Response response = await categoryRepo.getCategoryWiseProductList(categoryId);
    if(response.statusCode == 200 && response.body != {}) {
      _categoriesProductList = [];
      response.body.forEach((categoriesProduct) => _categoriesProductList?.add(CategoriesProduct.fromJson(categoriesProduct)));
    }else {
      ApiChecker.checkApi(response);
    }
    update();
  }

  Future<void> getSearchProductList(String name, {bool isReset = false}) async {
    if(!isReset){
      Response response = await categoryRepo.getSearchProductByName(name);
      if(response.body != {} &&  response.statusCode == 200) {
        _searchedProductList = [];
        _searchedProductList?.addAll(ProductModel.fromJson(response.body).products ?? []);
      }else {
        ApiChecker.checkApi(response);
      }
      update();

    }else{
      _searchedProductList = null;
      update();
    }
  }

  Future<void> getSubCategoryList(int offset, int? categoryId, {Products? product, bool isUpdate = true, String? startDate, String? endDate, String? sortingType, String? searchText}) async {
    
    _selectedCategoryId = categoryId;

    if(offset == 1){
      _subCategoryModel = null;

      if(isUpdate){
        update();
      }
    }

    Response response = await categoryRepo.getSubCategoryList(offset, categoryId, startDate: startDate, endDate: endDate, sortingType: sortingType, searchText: searchText);
    if(response.statusCode == 200 && response.body != null) {
      if(offset == 1) {
        _subCategoryModel = SubCategoryModel.fromJson(response.body);
      }else {
        _subCategoryModel?.offset = SubCategoryModel.fromJson(response.body).offset;
        _subCategoryModel?.totalSize = SubCategoryModel.fromJson(response.body).totalSize;
        _subCategoryModel?.subCategoriesList?.addAll(SubCategoryModel.fromJson(response.body).subCategoriesList ?? []);
      }

      if(product != null && product.categoryIds != null){
        for(int i = 0; i < (product.categoryIds?.length ?? 0); i++) {
          if(product.categoryIds?[i].position == 2) {
            setSubCategoryIndex(int.tryParse('${product.categoryIds?[i].id}'), false);
          }
        }
      }

    }else {
      ApiChecker.checkApi(response);
    }
    update();
  }

  Future<void> addSubCategory(String subCategoryName, int? id, int? parenCategoryId, bool isUpdate) async {
    _isLoading = true;
    update();
    Response response = await categoryRepo.addSubCategory(subCategoryName, parenCategoryId, id, subCategoryLocalStatus, isUpdate: isUpdate);
    if(response.statusCode == 200) {
      getSubCategoryList(1, parenCategoryId);
      Get.back();
      showCustomSnackBarHelper(isUpdate ? 'sub_category_update_successfully'.tr : 'sub_category_added_successfully'.tr, isError: false);
    }else {
      ApiChecker.checkApi(response);
    }
    _isLoading = false;
    update();
  }

  void setCategoryIndex(int? id, bool notify, {bool fromUpdate = false, Products? product, }) {
    _selectedSubCategoryId = null;

    if(id != null){
      getSubCategoryList(1, id, product: product);

    }else{
      _subCategoryModel = null;
    }

    _selectedCategoryId = _shiftedCategoryId =  id;
    _categorySelectedIndex = _selectedCategoryId;
    if(notify) {
      update();
    }
  }

  void setSubCategoryIndex(int? index, bool notify) {
    _selectedSubCategoryId = index;

    if(notify) {
      update();
    }
  }

  void changeSelectedIndex(int? selectedIndex, {bool isUpdate = false}) {
    _categorySelectedIndex = selectedIndex;
    if(isUpdate){
      update();
    }
  }

  Future<void> deleteCategory(int? categoryId, int? shiftedCategoryId, int? shiftedSubCategoryId, bool fromDetailsScreen) async {
    Response response = await categoryRepo.deleteCategory(categoryId, shiftedCategoryId, shiftedSubCategoryId);
    if(response.statusCode == 200) {
      getCategoryList(1);
      if(fromDetailsScreen){
        Get.back();
      }
      Get.back();
      showCustomSnackBarHelper('category_deleted_successfully'.tr, isError: false);
    }else {
      Get.back();
      ApiChecker.checkApi(response);
    }
    update();
  }

  Future<void> deleteSubCategory(SubCategories? subCategory, int? shiftedCategoryId, int? shiftedSubCategoryId, bool fromDetailsScreen) async {
    _isLoading = true;
    update();
    Get.back();
    if(fromDetailsScreen){
      Get.back();
    }

    Response response = await categoryRepo.deleteCategory(subCategory?.id, shiftedCategoryId, shiftedSubCategoryId);
    if(response.statusCode == 200) {
      getSubCategoryList(1, subCategory?.parentId);
      showCustomSnackBarHelper('sub_category_deleted_successfully'.tr, isError: false);

    }else {
      ApiChecker.checkApi(response);
    }
    _isLoading = false;
    update();
  }

  Future<void> onChangeCategoryStatus({int? categoryId, required int status, int? index}) async {
    Response response = await categoryRepo.updateCategoryStatus(categoryId, status);
    if(response.statusCode == 200){
      _categoryModel?.categoriesList?[index!].status = status;
      showCustomSnackBarHelper('category_status_updated_successfully'.tr, isError: false);
    }else{
      ApiChecker.checkApi(response);
    }
    update();
  }

  Future<void> onChangeSubCategoryStatus(int? subCategoryId, int status, int? index) async {
    Response response = await categoryRepo.updateSubCategoryStatus(categoryId: subCategoryId, status: status);
    if(response.statusCode == 200){
      _subCategoryModel?.subCategoriesList?[index!].status = status;
      showCustomSnackBarHelper('category_status_updated_successfully'.tr, isError: false);
    }else{
      ApiChecker.checkApi(response);
    }
    update();
  }

  void setCategoryAndSubCategoryEmpty(){
    _selectedCategoryId = null;
    _selectedSubCategoryId = null;
  }

  void clearCategoryFilter(){
    Get.find<FilterController>().clearFilter();
    categorySearchText = null;
    getCategoryList(1);
    update();
  }

  void clearSubCategoryFilter(){
    Get.find<FilterController>().clearFilter();
    subCategorySearchText = null;
    getSubCategoryList(1, _categorySelectedIndex);
    update();
  }

  void setShiftedCategoryIndex(int? id, bool notify) {
    _selectedSubCategoryId = null;

    if(id != null){
      getShiftedSubCategoryList(1, id);

    }else{
      _shiftedSubCategoryModel = null;
    }

    _shiftedCategoryId =  id;
    if(notify) {
      update();
    }
  }

  Future<void> getShiftedSubCategoryList(int offset, int? categoryId) async {

    _selectedCategoryId = categoryId;
    _isLoading = true;
    update();

    if(offset == 1){
      _shiftedSubCategoryModel = null;
    }

    Response response = await categoryRepo.getSubCategoryList(offset, categoryId);
    if(response.statusCode == 200 && response.body != null) {
      if(offset == 1) {
        _shiftedSubCategoryModel = SubCategoryModel.fromJson(response.body);
      }else {
        _shiftedSubCategoryModel?.offset = SubCategoryModel.fromJson(response.body).offset;
        _shiftedSubCategoryModel?.totalSize = SubCategoryModel.fromJson(response.body).totalSize;
        _shiftedSubCategoryModel?.subCategoriesList?.addAll(SubCategoryModel.fromJson(response.body).subCategoriesList ?? []);
      }

    }else {
      ApiChecker.checkApi(response);
    }
    _isLoading = false;
    update();
  }

  Future<void> getProductFilterCategoryList( int offset, {int limit = 10}) async {
    if(offset == 1){
      _productFilterCategoryModel = null;

    }

    Response response = await categoryRepo.getCategoryList(offset, limit, null, null, null, null);

    if(response.statusCode == 200 && response.body != null) {
      if(offset == 1) {
        _productFilterCategoryModel = CategoryModel.fromJson(response.body);
      }else {
        _productFilterCategoryModel?.offset = CategoryModel.fromJson(response.body).offset;
        _productFilterCategoryModel?.totalSize = CategoryModel.fromJson(response.body).totalSize;
        _productFilterCategoryModel?.categoriesList?.addAll(CategoryModel.fromJson(response.body).categoriesList ?? []);
      }

    }else {
      ApiChecker.checkApi(response);

    }
    update();
  }

  Future<void> getProductFilterSubCategoryList(int offset) async {

    if(offset == 1){
      _productFilterSubCategoryModel = null;

      _isLoading = true;
      update();
    }

    Response response = await categoryRepo.getFilterSubCategoryList(offset, categoryIds: _selectedProductCategoryFilter.toList());
    if(response.statusCode == 200 && response.body != null) {
      if(offset == 1) {
        _productFilterSubCategoryModel = SubCategoryModel.fromJson(response.body);
      }else {
        _productFilterSubCategoryModel?.offset = SubCategoryModel.fromJson(response.body).offset;
        _productFilterSubCategoryModel?.totalSize = SubCategoryModel.fromJson(response.body).totalSize;
        _productFilterSubCategoryModel?.subCategoriesList?.addAll(SubCategoryModel.fromJson(response.body).subCategoriesList ?? []);
      }

    }else {
      ApiChecker.checkApi(response);
    }
    _isLoading = false;

    update();
  }

  void onUpdateCategorySelection(int? id){

    if(id == null) return;

    if(_selectedProductCategoryFilter.contains(id)){
      _selectedProductCategoryFilter.remove(id);
    }else{
      _selectedProductCategoryFilter.add(id);
    }
    getProductFilterSubCategoryList(1);

    update();
  }

  void onUpdateSubCategorySelection(int? id){

    if(id == null) return;

    if(_selectedProductSubCategoryFilter.contains(id)){
      _selectedProductSubCategoryFilter.remove(id);
    }else{
      _selectedProductSubCategoryFilter.add(id);
    }

    update();
  }

  void clearProductFilter(){
    _selectedProductCategoryFilter = {};
    _selectedProductSubCategoryFilter = {};
    update();
  }

  void onChangeCategoryLocalStatus(int status, {bool isUpdate = true}){
    categoryLocalStatus = status;
    if(isUpdate){
      update();
    }
  }

  void onChangeSubCategoryLocalStatus(int status, {bool isUpdate = true}){
    subCategoryLocalStatus = status;
    if(isUpdate){
      update();
    }
  }

  void setOldCategoryImage(String? image){
    oldCategoryImage = image;
  }

  void pickOldImage(bool isRemove, int index){
    if(isRemove){
      _categoryModel?.categoriesList?[index].image = null;
    }else{
      _categoryImage = null;
      _categoryModel?.categoriesList?[index].image = oldCategoryImage;
    }
    update();
  }

  Future<void> getPosCategoryList( int offset, {isUpdate = false, int limit = 10}) async {
    if(offset == 1){
      _posCategoryModel = null;

      if(isUpdate) {
        update();
      }
    }

    Response response = await categoryRepo.getPosCategoryList(offset, limit);

    if(response.statusCode == 200 && response.body != null) {
      if(offset == 1) {
        _posCategoryModel = CategoryModel.fromJson(response.body);
        _posCategoryModel?.categoriesList?.insert(0, Categories(id: null, name: 'all', status: 1));
        getCategoryWiseProductList(_posCategoryModel?.categoriesList?[0].id, isUpdate: false);
      }else {
        _posCategoryModel?.offset = CategoryModel.fromJson(response.body).offset;
        _posCategoryModel?.totalSize = CategoryModel.fromJson(response.body).totalSize;
        _posCategoryModel?.categoriesList?.addAll(CategoryModel.fromJson(response.body).categoriesList ?? []);
      }


    }else {
      ApiChecker.checkApi(response);

    }
    update();
  }

}