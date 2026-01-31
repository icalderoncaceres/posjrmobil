import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:six_pos/common/models/order_model.dart';
import 'package:six_pos/helper/date_converter_helper.dart';
import 'package:six_pos/helper/extension_helper.dart';
import 'package:six_pos/helper/price_converter_helper.dart';
import 'package:six_pos/helper/responsive_helper.dart';
import 'package:six_pos/util/dimensions.dart';
import 'package:six_pos/util/styles.dart';

class OrderInfoWidget extends StatelessWidget {
  final Orders? order;
  final bool fromRefund;
  const OrderInfoWidget({super.key, this.order, this.fromRefund = false});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault),
      child: Column(spacing: Dimensions.paddingSizeSmall,children: [
        Container(width: Get.width,
          padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault,vertical: Dimensions.paddingSizeSmall),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(Dimensions.paddingSizeMediumBorder),
              color: Theme.of(context).hintColor.withValues(alpha: 0.1)
          ),
          child: Text(fromRefund ? 'refund_info'.tr : 'order_info'.tr,style: ubuntuMedium),
        ),

        if(!fromRefund)...[
          Row(spacing: Dimensions.paddingSizeSmall, children: [
            Expanded(flex: 3,child: Text('order_id'.tr,style: ubuntuMedium.copyWith(fontSize: Dimensions.fontSizeSmall,color: context.customThemeColors.textColor))),

            const Text(' : '),

            Expanded(flex:7, child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              RichText(text: TextSpan(
                text: '#${order?.orderId}',style: ubuntuRegular.copyWith(fontSize: Dimensions.fontSizeSmall,color: context.customThemeColors.textColor),
              )),

              Container(
                padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault,vertical: Dimensions.paddingSizeBorder),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50),
                    color: order?.orderStatus == 'completed' ?
                    Colors.green.withValues(alpha: 0.1) :
                    Theme.of(context).colorScheme.error.withValues(alpha: 0.1)
                ),
                child: Text(
                  order?.orderStatus == 'completed' ? 'completed'.tr : 'refunded'.tr,
                  style: ubuntuMedium.copyWith(
                      color: order?.orderStatus == 'completed' ? Colors.green : Theme.of(context).colorScheme.error,
                      fontSize: Dimensions.fontSizeSmall
                  ),
                ),
              ),
            ]))
          ]),

          _ItemCartWidget(keyText: 'date',valueText: DateConverterHelper.isoStringToDateMonthYearWithLocal(order!.orderDate!)),

          _ItemCartWidget(keyText: 'counter_no',valueText: 'Counter -${order?.counterNo ?? 'N/A'} ',subText: order?.counterName != null ? '(${order?.counterName})' : ''),
        ],

        if(fromRefund)
          if(ResponsiveHelper.isTab(context))...[
            Row(children: [
              Flexible(
                child: Column(children: [
                  if(order?.refundDate != null)
                    _ItemCartWidget(keyText: 'refund_date',valueText: DateConverterHelper.isoStringToDateMonthYearWithLocal(order!.refundDate!)),

                  _ItemCartWidget(keyText: 'refund_amount',valueText: PriceConverterHelper.priceWithSymbol(order?.refundAmount ?? 0)),


                  _ItemCartWidget(keyText: 'refunded_given_from',valueText: order?.refundAdminPaymentMethodName ?? ''),
                ]),
              ),

              Flexible(
                child: Column(children: [
                  _ItemCartWidget(keyText: 'refund_given_to',valueText: order?.refundCustomerPayoutMethodName ?? ''),

                  if(order?.refundOtherPaymentDetails?.paymentMethod != null)
                    _ItemCartWidget(keyText: 'payment_method',valueText: order?.refundOtherPaymentDetails?.paymentMethod ?? ''),

                  if(order?.refundOtherPaymentDetails?.paymentInfo != null)
                    _ItemCartWidget(keyText: 'payment_info_acc',valueText: order?.refundOtherPaymentDetails?.paymentInfo ?? ''),
                ]),
              ),
            ])
          ]
          else...[
            if(order?.refundDate != null)
              _ItemCartWidget(keyText: 'refund_date',valueText: DateConverterHelper.isoStringToDateMonthYearWithLocal(order!.refundDate!)),

            _ItemCartWidget(keyText: 'refund_amount',valueText: PriceConverterHelper.priceWithSymbol(order?.refundAmount ?? 0)),

            _ItemCartWidget(keyText: 'refunded_given_from',valueText: order?.refundAdminPaymentMethodName ?? ''),

            _ItemCartWidget(keyText: 'refund_given_to',valueText: order?.refundCustomerPayoutMethodName ?? ''),

            if(order?.refundOtherPaymentDetails?.paymentMethod != null)
              _ItemCartWidget(keyText: 'payment_method',valueText: order?.refundOtherPaymentDetails?.paymentMethod ?? ''),

            if(order?.refundOtherPaymentDetails?.paymentInfo != null)
              _ItemCartWidget(keyText: 'payment_info_acc',valueText: order?.refundOtherPaymentDetails?.paymentInfo ?? ''),
          ]

      ]),
    );
  }
}

class _ItemCartWidget extends StatelessWidget {
  final String keyText;
  final String valueText;
  final String? subText;
  const _ItemCartWidget({required this.keyText, required this.valueText, this.subText});

  @override
  Widget build(BuildContext context) {
    return Row(spacing: Dimensions.paddingSizeSmall, children: [
      Expanded(flex: 3,child: Text(keyText.tr,style: ubuntuMedium.copyWith(fontSize: Dimensions.fontSizeSmall,color: context.customThemeColors.textColor))),

      const Text(':'),

      Expanded(flex:7, child: RichText(text: TextSpan(
          text: valueText.tr,style: ubuntuRegular.copyWith(fontSize: Dimensions.fontSizeSmall,color: context.customThemeColors.textColor),
          children: [
            if(subText != null)
              TextSpan(
                  text: subText!.tr,style: ubuntuRegular.copyWith(fontSize: Dimensions.fontSizeSmall,color: context.customThemeColors.textColor.withValues(alpha: 0.6))
              )
          ]
      )))
    ]);
  }
}

