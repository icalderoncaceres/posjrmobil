import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:screenshot/screenshot.dart';
import 'package:six_pos/common/widgets/custom_asset_image_widget.dart';
import 'package:six_pos/features/order/controllers/order_controller.dart';
import 'package:six_pos/features/order/screens/order_invoice_print_screen.dart';
import 'package:six_pos/features/order/widgets/customer_info_element_widget.dart';
import 'package:six_pos/features/splash/controllers/splash_controller.dart';
import 'package:six_pos/helper/date_converter_helper.dart';
import 'package:six_pos/helper/extension_helper.dart';
import 'package:six_pos/helper/price_converter_helper.dart';
import 'package:six_pos/util/app_constants.dart';
import 'package:six_pos/util/dimensions.dart';
import 'package:six_pos/util/images.dart';
import 'package:six_pos/util/styles.dart';
import 'package:six_pos/common/widgets/custom_app_bar_widget.dart';
import 'package:six_pos/common/widgets/custom_divider.dart';
import 'package:six_pos/common/widgets/custom_drawer_widget.dart';
import 'package:six_pos/common/widgets/custom_header_widget.dart';
import '../widgets/invoice_element_widget.dart';

class InVoiceScreen extends StatefulWidget {
  final int? orderId;
  const InVoiceScreen({super.key, this.orderId});

  @override
  State<InVoiceScreen> createState() => _InVoiceScreenState();
}

class _InVoiceScreenState extends State<InVoiceScreen> {
  Future<void> _loadData() async {
    await Get.find<OrderController>().getInvoiceData(widget.orderId);
  }

  double totalPayableAmount = 0;
  final ScreenshotController screenshotController = ScreenshotController();

  @override
  void initState() {
    _loadData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBarWidget(),
      endDrawer: const CustomDrawerWidget(),
      body: GetBuilder<SplashController>(
        builder: (shopController) {
          return SingleChildScrollView(
            child: GetBuilder<OrderController>(
              builder: (invoiceController) {
                totalPayableAmount = invoiceController.invoice?.orderTotal ?? 0;

                return Column(
                  children: [
                    CustomHeaderWidget(
                      title: 'invoice'.tr,
                      headerImage: Images.peopleIcon,
                    ),

                    Padding(
                      padding: const EdgeInsets.all(
                        Dimensions.paddingSizeExtraSmall,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          const Expanded(flex: 3, child: SizedBox.shrink()),

                          Padding(
                            padding: const EdgeInsets.all(
                              Dimensions.paddingSizeSmall,
                            ),
                            child: Container(
                              width: 80,
                              padding: const EdgeInsets.symmetric(
                                horizontal: Dimensions.paddingSizeSmall,
                                vertical: Dimensions.paddingSizeSmall,
                              ),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(
                                  Dimensions.paddingSizeBorder,
                                ),
                                color: Theme.of(context).primaryColor,
                              ),
                              child: InkWell(
                                onTap: () {
                                  Get.to(
                                    OrderInvoicePrintScreen(
                                      screenshotController:
                                          screenshotController,
                                    ),
                                  );
                                },
                                child: Center(
                                  child: Row(
                                    children: [
                                      Icon(
                                        Icons.event_note_outlined,
                                        color: Theme.of(context).cardColor,
                                        size: 15,
                                      ),
                                      const SizedBox(
                                        width:
                                            Dimensions.paddingSizeMediumBorder,
                                      ),
                                      Text(
                                        'print'.tr,
                                        style: ubuntuRegular.copyWith(
                                          color: Theme.of(context).cardColor,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    Screenshot(
                      controller: screenshotController,
                      child: Column(
                        children: [
                          SizedBox(
                            width: Dimensions.productCartImageSize,
                            child: Center(
                              child: Text(
                                'Abasto Melani',
                                style: TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black87,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: Dimensions.paddingSizeMediumBorder,
                          ),

                          Text(
                            shopController
                                    .configModel
                                    ?.businessInfo
                                    ?.shopAddress ??
                                '',
                            style: ubuntuRegular.copyWith(
                              color: context.customThemeColors.textOpacityColor,
                            ),
                          ),
                          const SizedBox(
                            height: Dimensions.paddingSizeExtraSmall,
                          ),

                          Text(
                            '${"vat_reg".tr} : ${shopController.configModel?.businessInfo?.vat ?? ''}',
                            style: ubuntuRegular.copyWith(
                              color: context.customThemeColors.textColor,
                            ),
                          ),

                          GetBuilder<OrderController>(
                            builder: (orderController) {
                              return orderController.invoice?.orderTotal != null
                                  ? Padding(
                                      padding: const EdgeInsets.all(
                                        Dimensions.paddingSizeLarge,
                                      ),
                                      child: Column(
                                        children: [
                                          CustomDividerWidget(
                                            color: context
                                                .customThemeColors
                                                .textOpacityColor,
                                          ),
                                          const SizedBox(
                                            height: Dimensions.paddingSizeLarge,
                                          ),

                                          Text(
                                            '${'invoice'.tr} : ${widget.orderId}',
                                            style: ubuntuRegular.copyWith(
                                              color: context
                                                  .customThemeColors
                                                  .textColor,
                                              fontSize:
                                                  Dimensions.fontSizeLarge,
                                            ),
                                          ),

                                          Text(
                                            DateConverterHelper.dateTimeStringToWeekDateMonthAndTime(
                                              orderController
                                                  .invoice!
                                                  .orderDate!,
                                            ),
                                            style: ubuntuRegular.copyWith(
                                              color: context
                                                  .customThemeColors
                                                  .textColor,
                                            ),
                                          ),
                                          const SizedBox(
                                            height: Dimensions.paddingSizeLarge,
                                          ),

                                          CustomDividerWidget(
                                            color: context
                                                .customThemeColors
                                                .textOpacityColor,
                                          ),
                                          const SizedBox(
                                            height: Dimensions.paddingSizeLarge,
                                          ),

                                          if (invoiceController
                                                  .invoice
                                                  ?.counterNo !=
                                              null) ...[
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Text(
                                                  'counter_no'.tr,
                                                  style: ubuntuRegular.copyWith(
                                                    fontSize: Dimensions
                                                        .fontSizeDefault,
                                                    color: context
                                                        .customThemeColors
                                                        .textOpacityColor,
                                                  ),
                                                ),

                                                Text(
                                                  '${invoiceController.invoice?.counterNo}',
                                                  style: ubuntuRegular.copyWith(
                                                    fontSize: Dimensions
                                                        .fontSizeDefault,
                                                    color: context
                                                        .customThemeColors
                                                        .textColor,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            const SizedBox(
                                              height:
                                                  Dimensions.paddingSizeLarge,
                                            ),
                                          ],

                                          if (invoiceController
                                                  .invoice
                                                  ?.cardNumber
                                                  ?.isNotEmpty ??
                                              false) ...[
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Text(
                                                  'card_no'.tr,
                                                  style: ubuntuRegular.copyWith(
                                                    fontSize: Dimensions
                                                        .fontSizeDefault,
                                                    color: context
                                                        .customThemeColors
                                                        .textOpacityColor,
                                                  ),
                                                ),

                                                Text(
                                                  '${invoiceController.invoice?.cardNumber}',
                                                  style: ubuntuRegular.copyWith(
                                                    fontSize: Dimensions
                                                        .fontSizeDefault,
                                                    color: context
                                                        .customThemeColors
                                                        .textColor,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            const SizedBox(
                                              height:
                                                  Dimensions.paddingSizeSmall,
                                            ),
                                          ],

                                          if (invoiceController
                                                  .invoice
                                                  ?.emailOrPhone
                                                  ?.isNotEmpty ??
                                              false) ...[
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Text(
                                                  'phone_or_email'.tr,
                                                  style: ubuntuRegular.copyWith(
                                                    fontSize: Dimensions
                                                        .fontSizeDefault,
                                                    color: context
                                                        .customThemeColors
                                                        .textOpacityColor,
                                                  ),
                                                ),

                                                Text(
                                                  '${invoiceController.invoice?.emailOrPhone}',
                                                  style: ubuntuRegular.copyWith(
                                                    fontSize: Dimensions
                                                        .fontSizeDefault,
                                                    color: context
                                                        .customThemeColors
                                                        .textColor,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            const SizedBox(
                                              height:
                                                  Dimensions.paddingSizeSmall,
                                            ),
                                          ],

                                          if (invoiceController
                                                  .invoice
                                                  ?.counterNo !=
                                              null) ...[
                                            CustomDividerWidget(
                                              color: context
                                                  .customThemeColors
                                                  .textOpacityColor,
                                            ),
                                            const SizedBox(
                                              height:
                                                  Dimensions.paddingSizeLarge,
                                            ),
                                          ],

                                          CustomerInfoElementWidget(
                                            title: "customer_name".tr,
                                            info:
                                                "${invoiceController.invoice?.customer?.name}",
                                          ),
                                          const SizedBox(
                                            height: Dimensions.paddingSizeSmall,
                                          ),

                                          if (invoiceController
                                                      .invoice
                                                      ?.customer
                                                      ?.mobile !=
                                                  null &&
                                              invoiceController
                                                      .invoice
                                                      ?.customer
                                                      ?.mobile !=
                                                  "1") ...[
                                            CustomerInfoElementWidget(
                                              title: "phone".tr,
                                              info:
                                                  "${invoiceController.invoice?.customer?.mobile}",
                                            ),
                                            const SizedBox(
                                              height:
                                                  Dimensions.paddingSizeSmall,
                                            ),
                                          ],

                                          if (invoiceController
                                                  .invoice
                                                  ?.customer
                                                  ?.address !=
                                              null) ...[
                                            CustomerInfoElementWidget(
                                              title: "Address".tr,
                                              info:
                                                  "${invoiceController.invoice?.customer?.address}",
                                            ),
                                            const SizedBox(
                                              height:
                                                  Dimensions.paddingSizeDefault,
                                            ),
                                          ],

                                          InvoiceElementWidget(
                                            serial: 'sl'.tr,
                                            title: 'product_info'.tr,
                                            quantity: 'qty'.tr,
                                            price: 'unit_price'.tr,
                                            total: 'total'.tr,
                                          ),
                                          const SizedBox(
                                            height:
                                                Dimensions.paddingSizeBorder,
                                          ),

                                          CustomDividerWidget(
                                            color: context
                                                .customThemeColors
                                                .textOpacityColor,
                                          ),

                                          ListView.builder(
                                            itemBuilder: (con, index) {
                                              return SizedBox(
                                                child: Padding(
                                                  padding: const EdgeInsets.only(
                                                    top: Dimensions
                                                        .paddingSizeExtraSmall,
                                                    bottom: Dimensions
                                                        .paddingSizeExtraSmall,
                                                  ),
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    children: [
                                                      // Serial + Product Name (40%)
                                                      Expanded(
                                                        flex: 4,
                                                        child: Row(
                                                          children: [
                                                            Text(
                                                              (index + 1)
                                                                  .toString(),
                                                              textAlign:
                                                                  TextAlign
                                                                      .left,
                                                              style: ubuntuRegular.copyWith(
                                                                color: context
                                                                    .customThemeColors
                                                                    .textOpacityColor,
                                                              ),
                                                            ),
                                                            const SizedBox(
                                                              width: Dimensions
                                                                  .paddingSizeLarge,
                                                            ),
                                                            Expanded(
                                                              child: Text(
                                                                invoiceController
                                                                        .invoice
                                                                        ?.orderDetails?[index]
                                                                        .name ??
                                                                    '',
                                                                overflow:
                                                                    TextOverflow
                                                                        .ellipsis,
                                                                maxLines: 2,
                                                                style: ubuntuRegular.copyWith(
                                                                  color: context
                                                                      .customThemeColors
                                                                      .textOpacityColor,
                                                                ),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),

                                                      // Quantity (15%)
                                                      Expanded(
                                                        flex: 1,
                                                        child: Center(
                                                          child: Text(
                                                            (invoiceController
                                                                        .invoice
                                                                        ?.orderDetails?[index]
                                                                        .quantity ??
                                                                    '')
                                                                .toString(),
                                                            style: ubuntuRegular
                                                                .copyWith(
                                                                  color: context
                                                                      .customThemeColors
                                                                      .textOpacityColor,
                                                                ),
                                                          ),
                                                        ),
                                                      ),

                                                      // Unit Price (20%)
                                                      Expanded(
                                                        flex: 2,
                                                        child: Align(
                                                          alignment: Alignment
                                                              .centerRight,
                                                          child: Text(
                                                            PriceConverterHelper.priceWithSymbol(
                                                              invoiceController
                                                                      .invoice
                                                                      ?.orderDetails?[index]
                                                                      .basePrice ??
                                                                  0,
                                                            ),
                                                            style: ubuntuRegular
                                                                .copyWith(
                                                                  color: context
                                                                      .customThemeColors
                                                                      .textOpacityColor,
                                                                ),
                                                          ),
                                                        ),
                                                      ),

                                                      // Total (25%)
                                                      Expanded(
                                                        flex: 2,
                                                        child: Align(
                                                          alignment: Alignment
                                                              .centerRight,
                                                          child: Text(
                                                            PriceConverterHelper.priceWithSymbol(
                                                              invoiceController
                                                                      .invoice
                                                                      ?.orderDetails?[index]
                                                                      .totalPrice ??
                                                                  0,
                                                            ),
                                                            style: ubuntuRegular
                                                                .copyWith(
                                                                  color: context
                                                                      .customThemeColors
                                                                      .textColor,
                                                                ),
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              );
                                            },
                                            itemCount: invoiceController
                                                .invoice!
                                                .orderDetails!
                                                .length,
                                            physics:
                                                const NeverScrollableScrollPhysics(),
                                            shrinkWrap: true,
                                          ),

                                          Padding(
                                            padding: const EdgeInsets.symmetric(
                                              vertical:
                                                  Dimensions.paddingSizeLarge,
                                            ),
                                            child: CustomDividerWidget(
                                              color: context
                                                  .customThemeColors
                                                  .textOpacityColor,
                                            ),
                                          ),

                                          Column(
                                            children: [
                                              _PaymentItemWidget(
                                                title: 'subtotal'.tr,
                                                amount: orderController
                                                    .invoice
                                                    ?.subtotal,
                                              ),
                                              const SizedBox(
                                                height:
                                                    Dimensions.paddingSizeSmall,
                                              ),

                                              _PaymentItemWidget(
                                                title: 'discount'.tr,
                                                amount: invoiceController
                                                    .invoice
                                                    ?.discount,
                                              ),
                                              const SizedBox(
                                                height:
                                                    Dimensions.paddingSizeSmall,
                                              ),

                                              _PaymentItemWidget(
                                                title: 'coupon_discount'.tr,
                                                amount: orderController
                                                    .invoice
                                                    ?.orderCouponDiscountAmount,
                                              ),
                                              const SizedBox(
                                                height:
                                                    Dimensions.paddingSizeSmall,
                                              ),

                                              _PaymentItemWidget(
                                                title: 'extra_discount'.tr,
                                                amount: orderController
                                                    .invoice
                                                    ?.orderExtraDiscount,
                                              ),
                                              const SizedBox(
                                                height:
                                                    Dimensions.paddingSizeSmall,
                                              ),

                                              _PaymentItemWidget(
                                                title: 'tax'.tr,
                                                amount: invoiceController
                                                    .invoice
                                                    ?.orderTax,
                                              ),
                                              const SizedBox(
                                                height:
                                                    Dimensions.paddingSizeSmall,
                                              ),
                                            ],
                                          ),

                                          _PaymentItemWidget(
                                            title: 'total'.tr,
                                            amount: totalPayableAmount,
                                            isBold: true,
                                          ),

                                          Padding(
                                            padding: const EdgeInsets.symmetric(
                                              vertical:
                                                  Dimensions.paddingSizeLarge,
                                            ),
                                            child: CustomDividerWidget(
                                              color: context
                                                  .customThemeColors
                                                  .textOpacityColor,
                                            ),
                                          ),

                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                'paid_by'.tr,
                                                style: ubuntuRegular.copyWith(
                                                  color: context
                                                      .customThemeColors
                                                      .textOpacityColor,
                                                ),
                                              ),

                                              Text(
                                                invoiceController
                                                        .invoice
                                                        ?.paymentMethod ??
                                                    '',
                                                textAlign: TextAlign.end,
                                                style: ubuntuRegular.copyWith(
                                                  color: context
                                                      .customThemeColors
                                                      .textColor,
                                                ),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(
                                            height: Dimensions.paddingSizeSmall,
                                          ),

                                          _PaymentItemWidget(
                                            title: 'paid_amount'.tr,
                                            amount: orderController
                                                .invoice
                                                ?.paidAmount,
                                          ),
                                          const SizedBox(
                                            height: Dimensions.paddingSizeSmall,
                                          ),

                                          if ((orderController
                                                      .invoice
                                                      ?.changeAmount ??
                                                  0) >
                                              0)
                                            _PaymentItemWidget(
                                              title: 'change_return'.tr,
                                              amount: orderController
                                                  .invoice
                                                  ?.changeAmount,
                                            ),
                                          const SizedBox(
                                            height: Dimensions.paddingSizeSmall,
                                          ),

                                          if ((orderController
                                                      .invoice
                                                      ?.refundAmount ??
                                                  0) >
                                              0) ...[
                                            _PaymentItemWidget(
                                              title: 'refund_amount'.tr,
                                              amount: orderController
                                                  .invoice
                                                  ?.refundAmount,
                                              isBold: true,
                                            ),
                                            const SizedBox(
                                              height:
                                                  Dimensions.paddingSizeLarge,
                                            ),

                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Text(
                                                  'refund_reason'.tr,
                                                  style: ubuntuRegular.copyWith(
                                                    color: context
                                                        .customThemeColors
                                                        .textColor
                                                        .withValues(alpha: 0.5),
                                                  ),
                                                ),

                                                Text(
                                                  invoiceController
                                                          .invoice
                                                          ?.refundReason ??
                                                      '',
                                                  textAlign: TextAlign.end,
                                                  style: ubuntuRegular.copyWith(
                                                    color: context
                                                        .customThemeColors
                                                        .textColor,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],

                                          Padding(
                                            padding: const EdgeInsets.symmetric(
                                              vertical:
                                                  Dimensions.paddingSizeLarge,
                                            ),
                                            child: CustomDividerWidget(
                                              color: context
                                                  .customThemeColors
                                                  .textOpacityColor,
                                            ),
                                          ),

                                          Text(
                                            '${"thank_you_for_buying".tr} ${"please_visit".tr} ${shopController.configModel?.businessInfo?.shopName} ${"again".tr}.',
                                            style: ubuntuRegular.copyWith(
                                              color: context
                                                  .customThemeColors
                                                  .textOpacityColor,
                                            ),
                                          ),

                                          Padding(
                                            padding: const EdgeInsets.only(
                                              top: Dimensions.paddingSizeLarge,
                                              bottom: Dimensions
                                                  .paddingSizeMediumBorder,
                                            ),
                                            child: CustomDividerWidget(
                                              color: context
                                                  .customThemeColors
                                                  .textOpacityColor,
                                            ),
                                          ),

                                          Text(
                                            '${'powered_by'.tr} ${shopController.configModel?.businessInfo?.shopName}, ${"phone".tr} : ${shopController.configModel?.businessInfo?.shopPhone ?? ''}',
                                            style: ubuntuMedium.copyWith(
                                              color: context
                                                  .customThemeColors
                                                  .textOpacityColor,
                                            ),
                                          ),
                                          const SizedBox(
                                            height: Dimensions.paddingSizeSmall,
                                          ),
                                        ],
                                      ),
                                    )
                                  : const SizedBox();
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              },
            ),
          );
        },
      ),
    );
  }
}

class _PaymentItemWidget extends StatelessWidget {
  final String? title;
  final double? amount;
  final bool isBold;
  const _PaymentItemWidget({this.title, this.amount, this.isBold = false});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title ?? '',
          style: isBold
              ? ubuntuSemiBold.copyWith(
                  color: context.customThemeColors.textColor,
                )
              : ubuntuRegular.copyWith(
                  color: context.customThemeColors.textOpacityColor,
                ),
        ),
        Text(
          PriceConverterHelper.priceWithSymbol(amount ?? 0),
          style: isBold
              ? ubuntuSemiBold.copyWith(
                  color: context.customThemeColors.textColor,
                )
              : ubuntuRegular.copyWith(
                  color: context.customThemeColors.textColor,
                ),
        ),
      ],
    );
  }
}
