import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:six_pos/common/models/order_model.dart';
import 'package:six_pos/common/widgets/custom_asset_image_widget.dart';
import 'package:six_pos/common/widgets/custom_image_widget.dart';
import 'package:six_pos/features/splash/controllers/splash_controller.dart';
import 'package:six_pos/helper/price_converter_helper.dart';
import 'package:six_pos/helper/responsive_helper.dart';
import 'package:six_pos/util/dimensions.dart';
import 'package:six_pos/util/images.dart';
import 'package:six_pos/util/styles.dart';

class OrderItemsBottomSheetWidget extends StatelessWidget {
  final Orders? order;
  const OrderItemsBottomSheetWidget({super.key, this.order});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: Dimensions.paddingSizeSmall,right: Dimensions.paddingSizeSmall,top: Dimensions.paddingSizeSmall),
      decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius:const BorderRadius.only(
            topRight: Radius.circular(Dimensions.paddingSizeLarge),
            topLeft: Radius.circular(Dimensions.paddingSizeLarge),
          )
      ),
      child: Column(mainAxisSize: MainAxisSize.min, children: [
        InkWell(
          onTap: ()=> Get.back(),
          child: Align(alignment: Alignment.topRight,
            child: Container(
              decoration: BoxDecoration(
                color: Theme.of(context).hintColor.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(50),
              ),
              padding: const EdgeInsets.all(Dimensions.paddingSizeExtraSmall),

              child: const CustomAssetImageWidget(Images.crossIcon,height: 14,width: 14),
            ),
          ),
        ),
        const SizedBox(height: Dimensions.paddingSizeSmall),

        Text('${order?.orderDetails?.length} ${'items'.tr}',style: ubuntuBold.copyWith(fontSize: Dimensions.fontSizeLarge)),

        Text('${'order_id'.tr} #${order?.orderId}',style: ubuntuRegular.copyWith(fontSize: Dimensions.fontSizeSmall)),
        const SizedBox(height: Dimensions.paddingSizeSmall),

        Divider(color: Theme.of(context).primaryColor.withValues(alpha: 0.1)),
        const SizedBox(height: Dimensions.paddingSizeSmall),

        Flexible(child: Padding(
          padding: EdgeInsets.symmetric(horizontal: ResponsiveHelper.isTab(context) ? (Dimensions.paddingSizeLarge *2) : Dimensions.paddingSizeDefault),
          child: ListView.separated(
              shrinkWrap: true,
              itemCount: order?.orderDetails?.length ?? 0,
              itemBuilder: (ctx,index){
                return Padding(
                  padding: const EdgeInsets.only(bottom: Dimensions.paddingSizeSmall),
                  child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                    Expanded(flex: 6, child: Row(children: [
                      Container(
                        height: 40,width: 40,
                        padding: const EdgeInsets.all(3),
                        decoration: BoxDecoration(
                            color: Theme.of(context).primaryColor.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(Dimensions.paddingSizeSmall),
                            border: Border.all(color: Theme.of(context).primaryColor.withValues(alpha: 0.25))
                        ),
                        child: CustomImageWidget(image: '${Get.find<SplashController>().baseUrls!.productImageUrl}/${order?.orderDetails?[index].image}',fit: BoxFit.cover),
                      ),
                      const SizedBox(width: Dimensions.paddingSizeSmall),

                      Expanded(
                        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                          Text('${order?.orderDetails?[index].name}',style: ubuntuSemiBold.copyWith(fontSize:Dimensions.fontSizeSmall),overflow: TextOverflow.ellipsis),

                          Text('${order?.orderDetails?[index].unitValue} ${order?.orderDetails?[index].unitType}',style: ubuntuRegular.copyWith(fontSize:Dimensions.fontSizeSmall))
                        ]),
                      ),
                    ])),

                    Flexible(flex: 2, child: Text('x ${order?.orderDetails?[index].quantity}',style: ubuntuSemiBold)),

                    Flexible(flex: 3, child: Text(PriceConverterHelper.priceWithSymbol(order?.orderDetails?[index].totalPrice ?? 0), style: ubuntuSemiBold),
                    )
                  ]),
                );
              },
              separatorBuilder: (ctx,index){
                return Column(children: [
                  Divider(color: Theme.of(context).primaryColor.withValues(alpha: 0.1)),

                  const SizedBox(height: Dimensions.paddingSizeDefault),
                ]);
              },
            ),
        ))
      ]),
    );
  }
}


