import 'package:get/get_connect/http/src/response/response.dart';
import 'package:six_pos/data/api/api_client.dart';
import 'package:six_pos/util/app_constants.dart';

class CounterRepo{
  ApiClient apiClient;
  CounterRepo({required this.apiClient});


  Future<Response> getCounterList({int? offset, String? searchText}) async {
    return await apiClient.getData(
      (searchText?.isNotEmpty ?? false) ?
      "${AppConstants.getCounterListUrl}?search=$searchText&offset=$offset"
          : "${AppConstants.getCounterListUrl}?offset=$offset",
    );
  }

  Future<Response> addCounter({required String name,required String number,required String description}) async {
    return await apiClient.postData(AppConstants.storeCounterListUrl, {
      'name': name,
      'number': number,
      'description': description,
    });
  }

  Future<Response> updateCounter({required int id, required String name,required String number,required String description}) async {
    return await apiClient.postData(AppConstants.updateCounterUrl, {
      'id': id,
      'name': name,
      'number': number,
      'description': description,
    });
  }

  Future<Response> deleteCounter({required int id}) async {
    return await apiClient.getData("${AppConstants.deleteCounterUrl}?id=$id");
  }

  Future<Response> getCounterDetails({required int? offset, required int counterID, String? searchText}) async {
    return await apiClient.getData(
        (searchText?.isNotEmpty ?? false) ? "${AppConstants.orderListUri}?limit=10&offset=${offset ?? ''}&counter_id=$counterID&search=$searchText"
            : "${AppConstants.orderListUri}?limit=10&offset=${offset ?? ''}&counter_id=$counterID"
    );
  }

  Future<Response> changeStatusCounter ({required int id}) async {
    return await apiClient.getData("${AppConstants.changeStatusCounterUrl}?id=$id");
  }

}