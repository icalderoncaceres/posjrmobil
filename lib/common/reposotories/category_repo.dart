import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:six_pos/data/api/api_client.dart';
import 'package:six_pos/util/app_constants.dart';
import 'dart:typed_data';
import 'package:path/path.dart';
import 'package:http/http.dart' as http;


class CategoryRepo{
  ApiClient apiClient;
  CategoryRepo({required this.apiClient});

  Future<Response> getCategoryList(int offset, int limit, String? startDate, String? endDate, String? sortingType, String? searchText) async {
    String url = '${AppConstants.getCategoryListUri}?limit=$limit&offset=$offset';
    if(startDate != 'null' && startDate != null)
        url = url + '&start_date=$startDate';
    if(endDate != 'null' && endDate != null)
      url = url + '&end_date=$endDate';
    if(sortingType != null )
      url = url + '&sorting_type=$sortingType';
    if(searchText != null )
      url = url + '&search=$searchText';

    return await apiClient.getData(url);
  }

  Future<Response> getCategoryWiseProductList(int? categoryId) async {
    return await apiClient.getData('${AppConstants.getPosCategoryWiseProduct}?category_id=${categoryId ?? ''}');
  }


  Future<http.StreamedResponse> addCategory(String categoryName,int? categoryId,  XFile? file, String token, String description, int status, String? oldImage, {bool isUpdate = false}) async {
    http.MultipartRequest request = isUpdate ? http.MultipartRequest('POST', Uri.parse('${AppConstants.baseUrl}${AppConstants.updateCategoryUri}')) :
    http.MultipartRequest('POST', Uri.parse('${AppConstants.baseUrl}${AppConstants.addCategoryUri}'));
    request.headers.addAll(<String,String>{'Authorization': 'Bearer $token'});

      if(file != null) {
        Uint8List list = await file.readAsBytes();
        var part = http.MultipartFile('image', file.readAsBytes().asStream(), list.length, filename: basename(file.path));
        request.files.add(part);
      }

    Map<String, String> fields = {};
    fields.addAll(<String, String>{
      'id': categoryId.toString(),
      'name': categoryName,
      'description': description
    });

    if(isUpdate){
      fields.addAll(<String, String>{
        'status': status.toString(),
        if(oldImage != null) 'old_image': oldImage
      });
    }

    request.fields.addAll(fields);
    http.StreamedResponse response = await request.send();
    return response;
  }


  Future<Response> getSubCategoryList(int offset, int? categoryId, {String? startDate, String? endDate, String? sortingType, String? searchText}) async {
    String url = '${AppConstants.getSubCategoryListUri}?limit=10&offset=$offset&category_id=$categoryId';
    if(startDate != 'null' && startDate != null)
      url = url + '&start_date=$startDate';
    if(endDate != 'null' && endDate != null)
      url = url + '&end_date=$endDate';
    if(sortingType != null )
      url = url + '&sorting_type=$sortingType';
    if(searchText != null )
      url = url + '&search=$searchText';

    return await apiClient.getData(url);
  }


  Future<Response> addSubCategory(String subCategoryName, int? parenCategoryId, int? id, int? status, {bool isUpdate = false}) async {
    var data = {
      'name':subCategoryName,
      'parent_id' : parenCategoryId,
      'id': id
    };

    if(isUpdate){
      data.addAll({
        'status': status
      });
    }

    return await apiClient.postData(
        isUpdate?  AppConstants.updateSubCategoryUri : AppConstants.addSubCategoryUri,
        data
    );
  }


  Future<Response> getSearchProductByName(String productName) async {
    return await apiClient.getData('${AppConstants.productSearchUri}?name=$productName');
  }

  Future<Response> deleteCategory(int? categoryId, int? shiftedCategoryId, int? shiftedSubCategoryId) async {
    String url = '${AppConstants.deleteCategoryUri}?id=$categoryId&type=${shiftedCategoryId != null ? 'shift_and_delete' : 'delete'}';
    if( shiftedCategoryId != null)
      url = url + '&resource_id=$shiftedCategoryId';
    if( shiftedSubCategoryId != null)
      url = url + '&resource_child_id=$shiftedSubCategoryId';

    return await apiClient.getData(url);
  }

  Future<Response> updateCategoryStatus(int? categoryId, int status) async {
    return await apiClient.getData('${AppConstants.updateCategoryStatusUri}?id=$categoryId&status=$status');
  }

  Future<Response> updateSubCategoryStatus({int? categoryId, required int status}) async {
    return await apiClient.getData('${AppConstants.updateCategoryStatusUri}?id=$categoryId&status=$status');
  }

  Future<Response> getFilterSubCategoryList(int offset,{List<int>? categoryIds}) async {
    String url = '${AppConstants.getFilteredSubCategoryListUri}?limit=10&offset=$offset';
    if(categoryIds != null && categoryIds.isNotEmpty)
      url = url + '&category_ids=${categoryIds.toString()}';

    return await apiClient.getData(url);
  }

  Future<Response> getPosCategoryList(int offset, int limit,) async {
    String url = '${AppConstants.getPosCategories}?limit=$limit&offset=$offset';

    return await apiClient.getData(url);
  }


}