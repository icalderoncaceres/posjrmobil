import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:six_pos/common/controllers/category_controller.dart';
import 'package:six_pos/common/widgets/custom_asset_image_widget.dart';
import 'package:six_pos/common/widgets/custom_button_widget.dart';
import 'package:six_pos/common/widgets/custom_clear_icon_widget.dart';
import 'package:six_pos/features/category/domain/models/category_model.dart';
import 'package:six_pos/helper/extension_helper.dart';
import 'package:six_pos/helper/responsive_helper.dart';
import 'package:six_pos/util/dimensions.dart';
import 'package:six_pos/util/images.dart';
import 'package:six_pos/util/styles.dart';


class CategoryDeleteDialogWidget extends StatelessWidget {
  final Function onDeleteTap;
  final bool isLoading;
  final double? borderRadius;
  final Categories? category;
  final int? categoryProductCount;


  const CategoryDeleteDialogWidget({Key? key,
    this.isLoading = false,
    required this.onDeleteTap,
    this.borderRadius,
    this.category,
    required this.categoryProductCount,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bool showDropDown = (categoryProductCount ?? 0) > 0;


    return Dialog(
      insetPadding: ResponsiveHelper.isTab(context) ? EdgeInsets.symmetric(horizontal: Get.width * 0.35) : null,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(borderRadius ?? 10)),
      child: Padding(
        padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
        child: Column(mainAxisSize: MainAxisSize.min, children: [

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
              'need_to_shift_products_to_another_category'.tr :
              'are_you_sure_you_want_to_delete_category'.tr, style: ubuntuMedium.copyWith(fontSize: Dimensions.fontSizeLarge), textAlign: TextAlign.center),
              const SizedBox(height: Dimensions.paddingSizeDefault),

              if(!showDropDown) ...[
                Text('once_you_delete_this_category_the_associated_products_data_will_be_lost_permanently'.tr, textAlign: TextAlign.center, style: ubuntuRegular.copyWith(
                    fontSize: Dimensions.fontSizeSmall,
                    color: context.customThemeColors.textOpacityColor
                )),
                const SizedBox(height: Dimensions.paddingSizeExtraExtraLarge),
              ]
              else ...[
                Text(
                  '${'this_category_has'.tr} $categoryProductCount ${'products'.tr}. ${'please_shift_them_to_another_category_before_deleting'.tr}',
                  textAlign: TextAlign.center,
                  style: ubuntuRegular.copyWith(
                    fontSize: Dimensions.fontSizeSmall,
                    color: context.customThemeColors.textOpacityColor,
                  ),
                ),
                const SizedBox(height: Dimensions.paddingSizeDefault),

                Align(alignment: Alignment.centerLeft, child: Text('choose_category'.tr)),
                const SizedBox(height: Dimensions.paddingSizeSmall),

                GetBuilder<CategoryController>(builder: (categoryController) {
                  return  Container(
                    padding: const EdgeInsets.symmetric(horizontal:Dimensions.paddingSizeSmall),
                    decoration: BoxDecoration(
                      color: Theme.of(context).cardColor,
                      border: Border.all(width: 1, color: Theme.of(context).hintColor.withValues(alpha: 0.2)),
                      borderRadius: BorderRadius.circular(Dimensions.paddingSizeMediumBorder),
                    ),
                    child: DropdownButton<int>(
                      hint: Text('select'.tr),
                      value: categoryController.categorySelectedIndex,

                      items: categoryController.categoryModel?.categoriesList?.map((Categories? value) {
                        return DropdownMenuItem<int>(
                            enabled: category?.id != value?.id,
                            value: value?.id,
                            child: Text(value?.name ?? '', style: ubuntuRegular.copyWith(
                              fontSize: Dimensions.fontSizeSmall,
                              color: category?.id == value?.id ? Theme.of(context).disabledColor : null,
                            )));
                      }).toList(),
                      onChanged: (int? value) {
                        categoryController.changeSelectedIndex(value!, isUpdate: true);
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
                    onPressed: ()=> onDeleteTap(),
                    buttonColor: context.customThemeColors.deleteButtonColor,
                    isButtonTextBold: true,
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
