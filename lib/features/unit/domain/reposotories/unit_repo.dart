import 'package:get/get.dart';
import 'package:six_pos/data/api/api_client.dart';
import 'package:six_pos/util/app_constants.dart';



class UnitRepo{
  ApiClient apiClient;
  UnitRepo({required this.apiClient});

  Future<Response> getUnitList(int offset, int limit, {String? startDate, String? endDate, String? sortingType}) async {
    String url = '${AppConstants.getUnitList}?limit=$limit&offset=$offset';
    if(startDate != 'null' && startDate != null)
      url = url + '&start_date=$startDate';
    if(endDate != 'null' && endDate != null)
      url = url + '&end_date=$endDate';
    if(sortingType != null )
      url = url + '&sorting_type=$sortingType';

    return await apiClient.getData(url);
  }

  Future<Response> deleteUnit(int? unitId, int? shiftedUnitId) async {
    String url = '${AppConstants.deleteUnitUri}?id=$unitId&type=${shiftedUnitId != null ? 'shift_and_delete' : 'delete'}';
    if(shiftedUnitId != null)
      url += '&resource_id=$shiftedUnitId';

    return await apiClient.getData(url);
  }

  Future<Response> addUnit(String unitType, int? unitId, int status, {bool isUpdate = false}) async {
    return await apiClient.postData(isUpdate? AppConstants.updateUnitUri: AppConstants.addUnitUri,
        {
          'id': unitId,
          'unit_type': unitType,
          '_method': isUpdate? 'put' :'post',
          'status': (isUpdate ? status : 1).toString()
        });
  }

  Future<Response> updateUnitStatus(int? unitId, int status) async {
    return await apiClient.getData('${AppConstants.updateUnitStatusUri}?id=$unitId&status=$status');
  }

}