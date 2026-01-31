class OrderModel {
  int? total;
  int? limit;
  int? offset;
  List<Orders>? orders;
  int? customerId;
  int? counterId;
  Set<int>? paymentMethodId;

  OrderModel({this.total, this.limit, this.offset, this.orders});

  OrderModel.fromJson(Map<String, dynamic> json) {
    total = int.parse(json['total'].toString());
    limit = int.parse(json['limit'].toString());
    offset = int.parse(json['offset'].toString());
    customerId = int.tryParse('${json['customer_id']}');
    counterId = int.tryParse('${json['counter_id']}');
    paymentMethodId = json['payment_method_id'] != null ? Set<int>.from(json['payment_method_id']) : null;
    if (json['orders'] != null) {
      orders = <Orders>[];
      json['orders'].forEach((v) {
        orders!.add(Orders.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['total'] = total;
    data['limit'] = limit;
    data['offset'] = offset;
    if (orders != null) {
      data['orders'] = orders!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Orders {
  int? orderId;
  String? orderDate;
  String? counterName;
  String? counterNo;
  String? referenceId;
  String? paymentMethod;
  String? orderNote;
  List<OrderDetails>? orderDetails;
  double? orderTax;
  double? orderExtraDiscount;
  double? orderCouponDiscountAmount;
  double? orderTotal;
  double? paidAmount;
  double? changeAmount;
  double? refundAmount;
  String? refundReason;
  double? subtotal;
  double? discount;
  Customer? customer;
  String? orderStatus;
  String? refundDate;
  String? refundAdminPaymentMethodId;
  String? refundAdminPaymentMethodName;
  String? refundCustomerPayoutMethodName;
  RefundOtherPaymentDetails? refundOtherPaymentDetails;
  Orders(
      {this.orderId,
        this.orderDate,
        this.counterName,
        this.counterNo,
        this.referenceId,
        this.paymentMethod,
        this.orderNote,
        this.orderDetails,
        this.orderTax,
        this.orderExtraDiscount,
        this.orderCouponDiscountAmount,
        this.orderTotal,
        this.paidAmount,
        this.changeAmount,
        this.refundAmount,
        this.refundReason,
        this.subtotal,
        this.discount,
        this.customer,
        this.orderStatus,
        this.refundDate,
        this.refundAdminPaymentMethodId,
        this.refundAdminPaymentMethodName,
        this.refundCustomerPayoutMethodName,
        this.refundOtherPaymentDetails
      });

  Orders.fromJson(Map<String, dynamic> json) {
    orderId = int.parse(json['order_id'].toString());
    orderDate = json['order_date'];
    counterName = json['counter_name'];
    counterNo = json['counter_no'];
    referenceId = json['reference_id'];
    paymentMethod = json['payment_method'];
    orderNote = json['order_note'];
    if (json['order_details'] != null) {
      orderDetails = <OrderDetails>[];
      json['order_details'].forEach((v) {
        orderDetails!.add(OrderDetails.fromJson(v));
      });
    }
    orderTax = double.tryParse(json['order_tax'].toString());
    orderExtraDiscount = double.parse(json['order_extra_discount'].toString());
    orderCouponDiscountAmount = double.parse(json['order_coupon_discount_amount'].toString());
    orderTotal = double.parse(json['order_total'].toString());
    paidAmount = double.parse(json['paid_amount'].toString());
    changeAmount = double.parse(json['change_amount'].toString());
    refundAmount = double.parse(json['refund_amount'].toString());
    refundReason = json['refund_reason'];
    subtotal = double.parse(json['subtotal'].toString());
    discount = double.parse(json['discount'].toString());
    customer = json['customer'] != null
        ? Customer.fromJson(json['customer'])
        : null;
    orderStatus = json['order_status'];
    refundDate = json['refund_date'];
    refundAdminPaymentMethodId = json['refund_admin_payment_method_id'];
    refundAdminPaymentMethodName = json['refund_admin_payment_method_name'];
    refundCustomerPayoutMethodName = json['refund_customer_payout_method_name'];
    refundOtherPaymentDetails = json['refund_other_payment_details'] != null
        ? RefundOtherPaymentDetails.fromJson(
        json['refund_other_payment_details'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['order_id'] = orderId;
    data['order_date'] = orderDate;
    data['counter_name'] = counterName;
    data['counter_no'] = counterNo;
    data['reference_id'] = referenceId;
    data['payment_method'] = paymentMethod;
    data['order_note'] = orderNote;
    if (orderDetails != null) {
      data['order_details'] =
          orderDetails!.map((v) => v.toJson()).toList();
    }
    data['order_tax'] = orderTax;
    data['order_extra_discount'] = orderExtraDiscount;
    data['order_coupon_discount_amount'] = orderCouponDiscountAmount;
    data['order_total'] = orderTotal;
    data['paid_amount'] = paidAmount;
    data['change_amount'] = changeAmount;
    data['refund_amount'] = refundAmount;
    data['refund_reason'] = refundReason;
    data['subtotal'] = subtotal;
    data['discount'] = discount;
    if (customer != null) {
      data['customer'] = customer!.toJson();
    }
    data['refund_admin_payment_method_id'] = this.refundAdminPaymentMethodId;
    data['refund_admin_payment_method_name'] =
        this.refundAdminPaymentMethodName;
    data['refund_customer_payout_method_name'] =
        this.refundCustomerPayoutMethodName;
    if (this.refundOtherPaymentDetails != null) {
      data['refund_other_payment_details'] =
          this.refundOtherPaymentDetails!.toJson();
    }
    return data;
  }
}

class OrderDetails {
  String? name;
  int? quantity;
  String? unitType;
  double? unitValue;
  double? basePrice;
  double? baseTax;
  double? baseDiscount;
  double? totalPrice;
  String? image;
  double? totalDiscount;
  double? totalTax;
  bool? isExist;

  OrderDetails({
    this.name,
    this.quantity,
    this.unitType,
    this.unitValue,
    this.basePrice,
    this.baseTax,
    this.baseDiscount,
    this.totalPrice,
    this.image,
    this.totalDiscount,
    this.totalTax,
    this.isExist
  });

  OrderDetails.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    quantity = int.parse(json['quantity'].toString());
    unitType = json['unit_type'];
    unitValue = double.parse(json['unit_value'].toString());
    basePrice = double.parse(json['base_price'].toString());
    baseTax = double.parse(json['base_tax'].toString());
    baseDiscount = double.parse(json['base_discount'].toString());
    totalPrice = double.parse(json['total_price'].toString());
    image = json['image'];
    totalDiscount = double.parse(json['total_discount'].toString());
    totalTax = double.parse(json['total_tax'].toString());
    isExist = json['does_exist'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['quantity'] = quantity;
    data['unit_type'] = unitType;
    data['unit_value'] = unitValue;
    data['base_price'] = basePrice;
    data['base_tax'] = baseTax;
    data['base_discount'] = baseDiscount;
    data['total_price'] = totalPrice;
    data['image'] = image;
    data['total_discount'] = totalDiscount;
    data['total_tax'] = totalTax;
    data['does_exist'] = isExist;
    return data;
  }
}

class Customer {
  int? id;
  String? name;
  String? mobile;
  String? email;
  String? image;
  String? state;
  String? city;
  String? zipCode;
  String? address;
  double? balance;
  String? createdAt;
  String? updatedAt;
  int? companyId;
  String? imageFullpath;
  int? totalOrderCount;
  Customer(
      {this.id,
        this.name,
        this.mobile,
        this.email,
        this.image,
        this.state,
        this.city,
        this.zipCode,
        this.address,
        this.balance,
        this.createdAt,
        this.updatedAt,
        this.companyId,
        this.imageFullpath,
        this.totalOrderCount
      });

  Customer.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    mobile = json['mobile'];
    email = json['email'];
    image = json['image'];
    state = json['state'];
    city = json['city'];
    zipCode = json['zip_code'];
    address = json['address'];
    balance = double.tryParse('${json['balance']}');
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    companyId = json['company_id'];
    imageFullpath = json['image_fullpath'];
    totalOrderCount = int.tryParse('${json['orders_count']}');
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['mobile'] = mobile;
    data['email'] = email;
    data['image'] = image;
    data['state'] = state;
    data['city'] = city;
    data['zip_code'] = zipCode;
    data['address'] = address;
    data['balance'] = balance;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['company_id'] = companyId;
    data['image_fullpath'] = imageFullpath;
    data['orders_count'] = totalOrderCount;
    return data;
  }
}

class RefundOtherPaymentDetails {
  String? paymentInfo;
  String? paymentMethod;

  RefundOtherPaymentDetails({this.paymentInfo, this.paymentMethod});

  RefundOtherPaymentDetails.fromJson(Map<String, dynamic> json) {
    paymentInfo = json['payment_info'];
    paymentMethod = json['payment_method'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['payment_info'] = this.paymentInfo;
    data['payment_method'] = this.paymentMethod;
    return data;
  }
}
