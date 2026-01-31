import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:six_pos/common/models/order_model.dart';
import 'package:six_pos/helper/extension_helper.dart';
import 'package:six_pos/util/dimensions.dart';
import 'package:six_pos/util/styles.dart';

class PaymentInfoWidget extends StatelessWidget {
  final Orders? order;
  const PaymentInfoWidget({super.key, this.order});

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
          child: Text('payment_info'.tr,style: ubuntuMedium),
        ),

        if(order?.referenceId != null)
          Row(spacing: Dimensions.paddingSizeSmall, children: [
            Expanded(flex: 3,child: Text('reference_id'.tr,style: ubuntuMedium.copyWith(fontSize: Dimensions.fontSizeSmall,color: context.customThemeColors.textColor))),

            const Text(':'),

            Expanded(flex:6, child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              Text('${order?.referenceId}',style: ubuntuRegular.copyWith(fontSize: Dimensions.fontSizeSmall,color: context.customThemeColors.textColor)),

              if(((order?.paidAmount ?? 0) >= (order?.orderTotal ?? 0)) && order?.referenceId != null)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault,vertical: Dimensions.paddingSizeBorder),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50),
                      color: context.customThemeColors.holdButtonColor.withValues(alpha: 0.05)
                  ),
                  child: Text('paid'.tr, style: ubuntuMedium.copyWith(
                    color: context.customThemeColors.holdButtonColor,
                    fontSize: Dimensions.fontSizeSmall,
                  )),
                ),
            ])),
          ]),

        Row(spacing: Dimensions.paddingSizeSmall, children: [
          Expanded(flex: 3,child: Text('payment_method'.tr,style: ubuntuMedium.copyWith(fontSize: Dimensions.fontSizeSmall,color: context.customThemeColors.textColor))),

          const Text(':'),

          Flexible(flex:6, child: Container(
            padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault,vertical: Dimensions.paddingSizeBorder),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(50),
                color: Colors.green.withValues(alpha: 0.1)
            ),
            child: Text((order?.paymentMethod ?? 'payment_method_deleted').tr,style: ubuntuMedium.copyWith(
              color: Colors.green,
              fontSize: Dimensions.fontSizeSmall,
            )),
          )),
        ]),
      ]),
    );
  }
}
