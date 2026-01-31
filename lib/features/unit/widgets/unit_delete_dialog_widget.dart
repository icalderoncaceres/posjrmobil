import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:six_pos/common/widgets/custom_asset_image_widget.dart';
import 'package:six_pos/common/widgets/custom_button_widget.dart';
import 'package:six_pos/common/widgets/custom_clear_icon_widget.dart';
import 'package:six_pos/features/brand/controllers/brand_controller.dart';
import 'package:six_pos/features/brand/domain/models/brand_model.dart';
import 'package:six_pos/features/unit/controllers/unit_controller.dart';
import 'package:six_pos/features/unit/domain/models/unit_model.dart';
import 'package:six_pos/helper/extension_helper.dart';
import 'package:six_pos/helper/responsive_helper.dart';
import 'package:six_pos/util/dimensions.dart';
import 'package:six_pos/util/images.dart';
import 'package:six_pos/util/styles.dart';

class UnitDeleteDialogWidget extends StatelessWidget {
  final Function onDeleteTap;
  final bool isLoading;
  final double? borderRadius;
  final Units? unit;
  final int? unitProductCount;


  const UnitDeleteDialogWidget({Key? key,
    this.isLoading = false,
    required this.onDeleteTap,
    this.borderRadius,
    this.unit,
    required this.unitProductCount,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bool showDropDown = (unitProductCount ?? 0) > 0;


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

              Text(showDropDown ?
              'need_to_shift_unit_to_another_unit'.tr :
              'are_you_sure_you_want_to_delete_unit'.tr, style: ubuntuMedium.copyWith(fontSize: Dimensions.fontSizeLarge), textAlign: TextAlign.center),
              const SizedBox(height: Dimensions.paddingSizeDefault),

              if(!showDropDown) ...[
                Text('once_you_delete_this_unit_the_associated_products_data_will_be_lost_permanently'.tr, textAlign: TextAlign.center, style: ubuntuRegular.copyWith(
                    fontSize: Dimensions.fontSizeSmall,
                    color: context.customThemeColors.textOpacityColor
                )),
                const SizedBox(height: Dimensions.paddingSizeExtraExtraLarge),
              ]
              else ...[
                Text(
                  '${'this_unit_has'.tr} $unitProductCount ${'products'.tr}. ${'please_shift_them_to_another_unit_before_deleting'.tr}',
                  textAlign: TextAlign.center,
                  style: ubuntuRegular.copyWith(
                      fontSize: Dimensions.fontSizeSmall,
                      color: context.customThemeColors.textOpacityColor,
                  ),
                ),
                const SizedBox(height: Dimensions.paddingSizeDefault),

                Align(alignment: Alignment.centerLeft, child: Text('choose_unit'.tr)),
                const SizedBox(height: Dimensions.paddingSizeSmall),

                GetBuilder<UnitController>(builder: (unitController) {
                  return  Container(
                    padding: const EdgeInsets.symmetric(horizontal:Dimensions.paddingSizeSmall),
                    decoration: BoxDecoration(
                      color: Theme.of(context).cardColor,
                      border: Border.all(width: 1, color: Theme.of(context).hintColor.withValues(alpha: 0.2)),
                      borderRadius: BorderRadius.circular(Dimensions.paddingSizeMediumBorder),
                    ),
                    child: DropdownButton<int>(
                      hint: Text('select'.tr, style: ubuntuRegular.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).textTheme.bodyLarge?.color)),
                      value: unitController.selectedUnitId,
                      items: unitController.unitList?.map((Units? value) {
                        return DropdownMenuItem<int>(
                          enabled: unit?.id != value?.id,
                            value: value?.id,
                            child: Text(value?.unitType ?? '', style: ubuntuRegular.copyWith(
                                fontSize: Dimensions.fontSizeSmall,
                                color: unit?.id == value?.id ? Theme.of(context).disabledColor : null
                            )));
                      }).toList(),
                      onChanged: (int? value) {
                        unitController.onChangeUnitId(value!, true);
                        },
                      isExpanded: true,
                      underline: const SizedBox(),
                      iconEnabledColor: Theme.of(context).hintColor,
                    ),
                  );
                }),
                const SizedBox(height: Dimensions.paddingSizeExtraExtraLarge),
              ],


              Row(children: [
                Expanded(child: SizedBox(height: Dimensions.dropDownHeight,
                  child: CustomButtonWidget(
                    buttonText: 'no'.tr,
                    isButtonTextBold: true,
                    isClear: true,
                    textColor: Theme.of(context).textTheme.bodyLarge?.color,
                    buttonColor: Theme.of(context).hintColor.withValues(alpha: 0.20),
                    onPressed:()=> Navigator.pop(context),
                  ),
                )),
                const SizedBox(width: Dimensions.paddingSizeSmall),

                Expanded(child: SizedBox(height: Dimensions.dropDownHeight,
                  child: CustomButtonWidget(
                    isLoading: isLoading,
                    buttonText: showDropDown ? 'shift_and_delete'.tr : 'delete'.tr,
                    isButtonTextBold: true,
                    onPressed: onDeleteTap,
                    buttonColor: context.customThemeColors.deleteButtonColor,
                  ),
                )),
              ]),
            ]),
          )
        ]),
      ),
    );
  }
}
