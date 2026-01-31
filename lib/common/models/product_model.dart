import 'package:six_pos/common/models/sub_category_model.dart';
import 'package:six_pos/features/category/domain/models/category_model.dart';
import 'package:six_pos/features/unit/domain/models/unit_model.dart';

class ProductModel {
  int? totalSize;
  int? limit;
  int? offset;
  double? minPrice;
  double? maxPrice;
  Set<int>? categoryIds;
  Set<int>? subCategoryIds;
  Set<int>? brandIds;
  int? supplierId;
  String? availability;
  Set<String>? stocks;
  String? searchText;
  double? productMinimumPrice;
  double? productMaximumPrice;
  List<Products>? products;

  ProductModel.fromJson(Map<String, dynamic> json) {
    totalSize = int.tryParse('${json['total']}');
    limit = int.tryParse('${json['limit']}');
    offset = int.tryParse('${json['offset']}');
    minPrice = double.tryParse('${json['min_price']}');
    maxPrice = double.tryParse('${json['max_price']}');
    categoryIds = json['category_ids'] != null
        ? Set<int>.from(json['category_ids'])
        : null;
    subCategoryIds = json['subcategory_ids'] != null
        ? Set<int>.from(json['subcategory_ids'])
        : null;
    brandIds = json['brand_ids'] != null
        ? Set<int>.from(json['brand_ids'])
        : null;
    stocks = json['stocks'] != null ? Set<String>.from(json['stocks']) : null;
    supplierId = int.tryParse('${json['supplier_id']}');
    productMaximumPrice = double.tryParse('${json['product_maximum_price']}');
    productMinimumPrice = double.tryParse('${json['product_minimum_price']}');
    availability = json['availability'];
    searchText = json['search'];
    if (json['products'] != null) {
      products = <Products>[];
      json['products'].forEach((v) {
        products?.add(Products.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['total'] = totalSize;
    data['limit'] = limit;
    data['offset'] = offset;
    if (products != null) {
      data['products'] = products!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Products {
  int? _id;
  String? _title;
  String? _productCode;
  Units? _unitType;
  String? _unitValue;
  Brand? _brand;
  List<CategoryIds>? _categoryIds;
  double? _purchasePrice;
  double? _sellingPrice;
  String? _discountType;
  double? _discount;
  double? _tax;
  int? _quantity;
  String? _image;
  Supplier? _supplier;
  String? description;
  int? reorderLevel;
  String? availableStartTime;
  String? availableEndTime;
  int? status;
  Categories? category;
  SubCategories? subCategory;
  int? totalSold;
  int? totalOrder;
  double? totalSoldAmount;
  String? createdAt;
  String? updatedAt;

  // Multi-currency and weight-based support
  bool? isWeightBased;
  double? currentCurrencyPrice;
  String? currentCurrencySymbol;
  String? currentCurrencyCode;
  double? pricePerGram;
  double? pricePerKg;
  String? priceDisplay;

  Products({
    int? id,
    String? title,
    String? productCode,
    Units? unitType,
    String? unitValue,
    Brand? brand,
    List<CategoryIds>? categoryIds,
    double? purchasePrice,
    double? sellingPrice,
    String? discountType,
    double? discount,
    double? tax,
    int? quantity,
    String? image,
    Supplier? supplier,
    this.description,
    this.reorderLevel,
    this.availableEndTime,
    this.availableStartTime,
    this.status,
    this.category,
    this.subCategory,
    this.totalOrder,
    this.totalSold,
    this.totalSoldAmount,
    this.createdAt,
    this.updatedAt,
    this.isWeightBased,
    this.currentCurrencyPrice,
    this.currentCurrencySymbol,
    this.currentCurrencyCode,
    this.pricePerGram,
    this.pricePerKg,
    this.priceDisplay,
  }) {
    if (id != null) {
      _id = id;
    }
    if (title != null) {
      _title = title;
    }
    if (productCode != null) {
      _productCode = productCode;
    }
    if (unitType != null) {
      _unitType = unitType;
    }
    if (unitValue != null) {
      _unitValue = unitValue;
    }
    if (brand != null) {
      _brand = brand;
    }
    if (categoryIds != null) {
      _categoryIds = categoryIds;
    }
    if (purchasePrice != null) {
      _purchasePrice = purchasePrice;
    }
    if (sellingPrice != null) {
      _sellingPrice = sellingPrice;
    }
    if (discountType != null) {
      _discountType = discountType;
    }
    if (discount != null) {
      _discount = discount;
    }
    if (tax != null) {
      _tax = tax;
    }
    if (quantity != null) {
      _quantity = quantity;
    }
    if (image != null) {
      _image = image;
    }
    if (supplier != null) {
      _supplier = supplier;
    }
  }

  int? get id => _id;
  String? get title => _title;
  String? get productCode => _productCode;
  Units? get unitType => _unitType;
  String? get unitValue => _unitValue;
  Brand? get brand => _brand;
  List<CategoryIds>? get categoryIds => _categoryIds;
  double? get purchasePrice => _purchasePrice;
  double? get sellingPrice => _sellingPrice;
  String? get discountType => _discountType;
  double? get discount => _discount;
  double? get tax => _tax;
  int? get quantity => _quantity;
  String? get image => _image;
  Supplier? get supplier => _supplier;

  set image(String? image) {
    _image = image;
  }

  Products.fromJson(Map<String, dynamic> json) {
    _id = json['id'];
    _title = json['title'];
    _productCode = json['product_code'];
    if (json['unit_type'] != null) {
      _unitType = Units.fromJson(json['unit_type']);
    }

    if (json['unit_value'] != null) {
      _unitValue = json['unit_value'].toString();
    }
    _brand = json['brand'] != null ? Brand.fromJson(json['brand']) : null;
    if (json['category_ids'] != null) {
      _categoryIds = <CategoryIds>[];
      json['category_ids'].forEach((v) {
        _categoryIds!.add(CategoryIds.fromJson(v));
      });
    }
    if (json['purchase_price'] != null) {
      try {
        _purchasePrice = json['purchase_price'].toDouble();
      } catch (e) {
        _purchasePrice = double.parse(json['purchase_price'].toString());
      }
    } else {
      _purchasePrice = 0.0;
    }

    if (json['selling_price'] != null) {
      try {
        _sellingPrice = json['selling_price'].toDouble();
      } catch (e) {
        _sellingPrice = double.parse(json['selling_price'].toString());
      }
    } else {
      _sellingPrice = 0.0;
    }

    _discountType = json['discount_type'];
    if (json['discount'] != null) {
      try {
        _discount = json['discount'].toDouble();
      } catch (e) {
        _discount = double.parse(json['discount'].toString());
      }
    } else {
      _discount = 0.0;
    }

    if (json['tax'] != null) {
      try {
        _tax = json['tax'].toDouble();
      } catch (e) {
        _tax = double.parse(json['tax'].toString());
      }
    } else {
      _tax = 0.0;
    }
    if (json['quantity'] != null) {
      _quantity = int.parse(json['quantity'].toString());
    }

    _image = json['image'];
    _supplier = json['supplier'] != null
        ? Supplier.fromJson(json['supplier'])
        : null;
    description = json['description'];
    reorderLevel = json['reorder_level'];
    availableEndTime = json['available_time_ended_at'];
    availableStartTime = json['available_time_started_at'];
    status = json['status'];
    category = json['category'] != null
        ? Categories.fromJson(json['category'])
        : null;
    subCategory = json['sub_category'] != null
        ? SubCategories.fromJson(json['sub_category'])
        : null;
    totalSoldAmount = double.tryParse('${json['total_sold_amount']}');
    totalSold = int.tryParse('${json['total_sold']}');
    totalOrder = int.tryParse('${json['total_orders']}');
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];

    // Multi-currency and weight-based support
    isWeightBased = json['is_weight_based'] ?? false;
    currentCurrencyPrice = double.tryParse('${json['current_currency_price']}');
    currentCurrencySymbol = json['current_currency_symbol'];
    currentCurrencyCode = json['current_currency_code'];
    pricePerGram = double.tryParse('${json['price_per_gram']}');
    pricePerKg = double.tryParse('${json['price_per_kg']}');
    priceDisplay = json['price_display'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = _id;
    data['title'] = _title;
    data['product_code'] = _productCode;
    data['unit_type'] = _unitType;
    data['unit_value'] = _unitValue;
    if (_brand != null) {
      data['brand'] = _brand!.toJson();
    }
    if (_categoryIds != null) {
      data['category_ids'] = _categoryIds!.map((v) => v.toJson()).toList();
    }
    data['purchase_price'] = _purchasePrice;
    data['selling_price'] = _sellingPrice;
    data['discount_type'] = _discountType;
    data['discount'] = _discount;
    data['tax'] = _tax;
    data['quantity'] = _quantity;
    data['image'] = _image;
    if (_supplier != null) {
      data['supplier'] = _supplier!.toJson();
    }
    data['description'] = description;
    data['reorder_level'] = reorderLevel;
    data['availability_ended_at'] = availableEndTime;
    data['availability_started_at'] = availableStartTime;
    data['status'] = status;
    return data;
  }
}

class Brand {
  int? _id;
  String? _name;
  String? _image;

  Brand({int? id, String? name, String? image}) {
    if (id != null) {
      _id = id;
    }
    if (name != null) {
      _name = name;
    }
    if (image != null) {
      _image = image;
    }
  }

  int? get id => _id;
  String? get name => _name;
  String? get image => _image;

  Brand.fromJson(Map<String, dynamic> json) {
    _id = json['id'];
    _name = json['name'];
    _image = json['image'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = _id;
    data['name'] = _name;
    data['image'] = _image;

    return data;
  }
}

class CategoryIds {
  String? _id;
  int? _position;

  CategoryIds({String? id, int? position}) {
    if (id != null) {
      _id = id;
    }
    if (position != null) {
      _position = position;
    }
  }

  String? get id => _id;
  int? get position => _position;

  CategoryIds.fromJson(Map<String, dynamic> json) {
    _id = json['id'].toString();
    _position = int.tryParse(json['position'].toString());
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = _id;
    data['position'] = _position;
    return data;
  }
}

class Supplier {
  int? _id;
  String? _name;
  String? _mobile;
  String? _email;
  String? _image;
  String? _state;
  String? _city;
  String? _zipCode;
  String? _address;

  Supplier({
    int? id,
    String? name,
    String? mobile,
    String? email,
    String? image,
    String? state,
    String? city,
    String? zipCode,
    String? address,
  }) {
    if (id != null) {
      _id = id;
    }
    if (name != null) {
      _name = name;
    }
    if (mobile != null) {
      _mobile = mobile;
    }
    if (email != null) {
      _email = email;
    }
    if (image != null) {
      _image = image;
    }
    if (state != null) {
      _state = state;
    }
    if (city != null) {
      _city = city;
    }
    if (zipCode != null) {
      _zipCode = zipCode;
    }
    if (address != null) {
      _address = address;
    }
  }

  int? get id => _id;
  String? get name => _name;
  String? get mobile => _mobile;
  String? get email => _email;
  String? get image => _image;
  String? get state => _state;
  String? get city => _city;
  String? get zipCode => _zipCode;
  String? get address => _address;

  Supplier.fromJson(Map<String, dynamic> json) {
    _id = json['id'];
    _name = json['name'];
    _mobile = json['mobile'];
    _email = json['email'];
    _image = json['image'];
    _state = json['state'];
    _city = json['city'];
    _zipCode = json['zip_code'];
    _address = json['address'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = _id;
    data['name'] = _name;
    data['mobile'] = _mobile;
    data['email'] = _email;
    data['image'] = _image;
    data['state'] = _state;
    data['city'] = _city;
    data['zip_code'] = _zipCode;
    data['address'] = _address;
    return data;
  }
}
