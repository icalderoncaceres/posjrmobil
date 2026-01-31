import 'dart:math';
import 'package:barcode_scan2/barcode_scan2.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:six_pos/features/coupon/controllers/coupon_controller.dart';
import 'package:six_pos/features/order/controllers/order_controller.dart';
import 'package:six_pos/features/account_management/controllers/transaction_controller.dart';
import 'package:six_pos/data/api/api_checker.dart';
import 'package:six_pos/common/models/place_order_model.dart';
import 'package:six_pos/common/models/cart_model.dart';
import 'package:six_pos/features/product/domain/models/categories_product_model.dart';
import 'package:six_pos/features/coupon/domain/models/coupon_model.dart';
import 'package:six_pos/common/models/customer_model.dart';
import 'package:six_pos/common/models/temporary_cart_list_model.dart';
import 'package:six_pos/common/reposotories/cart_repo.dart';
import 'package:six_pos/helper/pos_screen_helper.dart';
import 'package:six_pos/helper/price_converter_helper.dart';
import 'package:six_pos/helper/show_custom_snackbar_helper.dart';
import 'package:six_pos/features/order/screens/invoice_screen.dart';

class CartController extends GetxController implements GetxService {
  final CartRepo cartRepo;
  CartController({required this.cartRepo});

  List<CartModel> _cartList = [];
  List<CartModel> get cartList => _cartList;
  double _amount = 0.0;
  double get amount => _amount;
  double _productDiscount = 0.0;
  double get productDiscount => _productDiscount;

  final double _productTax = 0.0;
  double get productTax => _productTax;

  List<TemporaryCartListModel> _customerCartList = [];
  List<TemporaryCartListModel> get customerCartList => _customerCartList;

  TemporaryCartListModel? _currentCartModel;
  TemporaryCartListModel? get currentCartModel => _currentCartModel;

  final TextEditingController _collectedCashController =
      TextEditingController();
  TextEditingController get collectedCashController => _collectedCashController;

  final TextEditingController _customerWalletController =
      TextEditingController();
  TextEditingController get customerWalletController =>
      _customerWalletController;

  final TextEditingController _couponController = TextEditingController();
  TextEditingController get couponController => _couponController;

  final TextEditingController _extraDiscountController =
      TextEditingController();
  TextEditingController get extraDiscountController => _extraDiscountController;

  double _returnToCustomerAmount = 0;
  double get returnToCustomerAmount => _returnToCustomerAmount;

  double _couponCodeAmount = 0;
  double get couponCodeAmount => _couponCodeAmount;

  double _extraDiscountAmount = 0;
  double get extraDiscountAmount => _extraDiscountAmount;

  int _discountTypeIndex = 0;
  int get discountTypeIndex => _discountTypeIndex;

  String? _selectedDiscountType = '';
  String? get selectedDiscountType => _selectedDiscountType;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  List<CategoriesProduct> _scanProduct = [];
  List<CategoriesProduct> get scanProduct => _scanProduct;

  final List<bool> _isSelectedList = [];
  List<bool> get isSelectedList => _isSelectedList;

  int _customerIndex = 0;
  int get customerIndex => _customerIndex;

  List<int?> _customerIds = [];
  List<int?> get customerIds => _customerIds;

  List<CartModel>? _existInCartList;
  List<CartModel>? get existInCartList => _existInCartList;

  Coupons? _coupons;
  Coupons? get coupons => _coupons;

  List<Customers>? _searchedCustomerList;
  List<Customers>? get searchedCustomerList => _searchedCustomerList;

  bool _isGetting = false;
  bool _isFirst = true;
  bool get isFirst => _isFirst;
  bool get isGetting => _isGetting;

  int? _customerListLength = 0;
  int? get customerListLength => _customerListLength;

  String? _customerSelectedName = '';
  String? get customerSelectedName => _customerSelectedName;

  String? _customerSelectedMobile = '';
  String? get customerSelectedMobile => _customerSelectedMobile;

  int? _customerId = 0;
  int? get customerId => _customerId;

  final TextEditingController _searchCustomerController =
      TextEditingController();
  TextEditingController get searchCustomerController =>
      _searchCustomerController;
  double? _customerBalance = 0.0;
  double? get customerBalance => _customerBalance;
  int cartIndex = 0;

  int? _selectedCouponIndex;
  int? get selectedCouponIndex => _selectedCouponIndex;

  bool _isTopSectionShowHoldButton = true;

  bool get isTopSectionShowHoldButton => _isTopSectionShowHoldButton;

  bool _isUpdatePaidAmount = true;
  bool get isUpdatePaidAmount => _isUpdatePaidAmount;

  void setSelectedDiscountType(String? type) {
    _selectedDiscountType = type;
    update();
  }

  void setDiscountTypeIndex(int index, bool notify) {
    _discountTypeIndex = index;
    if (notify) {
      update();
    }
  }

  void setSearchCustomerList(List<Customers>? list) {
    _searchedCustomerList = list;
    update();
  }

  void getReturnAmount(double totalCostAmount) {
    setReturnAmountToZero();

    if (_customerId != 0 &&
        Get.find<TransactionController>().selectedFromAccountId == 0) {
      _customerWalletController.text = _customerBalance.toString();
      _returnToCustomerAmount =
          double.parse(_customerWalletController.text) - totalCostAmount;
    } else if (_collectedCashController.text.isNotEmpty) {
      _returnToCustomerAmount =
          double.parse(_collectedCashController.text) - totalCostAmount;
    } else {
      _returnToCustomerAmount = (_customerBalance ?? 0.0) - totalCostAmount;
    }

    update();
  }

  void applyCouponCodeAndExtraDiscount({required double totalAmount}) {
    double extraDiscount =
        double.tryParse(_extraDiscountController.text.trim()) ?? 0;
    double discountAmount = PriceConverterHelper.discountCalculation(
      Get.context!,
      totalAmount,
      extraDiscount,
      _selectedDiscountType,
    );

    if (discountAmount > totalAmount) {
      showCustomSnackBarHelper(
        '${'discount_cant_greater_than'.tr} ${PriceConverterHelper.convertPrice(Get.context!, totalAmount)}',
      );
    } else {
      _extraDiscountAmount = extraDiscount;
      _currentCartModel?.extraDiscount = extraDiscount;
      _isUpdatePaidAmount = true;
      Get.back();
    }

    update();
  }

  void setReturnAmountToZero({bool isUpdate = true}) {
    _returnToCustomerAmount = 0;
    if (isUpdate) {
      update();
    }
  }

  Future<void> addToCart(CartModel cartModel) async {
    _amount = 0;
    if (_currentCartModel == null) {
      _currentCartModel = getInitialTempCartData();

      // _currentCartModel?.cart?.add(cartModel);
      emptyCurrentCartDiscountAmount();
    }

    if ((_currentCartModel?.cart?.any(
          (e) => e.product?.id == cartModel.product?.id,
        ) ??
        false)) {
      isExistInCart(cartModel);
      emptyCurrentCartDiscountAmount();
    } else {
      _currentCartModel!.cart?.add(cartModel);
      for (int i = 0; i < (_currentCartModel!.cart?.length ?? 0); i++) {
        _amount =
            _amount +
            (_currentCartModel!.cart![i].price! *
                _currentCartModel!.cart![i].quantity!);
      }
      emptyCurrentCartDiscountAmount();
      showCustomSnackBarHelper('added_cart_successfully'.tr, isError: false);
    }

    await Get.find<TransactionController>().getAccountListWithWallet();
    update();
  }

  Future<void> onChangeOrder(int id, double payable) async {
    final TransactionController transactionController =
        Get.find<TransactionController>();

    await setCustomerIndex(_customerIds.indexOf(id), true);

    setCustomerInfo(
      id: customerCartList[customerIndex].userId,
      name: customerCartList[(customerIndex)].customerName,
      phone: customerCartList[(customerIndex)].customerPhone,
      customerBalance: customerCartList[(customerIndex)].customerBalance,
    );

    //transactionController.addCustomerBalanceIntoAccountList(Accounts(id: 0, account: 'Wallet'));
    transactionController.setAccountIndex(1, 'from', true);
    await transactionController.getAccountListWithWallet();
    getReturnAmount(payable);
  }

  void setQuantity(bool isIncrement, int index) {
    if (_currentCartModel?.cart?[index] == null) return;

    _amount = 0;
    if (isIncrement) {
      if (_currentCartModel!.cart![index].product!.quantity! >
          _currentCartModel!.cart![index].quantity!) {
        _currentCartModel!.cart![index].quantity =
            _currentCartModel!.cart![index].quantity! + 1;

        for (int i = 0; i < _currentCartModel!.cart!.length; i++) {
          _amount =
              _amount +
              (_currentCartModel!.cart![i].price! *
                  _currentCartModel!.cart![i].quantity!);
        }
        emptyCurrentCartDiscountAmount();
      } else {
        for (int i = 0; i < _currentCartModel!.cart!.length; i++) {
          _amount =
              _amount +
              (_currentCartModel!.cart![i].price! *
                  _currentCartModel!.cart![i].quantity!);
        }
        showCustomSnackBarHelper('stock_out'.tr);
      }
    } else {
      if (_currentCartModel!.cart![index].quantity! > 1) {
        _currentCartModel!.cart![index].quantity =
            _currentCartModel!.cart![index].quantity! - 1;
        for (int i = 0; i < _currentCartModel!.cart!.length; i++) {
          _amount =
              _amount +
              (_currentCartModel!.cart![i].price! *
                  _currentCartModel!.cart![i].quantity!);
        }
        emptyCurrentCartDiscountAmount();
      } else {
        showCustomSnackBarHelper('minimum_quantity_1'.tr);
        for (int i = 0; i < _currentCartModel!.cart!.length; i++) {
          _amount =
              _amount +
              (_currentCartModel!.cart![i].price! *
                  _currentCartModel!.cart![i].quantity!);
        }
      }
    }
    _isUpdatePaidAmount = true;
    update();
  }

  void removeFromCart(int index) {
    if (_currentCartModel != null) {
      _amount =
          _amount -
          (_currentCartModel!.cart![index].price! *
              _currentCartModel!.cart![index].quantity!);
      _currentCartModel!.cart!.removeAt(index);
    }

    update();
  }

  void removeAllCart() {
    _cartList = [];
    _collectedCashController.clear();
    _extraDiscountAmount = 0;
    _amount = 0;
    _collectedCashController.clear();
    _currentCartModel?.cart = [];

    emptyCurrentCartDiscountAmount();
    update();
  }

  void removeAllCartList() {
    _cartList = [];
    _customerWalletController.clear();
    _extraDiscountAmount = 0;
    _amount = 0;
    _collectedCashController.clear();
    // _customerCartList =[];
    _customerIds = [];
    _customerIndex = 0;
    _customerId = 0;
    update();
  }

  void clearCartList() {
    _cartList = [];
    _amount = 0;
    update();
  }

  bool isExistInCart(CartModel cartModel) {
    cartIndex = 0;
    for (int index = 0; index < _currentCartModel!.cart!.length; index++) {
      if (_currentCartModel!.cart![index].product!.id ==
          cartModel.product!.id) {
        // Handle weight-based products differently
        if (cartModel.isWeightBased == true &&
            _currentCartModel!.cart![index].isWeightBased == true) {
          // For weight-based products, sum the weights and recalculate price
          double currentWeight = _currentCartModel!.cart![index].weight ?? 0.0;
          double newWeight = cartModel.weight ?? 0.0;
          double totalWeight = currentWeight + newWeight;

          // Update weight and recalculate total price
          _currentCartModel!.cart![index].weight = totalWeight;
          _currentCartModel!.cart![index].actualPrice =
              totalWeight * (cartModel.pricePerGram ?? 0.0);
          _currentCartModel!.cart![index].price =
              _currentCartModel!.cart![index].actualPrice;

          showCustomSnackBarHelper(
            '${totalWeight.toStringAsFixed(0)}g ${'of'.tr} ${cartModel.product?.title ?? 'product'} ${'added_to_cart'.tr}',
            isError: false,
          );
        } else {
          // For regular products, increment quantity
          setQuantity(true, index);
          showCustomSnackBarHelper(
            '${'added_cart_successfully'.tr} ${_currentCartModel!.cart![index].quantity} ${'items'.tr}',
            isError: false,
          );
        }

        // Recalculate cart total
        calculateCurrentCartPrice();
        return true;
      }
    }
    return false;
  }

  Future<void> getCouponDiscount(
    String couponCode,
    int? userId,
    double orderAmount,
  ) async {
    Response response = await cartRepo.getCouponDiscount(
      couponCode,
      userId,
      orderAmount,
    );
    if (response.statusCode == 200) {
      bool percent;
      _coupons = Coupons.fromJson(response.body['coupon']);

      percent = _coupons!.discountType == 'percent';
      if (percent) {
        _couponCodeAmount =
            (double.parse(coupons!.discount!) / 100) * orderAmount;
      } else {
        _couponCodeAmount = double.parse(coupons!.discount!);
      }

      _currentCartModel?.couponAmount = _couponCodeAmount;

      showCustomSnackBarHelper(
        '${'you_got'.tr} $_couponCodeAmount ${'discount'.tr}',
        isError: false,
      );
      _isUpdatePaidAmount = true;
    } else if (response.statusCode == 202) {
      Map map = response.body;
      String? message = map['message'];
      showCustomSnackBarHelper(message);
    } else {
      ApiChecker.checkApi(response);
    }
    update();
  }

  void clearCardForCancel() {
    _couponCodeAmount = 0;
    _extraDiscountAmount = 0;
    _coupons = null;
    update();
  }

  Future<Response> placeOrder(PlaceOrderModel placeOrderBody) async {
    _isLoading = true;
    update();

    Response response = await cartRepo.placeOrder(placeOrderBody);
    if (response.statusCode == 200) {
      _returnToCustomerAmount = 0;
      _couponCodeAmount = 0;
      _productDiscount = 0;
      _customerBalance = 0;
      _customerWalletController.clear();
      Get.find<OrderController>().getOrderList(1);
      showCustomSnackBarHelper('order_placed_successfully'.tr, isError: false);
      _extraDiscountAmount = 0;
      _amount = 0;
      _collectedCashController.clear();
      _extraDiscountController.clear();
      initTempCart();

      setReturnAmountToZero();
      _coupons = null;
      _isUpdatePaidAmount = true;

      if (_customerIds.isNotEmpty) {
        _amount = 0;
        setCustomerIndex(0, false);
        Get.find<CartController>().searchCustomerController.text =
            'walk_in_customer'.tr;
        setCustomerInfo(
          id: _customerCartList[_customerIndex].userId,
          name: _customerCartList[_customerIndex].customerName,
          phone: '',
          customerBalance: _customerCartList[_customerIndex].customerBalance,
        );
      }
      Get.to(() => InVoiceScreen(orderId: response.body['order_id']));
    } else {
      ApiChecker.checkApi(response);
    }
    _isLoading = false;
    update();
    return response;
  }

  Future<void> scanProductBarCode() async {
    String? scannedProductBarCode;
    try {
      final result = await BarcodeScanner.scan(
        options: const ScanOptions(
          strings: {
            'cancel': 'cancel',
            'flash_on': 'flash on',
            'flash_off': 'flash off',
          },
          restrictFormat: [BarcodeFormat.code128],
          useCamera: -1,
          autoEnableFlash: false,
          android: AndroidOptions(aspectTolerance: 0.00, useAutoFocus: true),
        ),
      );

      scannedProductBarCode = result.rawContent;
    } catch (e) {
      debugPrint('$e');
    }
    if (scannedProductBarCode != null) {
      getProductFromScan(scannedProductBarCode);
    }
  }

  Future<void> getProductFromScan(String? productCode) async {
    _isLoading = true;
    Response response = await cartRepo.getProductByCode(productCode);
    if (response.statusCode == 200) {
      _scanProduct = [];
      response.body.forEach(
        (categoriesProduct) =>
            _scanProduct.add(CategoriesProduct.fromJson(categoriesProduct)),
      );
      if (_scanProduct.isEmpty) {
        showCustomSnackBarHelper('product_not_found'.tr);
      } else {
        CartModel cartModel = CartModel(
          _scanProduct[0].sellingPrice,
          _scanProduct[0].discount,
          1,
          _scanProduct[0].tax,
          _scanProduct[0],
        );
        addToCart(cartModel);
      }
      _isLoading = false;
    } else {
      ApiChecker.checkApi(response);
    }
    _isLoading = false;
    update();
  }

  Future<void> setCustomerIndex(int index, bool notify) async {
    _amount = 0;
    _customerIndex = index;
    if (_customerCartList.isNotEmpty) {
      for (int i = 0; i < _customerCartList[_customerIndex].cart!.length; i++) {
        _amount =
            _amount +
            (_customerCartList[_customerIndex].cart![i].price! *
                _customerCartList[_customerIndex].cart![i].quantity!);
      }
    }

    if (notify) {
      update();
    }
  }

  Future<void> onSearchCustomer(String search) async {
    _searchedCustomerList = [];
    _isGetting = true;
    Response response = await cartRepo.customerSearch(search);
    if (response.statusCode == 200) {
      _searchedCustomerList = [];
      _searchedCustomerList!.addAll(
        CustomerModel.fromJson(response.body).customerList ?? [],
      );
      update();
      _customerListLength = CustomerModel.fromJson(response.body).totalSize;
      _isGetting = false;
      _isFirst = false;
    } else {
      ApiChecker.checkApi(response);
    }
    _isGetting = false;
    update();
  }

  void setCustomerInfo({
    int? id,
    String? name,
    String? phone,
    double? customerBalance,
    bool notify = true,
    bool isReload = false,
  }) {
    if (isReload) {
      _customerId = 0;
      _customerSelectedName = null;
      _customerSelectedMobile = null;
      _customerBalance = null;

      getInitialTempCartData();
    } else {
      _customerId = id;
      _customerSelectedName = name;
      _customerSelectedMobile = phone;
      _customerBalance = customerBalance;

      _currentCartModel!.userId = id;
      _currentCartModel!.customerName = name;
      _currentCartModel!.customerPhone = phone;
      _currentCartModel!.customerBalance = customerBalance;
    }

    Get.find<CouponController>().getUserWiseCouponList(userId: id ?? 0);
    if (notify) {
      update();
    }
  }

  void setSelectedCouponIndex(
    int? index, {
    bool isUpdate = false,
    bool isClearText = false,
  }) {
    _selectedCouponIndex = index;
    if (index != null &&
        Get.find<CouponController>().userWiseCouponList != null) {
      _couponController.text =
          Get.find<CouponController>().userWiseCouponList?[index].couponCode ??
          '';
    } else if (isClearText) {
      _couponController.text = '';
    }

    if (isUpdate) {
      update();
    }
  }

  void setIsTopSectionShowHoldButton(bool value, {bool isUpdate = true}) {
    _isTopSectionShowHoldButton = value;
    if (isUpdate) {
      update();
    }
  }

  void initTempCartData({bool isUpdate = true}) {
    _currentCartModel = getInitialTempCartData();
    if (isUpdate) {
      notifyChildrens();
    }
  }

  TemporaryCartListModel getInitialTempCartData() {
    final rng = Random();

    searchCustomerController.text = 'walk_in_customer'.tr;
    _customerId = 0;
    _customerSelectedName = 'walk_in_customer'.tr;
    _customerSelectedMobile = null;
    _customerBalance = 0;

    return TemporaryCartListModel(
      cart: [],
      userId: 0,
      holdId: 'wc-${rng.nextInt(10000)}',
      customerName: 'walk_in_customer'.tr,
      customerPhone: '',
      customerBalance: 0,
    );
  }

  initTempCart() {
    _currentCartModel = getInitialTempCartData();
    update();
  }

  void addToHoldUserList() {
    TemporaryCartListModel userCart = currentCartModel!;

    if (userCart.userIndex != null &&
        userCart.userId != 0 &&
        isUserExists(userCart.userId!)) {
      // updateHoldUser(userCart);
    } else {
      emptyCurrentCartDiscountAmount();
      addUserCart(userCart);
    }

    calculateCurrentCartPrice();
    update();
  }

  void addUserCart(TemporaryCartListModel userCart) {
    if (userCart.userId != 0) {
      userCart.holdId = 'sc-${userCart.userId}';
    }
    _customerCartList.add(userCart);
    initTempCart();
    saveCardDataToLocal();
    showCustomSnackBarHelper('cart_successfully_added'.tr, isError: false);
    // cart_successfully_added
  }

  bool isUserExists(int userId) {
    for (int i = 0; i < _customerCartList.length; i++) {
      if (_customerCartList[i].userId == userId) {
        return true;
      }
    }
    return false;
  }

  void saveCardDataToLocal() async {
    cartRepo.addToCartList(_customerCartList);
  }

  void resumeCartFromHoldOrder(TemporaryCartListModel userCart, int index) {
    _currentCartModel = userCart;

    searchCustomerController.text = userCart.customerName ?? '';
    _customerId = userCart.userId ?? 0;
    _customerSelectedName = userCart.customerName ?? '';
    _customerSelectedMobile = userCart.customerPhone;
    _customerBalance = userCart.customerBalance;

    removeCartFromHoldData(index);
    saveCardDataToLocal();

    calculateCurrentCartPrice();
    update();
  }

  void getCartData() {
    List<TemporaryCartListModel> localCartList = cartRepo.getCartList();

    if (localCartList.isNotEmpty) {
      _customerCartList = cartRepo.getCartList();
    }
  }

  void removeCartFromHoldData(int index) {
    _customerCartList.removeAt(index);
    update();
    saveCardDataToLocal();
  }

  void calculateCurrentCartPrice({bool isUpdate = true}) {
    _amount = 0;
    if (_currentCartModel != null &&
        (_currentCartModel?.cart?.isNotEmpty ?? false)) {
      for (int i = 0; i < _currentCartModel!.cart!.length; i++) {
        CartModel cartItem = _currentCartModel!.cart![i];

        double itemPrice;
        if (cartItem.isWeightBased == true && cartItem.actualPrice != null) {
          // For weight-based products, use the actual calculated price
          itemPrice = cartItem.actualPrice! * cartItem.quantity!;
        } else {
          // For regular products, use standard calculation
          itemPrice = cartItem.price! * cartItem.quantity!;
        }

        _amount = _amount + itemPrice;
      }
    }
    _isUpdatePaidAmount = true;
    if (isUpdate) {
      update();
    }
  }

  void emptyCurrentCartDiscountAmount() {
    if (_currentCartModel != null) {
      _currentCartModel?.couponAmount = 0;
      _currentCartModel?.extraDiscount = 0;
      _extraDiscountAmount = 0;
      _couponCodeAmount = 0;
      _extraDiscountController.clear();
    }
  }

  void setUpdatePaidAmount(bool value, {bool isUpdate = true}) {
    _isUpdatePaidAmount = value;
    if (isUpdate) {
      update();
    }
  }

  void removeUnavailableProductFromCard() {
    _currentCartModel?.cart?.removeWhere((cartItem) {
      final isUnavailable = PosScreenHelper.isProductUnAvailable(
        cartItem.product?.availableStartTime,
        cartItem.product?.availableEndTime,
      );
      return isUnavailable;
    });
    calculateCurrentCartPrice(isUpdate: false);
  }
}
