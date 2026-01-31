import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:six_pos/data/api/api_client.dart';
import 'package:six_pos/util/app_constants.dart';
import 'dart:typed_data';
import 'package:path/path.dart';
import 'package:http/http.dart' as http;


class BrandRepo{
  ApiClient apiClient;
  BrandRepo({required this.apiClient});

  Future<Response> getBrandList(int offset, int limit, {String? startDate, String? endDate, String? sortingType, String? searchText}) async {
    String url = '${AppConstants.getBrandListUri}?limit=$limit&offset=$offset';
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

  Future<http.StreamedResponse> addBrand(String brandName,int? brandId,  XFile? file, String token, String description, int status, String? oldImage, {required bool isUpdate}) async {
    http.MultipartRequest request = isUpdate? http.MultipartRequest('POST', Uri.parse('${AppConstants.baseUrl}${AppConstants.updateBrandUri}')):
    http.MultipartRequest('POST', Uri.parse('${AppConstants.baseUrl}${AppConstants.addBrandUri}'));
    request.headers.addAll(<String,String>{'Authorization': 'Bearer $token'});

    if(file != null) {
      Uint8List list = await file.readAsBytes();
      var part = http.MultipartFile('image', file.readAsBytes().asStream(), list.length, filename: basename(file.path));
      request.files.add(part);
    }

    Map<String, String> fields = {};
    fields.addAll(<String, String>{
      'id': brandId.toString(),
      'name': brandName,
      'description' : description
    });

    if(isUpdate){
      fields.addAll({
        'status': status.toString(),
        if(oldImage != null) 'old_image': oldImage
      });
    }

    request.fields.addAll(fields);
    http.StreamedResponse response = await request.send();
    return response;
  }

  Future<Response> deleteBrand(int? brandId, int? shiftedBrandId) async {
    String url = '${AppConstants.deleteBrandUri}?id=$brandId&type=${shiftedBrandId != null ? 'shift_and_delete' : 'delete'}';
    if(shiftedBrandId != null)
      url += '&resource_id=$shiftedBrandId';

    return await apiClient.getData(url);
  }

  Future<Response> updateBrandStatus(int? brandId, int status) async {
    return await apiClient.getData('${AppConstants.updateBrandStatusUri}?id=$brandId&status=$status');
  }

}