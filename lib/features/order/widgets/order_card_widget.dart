import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:six_pos/common/models/order_model.dart';
import 'package:six_pos/common/widgets/custom_asset_image_widget.dart';
import 'package:six_pos/features/order/screens/invoice_screen.dart';
import 'package:six_pos/features/order/screens/order_details_screen.dart';
import 'package:six_pos/features/order/widgets/order_items_bottomsheet_widget.dart';
import 'package:six_pos/helper/date_converter_helper.dart';
import 'package:six_pos/helper/extension_helper.dart';
import 'package:six_pos/helper/price_converter_helper.dart';
import 'package:six_pos/util/dimensions.dart';
import 'package:six_pos/util/images.dart';
import 'package:six_pos/util/styles.dart';
import 'package:six_pos/features/user/widgets/custom_divider_widget.dart';

class OrderCardWidget extends StatelessWidget {
  final Orders? order;
  const OrderCardWidget({super.key, this.order});

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const SizedBox(height: Dimensions.paddingSizeExtraSmall),

          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Row(children: [
              Text('${order?.orderId}', style: ubuntuRegular.copyWith(
                fontSize: Dimensions.fontSizeDefault,color: context.customThemeColors.textColor
              )),
              const SizedBox(width: Dimensions.paddingSizeSmall),

              Container(
                padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeExtraSmall,vertical: Dimensions.paddingSizeBorder),
                decoration: BoxDecoration(
                  color: order?.orderStatus == 'completed' ? Colors.green.withValues(alpha: 0.1) : Colors.blue.withValues(alpha: 0.1),
                  borderRadius: const BorderRadius.all(Radius.circular(50))
                ),
                child: Text(
                  order?.orderStatus == 'completed' ? 'completed'.tr : 'refunded'.tr,
                  style: ubuntuRegular.copyWith(color: order?.orderStatus == 'completed' ? Colors.green : Colors.blue),
                ),
              )
            ]),

            Container(height: 25,width: 25,margin: const EdgeInsets.only(right: Dimensions.paddingSizeExtraSmall),
              child: PopupMenuButton(padding: EdgeInsets.zero,offset: Offset(-Get.width* 0.06, Get.height *0.01), itemBuilder: (ctx)=> [
                PopupMenuItem<int>(value: 0,
                  onTap: ()=> Get.to(OrderDetailsScreen(orderId: order?.orderId)),
                  child: SizedBox(
                    child: Row(children: [
                      Image.asset(Images.eyeIcon,height: 18,width: 18),
                      const SizedBox(width: Dimensions.paddingSizeSmall),

                      Text('view'.tr),
                    ]),
                  ),
                ),

                PopupMenuItem<int>(value: 1,
                  onTap: ()=> Get.to(()=> InVoiceScreen(orderId: order?.orderId)),
                  child: Row(children: [
                    const CustomAssetImageWidget(Images.printIconSvg,height: 18,width: 18),
                    const SizedBox(width: Dimensions.paddingSizeSmall),

                    Text('print'.tr),
                  ]),
                ),
              ]),
            )
          ]),

          Text(
            DateConverterHelper.isoStringToDateMonthYearWithLocal(order!.orderDate!),
            style: ubuntuRegular.copyWith(color: context.customThemeColors.textColor.withValues(alpha: 0.8)),
          ),

          Padding(
            padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeSmall),
            child: CustomDividerWidget(color: Theme.of(context).hintColor),
          ),

          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,spacing: Dimensions.paddingSizeLarge, children: [
            InkWell(
              onTap: ()=>
                showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    isDismissible: false,
                    constraints: BoxConstraints(maxHeight: Get.height * 0.9, maxWidth: double.infinity),
                    builder: (ctx){
                      return OrderItemsBottomSheetWidget(order: order);
                    },
                ),
              child: Text('${order?.orderDetails?.length} ${'items'.tr}',style: ubuntuRegular.copyWith(
                color: Theme.of(context).primaryColor,decoration: TextDecoration.underline,
                decorationColor: Theme.of(context).primaryColor.withValues(alpha: 0.5),
              )),
            ),

            RichText(text: TextSpan(
                text: 'counter'.tr,
                style: ubuntuRegular.copyWith(color: context.customThemeColors.textColor.withValues(alpha: 0.8)),
                children: [
                  TextSpan(
                    text:' - ${order?.counterNo ?? 'N/A'} ${order?.counterName ?? ''}',
                    style: ubuntuRegular.copyWith(color: context.customThemeColors.textColor),
                  )
                ]
            ),textAlign: TextAlign.center),

            Flexible(
              child: Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
                RichText(text: TextSpan(
                    text: '${'paid_by'.tr} ',
                    style: ubuntuRegular.copyWith(color: context.customThemeColors.textColor.withValues(alpha: 0.8),fontSize: Dimensions.fontSizeSmall),
                    children: [
                      TextSpan(
                        text: (order?.paymentMethod ?? 'payment_method_deleted').tr,
                        style: ubuntuBold.copyWith(color: context.customThemeColors.textColor,fontSize: Dimensions.fontSizeSmall),
                      )
                    ]
                ),textAlign: TextAlign.center,maxLines: 1,overflow: TextOverflow.ellipsis),
              
                Text(
                  PriceConverterHelper.priceWithSymbol(order?.orderTotal ?? 0),
                  style: ubuntuSemiBold.copyWith(fontSize: Dimensions.fontSizeLarge,color: Theme.of(context).primaryColor),
                )
              ]),
            )
          ]),
          const SizedBox(height: Dimensions.paddingSizeExtraSmall),

        ]),
      ),

      Container(height: Dimensions.paddingSizeDefault, color: Theme.of(context).primaryColor.withValues(alpha: 0.03)),
    ]);
  }
}
