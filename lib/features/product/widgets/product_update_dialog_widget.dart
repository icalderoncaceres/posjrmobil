import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:six_pos/common/widgets/custom_asset_image_widget.dart';
import 'package:six_pos/common/widgets/custom_clear_icon_widget.dart';
import 'package:six_pos/features/product/controllers/product_controller.dart';
import 'package:six_pos/helper/extension_helper.dart';
import 'package:six_pos/helper/responsive_helper.dart';
import 'package:six_pos/util/dimensions.dart';
import 'package:six_pos/common/widgets/custom_button_widget.dart';
import 'package:six_pos/common/widgets/custom_text_field_widget.dart';
import 'package:six_pos/util/images.dart';
import 'package:six_pos/util/styles.dart';

class ProductUpdateDialogWidget extends StatelessWidget {
  final Function onYesPressed;
  const ProductUpdateDialogWidget({Key? key, required this.onYesPressed}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
        insetPadding: ResponsiveHelper.isTab(context) ? EdgeInsets.symmetric(horizontal: Get.width * 0.35) : null,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(Dimensions.paddingSizeLarge)),
        child: GetBuilder<ProductController>(builder: (productController) {
          return Container(
            padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
            decoration: BoxDecoration(
              color: Theme.of(context).hintColor.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(Dimensions.paddingSizeExtraSmall),
            ),
            child: Column(mainAxisSize: MainAxisSize.min,children: [
              Align(alignment: Alignment.centerRight,child: CustomClearIconWidget()),

              Flexible(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                    child: Column(mainAxisSize: MainAxisSize.min, children: [

                      Text('update_quantity'.tr, style: ubuntuMedium.copyWith(fontSize: Dimensions.fontSizeLarge)),
                      SizedBox(height: Dimensions.paddingSizeDefault),

                      Text('enter_the_product_quantity'.tr, style: ubuntuRegular.copyWith(fontSize: Dimensions.fontSizeSmall)),
                      SizedBox(height: Dimensions.paddingSizeLarge),

                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeExtraExtraLarge, vertical: Dimensions.paddingSizeLarge),
                        decoration: BoxDecoration(
                          color: Theme.of(context).hintColor.withValues(alpha: 0.08),
                          borderRadius: BorderRadius.circular(Dimensions.paddingSizeMediumBorder),
                        ),
                        child: CustomTextFieldWidget(
                          hintText: 'product_quantity_hint'.tr,
                          controller: productController.productQuantityController,
                          inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[0-9]'))],
                          inputType: TextInputType.number,
                          textAlign: TextAlign.center,
                        ),
                      ),
                      SizedBox(height: Dimensions.paddingSizeSmall),

                      Container(
                        padding: EdgeInsets.symmetric(horizontal: Dimensions.fontSizeSmall, vertical: Dimensions.paddingSizeExtraSmall),
                        decoration: BoxDecoration(
                          color: Theme.of(context).primaryColor.withValues(alpha: 0.08),
                          borderRadius: BorderRadius.circular(Dimensions.paddingSizeMediumBorder),
                        ),
                        child: Row(crossAxisAlignment: CrossAxisAlignment.start,children: [

                          CustomAssetImageWidget(Images.hintBulbIcon, height: Dimensions.paddingSizeLarge, width: Dimensions.paddingSizeLarge),
                          SizedBox(width: Dimensions.paddingSizeSmall),

                          Flexible(
                            child: Text('to_decrease_product'.tr, style: ubuntuRegular.copyWith(
                              fontSize: Dimensions.fontSizeSmall,
                              color: context.customThemeColors.textOpacityColor,
                            ), maxLines: 3),
                          ),
                        ]),
                      ),
                      SizedBox(height: Dimensions.paddingSizeExtraExtraLarge),

                      SizedBox(height: 40,
                        child: Row(children: [
                          Expanded(child: CustomButtonWidget(
                            buttonText: 'cancel'.tr,
                            buttonColor: Theme.of(context).hintColor.withValues(alpha: 0.2),
                            textColor: context.customThemeColors.textColor,
                            isButtonTextBold: true,
                            isClear: true,
                            onPressed: ()=>Get.back(),
                          )),
                          const SizedBox(width: Dimensions.paddingSizeDefault),

                          Expanded(child: CustomButtonWidget(
                            buttonText: 'update'.tr,
                            onPressed: () => onYesPressed(),
                            isButtonTextBold: true,
                          )),
                        ]),
                      ),

                    ]),
                  ),
                ),
              ),
            ]),
          );
        }));
  }
}
