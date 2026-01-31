import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:six_pos/data/api/api_client.dart';
import 'package:six_pos/util/app_constants.dart';

class OrderRepo{
  ApiClient apiClient;
  final SharedPreferences sharedPreferences;

  OrderRepo({required this.apiClient, required this.sharedPreferences});

  Future<Response> getOrderList(
      int? offset, {
        String? type,
        DateTime? startDate,
        DateTime? endDate,
        int? customerId,
        int? counterId,
        String? searchText,
        List<int>? paymentMethod}
      ) async {

    String url = '${AppConstants.orderListUri}?limit=10&offset=$offset';
    if(type != null){
      url += '&type=$type';
    }
    if(startDate != null){
      url += '&start_date=$startDate';
    }
    if(endDate != null){
      url += '&end_date=$endDate';
    }
    if(customerId != null){
      url += '&customer_id=$customerId';
    }
    if(counterId != null){
      url += '&counter_id=$counterId';
    }
    if(paymentMethod != null && paymentMethod.isNotEmpty){
      url += '&payment_method_id=${paymentMethod.toString()}';
    }
    if(searchText != null && searchText.isNotEmpty){
      url += '&search=$searchText';
    }

    return await apiClient.getData(url);
  }

  Future<Response> customerSearch(String search) async {
    return await apiClient.getData('${AppConstants.customerSearchUri}?search=$search');
  }

  Future<Response> getCounterList() async {
    return await apiClient.getData(AppConstants.getCounterListUrl);
  }

  Future<Response> getInvoiceData(int? orderId) async {
    return await apiClient.getData('${AppConstants.invoice}?order_id=$orderId');
  }

  Future<Response> getOrderDetails(int orderId) async {
    return await apiClient.getData('${AppConstants.getOrderDetails}$orderId');
  }

  Future<void> setBluetoothAddress(String? address) async {
    await sharedPreferences.setString(AppConstants.bluetoothMacAddress, address ?? '');
  }

  Future<Response> sendRefundRequest({required int orderId, required String orderAmount, String? orderNote, String? adminWallet, String? customerWallet, String? paymentMethod, String? paymentInfo}) async {
    var data = {
      "refund_amount":orderAmount,
      "refund_reason":orderNote,
      "admin_payment_method": adminWallet,
      "customer_payout_method": customerWallet,
      if(paymentMethod != null) "payment_method": paymentMethod,
      if(paymentInfo != null) "payment_info": paymentInfo
    };
    return await apiClient.postData(
        '${AppConstants.refundRequestUrl}$orderId',
        data
        );
  }

  String? getBluetoothAddress() => sharedPreferences.getString(AppConstants.bluetoothMacAddress);
}