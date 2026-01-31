import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:six_pos/common/widgets/custom_asset_image_widget.dart';
import 'package:six_pos/common/widgets/custom_button_widget.dart';
import 'package:six_pos/common/widgets/custom_clear_icon_widget.dart';
import 'package:six_pos/features/brand/controllers/brand_controller.dart';
import 'package:six_pos/features/brand/domain/models/brand_model.dart';
import 'package:six_pos/helper/extension_helper.dart';
import 'package:six_pos/helper/responsive_helper.dart';
import 'package:six_pos/util/dimensions.dart';
import 'package:six_pos/util/images.dart';
import 'package:six_pos/util/styles.dart';


class BrandDeleteDialogWidget extends StatefulWidget {
  final Function(bool isShiftDelete) onDeleteTap;
  final bool isLoading;
  final double? borderRadius;
  final Brands? brand;
  final int? brandProductCount;
  const BrandDeleteDialogWidget({Key? key,
    this.isLoading = false,
    required this.onDeleteTap,
    this.borderRadius,
    this.brand,
    required this.brandProductCount,
  }) : super(key: key);

  @override
  State<BrandDeleteDialogWidget> createState() => _BrandDeleteDialogWidgetState();
}

class _BrandDeleteDialogWidgetState extends State<BrandDeleteDialogWidget> {
  bool isShiftDelete = false;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: ResponsiveHelper.isTab(context) ? EdgeInsets.symmetric(horizontal: Get.width * 0.35) : null,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(widget.borderRadius ?? 10)),
      child: GetBuilder<BrandController>(builder: (brandController){
        return Padding(
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

                Text(isShiftDelete ?
                'need_to_shift_brand_to_another_brand'.tr :
                'are_you_sure_you_want_to_delete_brand'.tr, style: ubuntuMedium.copyWith(fontSize: Dimensions.fontSizeLarge), textAlign: TextAlign.center),
                const SizedBox(height: Dimensions.paddingSizeDefault),

                if((widget.brandProductCount ?? 0) <= 0) ...[
                  Text('once_you_delete_this_brand_the_associated_products_data_will_be_lost_permanently'.tr, textAlign: TextAlign.center, style: ubuntuRegular.copyWith(
                      fontSize: Dimensions.fontSizeSmall,
                      color: context.customThemeColors.textOpacityColor
                  )),
                  const SizedBox(height: Dimensions.paddingSizeExtraExtraLarge),
                ]
                else ...[
                  Text(
                    '${'this_brand_has'.tr} ${widget.brandProductCount} ${'products'.tr}. ${'please_shift_them_to_another_brand_before_deleting'.tr}',
                    textAlign: TextAlign.center,
                    style: ubuntuRegular.copyWith(
                      fontSize: Dimensions.fontSizeSmall,
                      color: context.customThemeColors.textOpacityColor,
                    ),
                  ),
                  const SizedBox(height: Dimensions.paddingSizeDefault),

                ],

                if(isShiftDelete)...[
                  Align(alignment: Alignment.centerLeft, child: Text('choose_brand'.tr)),
                  const SizedBox(height: Dimensions.paddingSizeSmall),

                  Container(
                    padding: const EdgeInsets.symmetric(horizontal:Dimensions.paddingSizeSmall),
                    decoration: BoxDecoration(
                      color: Theme.of(context).cardColor,
                      border: Border.all(width: 1, color: Theme.of(context).hintColor.withValues(alpha: 0.2)),
                      borderRadius: BorderRadius.circular(Dimensions.paddingSizeMediumBorder),
                    ),
                    child: DropdownButton<int>(
                      hint: Text('select'.tr, style: ubuntuRegular.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).textTheme.bodyLarge?.color)),
                      value: brandController.selectedBrandId,
                      items: brandController.brandModel?.brandList?.map((Brands? value) {
                        return DropdownMenuItem<int>(
                            enabled: widget.brand?.id != value?.id,
                            value: value?.id,
                            child: Text(value?.name ?? '', style: ubuntuRegular.copyWith(
                              fontSize: Dimensions.fontSizeSmall,
                              color: widget.brand?.id == value?.id ? Theme.of(context).disabledColor : null,
                            )));
                      }).toList(),
                      onChanged: (int? value) {
                        brandController.onChangeBrandId(value!, true);
                      },
                      isExpanded: true,
                      underline: const SizedBox(),
                      iconEnabledColor: Theme.of(context).hintColor,
                    ),
                  ),
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
                      isLoading: widget.isLoading,
                      buttonText: isShiftDelete ? 'shift_and_delete'.tr : 'delete'.tr,
                      isButtonTextBold: true,
                      onPressed: ()=> widget.onDeleteTap(isShiftDelete),
                      buttonColor: context.customThemeColors.deleteButtonColor,
                    ),
                  )),
                ]),
                const SizedBox(height: Dimensions.paddingSizeSmall),

                if((widget.brandProductCount ?? 0) > 0)...[
                  if(!isShiftDelete)
                    Text('want_to_shift_them_another_brand'.tr, textAlign: TextAlign.center, style: ubuntuRegular.copyWith(
                        fontSize: Dimensions.fontSizeSmall,
                        color: context.customThemeColors.textOpacityColor
                    )),
                  const SizedBox(height: Dimensions.paddingSizeSmall),

                  InkWell(
                    onTap: (){
                      if(((brandController.brandModel?.brandList?.length ?? 0) < 2) || isShiftDelete){
;                        brandController.onChangeBrandId(null, false);
                      }else{
                        if(brandController.brandModel?.brandList?[0].id != widget.brand?.id){
                          brandController.onChangeBrandId(brandController.brandModel?.brandList?[0].id, false);
                        }else{
                          brandController.onChangeBrandId(brandController.brandModel?.brandList?[1].id, false);
                        }
                      }
                      setState(() {
                        isShiftDelete = !isShiftDelete;
                      });
                    },
                    child: Text(isShiftDelete ? 'go_back'.tr : 'click_here'.tr, textAlign: TextAlign.center, style: ubuntuRegular.copyWith(
                        fontSize: Dimensions.fontSizeSmall,
                        color: context.customThemeColors.infoColor, decorationColor: context.customThemeColors.infoColor,
                        decoration: TextDecoration.underline
                    )),
                  ),
                ]

              ]),
            )
          ]),
        );
      }),
    );
  }
}
