import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:six_pos/common/controllers/cart_controller.dart';
import 'package:six_pos/common/widgets/custom_asset_image_widget.dart';
import 'package:six_pos/features/coupon/controllers/coupon_controller.dart';
import 'package:six_pos/features/coupon/domain/models/coupon_model.dart';
import 'package:six_pos/features/splash/controllers/splash_controller.dart';
import 'package:six_pos/util/dimensions.dart';
import 'package:six_pos/common/widgets/custom_button_widget.dart';
import 'package:six_pos/common/widgets/custom_text_field_widget.dart';
import 'package:six_pos/util/images.dart';
import 'package:six_pos/util/styles.dart';
class CouponDialogWidget extends StatelessWidget {
  final double discountedOrderAmount;
  const  CouponDialogWidget({super.key, required this.discountedOrderAmount});


  @override
  Widget build(BuildContext context) {
    Orientation orientation = MediaQuery.of(context).orientation;

    return Dialog(
      insetPadding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(Dimensions.paddingSizeSmall)),
      child: GetBuilder<CartController>(builder: (cartController) {
        return GetBuilder<CouponController>(builder: (couponController){
          return Container(
            padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
            height: _isCouponListEmpty(couponController)
                ? orientation.name == 'landscape' ? Get.height * 0.95
                : Get.height * 0.55 : Get.height * 0.45,

            child: Column(crossAxisAlignment:CrossAxisAlignment.start,children: [

              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [

                Text('coupon_discount'.tr, style: ubuntuBold.copyWith(fontSize: Dimensions.fontSizeLarge)),

                Transform.translate(
                  offset: const Offset(0, -5),
                  child: InkWell(
                    onTap: () {
                      cartController.setSelectedCouponIndex(null, isClearText: true);
                      Get.back();
                    },
                    child: const CustomAssetImageWidget(
                      Images.crossIcon,
                      width: Dimensions.paddingSizeExtraLarge,
                      height: Dimensions.paddingSizeExtraLarge,
                    ),
                  ),
                ),
              ]),

              Text('select_from_available_coupon_or_input_code'.tr, style: ubuntuRegular.copyWith(fontSize: Dimensions.fontSizeSmall),),
              const SizedBox(height: Dimensions.paddingSizeSmall),

              Padding(
                padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeSmall),
                child: Text('available_coupon'.tr, style: ubuntuMedium),
              ),

              _isCouponListEmpty(couponController) ?
              SizedBox(height: orientation.name == 'landscape' ? Get.height * 0.25 :  Get.height * 0.12,
                child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: couponController.userWiseCouponList?.length ?? 0,
                    itemBuilder: (context, index){
                      return InkWell(
                        splashColor: Colors.transparent,
                        highlightColor: Colors.transparent,
                        onTap: (){
                          cartController.setSelectedCouponIndex(index, isUpdate: true);
                        },
                        child: _CouponCardWidget(
                          coupon: couponController.userWiseCouponList?[index],
                          isSelected: cartController.selectedCouponIndex == index,
                        ),
                      );
                    }),
              ) :
              Text('no_coupon_available'.tr),
              const SizedBox(height: Dimensions.paddingSizeDefault),

              Padding(
                padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeMediumBorder),
                child: Text('coupon_code'.tr, style: ubuntuMedium),
              ),

              CustomTextFieldWidget(hintText: 'coupon_code_hint'.tr,
                controller:cartController.couponController,
                onChanged: (String val)=> cartController.setSelectedCouponIndex(null, isUpdate: true),
              ),
              
              Padding(
                padding: const EdgeInsets.only(top: Dimensions.paddingSizeLarge),
                child: Row(mainAxisAlignment: MainAxisAlignment.end, children: [

                  const Expanded(child: SizedBox()),

                  Expanded(child: CustomButtonWidget(
                    buttonText: 'cancel'.tr,
                    buttonColor: Theme.of(context).secondaryHeaderColor.withValues(alpha: .1),
                    textColor: Theme.of(context).secondaryHeaderColor,
                    isClear: true,
                    onPressed: (){
                      Get.back();
                      cartController.setSelectedCouponIndex(null, isClearText: true);
                    },
                  )),
                  const SizedBox(width: Dimensions.paddingSizeDefault),

                  Expanded(child: CustomButtonWidget(
                    buttonText: 'apply'.tr,onPressed: (){
                    if(cartController.couponController.text.trim().isNotEmpty){
                      cartController.getCouponDiscount(
                        cartController.couponController.text.trim(),
                        cartController.customerId,
                        discountedOrderAmount,
                      );
                    }
                    Get.back();
                  },
                  )),

                ]),
              ),

            ]),
          );
        });
      }),
    );
  }
}

bool _isCouponListEmpty(CouponController couponController){
  return couponController.userWiseCouponList?.length != null && ((couponController.userWiseCouponList?.length ?? 0) > 0);
}


class _CouponCardWidget extends StatelessWidget {
  final bool isSelected;
  final Coupons? coupon;

  const _CouponCardWidget({
    Key? key,
    this.isSelected = false,
    this.coupon
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final widthSize = Get.width;
    return Stack(
      children: [
        Container(
          margin: const EdgeInsets.all(Dimensions.paddingSizeSmall),
          child: Stack(children: [
            Container(
              padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
              width: widthSize * 0.6,
              decoration: BoxDecoration(
                  color: isSelected ? Theme.of(context).cardColor : Theme.of(context).hintColor.withValues(alpha: .2),
                  borderRadius: const BorderRadius.all(Radius.circular(Dimensions.paddingSizeSmall)),
                  border: isSelected ? Border.all(width: 1, color:  Theme.of(context).primaryColor ) : null
              ),
              child: Row(children: [
                SizedBox(
                  width: widthSize * 0.35,
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.center, children: [

                    Row(mainAxisAlignment: MainAxisAlignment.start, children: [
                      Text('${'code'.tr}: ', style: ubuntuRegular),

                      Expanded(child: Text(
                        coupon?.couponCode ?? '',
                        style: ubuntuMedium.copyWith(
                            color: Get.isDarkMode ? Theme.of(context).textTheme.bodyMedium!.color!.withValues(alpha:0.9) : null,
                            fontSize: Dimensions.fontSizeDefault
                        ),
                        overflow: TextOverflow.ellipsis,
                      )),
                    ]),

                    Text(coupon?.title ?? '', style: ubuntuRegular.copyWith(
                        color: Theme.of(context).hintColor,
                        fontSize: Dimensions.fontSizeSmall,
                    ),maxLines: 1,overflow: TextOverflow.ellipsis),
                  ]),
                ),

                DottedLine(
                    direction: Axis.vertical,
                    dashColor: isSelected ? Theme.of(context).primaryColor : Theme.of(context).cardColor,
                    lineThickness: 2
                ),


                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeExtraSmall),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          '${coupon?.discount}${coupon?.discountType == 'percent' ? '%' : Get.find<SplashController>().configModel?.currencySymbol}',
                          style: ubuntuBold.copyWith(
                            color: Theme.of(context).textTheme.bodyMedium!.color!.withValues(alpha:0.8),
                            fontSize: Dimensions.fontSizeLarge,
                            overflow: TextOverflow.ellipsis,
                          ),
                          maxLines: 1,
                        ),

                        Text(
                          "discount".tr,
                          style: ubuntuBold.copyWith(
                              color: Theme.of(context).textTheme.bodyMedium!.color!.withValues(alpha:0.8),
                              overflow: TextOverflow.ellipsis,
                              fontSize: Dimensions.fontSizeExtraSmall
                          ),
                          maxLines: 1,
                        ),
                      ],
                    ),
                  ),
                ),

              ]),
            ),

            Positioned(
              bottom: -22, left: widthSize * 0.35,
              child: Container(
                width: 22, height : 32,
                decoration: BoxDecoration(
                    color: Theme.of(context).cardColor,
                    borderRadius: BorderRadius.circular(100),
                    border: isSelected ? Border.all(width: 1, color:  Theme.of(context).primaryColor ) : null
                ),
              ),
            ),

            Positioned(
              top: -22, left: widthSize * 0.35,
              child: Container(
                width: 22, height : 32,
                decoration: BoxDecoration(
                    color: Theme.of(context).cardColor,
                    borderRadius: BorderRadius.circular(100),
                    border: isSelected ? Border.all(width: 1, color:  Theme.of(context).primaryColor ) : null
                ),
              ),
            ),
          ]),
        ),


        isSelected ?
        Positioned(
          right: 5,
          top: 0,
          child: Container(
            width: Dimensions.paddingSizeLarge, height : Dimensions.paddingSizeLarge,
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
              borderRadius: BorderRadius.circular(100),
            ),
            child: Center(child: Icon(Icons.check, size: 18, color: Theme.of(context).cardColor)),
          ),
        ) :
        const SizedBox.shrink(),
      ],
    );
  }
}


