class InvoiceModel {
  bool? success;
  Invoice? invoice;

  InvoiceModel({this.success, this.invoice});

  InvoiceModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    invoice =
    json['invoice'] != null ? Invoice.fromJson(json['invoice']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['success'] = success;
    if (invoice != null) {
      data['invoice'] = invoice!.toJson();
    }
    return data;
  }
}

class Invoice {
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
  String? refundDate;
  double? subtotal;
  double? discount;
  Customer? customer;
  String? orderStatus;
  String? cardNumber;
  String? emailOrPhone;

  Invoice(
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
        this.refundDate,
        this.subtotal,
        this.discount,
        this.customer,
        this.orderStatus,
        this.cardNumber,
        this.emailOrPhone
      });

  Invoice.fromJson(Map<String, dynamic> json) {
    orderId = json['order_id'];
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
    orderExtraDiscount = double.tryParse(json['order_extra_discount'].toString());
    orderCouponDiscountAmount = double.tryParse(json['order_coupon_discount_amount'].toString());
    orderTotal = double.tryParse(json['order_total'].toString());
    paidAmount = double.tryParse(json['paid_amount'].toString());
    changeAmount = double.tryParse(json['change_amount'].toString());
    refundAmount = double.tryParse(json['refund_amount'].toString());
    refundReason = json['refund_reason'];
    refundDate = json['refund_date'];
    subtotal = double.tryParse(json['subtotal'].toString());
    discount = double.tryParse(json['discount'].toString());
    customer = json['customer'] != null
        ? Customer.fromJson(json['customer'])
        : null;
    orderStatus = json['order_status'];
    cardNumber = json['card_number'];
    emailOrPhone = json['email_or_phone'];
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
    data['refund_date'] = refundDate;
    data['subtotal'] = subtotal;
    data['discount'] = discount;
    if (customer != null) {
      data['customer'] = customer!.toJson();
    }
    data['order_status'] = orderStatus;
    return data;
  }
}

class OrderDetails {
  String? name;
  int? quantity;
  String? unitType;
  int? unitValue;
  double? basePrice;
  double? baseTax;
  double? baseDiscount;
  double? totalPrice;
  String? image;
  double? totalDiscount;
  double? totalTax;

  OrderDetails(
      {this.name,
        this.quantity,
        this.unitType,
        this.unitValue,
        this.basePrice,
        this.baseTax,
        this.baseDiscount,
        this.totalPrice,
        this.image,
        this.totalDiscount,
        this.totalTax});

  OrderDetails.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    quantity = int.tryParse(json['quantity'].toString()) ?? 0;
    unitType = json['unit_type'];
    unitValue = int.tryParse(json['unit_value'].toString());
    basePrice = double.tryParse(json['base_price'].toString());
    baseTax = double.tryParse(json['base_tax'].toString());
    baseDiscount = double.tryParse(json['base_discount'].toString());
    totalPrice = double.tryParse(json['total_price'].toString());
    image = json['image'];
    totalDiscount = double.tryParse(json['total_discount'].toString());
    totalTax = double.tryParse(json['total_tax'].toString());
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
  String? imageFullpath;

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
        this.imageFullpath,
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
    balance = double.tryParse(json['balance'].toString());
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    imageFullpath = json['image_fullpath'];

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
    data['image_fullpath'] = imageFullpath;

    return data;
  }
}
