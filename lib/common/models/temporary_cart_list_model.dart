import 'package:six_pos/common/models/cart_model.dart';

class TemporaryCartListModel {
  List<CartModel>? _cart;
  int? _userId;
  String? _holdId;
  String? _customerName;
  String? _customerPhone;
  int? _userIndex;
  double? _customerBalance;
  double? _couponAmount;
  double? _extraDiscount;

  TemporaryCartListModel({
    List<CartModel>? cart,
    int? userId,
    String? holdId,
    String? customerName,
    String? customerPhone,
    int? userIndex,
    double? customerBalance,
    double? couponAmount,
    double? extraDiscount,
  })  : _cart = cart,
        _userId = userId,
        _holdId = holdId,
        _customerName = customerName,
        _customerPhone = customerPhone,
        _userIndex = userIndex,
        _customerBalance = customerBalance,
        _couponAmount = couponAmount,
        _extraDiscount = extraDiscount;

  List<CartModel>? get cart => _cart;
  int? get userId => _userId;
  String? get holdId => _holdId;
  String? get customerName => _customerName;
  String? get customerPhone => _customerPhone;
  int? get userIndex => _userIndex;
  double? get customerBalance => _customerBalance;
  double? get couponAmount => _couponAmount;
  double? get extraDiscount => _extraDiscount;

  set couponAmount(double? value) => _couponAmount = value;
  set extraDiscount(double? value) => _extraDiscount = value;
  set userId(int? value) => _userId = value;
  set customerName(String? value) => _customerName = value;
  set customerPhone(String? value) => _customerPhone = value;
  set customerBalance(double? value) => _customerBalance = value;
  set cart(List<CartModel>? value) => _cart = value;
  set holdId(String? value) => _holdId = value;

  TemporaryCartListModel.fromJson(Map<String, dynamic> json) {
    _cart = (json['cart'] as List<dynamic>?)
        ?.map((v) => CartModel.fromJson(v))
        .toList();
    _userId = json['user_id'];
    _holdId = json['hold_id'];
    _userIndex = json['user_index'];
    _customerName = json['customer_name'];
    _customerPhone = json['customer_phone'];
    _customerBalance =  double.tryParse(json['customer_balance'].toString()) ?? 0.0;
    _couponAmount =  double.tryParse(json['coupon_amount'].toString()) ?? 0.0;
    _extraDiscount = double.tryParse(json['extra_discount'].toString()) ?? 0.0;
  }

  Map<String, dynamic> toJson() {
    return {
      'cart': _cart?.map((v) => v.toJson()).toList(),
      'user_id': _userId,
      'hold_id': _holdId,
      'user_index': _userIndex,
      'customer_name': _customerName,
      'customer_phone': _customerPhone,
      'customer_balance': _customerBalance, // Fixed incorrect assignment
      'coupon_amount': _couponAmount,
      'extra_discount': _extraDiscount,
    };
  }
}

class Cart {
  String? _productId;
  String? _price;
  double? _discountAmount;
  int? _quantity;
  double? _taxAmount;

  Cart(
      this._productId,
      this._price,
      this._discountAmount,
      this._quantity,
      this._taxAmount,
      );

  String? get productId => _productId;
  String? get price => _price;
  double? get discountAmount => _discountAmount;
  int? get quantity => _quantity;
  double? get taxAmount => _taxAmount;

  Cart.fromJson(Map<String, dynamic> json) {
    _productId = json['id'];
    _price = json['price'];
    _discountAmount =  double.tryParse(json['discount'].toString()) ?? 0.0;
    _quantity = json['quantity'];
    _taxAmount = (json['tax'] as num?)?.toDouble() ?? 0.0;
  }

  Map<String, dynamic> toJson() {
    return {
      'id': _productId,
      'price': _price,
      'discount': _discountAmount,
      'quantity': _quantity,
      'tax': _taxAmount,
    };
  }
}
