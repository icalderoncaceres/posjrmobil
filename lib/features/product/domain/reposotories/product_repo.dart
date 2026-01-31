import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:six_pos/data/api/api_client.dart';
import 'package:six_pos/common/models/product_model.dart';
import 'package:six_pos/util/app_constants.dart';
import 'package:path/path.dart';
import 'package:http/http.dart' as http;

class ProductRepo {
  ApiClient apiClient;
  ProductRepo({required this.apiClient});

  Future<Response> getProductList(
    int offset, {
    String? searchText,
    double? minPrice,
    double? maxPrice,
    List<String>? stocks,
    List<int>? categoryIds,
    List<int>? subCategoryIds,
    List<int>? brandsIds,
    int? supplierId,
    String? availability,
  }) async {
    String url = '${AppConstants.getProductUri}?limit=10&offset=$offset';
    if (searchText != null) url = url + '&search=$searchText';
    if (minPrice != null) url = url + '&min_price=$minPrice';
    if (maxPrice != null) url = url + '&max_price=$maxPrice';
    if (stocks != null && stocks.isNotEmpty)
      url = url + '&stocks=${jsonEncode(stocks)}';
    if (categoryIds != null && categoryIds.isNotEmpty)
      url = url + '&category_ids=${categoryIds.toString()}';
    if (subCategoryIds != null && subCategoryIds.isNotEmpty)
      url = url + '&subcategory_ids=${subCategoryIds.toString()}';
    if (brandsIds != null && brandsIds.isNotEmpty)
      url = url + '&brand_ids=${brandsIds.toString()}';
    if (supplierId != null) url = url + '&supplier_id=$supplierId';
    if (availability != null) url = url + '&availability=$availability';
    return await apiClient.getData(url);
  }

  Future<Response> getSupplierProductList(int offset, int? supplierId) async {
    return await apiClient.getData(
      '${AppConstants.supplierProductListUri}?limit=10&offset=$offset&supplier_id=$supplierId',
    );
  }

  Future<Response> getLimitedStockProductList(
    int offset, {
    String? searchText,
    double? minPrice,
    double? maxPrice,
    List<String>? stocks,
    List<int>? categoryIds,
    List<int>? subCategoryIds,
    List<int>? brandsIds,
    int? supplierId,
    String? availability,
  }) async {
    String url =
        '${AppConstants.getLimitedStockProductUri}?limit=10&offset=$offset';
    if (searchText != null) url = url + '&search=$searchText';
    if (minPrice != null) url = url + '&min_price=$minPrice';
    if (maxPrice != null) url = url + '&max_price=$maxPrice';
    if (stocks != null && stocks.isNotEmpty)
      url = url + '&stocks=${jsonEncode(stocks)}';
    if (categoryIds != null && categoryIds.isNotEmpty)
      url = url + '&category_ids=${categoryIds.toString()}';
    if (subCategoryIds != null && subCategoryIds.isNotEmpty)
      url = url + '&subcategory_ids=${subCategoryIds.toString()}';
    if (brandsIds != null && brandsIds.isNotEmpty)
      url = url + '&brand_ids=${brandsIds.toString()}';
    if (supplierId != null) url = url + '&supplier_id=$supplierId';
    if (availability != null) url = url + '&availability=$availability';
    return await apiClient.getData(url);
  }

  Future<Response> updateProductQuantity(int? productId, int quantity) async {
    return await apiClient.getData(
      '${AppConstants.updateProductQuantity}?id=$productId&quantity=$quantity',
    );
  }

  Future<http.StreamedResponse> addProduct(
    Products product,
    String categoryId,
    String subCategoryId,
    int? brandId,
    int? supplierId,
    XFile? file,
    String token,
    String? oldImage, {
    bool isUpdate = false,
    int? priceCurrencyId,
  }) async {
    http.MultipartRequest request = isUpdate
        ? http.MultipartRequest(
            'POST',
            Uri.parse(
              '${AppConstants.baseUrl}${AppConstants.updateProductUri}',
            ),
          )
        : http.MultipartRequest(
            'POST',
            Uri.parse('${AppConstants.baseUrl}${AppConstants.addProductUri}'),
          );
    request.headers.addAll(<String, String>{'Authorization': 'Bearer $token'});
    if (file != null) {
      Uint8List list = await file.readAsBytes();
      var part = http.MultipartFile(
        'image',
        file.readAsBytes().asStream(),
        list.length,
        filename: basename(file.path),
      );
      request.files.add(part);
    }

    Map<String, String> fields = {};
    fields.addAll(<String, String>{
      'id': product.id.toString(),
      'name': product.title!,
      'description': product.description ?? '',
      if (product.reorderLevel != null)
        'reorder_level': product.reorderLevel.toString(),
      'available_time_started_at': product.availableStartTime ?? '',
      'available_time_ended_at': product.availableEndTime ?? '',
      'category_id': categoryId,
      if (subCategoryId != "null") 'sub_category_id': subCategoryId,
      'product_code': product.productCode!,
      'unit_type': product.unitType!.id.toString(),
      'unit_value': '${product.unitValue}',
      'quantity': product.quantity.toString(),
      'purchase_price': product.purchasePrice.toString(),
      'selling_price': product.sellingPrice.toString(),
      'tax': product.tax.toString(),
      'discount': product.discount.toString(),
      'discount_type': product.discountType!,
      if (brandId != null) 'brand_id': brandId.toString(),
      if (supplierId != null) 'supplier_id': supplierId.toString(),
      if (priceCurrencyId != null)
        'price_currency_id': priceCurrencyId.toString(), // Campo de moneda
    });

    if (isUpdate) {
      fields.addAll({if (oldImage != null) 'old_image': oldImage});
    }

    request.fields.addAll(fields);
    http.StreamedResponse response = await request.send();
    return response;
  }

  Future<Response> searchProduct(String productName, int offset) async {
    return await apiClient.getData(
      '${AppConstants.productSearchUri}?limit=10&offset=$offset&name=$productName',
    );
  }

  Future<http.StreamedResponse> bulkImport(File? filePath, String token) async {
    http.MultipartRequest request = http.MultipartRequest(
      'POST',
      Uri.parse('${AppConstants.baseUrl}${AppConstants.bulkImportProductUri}'),
    );
    request.headers.addAll(<String, String>{'Authorization': 'Bearer $token'});
    if (filePath != null) {
      Uint8List list = await filePath.readAsBytes();
      var part = http.MultipartFile(
        'products_file',
        filePath.readAsBytes().asStream(),
        list.length,
        filename: basename(filePath.path),
      );
      request.files.add(part);
    }

    Map<String, String> fields = {};
    fields.addAll(<String, String>{});

    request.fields.addAll(fields);
    http.StreamedResponse response = await request.send();
    return response;
  }

  Future<Response> updateUnitStatus(int? productId, int status) async {
    return await apiClient.getData(
      '${AppConstants.updateProductStatusUri}?id=$productId&status=$status',
    );
  }

  Future<Response> bulkExport() async {
    return await apiClient.getData(AppConstants.bulkExportProductUri);
  }

  Future<Response> downloadSampleFile() async {
    return await apiClient.getData(AppConstants.getDownloadSampleFileUri);
  }

  Future<Response> deleteProduct(int? productId) async {
    return await apiClient.getData(
      '${AppConstants.productDeleteUri}?id=$productId',
    );
  }

  Future<Response> barCodeDownLoad(int id, int quantity) async {
    return await apiClient.getData(
      '${AppConstants.barCodeDownload}?id=$id&quantity=$quantity',
    );
  }
}
