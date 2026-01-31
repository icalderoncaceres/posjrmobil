class BrandModel {
  int? totalSize;
  int? limit;
  int? offset;
  String? sortingType;
  String? startDate;
  String? endDate;
  String? searchText;
  List<Brands>? brandList;


  BrandModel.fromJson(Map<String, dynamic> json) {
    totalSize = json['total'];
    limit = int.tryParse('${json['limit']}');
    offset = int.tryParse('${json['offset']}');
    startDate = json['start_date'];
    endDate = json['end_date'];
    sortingType = json['sorting_type'];
    searchText = json['search'];
    if (json['brands'] != null) {
      brandList = <Brands>[];
      json['brands'].forEach((v) {
        brandList?.add(Brands.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['total'] = totalSize;
    data['limit'] = limit;
    data['offset'] = offset;
    if (brandList != null) {
      data['brands'] = brandList?.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Brands {
  int? _id;
  String? _name;
  String? _image;
  String? _createdAt;
  String? _updatedAt;
  String? description;
  int? productCount;
  int? status;

  Brands({int? id,
    String? name,
    String? image,
    String? createdAt,
    String? updatedAt,
    this.productCount,
    this.description,
    this.status
  }) {
    if (id != null) {
      _id = id;
    }
    if (name != null) {
      _name = name;
    }
    if (image != null) {
      _image = image;
    }
    if (createdAt != null) {
      _createdAt = createdAt;
    }
    if (updatedAt != null) {
      _updatedAt = updatedAt;
    }
  }

  int? get id => _id;
  String? get name => _name;
  String? get image => _image;
  String? get createdAt => _createdAt;
  String? get updatedAt => _updatedAt;

  set image(String? image){
    _image = image;
  }

  Brands.fromJson(Map<String, dynamic> json) {
    _id = json['id'];
    _name = json['name'];
    _image = json['image'];
    _createdAt = json['created_at'];
    _updatedAt = json['updated_at'];
    productCount = int.tryParse('${json['product_count']}');
    description = json['description'];
    status = int.tryParse('${json['status']}');
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = _id;
    data['name'] = _name;
    data['image'] = _image;
    data['created_at'] = _createdAt;
    data['updated_at'] = _updatedAt;
    data['description'] = description;
    data['product_count'] = productCount;
    data['status'] = status;
    return data;
  }
}
