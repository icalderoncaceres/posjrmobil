import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:get/get.dart';
import 'package:six_pos/common/controllers/cart_controller.dart';
import 'package:six_pos/common/widgets/custom_asset_image_widget.dart';
import 'package:six_pos/common/widgets/custom_debounce_widget.dart';
import 'package:six_pos/features/counter/controllers/counter_controller.dart';
import 'package:six_pos/features/coupon/controllers/coupon_controller.dart';
import 'package:six_pos/features/currency/widgets/currency_widgets.dart';
import 'package:six_pos/features/langulage/controllers/localization_controller.dart';
import 'package:six_pos/features/pos/domain/enums/amount_type_enum.dart';
import 'package:six_pos/features/account_management/controllers/transaction_controller.dart';
import 'package:six_pos/common/models/place_order_model.dart';
import 'package:six_pos/common/models/cart_model.dart';
import 'package:six_pos/common/models/temporary_cart_list_model.dart'
    as customer;
import 'package:six_pos/features/pos/widgets/pos_buttons_widget.dart';
import 'package:six_pos/features/product/controllers/product_controller.dart';
import 'package:six_pos/features/splash/controllers/splash_controller.dart';
import 'package:six_pos/features/user/controllers/customer_controller.dart';
import 'package:six_pos/helper/extension_helper.dart';
import 'package:six_pos/helper/price_converter_helper.dart';
import 'package:six_pos/helper/responsive_helper.dart';
import 'package:six_pos/util/dimensions.dart';
import 'package:six_pos/util/images.dart';
import 'package:six_pos/util/styles.dart';
import 'package:six_pos/helper/animated_custom_dialog_helper.dart';
import 'package:six_pos/common/widgets/custom_app_bar_widget.dart';
import 'package:six_pos/common/widgets/custom_divider.dart';
import 'package:six_pos/common/widgets/custom_header_widget.dart';
import 'package:six_pos/helper/show_custom_snackbar_helper.dart';
import 'package:six_pos/common/widgets/custom_text_field_widget.dart';
import 'package:six_pos/features/pos/widgets/item_price_widget.dart';
import 'package:six_pos/features/pos/widgets/confirm_purchase_dialog_widget.dart';
import 'package:six_pos/features/pos/widgets/coupon_dialog_widget.dart';
import 'package:six_pos/features/pos/widgets/customer_search_dialog_widget.dart';
import 'package:six_pos/features/pos/widgets/extra_discount_dialog_widget.dart';
import 'package:six_pos/features/pos/widgets/item_card_widget.dart';
import 'package:six_pos/features/user/screens/add_new_user_screen.dart';

class PosScreen extends StatefulWidget {
  final bool fromMenu;
  const PosScreen({super.key, this.fromMenu = false});

  @override
  State<PosScreen> createState() => _PosScreenState();
}

class _PosScreenState extends State<PosScreen> {
  final ScrollController _scrollController = ScrollController();
  double subTotal = 0,
      productDiscount = 0,
      total = 0,
      payable = 0,
      couponAmount = 0,
      extraDiscount = 0,
      productTax = 0,
      exDiscount = 0;
  final GlobalKey dropDownKey = GlobalKey();

  final LayerLink _link = LayerLink();

  TextEditingController commentController = TextEditingController();
  TextEditingController cardInfoController = TextEditingController();
  TextEditingController phoneOrEmail = TextEditingController();
  TextEditingController searchCustomerController = TextEditingController();

  final FocusNode _searchFocusNode = FocusNode();
  final FocusNode _commentFocusNode = FocusNode();
  final FocusNode _cardInfoFocusNode = FocusNode();
  final FocusNode _phoneOrEmailFocusNode = FocusNode();
  final FocusNode _balanceFocusNode = FocusNode();

  int userId = 0;
  String customerName = '';
  String customerId = '0';
  bool isAmountNotSet = true;

  CustomDebounceWidget customDebounceWidget = CustomDebounceWidget(
    milliseconds: 500,
  );

  String? selectedValue;

  int val = 0;

  final SplashController splashController = Get.find<SplashController>();
  final CartController cartController = Get.find<CartController>();
  final OverlayPortalController overlayPortalController =
      OverlayPortalController();

  void _clearCart() {
    subTotal = 0;
    productDiscount = 0;
    total = 0;
    payable = 0;
    couponAmount = 0;
    extraDiscount = 0;
    productTax = 0;
    cartController.currentCartModel?.cart!.clear();
    cartController.removeAllCart();
    cartController.setReturnAmountToZero();
  }

  @override
  void initState() {
    super.initState();

    if (cartController.currentCartModel == null) {
      Get.find<CartController>().initTempCartData();
    }

    Get.find<CartController>().removeUnavailableProductFromCard();
    cartController.setReturnAmountToZero(isUpdate: false);
    Get.find<TransactionController>().setFromAccountIndex = null;
    Get.find<TransactionController>().setSelectedFromAccountId = null;
    Get.find<TransactionController>().setSelectedCounterNumberID(
      isUpdate: false,
    );
    _scrollController.addListener(_scrollListener);
    Get.find<CouponController>().getUserWiseCouponList(
      userId: cartController.customerId ?? 0,
    );
    Get.find<CartController>().setUpdatePaidAmount(true, isUpdate: false);
    cartController.setIsTopSectionShowHoldButton(true, isUpdate: false);

    SchedulerBinding.instance.addPostFrameCallback((_) {
      cartController.collectedCashController.text = '0';

      if (cartController.customerSelectedName == '') {
        cartController.searchCustomerController.text = 'walk_in_customer'.tr;
      }
    });
  }

  void _scrollListener() {
    if (_scrollController.position.pixels <
            _scrollController.position.maxScrollExtent * .97 ||
        (MediaQuery.of(context).viewInsets.bottom > 0)) {
      cartController.setIsTopSectionShowHoldButton(true);
    } else {
      cartController.setIsTopSectionShowHoldButton(false);
    }
  }

  void _openDropdown() {
    final dropdownContext = dropDownKey.currentContext;

    if (dropdownContext != null) {
      GestureDetector? detector;
      void searchGestureDetector(BuildContext context) {
        context.visitChildElements((element) {
          if (element.widget is GestureDetector) {
            detector = element.widget as GestureDetector?;
          } else {
            searchGestureDetector(element);
          }
        });
      }

      searchGestureDetector(dropdownContext);

      detector?.onTap?.call();
    }
  }

  @override
  void dispose() {
    commentController.dispose();
    cardInfoController.dispose();
    phoneOrEmail.dispose();
    unFocusCustomNode();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    customerId = Get.find<CartController>().customerId.toString();
    final isKeyboardOpen = MediaQuery.of(context).viewInsets.bottom > 0;

    return GestureDetector(
      onTap: () => Get.find<CartController>().setSearchCustomerList(null),
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: widget.fromMenu ? const CustomAppBarWidget() : null,
        body: RefreshIndicator(
          color: Theme.of(context).cardColor,
          backgroundColor: Theme.of(context).primaryColor,
          onRefresh: () async {},
          child: GetBuilder<CartController>(
            builder: (cartController) {
              productDiscount = _getAmount(
                cartController.currentCartModel,
                cartController.customerIndex,
                AmountType.discount,
              );

              total = 0;
              productTax = _getAmount(
                cartController.currentCartModel,
                cartController.customerIndex,
                AmountType.tax,
              );
              subTotal = cartController.amount;

              if (cartController.currentCartModel != null) {
                couponAmount =
                    cartController.currentCartModel?.couponAmount ?? 0;
                exDiscount =
                    cartController.currentCartModel?.extraDiscount ?? 0;
              } else {
                subTotal = 0;
                productDiscount = 0;
                total = 0;
                payable = 0;
                couponAmount = 0;
                extraDiscount = 0;
                productTax = 0;
                exDiscount = 0;
              }

              extraDiscount = double.parse(
                PriceConverterHelper.discountCalculationWithOutSymbol(
                  context,
                  (subTotal - productDiscount - couponAmount),
                  exDiscount,
                  cartController.selectedDiscountType,
                ),
              );
              total =
                  subTotal -
                  productDiscount -
                  couponAmount -
                  extraDiscount +
                  productTax;
              payable = total;

              if (isAmountNotSet || cartController.isUpdatePaidAmount) {
                // Convert total to active currency before displaying
                double convertedTotal =
                    PriceConverterHelper.convertToActiveCurrency(total);
                cartController.collectedCashController.text = convertedTotal
                    .toStringAsFixed(2);
                if (cartController.isUpdatePaidAmount) {
                  cartController.setUpdatePaidAmount(false, isUpdate: false);
                }
                isAmountNotSet = false;
              }

              return Stack(
                children: [
                  SingleChildScrollView(
                    controller: _scrollController,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: Dimensions.productCartImageSize),

                        CustomHeaderWidget(
                          title: 'billing_section'.tr,
                          headerImage: Images.billingSection,
                        ),
                        const SizedBox(height: Dimensions.paddingSizeSmall),

                        ///counter number section
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: Dimensions.paddingSizeDefault,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'counter_number'.tr,
                                style: ubuntuMedium.copyWith(
                                  color: Theme.of(context).primaryColor,
                                  fontSize: Dimensions.fontSizeDefault,
                                ),
                              ),
                              const SizedBox(
                                height: Dimensions.paddingSizeSmall,
                              ),

                              GetBuilder<CounterController>(
                                id: 'counter-list',
                                builder: (counterController) {
                                  return GetBuilder<TransactionController>(
                                    builder: (transactionController) {
                                      return DropdownButtonFormField<String>(
                                        key: dropDownKey,
                                        value: transactionController
                                            .selectedCounterID
                                            ?.toString(),
                                        decoration: InputDecoration(
                                          contentPadding:
                                              const EdgeInsets.symmetric(
                                                horizontal:
                                                    Dimensions.paddingSizeSmall,
                                              ),
                                          enabledBorder: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(
                                              Dimensions
                                                  .paddingSizeMediumBorder,
                                            ),
                                            borderSide: BorderSide(
                                              color: Theme.of(context).hintColor
                                                  .withValues(alpha: 0.5),
                                            ),
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(
                                              Dimensions
                                                  .paddingSizeMediumBorder,
                                            ),
                                            borderSide: BorderSide(
                                              color: Theme.of(context).hintColor
                                                  .withValues(alpha: 0.5),
                                            ),
                                          ),
                                          border: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(
                                              Dimensions
                                                  .paddingSizeMediumBorder,
                                            ),
                                          ),
                                        ),
                                        isExpanded: true,
                                        isDense: true,
                                        padding: EdgeInsets.zero,
                                        hint: Text(
                                          "no_counter_found".tr,
                                          style: ubuntuRegular.copyWith(
                                            color: context
                                                .customThemeColors
                                                .textColor,
                                            fontSize:
                                                Dimensions.fontSizeDefault,
                                          ),
                                        ),
                                        icon: const Icon(
                                          Icons.keyboard_arrow_down,
                                        ),
                                        items: (counterController.activeCounterList ?? [])
                                            .map<DropdownMenuItem<String>>((
                                              counter,
                                            ) {
                                              return DropdownMenuItem<String>(
                                                value: "${counter.id}",
                                                child: Row(
                                                  children: [
                                                    Text(
                                                      "${counter.name}",
                                                      style: ubuntuRegular
                                                          .copyWith(
                                                            color:
                                                                Theme.of(
                                                                      context,
                                                                    )
                                                                    .textTheme
                                                                    .bodyLarge
                                                                    ?.color,
                                                            fontSize: Dimensions
                                                                .fontSizeLarge,
                                                          ),
                                                    ),

                                                    Text(
                                                      " - ${counter.number}",
                                                      style: ubuntuRegular
                                                          .copyWith(
                                                            color:
                                                                Theme.of(
                                                                      context,
                                                                    )
                                                                    .textTheme
                                                                    .bodyLarge
                                                                    ?.color,
                                                            fontSize: Dimensions
                                                                .fontSizeLarge,
                                                          ),
                                                    ),
                                                  ],
                                                ),
                                              );
                                            })
                                            .toList(),
                                        onChanged: (String? newValue) {
                                          transactionController
                                              .setSelectedCounterNumberID(
                                                counterID: int.parse(newValue!),
                                                isUpdate: true,
                                              );
                                        },
                                      );
                                    },
                                  );
                                },
                              ),
                              const SizedBox(
                                height: Dimensions.paddingSizeDefault,
                              ),
                            ],
                          ),
                        ),

                        GetBuilder<CartController>(
                          builder: (cartController) {
                            return Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: Dimensions.paddingSizeDefault,
                              ),
                              child: Column(
                                children: [
                                  ///add new customer button
                                  GetBuilder<LocalizationController>(
                                    builder: (localizationController) {
                                      return Align(
                                        alignment: localizationController.isLtr
                                            ? Alignment.centerRight
                                            : Alignment.centerLeft,
                                        child: InkWell(
                                          onTap: () => Get.to(
                                            () => const AddNewUserScreen(
                                              isCustomer: true,
                                            ),
                                          ),
                                          child: Text(
                                            "+${"add_customer".tr}",
                                            style: ubuntuMedium.copyWith(
                                              decoration:
                                                  TextDecoration.underline,
                                              color: Theme.of(
                                                context,
                                              ).primaryColor,
                                              fontSize:
                                                  Dimensions.fontSizeLarge,
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                  const SizedBox(
                                    height: Dimensions.paddingSizeSmall,
                                  ),

                                  ///Customer search textfield
                                  Stack(
                                    clipBehavior: Clip.none,
                                    children: [
                                      CompositedTransformTarget(
                                        link: _link,
                                        child: OverlayPortal(
                                          controller: overlayPortalController,
                                          overlayChildBuilder: (BuildContext context) {
                                            return CompositedTransformFollower(
                                              link: _link,
                                              targetAnchor:
                                                  Alignment.bottomLeft,
                                              child: Align(
                                                alignment: Alignment.topLeft,
                                                child: CustomerSearchDialogWidget(
                                                  overlayPortalController:
                                                      overlayPortalController,
                                                ),
                                              ),
                                            );
                                          },
                                          child: CustomTextFieldWidget(
                                            focusNode: _searchFocusNode,
                                            hintText: 'search_customer'.tr,
                                            controller: cartController
                                                .searchCustomerController,
                                            onChanged: (value) {
                                              if (value.isEmpty &&
                                                  (overlayPortalController
                                                      .isShowing)) {
                                                overlayPortalController.hide();
                                              }
                                              customDebounceWidget.run(() {
                                                cartController.onSearchCustomer(
                                                  value,
                                                );
                                                overlayPortalController.show();
                                              });
                                            },
                                            suffixIcon: Images.search,
                                            suffix: true,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(
                                    height: Dimensions.paddingSizeDefault,
                                  ),

                                  GetBuilder<LocalizationController>(
                                    builder: (localizationController) {
                                      return Container(
                                        padding:
                                            const EdgeInsets.symmetric(
                                              vertical:
                                                  Dimensions.paddingSizeLarge,
                                            ).copyWith(
                                              left: localizationController.isLtr
                                                  ? Dimensions.paddingSizeLarge
                                                  : 0,
                                              right:
                                                  !localizationController.isLtr
                                                  ? Dimensions.paddingSizeLarge
                                                  : 0,
                                            ),
                                        decoration: BoxDecoration(
                                          color: Theme.of(context)
                                              .primaryColorLight
                                              .withValues(alpha: 0.2),
                                          borderRadius: BorderRadius.circular(
                                            Dimensions.radiusSmall,
                                          ),
                                        ),
                                        child: Column(
                                          children: [
                                            Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                const CustomAssetImageWidget(
                                                  Images.userIcon,
                                                  height: 16,
                                                  width: 16,
                                                ),
                                                const SizedBox(
                                                  width: Dimensions
                                                      .paddingSizeSmall,
                                                ),

                                                Text(
                                                  (cartController
                                                              .customerSelectedName
                                                              ?.isNotEmpty ??
                                                          false)
                                                      ? cartController
                                                            .customerSelectedName!
                                                      : 'walk_in_customer'.tr,
                                                  style: ubuntuRegular.copyWith(
                                                    fontSize: Dimensions
                                                        .fontSizeDefault,
                                                    color: Theme.of(context)
                                                        .textTheme
                                                        .bodyLarge
                                                        ?.color,
                                                  ),
                                                ),
                                              ],
                                            ),

                                            ///selected walk-In  customer card section
                                            if ((cartController
                                                        .customerSelectedMobile
                                                        ?.isNotEmpty ??
                                                    false) &&
                                                !cartController
                                                    .customerSelectedMobile!
                                                    .startsWith('1')) ...[
                                              const SizedBox(
                                                height:
                                                    Dimensions.paddingSizeSmall,
                                              ),
                                              Row(
                                                children: [
                                                  const CustomAssetImageWidget(
                                                    Images.phoneIcon,
                                                    height: 16,
                                                    width: 16,
                                                  ),
                                                  const SizedBox(
                                                    width: Dimensions
                                                        .paddingSizeSmall,
                                                  ),

                                                  Text(
                                                    cartController
                                                            .customerSelectedMobile ??
                                                        '',
                                                    style: ubuntuRegular
                                                        .copyWith(
                                                          fontSize: Dimensions
                                                              .fontSizeDefault,
                                                          color:
                                                              Theme.of(context)
                                                                  .textTheme
                                                                  .bodyLarge
                                                                  ?.color,
                                                        ),
                                                  ),
                                                ],
                                              ),
                                            ],

                                            if (cartController
                                                        .customerBalance !=
                                                    null &&
                                                ((cartController
                                                            .customerSelectedName
                                                            ?.isNotEmpty ??
                                                        false) &&
                                                    cartController.customerId !=
                                                        0)) ...[
                                              const SizedBox(
                                                height:
                                                    Dimensions.paddingSizeSmall,
                                              ),
                                              Row(
                                                children: [
                                                  const CustomAssetImageWidget(
                                                    Images.walletIcon,
                                                    height: 16,
                                                    width: 16,
                                                  ),
                                                  const SizedBox(
                                                    width: Dimensions
                                                        .paddingSizeSmall,
                                                  ),

                                                  Text(
                                                    "${'wallet_balance'.tr}:",
                                                    style: ubuntuRegular
                                                        .copyWith(
                                                          fontSize: Dimensions
                                                              .fontSizeDefault,
                                                          color:
                                                              Theme.of(context)
                                                                  .textTheme
                                                                  .bodyLarge
                                                                  ?.color,
                                                        ),
                                                  ),
                                                  const SizedBox(
                                                    width: Dimensions
                                                        .paddingSizeSmall,
                                                  ),

                                                  Text(
                                                    PriceConverterHelper.convertPrice(
                                                      context,
                                                      cartController
                                                              .customerBalance ??
                                                          0.0,
                                                    ),
                                                    style: ubuntuMedium
                                                        .copyWith(
                                                          fontSize: Dimensions
                                                              .fontSizeDefault,
                                                          color:
                                                              Theme.of(context)
                                                                  .textTheme
                                                                  .bodyLarge
                                                                  ?.color,
                                                        ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ],
                                        ),
                                      );
                                    },
                                  ),
                                  if (cartController
                                          .currentCartModel
                                          ?.cart
                                          ?.isNotEmpty ??
                                      false)
                                    const SizedBox(
                                      height: Dimensions.paddingSizeDefault,
                                    ),
                                ],
                              ),
                            );
                          },
                        ),

                        if (cartController.currentCartModel?.cart?.isNotEmpty ??
                            false)
                          Container(
                            padding: const EdgeInsets.fromLTRB(
                              Dimensions.paddingSizeDefault,
                              0,
                              Dimensions.paddingSizeDefault,
                              0,
                            ),
                            height: 50,
                            decoration: BoxDecoration(
                              color: Theme.of(
                                context,
                              ).primaryColor.withValues(alpha: .06),
                            ),
                            child: Row(
                              children: [
                                Expanded(
                                  flex: 7,
                                  child: Text(
                                    'item_info'.tr,
                                    style: ubuntuBold,
                                  ),
                                ),

                                Expanded(
                                  flex: ResponsiveHelper.isTab(context) ? 4 : 3,
                                  child: Text('qty'.tr, style: ubuntuBold),
                                ),

                                Expanded(
                                  flex: 2,
                                  child: Text(
                                    'price'.tr,
                                    style: ubuntuBold,
                                    textAlign: TextAlign.right,
                                  ),
                                ),
                              ],
                            ),
                          ),

                        (cartController.currentCartModel != null &&
                                cartController
                                    .currentCartModel!
                                    .cart!
                                    .isNotEmpty)
                            ? GetBuilder<CartController>(
                                builder: (custController) {
                                  return ListView.builder(
                                    itemCount: cartController
                                        .currentCartModel!
                                        .cart!
                                        .length,
                                    shrinkWrap: true,
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    itemBuilder: (itemContext, index) {
                                      return ItemCartWidget(
                                        cartModel: cartController
                                            .currentCartModel!
                                            .cart![index],
                                        index: index,
                                      );
                                    },
                                  );
                                },
                              )
                            : const SizedBox(),

                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: Dimensions.paddingSizeSmall),

                            // Currency Selector
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: Dimensions.fontSizeDefault,
                                vertical: Dimensions.paddingSizeDefault,
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.monetization_on,
                                        color: Theme.of(context).primaryColor,
                                        size: 20,
                                      ),
                                      const SizedBox(
                                        width: Dimensions.paddingSizeSmall,
                                      ),
                                      Text(
                                        'currency'.tr,
                                        style: ubuntuMedium.copyWith(
                                          fontSize: Dimensions.fontSizeDefault,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(
                                    height: Dimensions.paddingSizeSmall,
                                  ),
                                  CurrencySelectorWidget(
                                    onCurrencyChanged: () {
                                      // Refresh cart to update prices
                                      Get.find<CartController>().getCartData();
                                      // Recalculate current cart prices with new currency
                                      Get.find<CartController>()
                                          .calculateCurrentCartPrice();
                                      // Update paid amount to new currency
                                      Get.find<CartController>()
                                          .setUpdatePaidAmount(true);
                                    },
                                  ),
                                ],
                              ),
                            ),

                            const Divider(),

                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: Dimensions.fontSizeDefault,
                                vertical: Dimensions.paddingSizeExtraLarge,
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Text(
                                    'bill_summery'.tr,
                                    style: ubuntuMedium.copyWith(
                                      fontSize: Dimensions.fontSizeLarge,
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            ItemPriceWidget(
                              title: 'subtotal'.tr,
                              amount: PriceConverterHelper.priceWithSymbol(
                                subTotal,
                              ),
                            ),

                            ItemPriceWidget(
                              title: "discount".tr,
                              amount: PriceConverterHelper.priceWithSymbol(
                                productDiscount,
                              ),
                              sign: "negative_sign".tr,
                            ),

                            ItemPriceWidget(
                              title: "coupon_discount".tr,
                              amount: PriceConverterHelper.priceWithSymbol(
                                couponAmount,
                              ),
                              isEditButton: true,
                              onTap: () {
                                if (cartController
                                        .currentCartModel
                                        ?.cart
                                        ?.isEmpty ??
                                    false) {
                                  showCustomSnackBarHelper(
                                    'add_a_product_first'.tr,
                                  );
                                } else {
                                  showAnimatedDialogHelper(
                                    context,
                                    CouponDialogWidget(
                                      discountedOrderAmount:
                                          (subTotal - productDiscount),
                                    ),
                                    dismissible: false,
                                    isFlip: false,
                                  );
                                }
                              },
                            ),

                            ItemPriceWidget(
                              title: "extra_discount".tr,
                              amount: PriceConverterHelper.convertPrice(
                                context,
                                PriceConverterHelper.discountCalculation(
                                  context,
                                  (subTotal - productDiscount - couponAmount),
                                  cartController.extraDiscountAmount,
                                  cartController.selectedDiscountType,
                                ),
                              ),
                              isEditButton: true,
                              onTap: () {
                                if (cartController
                                        .currentCartModel
                                        ?.cart
                                        ?.isEmpty ??
                                    false) {
                                  showCustomSnackBarHelper(
                                    'add_a_product_first'.tr,
                                  );
                                } else {
                                  showAnimatedDialogHelper(
                                    context,
                                    ExtraDiscountDialogWidget(
                                      totalAmount:
                                          (subTotal -
                                          productDiscount -
                                          couponAmount),
                                    ),
                                    dismissible: false,
                                    isFlip: false,
                                  );
                                }
                              },
                            ),

                            ItemPriceWidget(
                              title: 'vat_or_tax'.tr,
                              amount: PriceConverterHelper.priceWithSymbol(
                                productTax,
                              ),
                              sign: "positive_sign".tr,
                            ),

                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: Dimensions.paddingSizeDefault,
                                vertical: Dimensions.paddingSizeSmall,
                              ),
                              child: CustomDividerWidget(
                                height: .4,
                                color: Theme.of(
                                  context,
                                ).hintColor.withValues(alpha: 1),
                              ),
                            ),

                            ItemPriceWidget(
                              title: 'total'.tr,
                              amount: PriceConverterHelper.priceWithSymbol(
                                total,
                              ),
                              isBold: true,
                            ),

                            Padding(
                              padding: const EdgeInsets.fromLTRB(
                                Dimensions.paddingSizeDefault,
                                Dimensions.paddingSizeExtraSmall,
                                Dimensions.paddingSizeDefault,
                                Dimensions.paddingSizeExtraSmall,
                              ),
                              child: Text(
                                'payment_method'.tr,
                                style: ubuntuMedium.copyWith(
                                  color: Theme.of(
                                    context,
                                  ).textTheme.bodyLarge?.color,
                                ),
                              ),
                            ),

                            GetBuilder<TransactionController>(
                              builder: (transactionController) {
                                return (transactionController
                                            .fromAccountIds
                                            ?.isNotEmpty ??
                                        false)
                                    ? SizedBox(
                                        height: 40,
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal:
                                                Dimensions.paddingSizeDefault,
                                          ),
                                          child: ListView.separated(
                                            itemCount:
                                                transactionController
                                                    .accountWithWalletList
                                                    ?.length ??
                                                0,
                                            shrinkWrap: true,
                                            scrollDirection: Axis.horizontal,
                                            physics:
                                                const AlwaysScrollableScrollPhysics(),
                                            separatorBuilder:
                                                (context, index) =>
                                                    const SizedBox(
                                                      width: Dimensions
                                                          .paddingSizeDefault,
                                                    ),
                                            itemBuilder: (context, index) {
                                              return InkWell(
                                                onTap: () {
                                                  transactionController
                                                      .setAccountIndex(
                                                        transactionController
                                                            .accountWithWalletList?[index]
                                                            .id,
                                                        'from',
                                                        true,
                                                      );
                                                  cartController
                                                      .collectedCashController
                                                      .clear();

                                                  if (transactionController
                                                          .accountWithWalletList?[index]
                                                          .account !=
                                                      'Wallet') {
                                                    cartController
                                                        .collectedCashController
                                                        .text = total
                                                        .toStringAsFixed(2);
                                                  }

                                                  cartController
                                                      .getReturnAmount(payable);
                                                  clearData();
                                                },
                                                child: Container(
                                                  width: 150,
                                                  padding:
                                                      const EdgeInsets.symmetric(
                                                        horizontal: Dimensions
                                                            .paddingSizeDefault,
                                                        vertical: Dimensions
                                                            .paddingSizeSmall,
                                                      ),
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                          Dimensions
                                                              .radiusSmall,
                                                        ),
                                                    border: Border.all(
                                                      color:
                                                          transactionController
                                                                  .selectedFromAccountId ==
                                                              transactionController
                                                                  .accountWithWalletList?[index]
                                                                  .id
                                                          ? Colors.transparent
                                                          : Theme.of(context)
                                                                .hintColor
                                                                .withValues(
                                                                  alpha: 0.4,
                                                                ),
                                                    ),
                                                    color:
                                                        transactionController
                                                                .selectedFromAccountId ==
                                                            transactionController
                                                                .accountWithWalletList?[index]
                                                                .id
                                                        ? Theme.of(
                                                            context,
                                                          ).primaryColor
                                                        : Theme.of(
                                                            context,
                                                          ).cardColor,
                                                  ),
                                                  child: Text(
                                                    transactionController
                                                            .accountWithWalletList?[index]
                                                            .account ??
                                                        '',
                                                    style: ubuntuMedium.copyWith(
                                                      color:
                                                          transactionController
                                                                  .selectedFromAccountId ==
                                                              transactionController
                                                                  .accountWithWalletList?[index]
                                                                  .id
                                                          ? Theme.of(
                                                              context,
                                                            ).cardColor
                                                          : Theme.of(context)
                                                                .textTheme
                                                                .bodyLarge
                                                                ?.color,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                    ),
                                                  ),
                                                ),
                                              );
                                            },
                                          ),
                                        ),
                                      )
                                    : const SizedBox.shrink();
                              },
                            ),
                            const SizedBox(
                              height: Dimensions.paddingSizeDefault,
                            ),

                            GetBuilder<TransactionController>(
                              builder: (transactionController) {
                                return !_isShowPaidAmount(transactionController)
                                    ? const SizedBox.shrink()
                                    : Container(
                                        padding: const EdgeInsets.fromLTRB(
                                          Dimensions.paddingSizeDefault,
                                          Dimensions.paddingSizeExtraSmall,
                                          Dimensions.paddingSizeDefault,
                                          Dimensions.paddingSizeExtraSmall,
                                        ),
                                        child: Column(
                                          children: [
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Text(
                                                  'paid_amount'.tr,
                                                  style: ubuntuRegular.copyWith(
                                                    color: Theme.of(context)
                                                        .textTheme
                                                        .bodyLarge!
                                                        .color!
                                                        .withValues(alpha: 0.5),
                                                    fontSize: Dimensions
                                                        .fontSizeLarge,
                                                  ),
                                                ),

                                                GetBuilder<CartController>(
                                                  builder: (customerController) {
                                                    return Container(
                                                      decoration: BoxDecoration(
                                                        border: Border.all(
                                                          color:
                                                              transactionController
                                                                      .selectedFromAccountId ==
                                                                  0
                                                              ? Theme.of(
                                                                  context,
                                                                ).hintColor
                                                              : Theme.of(
                                                                      context,
                                                                    )
                                                                    .primaryColorLight
                                                                    .withValues(
                                                                      alpha:
                                                                          0.02,
                                                                    ),
                                                          width:
                                                              transactionController
                                                                      .selectedFromAccountId ==
                                                                  0
                                                              ? 0
                                                              : 1,
                                                        ),
                                                        borderRadius:
                                                            BorderRadius.circular(
                                                              Dimensions
                                                                  .paddingSizeMediumBorder,
                                                            ),
                                                      ),
                                                      child: SizedBox(
                                                        width: 150,
                                                        child: CustomTextFieldWidget(
                                                          borderColor: Theme.of(
                                                            context,
                                                          ).hintColor,
                                                          hintText:
                                                              'balance_hint'.tr,
                                                          focusNode:
                                                              _balanceFocusNode,
                                                          isEnabled:
                                                              !_isPaidAmountDisable(
                                                                transactionController,
                                                              ),
                                                          controller:
                                                              transactionController
                                                                          .selectedFromAccountId ==
                                                                      0 &&
                                                                  Get.find<
                                                                            CartController
                                                                          >()
                                                                          .customerId !=
                                                                      0
                                                              ? cartController
                                                                    .customerWalletController
                                                              : cartController
                                                                    .collectedCashController,
                                                          inputType:
                                                              transactionController
                                                                      .selectedFromAccountId ==
                                                                  1
                                                              ? TextInputType
                                                                    .number
                                                              : TextInputType
                                                                    .text,
                                                          onChanged: (value) {
                                                            print(
                                                              "===OnchangesValue====>>$value",
                                                            );

                                                            if (transactionController
                                                                    .selectedFromAccountId ==
                                                                1) {
                                                              cartController
                                                                  .getReturnAmount(
                                                                    payable,
                                                                  );
                                                            }
                                                          },
                                                        ),
                                                      ),
                                                    );
                                                  },
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      );
                              },
                            ),

                            GetBuilder<TransactionController>(
                              builder: (transactionController) {
                                return transactionController
                                                .selectedFromAccountId !=
                                            null &&
                                        _isShowCardNumber(transactionController)
                                    ? Padding(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal:
                                              Dimensions.paddingSizeDefault,
                                        ),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              'card_no'.tr,
                                              style: ubuntuRegular.copyWith(
                                                fontSize:
                                                    Dimensions.fontSizeDefault,
                                                color: Theme.of(
                                                  context,
                                                ).textTheme.bodyLarge?.color,
                                              ),
                                            ),
                                            const SizedBox(
                                              height:
                                                  Dimensions.paddingSizeSmall,
                                            ),

                                            CustomTextFieldWidget(
                                              focusNode: _cardInfoFocusNode,
                                              controller: cardInfoController,
                                              hintText: 'card_hint_text'.tr,
                                            ),
                                          ],
                                        ),
                                      )
                                    : const SizedBox.shrink();
                              },
                            ),
                            const SizedBox(height: Dimensions.paddingSizeSmall),

                            GetBuilder<TransactionController>(
                              builder: (transactionController) {
                                return transactionController
                                                .selectedFromAccountId !=
                                            null &&
                                        _isWalletSelected(transactionController)
                                    ? Padding(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal:
                                              Dimensions.paddingSizeDefault,
                                        ),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              'phone_or_email'.tr,
                                              style: ubuntuRegular.copyWith(
                                                fontSize:
                                                    Dimensions.fontSizeDefault,
                                                color: Theme.of(
                                                  context,
                                                ).textTheme.bodyLarge?.color,
                                              ),
                                            ),
                                            const SizedBox(
                                              height:
                                                  Dimensions.paddingSizeSmall,
                                            ),

                                            CustomTextFieldWidget(
                                              controller: phoneOrEmail,
                                              focusNode: _phoneOrEmailFocusNode,
                                              hintText:
                                                  'phone_or_email_hint'.tr,
                                            ),
                                            const SizedBox(
                                              height:
                                                  Dimensions.paddingSizeSmall,
                                            ),

                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Text(
                                                  'customer_balance'.tr,
                                                  style: ubuntuRegular.copyWith(
                                                    fontSize: Dimensions
                                                        .fontSizeDefault,
                                                    color: Theme.of(context)
                                                        .textTheme
                                                        .bodyLarge
                                                        ?.color,
                                                  ),
                                                ),

                                                Text(
                                                  PriceConverterHelper.convertPrice(
                                                    context,
                                                    cartController
                                                        .customerBalance,
                                                  ).tr,
                                                  style: ubuntuMedium.copyWith(
                                                    fontSize: Dimensions
                                                        .fontSizeDefault,
                                                    color: Theme.of(context)
                                                        .textTheme
                                                        .bodyLarge
                                                        ?.color,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            const SizedBox(
                                              height:
                                                  Dimensions.paddingSizeSmall,
                                            ),

                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Text(
                                                  'remaining_balance'.tr,
                                                  style: ubuntuRegular.copyWith(
                                                    fontSize: Dimensions
                                                        .fontSizeDefault,
                                                    color: Theme.of(context)
                                                        .textTheme
                                                        .bodyLarge
                                                        ?.color,
                                                  ),
                                                ),

                                                Text(
                                                  PriceConverterHelper.convertPrice(
                                                    context,
                                                    ((cartController
                                                                .customerBalance ??
                                                            0.0) -
                                                        total),
                                                  ).tr,
                                                  style: ubuntuMedium.copyWith(
                                                    fontSize: Dimensions
                                                        .fontSizeDefault,
                                                    color: Theme.of(context)
                                                        .textTheme
                                                        .bodyLarge
                                                        ?.color,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            const SizedBox(
                                              height:
                                                  Dimensions.paddingSizeSmall,
                                            ),
                                          ],
                                        ),
                                      )
                                    : const SizedBox.shrink();
                              },
                            ),

                            GetBuilder<TransactionController>(
                              builder: (transactionController) {
                                return transactionController
                                                .selectedFromAccountId ==
                                            0 ||
                                        transactionController
                                                .selectedFromAccountId ==
                                            1
                                    ? Container(
                                        padding: const EdgeInsets.fromLTRB(
                                          Dimensions.paddingSizeDefault,
                                          0,
                                          Dimensions.paddingSizeDefault,
                                          Dimensions.paddingSizeExtraSmall,
                                        ),
                                        child: Row(
                                          children: [
                                            Text(
                                              transactionController
                                                              .selectedFromAccountId ==
                                                          0 &&
                                                      Get.find<CartController>()
                                                              .customerId !=
                                                          0
                                                  ? 'remaining_balance'.tr
                                                  : transactionController
                                                            .selectedFromAccountId ==
                                                        1
                                                  ? 'change_amount'.tr
                                                  : '',
                                              style: ubuntuRegular.copyWith(
                                                color: Theme.of(
                                                  context,
                                                ).textTheme.bodyLarge?.color,
                                              ),
                                            ),
                                            const Spacer(),

                                            Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                    horizontal: Dimensions
                                                        .paddingSizeSmall,
                                                    vertical: Dimensions
                                                        .paddingSizeExtraSmall,
                                                  ),
                                              child: Text(
                                                PriceConverterHelper.priceWithSymbol(
                                                  cartController
                                                      .returnToCustomerAmount,
                                                ),
                                                style: ubuntuSemiBold.copyWith(
                                                  color: Theme.of(
                                                    context,
                                                  ).textTheme.bodyLarge?.color,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      )
                                    : const SizedBox();
                              },
                            ),

                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: Dimensions.paddingSizeDefault,
                              ),
                              child: Text(
                                'comments'.tr,
                                style: ubuntuMedium.copyWith(
                                  fontSize: Dimensions.fontSizeDefault,
                                  color: Theme.of(
                                    context,
                                  ).textTheme.bodyLarge!.color,
                                ),
                              ),
                            ),
                            const SizedBox(height: Dimensions.paddingSizeSmall),

                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: Dimensions.paddingSizeDefault,
                              ),
                              child: CustomTextFieldWidget(
                                maxLines: 3,
                                focusNode: _commentFocusNode,
                                controller: commentController,
                              ),
                            ),

                            SizedBox(
                              height: isKeyboardOpen
                                  ? 0
                                  : Dimensions.productCartImageSize,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  Positioned(
                    left: 0,
                    top: 0,
                    right: 0,
                    child: GetBuilder<CartController>(
                      builder: (cartController) {
                        return AnimatedOpacity(
                          duration: const Duration(milliseconds: 500),
                          opacity: cartController.isTopSectionShowHoldButton
                              ? 1
                              : 0,
                          child: Card(
                            margin: EdgeInsets.zero,
                            elevation: 5,
                            shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(20),
                                bottomRight: Radius.circular(20),
                              ),
                            ),
                            child: AnimatedContainer(
                              duration: const Duration(seconds: 1),
                              height: cartController.isTopSectionShowHoldButton
                                  ? 80
                                  : 0,
                              child: Card(
                                margin: EdgeInsets.zero,
                                elevation: 5,
                                shape: const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.only(
                                    bottomLeft: Radius.circular(20),
                                    bottomRight: Radius.circular(20),
                                  ),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(15),
                                  child: PosButtonsWidget(
                                    onClearButtonTap: _clearCart,
                                    onPlaceOrderButtonTap: _onSubmit,
                                    onHoldButtonTap: _onHoldButtonPress,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),

                  if (!isKeyboardOpen)
                    Positioned(
                      left: 0,
                      right: 0,
                      bottom: 0,
                      child: AnimatedContainer(
                        duration: const Duration(seconds: 1),
                        height: cartController.isTopSectionShowHoldButton
                            ? 0
                            : 80,
                        child: !cartController.isTopSectionShowHoldButton
                            ? Padding(
                                padding:
                                    const EdgeInsets.symmetric(
                                      horizontal: Dimensions.paddingSizeDefault,
                                    ).copyWith(
                                      bottom: Dimensions.paddingSizeExtraLarge,
                                    ),
                                child: PosButtonsWidget(
                                  onClearButtonTap: _clearCart,
                                  onPlaceOrderButtonTap: _onSubmit,
                                  onHoldButtonTap: _onHoldButtonPress,
                                ),
                              )
                            : SizedBox.shrink(),
                      ),
                    ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  void _onHoldButtonPress() {
    if (cartController.currentCartModel != null &&
        cartController.currentCartModel!.cart!.isEmpty) {
      showCustomSnackBarHelper('no_item_in_your_cart'.tr);
    } else {
      cartController.addToHoldUserList();
    }
  }

  double _getAmount(
    customer.TemporaryCartListModel? customerCart,
    int customerIndex,
    AmountType amountType,
  ) {
    double amount = 0;
    if ((customerCart != null)) {
      if (amountType == AmountType.discount) {
        for (int i = 0; i < (customerCart.cart?.length ?? 0); i++) {
          if (customerCart.cart?[i].product?.discountType == 'amount') {
            amount =
                amount +
                customerCart.cart![i].product!.discount! *
                    customerCart.cart![i].quantity!;
          } else if (customerCart.cart?[i].product?.discountType == 'percent') {
            amount =
                amount +
                (customerCart.cart![i].product!.discount! / 100) *
                    customerCart.cart![i].product!.sellingPrice! *
                    customerCart.cart![i].quantity!;
          }
        }
      } else if (amountType == AmountType.tax) {
        if ((customerCart != null)) {
          for (int i = 0; i < (customerCart.cart?.length ?? 0); i++) {
            double productPrice =
                customerCart.cart![i].product!.sellingPrice! *
                customerCart.cart![i].quantity!;
            double discountAmount = 0;

            if (customerCart.cart?[i].product?.discountType == 'amount') {
              discountAmount =
                  customerCart.cart![i].product!.discount! *
                  customerCart.cart![i].quantity!;
            } else if (customerCart.cart?[i].product?.discountType ==
                'percent') {
              discountAmount =
                  (customerCart.cart![i].product!.discount! / 100) *
                  customerCart.cart![i].product!.sellingPrice! *
                  customerCart.cart![i].quantity!;
            }

            amount =
                amount +
                (customerCart.cart![i].product!.tax! / 100) *
                    (productPrice - discountAmount);
          }
        }
      }
    }
    return amount;
  }

  void _onSubmit() async {
    final CartController cartController = Get.find<CartController>();
    final TransactionController transactionController =
        Get.find<TransactionController>();
    final CounterController counterController = Get.find();

    if (cartController.currentCartModel == null ||
        cartController.currentCartModel!.cart!.isEmpty) {
      showCustomSnackBarHelper('please_select_at_least_one_product'.tr);
    } else if (transactionController.selectedFromAccountId == null) {
      showCustomSnackBarHelper('select_payment_method'.tr);
    } else if (transactionController.selectedFromAccountId == 1 &&
        cartController.collectedCashController.text.trim().isEmpty) {
      showCustomSnackBarHelper('please_pay_first'.tr);
    } else if (transactionController.selectedFromAccountId == 1 &&
        double.parse(cartController.collectedCashController.text.trim()) <
            total) {
      showCustomSnackBarHelper('please_pay_full_amount'.tr);
    } else if (_isShowCardNumber(transactionController) &&
        cardInfoController.text.trim().isEmpty) {
      showCustomSnackBarHelper('please_enter_card_number'.tr);
    } else if (_isWalletSelected(transactionController) &&
        phoneOrEmail.text.trim().isEmpty) {
      showCustomSnackBarHelper('please_enter_email_phone'.tr);
    } else if ((counterController.activeCounterList?.isNotEmpty ?? false) &&
        transactionController.selectedCounterID == null) {
      await _scrollController.animateTo(
        0,
        duration: const Duration(milliseconds: 100),
        curve: Curves.ease,
      );
      _openDropdown();
    } else {
      showAnimatedDialogHelper(
        context,

        ConfirmPurchaseDialogWidget(
          text: 'confirm_purchase'.tr,
          onYesPressed: cartController.isLoading
              ? null
              : () {
                  List<Cart> carts = [];

                  for (
                    int index = 0;
                    index < cartController.currentCartModel!.cart!.length;
                    index++
                  ) {
                    CartModel cart =
                        cartController.currentCartModel!.cart![index];

                    double productDiscount =
                        cart.product?.discountType == 'amount'
                        ? cart.product?.discount ?? 0
                        : (((cart.product?.discount ?? 0) / 100) *
                              (cart.product?.sellingPrice ?? 0));

                    double productTax =
                        (((cart.product?.tax ?? 0) / 100) *
                        ((cart.product?.sellingPrice ?? 0) - productDiscount));

                    carts.add(
                      Cart(
                        cart.product!.id.toString(),
                        cart.price.toString(),
                        productDiscount,
                        cart.quantity,
                        productTax,
                      ),
                    );
                  }

                  PlaceOrderModel placeOrderBody = PlaceOrderModel(
                    cart: carts,
                    couponDiscountAmount: cartController.couponCodeAmount,
                    couponCode: cartController.coupons?.couponCode,
                    orderAmount: cartController.amount,
                    userId: cartController.customerId,
                    collectedCash:
                        transactionController.selectedFromAccountId == 0
                        ? PriceConverterHelper.convertFromActiveCurrencyToBase(
                            double.parse(
                              cartController.customerWalletController.text
                                  .trim(),
                            ),
                          )
                        : transactionController.selectedFromAccountId == 1
                        ? PriceConverterHelper.convertFromActiveCurrencyToBase(
                            double.parse(
                              cartController.collectedCashController.text
                                  .trim(),
                            ),
                          )
                        : 0.0,
                    extraDiscountType: cartController.selectedDiscountType,
                    extraDiscount:
                        cartController.extraDiscountController.text
                            .trim()
                            .isEmpty
                        ? 0.0
                        : double.parse(
                            PriceConverterHelper.discountCalculationWithOutSymbol(
                              context,
                              (subTotal - productDiscount - couponAmount),
                              cartController.extraDiscountAmount,
                              cartController.selectedDiscountType,
                            ),
                          ),
                    returnedAmount: cartController.returnToCustomerAmount,
                    type: _isWalletSelected(transactionController)
                        ? 0
                        : Get.find<TransactionController>()
                              .selectedFromAccountId,
                    transactionRef:
                        transactionController.selectedFromAccountId != 0 &&
                            transactionController.selectedFromAccountId != 1
                        ? cartController.collectedCashController.text.trim()
                        : '',
                    selectedCounterID: transactionController.selectedCounterID,
                    cardNumber: cardInfoController.text.trim().isNotEmpty
                        ? cardInfoController.text.trim()
                        : null,
                    comment: commentController.text.trim(),
                    emailOrPhone: phoneOrEmail.text.trim().isNotEmpty
                        ? phoneOrEmail.text.trim()
                        : null,
                  );

                  cartController.placeOrder(placeOrderBody).then((value) {
                    if (value.isOk) {
                      couponAmount = 0;
                      extraDiscount = 0;
                      unFocusCustomNode();
                      Get.find<ProductController>().getLimitedStockProductList(
                        1,
                      );
                      Get.find<CustomerController>().getCustomerList(1);
                      cartController.setCustomerInfo(isReload: true);
                      cartController.searchCustomerController.text = '';
                      clearData();
                      transactionController.getAccountListWithWallet();
                    }
                  });
                },
        ),
        dismissible: false,
        isFlip: false,
      );
    }
  }

  bool _isShowCardNumber(TransactionController transactionController) {
    final CartController cartController = Get.find();
    if (cartController.customerId == 0) {
      return transactionController.selectedFromAccountId !=
          transactionController.accountWithWalletList?.first.id;
    } else {
      return transactionController.selectedFromAccountId !=
              transactionController.accountWithWalletList?.first.id &&
          transactionController.selectedFromAccountId !=
              transactionController.accountWithWalletList?[1].id;
    }
  }

  bool _isPaidAmountDisable(TransactionController transactionController) {
    return transactionController.selectedFromAccountId != 1;
  }

  bool _isWalletSelected(TransactionController transactionController) {
    final CartController cartController = Get.find();
    return cartController.customerId != 0 &&
        transactionController.selectedFromAccountId ==
            transactionController.accountWithWalletList?[1].id;
  }

  bool _isShowPaidAmount(TransactionController transactionController) {
    if (transactionController.accountWithWalletList != null &&
        transactionController.accountWithWalletList!.length > 2) {
      return transactionController.selectedFromAccountId != null &&
          transactionController.selectedFromAccountId !=
              (transactionController.accountWithWalletList?[1].account ==
                      'Wallet'
                  ? transactionController.accountWithWalletList![1].id
                  : -1);
    } else {
      return transactionController.selectedFromAccountId != null &&
          transactionController.selectedFromAccountId ==
              (transactionController.accountWithWalletList?.first.account ==
                      'Cash'
                  ? transactionController.accountWithWalletList!.first.id
                  : -1);
    }
  }

  void unFocusCustomNode() {
    _searchFocusNode.unfocus();
    _phoneOrEmailFocusNode.unfocus();
    _commentFocusNode.unfocus();
    _cardInfoFocusNode.unfocus();
    _balanceFocusNode.unfocus();
  }

  void clearData() {
    commentController.text = '';
    cardInfoController.text = '';
    phoneOrEmail.text = '';
  }
}
