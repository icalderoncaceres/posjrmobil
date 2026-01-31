
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:six_pos/common/widgets/custom_switch_widget.dart';
import 'package:six_pos/features/coupon/controllers/coupon_controller.dart';
import 'package:six_pos/features/coupon/domain/models/coupon_model.dart';
import 'package:six_pos/helper/extension_helper.dart';
import 'package:six_pos/util/dimensions.dart';
import 'package:six_pos/util/images.dart';
import 'package:six_pos/util/styles.dart';
import 'package:six_pos/helper/animated_custom_dialog_helper.dart';
import 'package:six_pos/common/widgets/custom_dialog_widget.dart';
import 'package:six_pos/features/coupon/screens/add_coupon_screen.dart';

class CouponCardWidget extends StatelessWidget{
  final int? index;
 final Coupons? coupon;
 const CouponCardWidget({Key? key, this.coupon, this.index}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return coupon != null ?  Padding(
      padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault,vertical: Dimensions.paddingSizeMediumBorder),
      child: Stack(
        children: [
          Container(padding: const EdgeInsets.fromLTRB(Dimensions.paddingSizeDefault, Dimensions.paddingSizeDefault,
              Dimensions.paddingSizeDefault, Dimensions.paddingSizeDefault),
            decoration: BoxDecoration(color: Theme.of(context).cardColor),
            child: Row(children: [
              Expanded(child: Column(crossAxisAlignment:CrossAxisAlignment.start,children: [
                Row(children: [
                  Flexible(child: Text('${coupon!.title}', style: ubuntuBold.copyWith(
                    fontSize: Dimensions.fontSizeDefault,
                    overflow: TextOverflow.ellipsis,
                  ))),
                  const SizedBox(width: Dimensions.paddingSizeExtraSmall),
                  
                  Text("(${"code".tr}:${coupon!.couponCode})",
                    maxLines: 1,overflow: TextOverflow.ellipsis,
                    style: ubuntuRegular.copyWith(fontSize: Dimensions.fontSizeSmall,
                      color: context.customThemeColors.borderPrimaryColor.withValues(alpha:0.8),),),

                ],),
                const SizedBox(height: Dimensions.paddingSizeExtraSmall),

                Text('${'discount_type'.tr} : ${coupon!.discountType!}',
                  style: ubuntuRegular.copyWith(fontSize: Dimensions.fontSizeSmall,
                    color: context.customThemeColors.borderPrimaryColor.withValues(alpha:0.8))),

                Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('${'validity'.tr} : ${coupon!.expireDate!}',
                      style: ubuntuRegular.copyWith(fontSize: Dimensions.fontSizeSmall,
                        color: context.customThemeColors.borderPrimaryColor.withValues(alpha:0.8))),

                    Container(padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall),
                      child: Row(children: [
                        GetBuilder<CouponController>(builder: (couponController) => CustomSwitchWidget(
                          value: coupon!.status == 1,
                          activeColor: context.customThemeColors.borderPrimaryColor,
                          onChanged: (value) => couponController.toggleCouponStatus(coupon!.id, coupon!.status == 1? 0 : 1 ,index),
                        )),
                        const SizedBox(width: Dimensions.paddingSizeSmall),

                        InkWell(onTap: (){
                          Get.to(() => AddCouponScreen(coupon: coupon,));
                        },
                            child: SizedBox(height: 20,
                                width: 20,
                                child: Image.asset(Images.editIcon))),
                        const SizedBox(width: Dimensions.paddingSizeSmall),

                        GetBuilder<CouponController>(
                          builder: (couponController) {
                            return InkWell(onTap: (){
                              showAnimatedDialogHelper(context,
                                  CustomDialogWidget(
                                    delete: true,
                                    icon: Icons.exit_to_app_rounded, title: '',
                                    description: 'are_you_sure_you_want_to_delete_coupon'.tr, onTapFalse:() => Navigator.of(context).pop(true),
                                    onTapTrue:() {
                                      couponController.deleteCoupon(coupon!.id);
                                    },
                                    onTapTrueText: 'yes'.tr, onTapFalseText: 'cancel'.tr,
                                  ),
                                  dismissible: false,
                                  isFlip: true);
                            },
                                child: SizedBox(height: 20,
                                    width: 20,
                                    child: Image.asset(Images.deleteIcon)));
                          }
                        ),

                      ],),),
                  ],
                ),


                Row(children: [
                  Text('${'min_purchase'.tr} : ${coupon!.minPurchase!}',
                    style: ubuntuRegular.copyWith(fontSize: Dimensions.fontSizeSmall,
                      color: context.customThemeColors.borderPrimaryColor.withValues(alpha:0.8))),
                  const SizedBox(width: Dimensions.paddingSizeExtraSmall),

                  Text('${'max_discount'.tr} : ${coupon!.maxDiscount!}',
                    style: ubuntuRegular.copyWith(fontSize: Dimensions.fontSizeSmall,
                      color: context.customThemeColors.borderPrimaryColor.withValues(alpha:0.8))),
                ],),
              ],)),
            ],),
          ),
        ],
      ),
    ) : const SizedBox();
  }
}
