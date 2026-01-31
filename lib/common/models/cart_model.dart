import 'package:six_pos/features/product/domain/models/categories_product_model.dart';

class CartModel {
  double? _price;
  double? _discountAmount;
  int? _quantity;
  double? _taxAmount;
  CategoriesProduct? _product;

  // Weight-based product support
  bool? _isWeightBased;
  double? _weight; // Weight in grams
  double? _actualPrice; // Total price for weight-based products
  double? _pricePerGram;
  String? _unitType;

  CartModel(
    double? price,
    double? discountAmount,
    int quantity,
    double? taxAmount,
    CategoriesProduct? product, {
    bool? isWeightBased,
    double? weight,
    double? actualPrice,
    double? pricePerGram,
    String? unitType,
  }) {
    _price = price;
    _discountAmount = discountAmount;
    _quantity = quantity;
    _taxAmount = taxAmount;
    _product = product;
    _isWeightBased = isWeightBased ?? false;
    _weight = weight;
    _actualPrice = actualPrice;
    _pricePerGram = pricePerGram;
    _unitType = unitType;
  }

  double? get price => _price;
  set price(double? p) => _price = p;
  double? get discountAmount => _discountAmount;
  // ignore: unnecessary_getters_setters
  int? get quantity => _quantity;
  // ignore: unnecessary_getters_setters
  set quantity(int? qty) => _quantity = qty;
  double? get taxAmount => _taxAmount;
  CategoriesProduct? get product => _product;

  // Weight-based getters and setters
  bool? get isWeightBased => _isWeightBased;
  double? get weight => _weight;
  set weight(double? w) => _weight = w;
  double? get actualPrice => _actualPrice;
  set actualPrice(double? p) => _actualPrice = p;
  double? get pricePerGram => _pricePerGram;
  String? get unitType => _unitType;

  CartModel.fromJson(Map<String, dynamic> json) {
    _price = json['price'].toDouble();
    _discountAmount = json['discount_amount'].toDouble();
    _quantity = json['quantity'];
    _taxAmount = json['tax_amount'].toDouble();
    if (json['product'] != null) {
      _product = CategoriesProduct.fromJson(json['product']);
    }

    // Weight-based support
    _isWeightBased = json['is_weight_based'] ?? false;
    _weight = json['weight'] != null
        ? double.tryParse(json['weight'].toString())
        : null;
    _actualPrice = json['actual_price'] != null
        ? double.tryParse(json['actual_price'].toString())
        : null;
    _pricePerGram = json['price_per_gram'] != null
        ? double.tryParse(json['price_per_gram'].toString())
        : null;
    _unitType = json['unit_type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['price'] = _price;
    data['discount_amount'] = _discountAmount;
    data['quantity'] = _quantity;
    data['tax_amount'] = _taxAmount;
    data['product'] = _product!.toJson();

    // Weight-based support
    data['is_weight_based'] = _isWeightBased;
    data['weight'] = _weight;
    data['actual_price'] = _actualPrice;
    data['price_per_gram'] = _pricePerGram;
    data['unit_type'] = _unitType;

    return data;
  }
}
