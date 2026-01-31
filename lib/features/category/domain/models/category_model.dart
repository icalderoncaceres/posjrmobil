class CategoryModel {
  int? totalSize;
  int? limit;
  int? offset;
  String? sortingType;
  String? startDate;
  String? endDate;
  String? searchText;
  List<Categories>? categoriesList;


  CategoryModel.fromJson(Map<String, dynamic> json) {
    totalSize = int.tryParse('${json['total']}');
    limit = int.tryParse('${json['limit']}');
    offset = int.tryParse('${json['offset']}');
    startDate = json['start_date'];
    endDate = json['end_date'];
    sortingType = json['sorting_type'];
    searchText = json['search'];
    if (json['categories'] != null) {
      categoriesList = <Categories>[];
      json['categories'].forEach((v) {
        categoriesList!.add(Categories.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['total'] = totalSize;
    data['limit'] = limit;
    data['offset'] = offset;
    if (categoriesList != null) {
      data['categories'] = categoriesList!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Categories {
  int? _id;
  String? _name;
  int? _parentId;
  int? _position;
  int? _status;
  String? _image;
  String? _createdAt;
  String? _updatedAt;
  String? _description;
  int? _productCount;

  Categories(
      {int? id,
        String? name,
        int? parentId,
        int? position,
        int? status,
        String? image,
        String? createdAt,
        String? updatedAt,
        String? description,
        int? productCount
      }) {
    if (id != null) {
      _id = id;
    }
    if (name != null) {
      _name = name;
    }
    if (parentId != null) {
      _parentId = parentId;
    }
    if (position != null) {
      _position = position;
    }
    if (status != null) {
      _status = status;
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
    if(productCount != null){
      _productCount = productCount;
    }
    if(description != null){
      _description = description;
    }
  }

  int? get id => _id;
  String? get name => _name;
  int? get parentId => _parentId;
  int? get position => _position;
  //ignore: unnecessary_getters_setters
  int? get status => _status;
  set status(int? value) {
    _status = value;
  }
  set image(String? image){
    _image = image;
  }

  String? get image => _image;
  String? get createdAt => _createdAt;
  String? get updatedAt => _updatedAt;
  int? get productCount => _productCount;
  String? get description => _description;


  Categories.fromJson(Map<String, dynamic> json) {
    _id = json['id'];
    _name = json['name'];
    if(json['parent_id'] != null){
      _parentId = int.parse(json['parent_id'].toString());
    }

    if(json['position'] != null){
      _position = int.parse(json['position'].toString());
    }

    if(json['status'] != null){
      _status = int.parse(json['status'].toString());
    }

    _image = json['image'];
    _createdAt = json['created_at'];
    _updatedAt = json['updated_at'];
    if(json['product_count'] != null){
      _productCount = int.parse(json['product_count'].toString());
    }
    _description = json['description'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = _id;
    data['name'] = _name;
    data['parent_id'] = _parentId;
    data['position'] = _position;
    data['status'] = _status;
    data['image'] = _image;
    data['created_at'] = _createdAt;
    data['updated_at'] = _updatedAt;
    data['product_count'] = _productCount;
    data['description'] = _description;
    return data;
  }
}
