import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:six_pos/common/widgets/custom_button_widget.dart';
import 'package:six_pos/common/widgets/custom_field_with_title_widget.dart';
import 'package:six_pos/common/widgets/custom_text_field_widget.dart';
import 'package:six_pos/features/product/controllers/product_controller.dart';
import 'package:six_pos/helper/extension_helper.dart';
import 'package:six_pos/helper/responsive_helper.dart';
import 'package:six_pos/helper/show_custom_snackbar_helper.dart';
import 'package:six_pos/util/dimensions.dart';
import 'package:six_pos/util/styles.dart';

class BarcodeGenerateResetButtonWidget extends StatelessWidget {
  final TextEditingController quantityController;
  const BarcodeGenerateResetButtonWidget({super.key, required this.quantityController});

  @override
  Widget build(BuildContext context) {
    return  GetBuilder<ProductController>(
        builder: (productController) {
        return Container(
          padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeSmall,horizontal: Dimensions.paddingSizeExtraSmall),
          decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(ResponsiveHelper.isTab(context) ? Dimensions.paddingSizeSmall : 0),
              boxShadow: [BoxShadow(blurRadius: 5, color: Theme.of(context).primaryColor.withValues(alpha: .05))]
          ),
          child: Column(children: [
        
            ///Generate and Reset Button section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall),
              child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Expanded(
                  flex: 7,
                  child: Padding(
                    padding: const EdgeInsets.only(top: Dimensions.paddingSizeExtraSmall),
                    child: Column(crossAxisAlignment: CrossAxisAlignment.start,  children: [
                      Text('generate_barcode'.tr, style: ubuntuMedium.copyWith(fontSize: Dimensions.fontSizeLarge, color: Theme.of(context).primaryColor)),
        
                      Text.rich(
                          TextSpan(children: [
                            TextSpan(
                              text: '${"input_number_to_print_barcode".tr} ',
                              style: ubuntuRegular.copyWith(
                                fontSize: Dimensions.fontSizeSmall,
                                color: context.customThemeColors.textColor.withValues(alpha: 0.5),
                              ),
                            ),
        
                            TextSpan(
                              text: '${"you_can_print_maximum".tr} ',
                              style: ubuntuRegular.copyWith(
                                fontSize: Dimensions.fontSizeSmall,
                                color: context.customThemeColors.textColor.withValues(alpha: 0.5),
                              ),
                            ),
        
                            TextSpan(
                              text: '${'270_copy'.tr} ',
                              style: ubuntuBold.copyWith(
                                fontSize: Dimensions.fontSizeSmall,
                                color: context.customThemeColors.textColor
                              ),
                            ),
        
                            TextSpan(
                              text: 'at_a_time'.tr,
                              style: ubuntuRegular.copyWith(
                                fontSize: Dimensions.fontSizeSmall,
                                color: context.customThemeColors.textColor.withValues(alpha: 0.5),
                              ),
                            ),
        
                          ])
                      ),
                    ]),
                  ),
                ),
                const SizedBox(width: Dimensions.paddingSizeDefault),
        
                Expanded(
                  flex: 3,
                  child: CustomButtonWidget(
                    height: Dimensions.paddingSizeExtraExtraLarge,
                    icon: Icons.refresh,
                    iconColor: Theme.of(context).primaryColor,
                    buttonText: 'reset'.tr,
                    onPressed: (){
                      quantityController.text = '9';
                      productController.setBarCodeQuantity(9);
                    },
                    buttonColor: Theme.of(context).primaryColor.withValues(alpha: .07),
                    textColor: Theme.of(context).primaryColor,
                    isClear: true,
                    margin: const EdgeInsets.only(left: Dimensions.paddingSizeExtraSmall, top: 0),
                  ),
                ),
              ]),
            ),
            const SizedBox(height: Dimensions.paddingSizeSmall),
        
            ///Textfield and Generate Button section
            Padding(
              padding: const EdgeInsets.only(left: Dimensions.barWidthFlowChart, right: Dimensions.paddingSizeSmall),
              child: Row(mainAxisAlignment: MainAxisAlignment.start, crossAxisAlignment: CrossAxisAlignment.end, children: [
                Expanded(
                  flex: 7,
                  child: CustomFieldWithTitleWidget(
                    limitSet: true,
                    padding: Dimensions.paddingSizeExtraSmall,
                    setLimitTitle: 'maximum_quantity_270'.tr,
                    customTextField: CustomTextFieldWidget(
                      hintText: 'sku_hint'.tr,
                      controller: quantityController,
                      inputType: TextInputType.number,
                    ),
                    title: 'number_of_barcode'.tr,
                    requiredField: false,
                    titleStyle: ubuntuRegular.copyWith(color: Theme.of(context).primaryColor, fontSize: Dimensions.fontSizeDefault),
                  ),
                ),
                const SizedBox(width: Dimensions.paddingSizeExtraSmall),

                Expanded(
                  flex: 3,
                  child: CustomButtonWidget(
                    buttonText: 'generate'.tr,
                    margin: const EdgeInsets.only(bottom: Dimensions.paddingSizeExtraSmall),
                    onPressed: (){
                      SystemChannels.textInput.invokeMethod('TextInput.hide');
                      try{
                        if(int.parse(quantityController.text)>270 || int.parse(quantityController.text) <= 0){
                          showCustomSnackBarHelper('please_enter_from_1_to_270'.tr);
                        }else{
                          productController.setBarCodeQuantity(int.parse(quantityController.text));
                        }
                      }catch(e){
                        showCustomSnackBarHelper('barcode_number_is_not_a_decimal_number'.tr);
                      }
                    },
                  ),
                ),
              ]),
            ),
          ]),
        );
      }
    );
  }
}
