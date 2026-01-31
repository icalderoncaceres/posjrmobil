import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:six_pos/common/controllers/cart_controller.dart';
import 'package:six_pos/common/widgets/custom_asset_image_widget.dart';
import 'package:six_pos/features/pos/widgets/discount_text_field_widget.dart';
import 'package:six_pos/util/dimensions.dart';
import 'package:six_pos/util/images.dart';
import 'package:six_pos/util/styles.dart';
import 'package:six_pos/common/widgets/custom_button_widget.dart';

class ExtraDiscountDialogWidget extends StatefulWidget {
  final double totalAmount;
  const ExtraDiscountDialogWidget({super.key, required this.totalAmount});

  @override
  State<ExtraDiscountDialogWidget> createState() => _ExtraDiscountDialogWidgetState();
}

class _ExtraDiscountDialogWidgetState extends State<ExtraDiscountDialogWidget> {
  final GlobalKey<FormState> validatorKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(Dimensions.paddingSizeSmall)),
      child: GetBuilder<CartController>(
        builder: (cartController) {
          return Column(crossAxisAlignment:CrossAxisAlignment.start,mainAxisSize: MainAxisSize.min, children: [
            Padding(
              padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
              child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [

                Text('extra_discount'.tr, style: ubuntuBold.copyWith(fontSize: Dimensions.fontSizeDefault)),

                Transform.translate(
                  offset: const Offset(0, -5),
                  child: InkWell(
                    onTap: ()=> Get.back(),
                    child: const CustomAssetImageWidget(
                      Images.crossIcon,
                      width: Dimensions.paddingSizeExtraLarge,
                      height: Dimensions.paddingSizeExtraLarge,
                    ),
                  ),
                ),
              ]),
            ),

            Divider(height: 5, thickness: 1, color: Theme.of(context).hintColor.withValues(alpha: .5)),

            Padding(
              padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text("discount".tr, style: ubuntuRegular.copyWith(fontSize: Dimensions.fontSizeDefault)),
                const SizedBox(height: Dimensions.paddingSizeSmall),

                Form(
                  key: validatorKey,
                  child: ProductDiscountTextFieldWidget(
                    isLabel: false,
                    border: true,
                    borderColor: Theme.of(context).primaryColor.withValues(alpha: .25),
                    focusBorder: true,
                    controller: cartController.extraDiscountController,
                    textInputAction: TextInputAction.next,
                    textInputType: TextInputType.number,
                    isAmount: true,
                    hintText: 'discount_hint'.tr,
                    isPassword : false,
                    isValidator: true,
                    validatorMessage: 'please_enter_discount_amount'.tr,
                    isDiscountAmount : cartController.discountTypeIndex == 0 ,
                    onDiscountTypeChanged : (String? value) {
                      cartController.setDiscountTypeIndex(value == 'amount' ? 0 : 1, true);
                      cartController.setSelectedDiscountType(value);
                    },
                  ),
                ),
              ]),
            ),

            Align(
              alignment: Alignment.centerRight,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault),
                child: FractionallySizedBox(
                  widthFactor: .3,
                  child: CustomButtonWidget(
                    buttonText: 'apply'.tr,
                    onPressed: (){
                    if(validatorKey.currentState!.validate()){
                      cartController.applyCouponCodeAndExtraDiscount(totalAmount: widget.totalAmount);
                    }
                    },
                  ),
                ),
              ),
            ),

            const SizedBox(height: Dimensions.paddingSizeLarge),
          ]);
        }
      ),
    );
  }
}
