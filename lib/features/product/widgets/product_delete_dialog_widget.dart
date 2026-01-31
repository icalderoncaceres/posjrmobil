import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:six_pos/common/models/product_model.dart';
import 'package:six_pos/common/widgets/custom_asset_image_widget.dart';
import 'package:six_pos/common/widgets/custom_button_widget.dart';
import 'package:six_pos/common/widgets/custom_clear_icon_widget.dart';
import 'package:six_pos/helper/extension_helper.dart';
import 'package:six_pos/helper/responsive_helper.dart';
import 'package:six_pos/util/dimensions.dart';
import 'package:six_pos/util/images.dart';
import 'package:six_pos/util/styles.dart';

class ProductDeleteDialogWidget extends StatelessWidget {
  final String title;
  final String description;
  final Function onTapDelete;
  final bool isLoading;
  final double? borderRadius;
  final Products? product;


  const ProductDeleteDialogWidget({Key? key,
    required this.title,
    required this.description,
    this.isLoading = false,
    required this.onTapDelete,
    this.borderRadius,
    this.product,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {


    return Dialog(
      insetPadding: ResponsiveHelper.isTab(context) ? EdgeInsets.symmetric(horizontal: Get.width * 0.35) : null,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(borderRadius ?? 10)),
      child: Padding(
        padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
        child:  Column(mainAxisSize: MainAxisSize.min, children: [

          Align(
              alignment: Alignment.centerRight,
              child: CustomClearIconWidget()
          ),

          Padding(
            padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
            child: Column(mainAxisAlignment: MainAxisAlignment.center,children: [

              CustomAssetImageWidget(Images.deleteImage, height: Dimensions.productImageSizeItem, width: Dimensions.productImageSizeItem),
              SizedBox(height: Dimensions.paddingSizeLarge),

              Text(title, style: ubuntuMedium.copyWith(fontSize: Dimensions.fontSizeLarge), textAlign: TextAlign.center),
              const SizedBox(height: Dimensions.paddingSizeDefault),

              Text(description, textAlign: TextAlign.center, style: ubuntuRegular.copyWith(
                  fontSize: Dimensions.fontSizeSmall,
                  color: context.customThemeColors.textOpacityColor
              )),
              const SizedBox(height: Dimensions.paddingSizeExtraExtraLarge),


              SizedBox(
                height: Dimensions.dropDownHeight,
                child: Row(children: [
                  Expanded(child: CustomButtonWidget(
                    buttonText: 'no'.tr,
                    isButtonTextBold: true,
                    isClear: true,
                    textColor: Theme.of(context).textTheme.bodyLarge?.color,
                    buttonColor: Theme.of(context).hintColor.withValues(alpha: 0.20),
                    onPressed:()=> Navigator.pop(context),
                  )),
                  const SizedBox(width: Dimensions.paddingSizeSmall),

                  Expanded(child: CustomButtonWidget(
                    isLoading: isLoading,
                    buttonText: 'delete'.tr,
                    isButtonTextBold: true,
                    onPressed: onTapDelete,
                    buttonColor: context.customThemeColors.deleteButtonColor,
                  )),
                ]),
              ),
            ]),
          )
        ]),
      ),
    );
  }
}
