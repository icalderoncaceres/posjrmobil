import 'dart:convert';

import 'package:get/get_connect/http/src/response/response.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:six_pos/common/models/temporary_cart_list_model.dart';
import 'package:six_pos/data/api/api_client.dart';
import 'package:six_pos/common/models/place_order_model.dart';
import 'package:six_pos/util/app_constants.dart';

class CartRepo{
  final ApiClient apiClient;
  final SharedPreferences sharedPreferences;
  CartRepo({required this.apiClient, required this.sharedPreferences});

  Future<Response> getCouponDiscount(String couponCode, int? userId, double orderAmount) async {
    return await apiClient.getData('${AppConstants.getCouponDiscount}?code=$couponCode&user_id=$userId&order_amount=$orderAmount');
  }

  Future<Response> placeOrder(PlaceOrderModel placeOrderBody) async {
    return await apiClient.postData(AppConstants.placeOrderUri, placeOrderBody.toJson());
  }

  Future<Response> getProductByCode(String? productCode) async {
    return await apiClient.getData('${AppConstants.getProductFromProduceCodeUri}?product_code=$productCode');
  }

  Future<Response> customerSearch(String search) async {
    return await apiClient.getData('${AppConstants.customerSearchUri}?search=$search');
  }

  void addToCartList(List<TemporaryCartListModel> cartProductList) {
    List<String> carts = [];
    cartProductList.forEach((cartModel) => carts.add(jsonEncode(cartModel)));
    sharedPreferences.setStringList(AppConstants.cartList, carts);
  }

  List<TemporaryCartListModel> getCartList() {
    List<String>? carts = [];
    if(sharedPreferences.containsKey(AppConstants.cartList)) {
      carts = sharedPreferences.getStringList(AppConstants.cartList);
    }
    List<TemporaryCartListModel> cartList = [];
    carts?.forEach((cart) => cartList.add(TemporaryCartListModel.fromJson(jsonDecode(cart))));
    return cartList;
  }

}