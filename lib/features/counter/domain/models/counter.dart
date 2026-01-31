class Counter {
  int? _id;
  String? _name;
  String? _number;
  String? _description;
  int? _status;
  String? _createdAt;
  String? _updatedAt;
  int? _ordersCount;
  double? _ordersSumOrderAmount;
  double? _ordersSumTotalTax;

  Counter(
      {int? id,
        String? name,
        String? number,
        String? description,
        int? status,
        String? createdAt,
        String? updatedAt,
        int? ordersCount,
        double? ordersSumOrderAmount,
        double? ordersSumTotalTax
      }) {
    if (id != null) {
      _id = id;
    }
    if (name != null) {
      _name = name;
    }
    if (number != null) {
      _number = number;
    }
    if (description != null) {
      _description = description;
    }
    if (status != null) {
      _status = status;
    }
    if (createdAt != null) {
      _createdAt = createdAt;
    }
    if (updatedAt != null) {
      _updatedAt = updatedAt;
    }
    if (ordersCount != null) {
      _ordersCount = ordersCount;
    }
    if (ordersSumOrderAmount != null) {
      _ordersSumOrderAmount = ordersSumOrderAmount;
    }
    if (ordersSumTotalTax != null) {
      _ordersSumTotalTax = ordersSumTotalTax;
    }
  }

  int? get id => _id;
  set id(int? id) => _id = id;
  String? get name => _name;
  set name(String? name) => _name = name;
  String? get number => _number;
  set number(String? number) => _number = number;
  String? get description => _description;
  set description(String? description) => _description = description;
  int? get status => _status;
  set status(int? status) => _status = status;
  String? get createdAt => _createdAt;
  set createdAt(String? createdAt) => _createdAt = createdAt;
  String? get updatedAt => _updatedAt;
  set updatedAt(String? updatedAt) => _updatedAt = updatedAt;
  int? get ordersCount => _ordersCount;
  set ordersCount(int? ordersCount) => _ordersCount = ordersCount;
  double? get ordersSumOrderAmount => _ordersSumOrderAmount;
  set ordersSumOrderAmount(double? ordersSumOrderAmount) =>
      _ordersSumOrderAmount = ordersSumOrderAmount;
  double? get ordersSumTotalTax => _ordersSumTotalTax;
  set ordersSumTotalTax(double? ordersSumTotalTax) =>
      _ordersSumTotalTax = ordersSumTotalTax;

  Counter.fromJson(Map<String, dynamic> json) {
    _id = json['id'];
    _name = json['name'];
    _number = json['number'];
    _description = json['description'];
    _status = json['status'];
    _createdAt = json['created_at'];
    _updatedAt = json['updated_at'];
    _ordersCount = json['orders_count'];
    _ordersSumOrderAmount = double.tryParse(json['orders_sum_order_amount'].toString());
    _ordersSumTotalTax = double.tryParse(json['orders_sum_total_tax'].toString());
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = _id;
    data['name'] = _name;
    data['number'] = _number;
    data['description'] = _description;
    data['status'] = _status;
    data['created_at'] = _createdAt;
    data['updated_at'] = _updatedAt;
    data['orders_count'] = _ordersCount;
    data['orders_sum_order_amount'] = _ordersSumOrderAmount;
    data['orders_sum_total_tax'] = _ordersSumTotalTax;
    return data;
  }
}