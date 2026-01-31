import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:six_pos/common/controllers/category_controller.dart';
import 'package:six_pos/features/auth/controllers/auth_controller.dart';
import 'package:six_pos/data/api/api_checker.dart';
import 'package:six_pos/features/brand/controllers/brand_controller.dart';
import 'package:six_pos/features/product/domain/models/limite_stock_product_model.dart';
import 'package:six_pos/common/models/product_model.dart';
import 'package:six_pos/features/product/domain/reposotories/product_repo.dart';
import 'package:six_pos/features/user/controllers/supplier_controller.dart';
import 'package:six_pos/helper/date_converter_helper.dart';
import 'package:six_pos/helper/show_custom_snackbar_helper.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as path;
import 'package:six_pos/util/app_constants.dart';

class ProductController extends GetxController implements GetxService {
  final ProductRepo productRepo;
  ProductController({required this.productRepo});

  bool _isLoading = false;
  final bool _isSub = false;
  bool _isFirst = true;
  bool get isFirst => _isFirst;
  bool get isLoading => _isLoading;
  bool get isSub => _isSub;
  int _discountTypeIndex = 0;
  int get discountTypeIndex => _discountTypeIndex;
  int _itemQuantity = 1;
  int get itemQuantity => _itemQuantity;

  ProductModel? _productModel;
  ProductModel? get productModel => _productModel;

  LimitedStockProductModel? _limitedStockProductModel;
  LimitedStockProductModel? get limitedStockProductModel =>
      _limitedStockProductModel;

  final TextEditingController _productNameController = TextEditingController();
  TextEditingController get productNameController => _productNameController;

  final TextEditingController _productDescriptionController =
      TextEditingController();
  TextEditingController get productDescriptionController =>
      _productDescriptionController;

  final TextEditingController _productStockController = TextEditingController();
  TextEditingController get productStockController => _productStockController;

  final TextEditingController _productSkuController = TextEditingController();
  TextEditingController get productSkuController => _productSkuController;

  final TextEditingController _unitValueController = TextEditingController();
  TextEditingController get unitValueController => _unitValueController;

  final TextEditingController _productSellingPriceController =
      TextEditingController();
  TextEditingController get productSellingPriceController =>
      _productSellingPriceController;

  final TextEditingController _productPurchasePriceController =
      TextEditingController();
  TextEditingController get productPurchasePriceController =>
      _productPurchasePriceController;

  // Variables para manejo de monedas
  int? _selectedCurrencyId;
  int? get selectedCurrencyId => _selectedCurrencyId;

  double? _originalSellingPrice;
  double? get originalSellingPrice => _originalSellingPrice;

  final TextEditingController _productTaxController = TextEditingController();
  TextEditingController get productTaxController => _productTaxController;

  final TextEditingController _productDiscountController =
      TextEditingController();
  TextEditingController get productDiscountController =>
      _productDiscountController;

  final TextEditingController _productQuantityController =
      TextEditingController();
  TextEditingController get productQuantityController =>
      _productQuantityController;

  final TextEditingController _productReorderController =
      TextEditingController();
  TextEditingController get productReorderController =>
      _productReorderController;

  LimitedStockProductModel? _limitedStockProductSuggestionList;
  LimitedStockProductModel? get limitedStockProductSuggestionList =>
      _limitedStockProductSuggestionList;

  ProductModel? _productModelSuggestingList;
  ProductModel? get productModelSuggestingList => _productModelSuggestingList;

  int _selectionTabIndex = 0;
  int get selectionTabIndex => _selectionTabIndex;
  String? _selectedDiscountType = '';
  String? get selectedDiscountType => _selectedDiscountType;

  File? _selectedFileForImport;
  File? get selectedFileForImport => _selectedFileForImport;

  String? _bulkImportSampleFilePath = '';
  String? get bulkImportSampleFilePath => _bulkImportSampleFilePath;

  String? _printBarCode = '';
  String? get printBarCode => _printBarCode;

  String? _bulkExportFilePath = '';
  String? get bulkExportFilePath => _bulkExportFilePath;

  int _barCodeQuantity = 0;
  int get barCodeQuantity => _barCodeQuantity;
  bool _isUpdate = false;
  bool get isUpdate => _isUpdate;

  String? _startTime;
  String? get startTime => _startTime;
  String? _endTime;
  String? get endTime => _endTime;

  String? _selectedAvailableType = AppConstants.availableTypeList[0];
  String? get selectedAvailableType => _selectedAvailableType;
  Set<String> _selectedQuantityType = {};
  Set<String> get selectedQuantityType => _selectedQuantityType;
  String? searchText;

  double? _minPrice;
  double? get minPrice => _minPrice;
  double? _maxPrice;
  double? get maxPrice => _maxPrice;
  String? oldProductImage;

  final picker = ImagePicker();
  XFile? _productImage;
  XFile? get productImage => _productImage;
  void pickImage(bool isRemove, {bool isUpdate = true}) async {
    if (isRemove) {
      _productImage = null;
    } else {
      _productImage = await ImagePicker().pickImage(
        source: ImageSource.gallery,
      );
    }
    if (isUpdate) {
      update();
    }
  }

  Future<void> getProductList(
    int offset, {
    bool isUpdate = true,
    String? query,
    double? minPrice,
    double? maxPrice,
    List<String>? stocks,
    List<int>? categoryIds,
    List<int>? subCategoryIds,
    List<int>? brandsIds,
    int? supplierId,
    String? availability,
  }) async {
    if (offset == 1) {
      _productModel = null;

      if (isUpdate) {
        update();
      }
    }
    Response response = await productRepo.getProductList(
      offset,
      searchText: query,
      minPrice: minPrice,
      maxPrice: maxPrice,
      stocks: stocks,
      categoryIds: categoryIds,
      subCategoryIds: subCategoryIds,
      brandsIds: brandsIds,
      supplierId: supplierId,
      availability: availability,
    );
    if (response.statusCode == 200 && response.body != null) {
      if (offset == 1) {
        _productModel = ProductModel.fromJson(response.body);
      } else {
        _productModel?.totalSize = ProductModel.fromJson(
          response.body,
        ).totalSize;
        _productModel?.offset = ProductModel.fromJson(response.body).offset;
        _productModel?.products?.addAll(
          ProductModel.fromJson(response.body).products ?? [],
        );
      }
    } else {
      ApiChecker.checkApi(response);
    }

    update();
  }

  Future<void> getSearchProductList(
    String name,
    int offset, {
    bool isUpdate = true,
  }) async {
    if (offset == 1) {
      _productModel = null;

      if (isUpdate) {
        update();
      }
    }
    Response response = await productRepo.searchProduct(name, offset);

    if (response.statusCode == 200 && response.body != null) {
      if (offset == 1) {
        _productModel = ProductModel.fromJson(response.body);
      } else {
        _productModel?.totalSize = ProductModel.fromJson(
          response.body,
        ).totalSize;
        _productModel?.offset = ProductModel.fromJson(response.body).offset;
        _productModel?.products?.addAll(
          ProductModel.fromJson(response.body).products ?? [],
        );
      }
    } else {
      ApiChecker.checkApi(response);
    }
    update();
  }

  Future<void> getLimitedStockProductList(
    int offset, {
    bool isUpdate = true,
    double? minPrice,
    double? maxPrice,
    List<String>? stocks,
    List<int>? categoryIds,
    List<int>? subCategoryIds,
    List<int>? brandsIds,
    int? supplierId,
    String? availability,
    String? searchText,
  }) async {
    if (offset == 1) {
      _limitedStockProductModel = null;

      if (isUpdate) {
        update();
      }
    }
    Response response = await productRepo.getLimitedStockProductList(
      offset,
      minPrice: minPrice,
      maxPrice: maxPrice,
      stocks: stocks,
      categoryIds: categoryIds,
      subCategoryIds: subCategoryIds,
      supplierId: supplierId,
      brandsIds: brandsIds,
      availability: availability,
      searchText: searchText,
    );
    if (response.statusCode == 200 && response.body != null) {
      if (offset == 1) {
        _limitedStockProductModel = LimitedStockProductModel.fromJson(
          response.body,
        );
      } else {
        _limitedStockProductModel?.totalSize =
            LimitedStockProductModel.fromJson(response.body).totalSize;
        _limitedStockProductModel?.offset = LimitedStockProductModel.fromJson(
          response.body,
        ).offset;
        _limitedStockProductModel?.stockLimitedProducts?.addAll(
          LimitedStockProductModel.fromJson(
                response.body,
              ).stockLimitedProducts ??
              [],
        );
      }
    } else {
      ApiChecker.checkApi(response);
    }
    update();
  }

  Future<void> getSupplierProductList(
    int offset,
    int? supplierId, {
    bool reload = true,
  }) async {
    if (offset == 1) {
      _productModel = null;

      if (isUpdate) {
        update();
      }
    }
    Response response = await productRepo.getSupplierProductList(
      offset,
      supplierId,
    );

    if (response.statusCode == 200 && response.body != null) {
      if (offset == 1) {
        _productModel = ProductModel.fromJson(response.body);
      } else {
        _productModel?.totalSize = ProductModel.fromJson(
          response.body,
        ).totalSize;
        _productModel?.offset = ProductModel.fromJson(response.body).offset;
        _productModel?.products?.addAll(
          ProductModel.fromJson(response.body).products ?? [],
        );
      }
    } else {
      ApiChecker.checkApi(response);
    }
    update();
  }

  Future<void> updateProductQuantity(int? productId, int quantity) async {
    _isUpdate = true;
    Response response = await productRepo.updateProductQuantity(
      productId,
      quantity,
    );
    if (response.statusCode == 200) {
      _productQuantityController.clear();
      getLimitedStockProductList(1);
      getProductList(1);

      showCustomSnackBarHelper(
        'product_quantity_updated_successfully'.tr,
        isError: false,
      );
      _isUpdate = false;
    } else {
      ApiChecker.checkApi(response);
    }
    _isUpdate = false;
    update();
  }

  Future<http.StreamedResponse> addProduct(
    Products product,
    String category,
    String subCategory,
    int? brandId,
    int? supplierId,
    bool isUpdate,
    int? index, {
    bool fromDetailPage = false,
  }) async {
    _isLoading = true;
    update();
    http.StreamedResponse response = await productRepo.addProduct(
      product,
      category,
      subCategory,
      brandId,
      supplierId,
      _productImage,
      Get.find<AuthController>().getUserToken(),
      isUpdate ? _productModel?.products![index!].image : null,
      isUpdate: isUpdate,
      priceCurrencyId: _selectedCurrencyId, // Pasar la moneda seleccionada
    );

    if (response.statusCode == 200) {
      _productImage = null;
      await getProductList(1);

      _productNameController.clear();
      _productDescriptionController.clear();
      _productReorderController.clear();
      _startTime = null;
      _endTime = null;
      _productDescriptionController.clear();
      _productStockController.clear();
      _productSkuController.clear();
      _productSellingPriceController.clear();
      _productPurchasePriceController.clear();
      _productTaxController.clear();
      _productDiscountController.clear();
      _productQuantityController.clear();

      if (fromDetailPage) {
        Get.back();
        Get.back();
      } else {
        Get.back();
      }

      showCustomSnackBarHelper(
        isUpdate
            ? 'product_updated_successfully'.tr
            : 'product_added_successfully'.tr,
        isError: false,
      );
    } else {
      ApiChecker.checkApi(await ApiChecker.getResponse(response));
    }
    _isLoading = false;
    update();
    return response;
  }

  Future<void> deleteProduct(int? productId, {bool fromDetails = false}) async {
    update();
    Response response = await productRepo.deleteProduct(productId);
    if (response.statusCode == 200) {
      Get.back();
      if (fromDetails) {
        Get.back();
      }
      getProductList(1);
      showCustomSnackBarHelper(
        'product_deleted_successfully'.tr.tr,
        isError: false,
      );
    } else {
      ApiChecker.checkApi(response);
    }
    update();
  }

  void removeImage() {
    _productImage = null;
    update();
  }

  void removeFirstLoading() {
    _isFirst = true;
    update();
  }

  void setDiscountTypeIndex(int index, bool notify) {
    _discountTypeIndex = index;
    if (notify) {
      update();
    }
  }

  void setIndexForTabBar(int index, {bool isUpdate = true}) {
    _selectionTabIndex = index;
    if (isUpdate) {
      update();
    }
  }

  void setSelectedDiscountType(String? type, {bool notify = true}) {
    _selectedDiscountType = type;
    if (notify) {
      update();
    }
  }

  // Métodos para manejar la moneda seleccionada
  void setSelectedCurrency(int? currencyId, {bool notify = true}) {
    _selectedCurrencyId = currencyId;
    if (notify) {
      update();
    }
  }

  void setOriginalSellingPrice(double? price, {bool notify = true}) {
    _originalSellingPrice = price;
    if (notify) {
      update();
    }
  }

  void setSelectedFileName(File fileName) {
    _selectedFileForImport = fileName;
    update();
  }

  Future<void> getSampleFile() async {
    Response response = await productRepo.downloadSampleFile();
    if (response.statusCode == 200) {
      Map map = response.body;
      _bulkImportSampleFilePath = map['product_bulk_file'];
    } else {
      ApiChecker.checkApi(response);
    }
    update();
  }

  Future<http.StreamedResponse> bulkImportFile() async {
    _isLoading = true;
    update();
    http.StreamedResponse response = await productRepo.bulkImport(
      _selectedFileForImport,
      Get.find<AuthController>().getUserToken(),
    );
    if (response.statusCode == 200) {
      _isLoading = false;
      Get.back();
      showCustomSnackBarHelper(
        'product_imported_successfully'.tr,
        isError: false,
      );
      _selectedFileForImport = null;
    } else {
      _isLoading = false;
      ApiChecker.checkApi(await ApiChecker.getResponse(response));
    }
    _isLoading = false;
    update();
    return response;
  }

  Future<void> bulkExportFile() async {
    Response response = await productRepo.bulkExport();
    if (response.statusCode == 200) {
      Map map = response.body;
      _bulkExportFilePath = map['excel_report'];
    } else {
      ApiChecker.checkApi(response);
    }
    update();
  }

  void setBarCodeQuantity(int quantity, {bool isUpdate = true}) {
    _barCodeQuantity = quantity;
    if (isUpdate) {
      update();
    }
  }

  void downloadFile(String url, String dir) async {
    await FlutterDownloader.enqueue(
      url: url,
      savedDir: dir,
      showNotification: true,
      saveInPublicStorage: true,
      openFileFromNotification: true,
    );
  }

  Future<void> barCodeDownload(int id, int quantity) async {
    Response response = await productRepo.barCodeDownLoad(id, quantity);
    if (response.statusCode == 200) {
      _printBarCode = response.body;
      showCustomSnackBarHelper(
        'barcode_downloaded_successfully'.tr,
        isError: false,
      );
    } else {
      ApiChecker.checkApi(response);
    }
    update();
  }

  void setItemQuantity() {
    _itemQuantity = 1;
  }

  void onUpdateItemQuantity(bool isIncrement) {
    if (isIncrement) {
      _itemQuantity++;
    } else {
      if (_itemQuantity < 2) {
        showCustomSnackBarHelper('minimum_quantity_1'.tr);
      } else {
        _itemQuantity--;
      }
    }
    update();
  }

  bool checkFileExtension(List<String> extensionList, String filePath) =>
      extensionList.contains(path.extension(filePath).replaceAll('.', ''));

  void updateStartTime(String? value, {bool isUpdate = true}) {
    if (value != null && (value.contains('AM') || value.contains('PM'))) {
      _startTime = value;
    } else {
      _startTime = DateConverterHelper.convert24HourToAmPm(value);
    }
    if (isUpdate) {
      update();
    }
  }

  void updateEndTime(String? value, {bool isUpdate = true}) {
    if (value != null && (value.contains('AM') || value.contains('PM'))) {
      _endTime = value;
    } else {
      _endTime = DateConverterHelper.convert24HourToAmPm(value);
    }

    if (isUpdate) {
      update();
    }
  }

  void updateSelectedAvailableType(String type, {bool isUpdate = true}) {
    _selectedAvailableType = type;
    if (isUpdate) {
      update();
    }
  }

  void updateSelectedQuantityType(String type, {bool isUpdate = true}) {
    if (_selectedQuantityType.contains(type)) {
      _selectedQuantityType.remove(type);
    } else {
      _selectedQuantityType.add(type);
    }

    if (isUpdate) {
      update();
    }
  }

  void setPriceRange(
    double? min,
    double? max,
    bool isMinUpdate,
    bool isMaxUpdate, {
    bool isUpdate = true,
  }) {
    if (isMinUpdate) _minPrice = min;

    if (isMaxUpdate) _maxPrice = max;

    if (isUpdate) {
      update();
    }
  }

  void getLimitedStockProductSuggestionList({
    String? query,
    double? minPrice,
    double? maxPrice,
    List<String>? stocks,
    List<int>? categoryIds,
    List<int>? subCategoryIds,
    List<int>? brandsIds,
    int? supplierId,
    String? availability,
  }) async {
    searchText = query;
    _isLoading = true;
    update();
    Response response = await productRepo.getLimitedStockProductList(
      1,
      searchText: query,
      minPrice: minPrice,
      maxPrice: maxPrice,
      stocks: stocks,
      categoryIds: categoryIds,
      subCategoryIds: subCategoryIds,
      supplierId: supplierId,
      brandsIds: brandsIds,
      availability: availability,
    );

    if (response.statusCode == 200 && response.body != null) {
      _limitedStockProductSuggestionList = LimitedStockProductModel.fromJson(
        response.body,
      );
    } else {
      ApiChecker.checkApi(response);
    }
    _isLoading = false;
    update();
  }

  void getProductSuggestionList({
    String? query,
    double? minPrice,
    double? maxPrice,
    List<String>? stocks,
    List<int>? categoryIds,
    List<int>? subCategoryIds,
    List<int>? brandsIds,
    int? supplierId,
    String? availability,
  }) async {
    searchText = query;
    _isLoading = true;
    update();
    Response response = await productRepo.getProductList(
      1,
      searchText: query,
      minPrice: minPrice,
      maxPrice: maxPrice,
      stocks: stocks,
      categoryIds: categoryIds,
      subCategoryIds: subCategoryIds,
      supplierId: supplierId,
      brandsIds: brandsIds,
      availability: availability,
    );

    if (response.statusCode == 200 && response.body != null) {
      _productModelSuggestingList = ProductModel.fromJson(response.body);
    } else {
      ApiChecker.checkApi(response);
    }
    _isLoading = false;
    update();
  }

  void clearFilter(bool fromProductList) {
    _selectedAvailableType = AppConstants.availableTypeList[0];
    _selectedQuantityType = {};
    searchText = null;
    Get.find<CategoryController>().clearProductFilter();
    Get.find<BrandController>().clearBrandFilter();
    Get.find<SupplierController>().clearSupplierFilter();
    if (fromProductList) {
      getProductList(1).then((_) {
        _minPrice = _productModel?.productMinimumPrice ?? 0;
        _maxPrice = _productModel?.productMaximumPrice ?? 1;
      });
    } else {
      getLimitedStockProductList(1).then((_) {
        _minPrice = _limitedStockProductModel?.productMinimumPrice ?? 0;
        _maxPrice = _limitedStockProductModel?.productMaximumPrice ?? 1;
      });
    }
    update();
  }

  void setOldProductImage(String? image) {
    oldProductImage = image;
  }

  void pickOldImage(bool isRemove, int index) {
    if (isRemove) {
      _productModel?.products?[index].image = null;
    } else {
      _productImage = null;
      _productModel?.products?[index].image = oldProductImage;
    }
    update();
  }

  Future<void> onChangeProductStatus({
    int? productId,
    required int status,
    int? index,
  }) async {
    Response response = await productRepo.updateUnitStatus(productId, status);
    if (response.statusCode == 200) {
      _productModel?.products?[index!].status = status;
      showCustomSnackBarHelper(
        'product_status_updated_successfully'.tr,
        isError: false,
      );
    } else {
      ApiChecker.checkApi(response);
    }
    update();
  }
}
