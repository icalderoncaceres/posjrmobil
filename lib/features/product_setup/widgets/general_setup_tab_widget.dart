import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:six_pos/common/controllers/category_controller.dart';
import 'package:six_pos/common/widgets/custom_field_with_title_widget.dart';
import 'package:six_pos/common/widgets/custom_menu_textfield_widget.dart';
import 'package:six_pos/common/widgets/custom_text_field_widget.dart';
import 'package:six_pos/features/brand/controllers/brand_controller.dart';
import 'package:six_pos/features/product/controllers/product_controller.dart';
import 'package:six_pos/features/unit/controllers/unit_controller.dart';
import 'package:six_pos/util/dimensions.dart';
import 'package:six_pos/util/styles.dart';
import 'package:six_pos/common/models/sub_category_model.dart';
import 'package:six_pos/features/brand/domain/models/brand_model.dart';
import 'package:six_pos/features/category/domain/models/category_model.dart';

class GeneralSetupTabWidget extends StatelessWidget {
  const GeneralSetupTabWidget({super.key});

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.sizeOf(context).height * 0.5;
    return GetBuilder<ProductController>(builder: (productController){
      return Container(
        margin: EdgeInsets.only(bottom: Dimensions.paddingSizeExtraExtraLarge),
        padding: EdgeInsets.all(Dimensions.paddingSizeLarge),
        color: Theme.of(context).cardColor,
        child: Container(
          padding: EdgeInsets.all(Dimensions.fontSizeSmall),
          decoration: BoxDecoration(
            color: Theme.of(context).hintColor.withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(Dimensions.paddingSizeExtraSmall),
          ),
          child: Column(children: [
            Row(children: [
              Expanded(
                child: GetBuilder<BrandController>(builder: (brandController) {
                  return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text('brand'.tr, style: ubuntuRegular.copyWith(fontSize: Dimensions.fontSizeSmall)),
                    const SizedBox(height: Dimensions.paddingSizeSmall),

                    Container(
                      height: 50,
                      padding: const EdgeInsets.symmetric(horizontal:Dimensions.paddingSizeSmall),
                      decoration: BoxDecoration(color: Theme.of(context).cardColor,
                          border: Border.all(width: .5, color: Theme.of(context).hintColor.withValues(alpha:.7)),
                          borderRadius: BorderRadius.circular(Dimensions.paddingSizeMediumBorder)),
                      child: DropdownButton<int>(
                        hint: Text('select_brand'.tr, style: ubuntuRegular.copyWith(
                          fontSize: Dimensions.fontSizeSmall,
                          color: Theme.of(context).textTheme.bodyLarge?.color,
                        )),
                        iconEnabledColor: Theme.of(context).hintColor,
                        menuMaxHeight: height,
                        value: brandController.selectedBrandId,
                        items: brandController.brandModel?.brandList?.map((Brands? value) {
                          return DropdownMenuItem<int>(
                            value: value?.id,
                            child: Text('${value?.name}', style: ubuntuMedium.copyWith(fontSize: Dimensions.fontSizeSmall)),
                            // child: Text( value != 0? brandController.brandModel!.brandList![(brandController.brandIds.indexOf(value) -1)].name!: 'select'.tr),
                          );
                        }).toList(),
                        onChanged: (int? value) {
                          brandController.onChangeBrandId(value, true);
                        },
                        isExpanded: true,
                        underline: const SizedBox(),
                      ),
                    ),
                  ]);
                }),
              ),
              SizedBox(width: Dimensions.paddingSizeLarge),

              Expanded(
                child: CustomFieldWithTitleWidget(
                  customTextField: CustomTextFieldWidget(hintText: 'type_quantity'.tr,
                    contentPadding: Dimensions.paddingSizeDefault,
                    fontSize: Dimensions.fontSizeSmall,
                    controller: productController.productStockController,
                    inputType: TextInputType.number,
                  ),
                  title: 'quantity'.tr,
                  requiredField: true,
                  padding: 0,
                ),
              ),
              SizedBox(width: Dimensions.paddingSizeLarge),

              Expanded(
                child: CustomFieldWithTitleWidget(
                  customTextField: CustomTextFieldWidget(hintText: 'stock_quantity_hint'.tr,
                    contentPadding: Dimensions.paddingSizeDefault,
                    fontSize: Dimensions.fontSizeSmall,
                    controller: productController.productReorderController,
                    inputType: TextInputType.number,
                  ),
                  title: 'reorder_level'.tr,
                  requiredField: true,
                  padding: 0,
                ),
              ),
            ]),
            SizedBox(height: Dimensions.paddingSizeLarge),

            IntrinsicHeight(
              child: Row(children: [
                Expanded(
                  child: CustomFieldWithTitleWidget(
                    customTextField: CustomMenuTextFieldWidget(
                      hintText: 'sku_hint'.tr,
                      contentPadding: Dimensions.paddingSizeDefault,
                      fontSize: Dimensions.fontSizeSmall,
                      controller: productController.unitValueController,
                      inputType: TextInputType.number,
                      menuWidget: Container(
                        padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall),
                        height: 50, width: Get.width * 0.1,
                        decoration: BoxDecoration(
                            borderRadius: const BorderRadius.only(
                              topRight: Radius.circular(8),
                              bottomRight: Radius.circular(8),
                            ),
                            color: Theme.of(context).hintColor.withValues(alpha:0.15)
                        ),
                        child: GetBuilder<UnitController>(builder: (unitController) {
                          return  DropdownButton<int>(
                            value: unitController.unitIndex,
                            items: unitController.unitIds.map((int? value) {
                              return DropdownMenuItem<int>(
                                value: value,
                                child: Text(
                                  value != 0 ?
                                  unitController.unitList![(unitController.unitIds.indexOf(value) -1)].unitType! :
                                  'select'.tr,
                                  style: ubuntuRegular.copyWith(fontSize: Dimensions.fontSizeSmall),
                                ),
                              );
                            }).toList(),
                            onChanged: (int? value) {
                              unitController.setUnitIndex(value, true);
                            },
                            isExpanded: true,
                            underline: const SizedBox(),
                            iconEnabledColor: Theme.of(context).hintColor,
                          );
                        }),
                      ),
                    ),
                    title: 'unit_type'.tr,
                    requiredField: true,
                    padding: 0,
                  ),
                ),
                SizedBox(width: Dimensions.paddingSizeLarge),
              
                Expanded(
                  child: GetBuilder<CategoryController>(builder: (categoryController) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start, children: [
              
                      Row(children: [
                        Text('category'.tr, style: ubuntuRegular.copyWith(fontSize: Dimensions.fontSizeSmall)),

                        Text(' *', style: ubuntuBold.copyWith(color: Colors.red)),
                      ]),
                      const SizedBox(height: Dimensions.paddingSizeSmall),
              
                      Container(
                        height: 50,
                        padding: const EdgeInsets.symmetric(
                            horizontal: Dimensions.paddingSizeSmall),
                        decoration: BoxDecoration(
                          color: Theme.of(context).cardColor,
                          border: Border.all(width: .5, color: Theme.of(context).hintColor.withValues(alpha: .7)),
                          borderRadius: BorderRadius.circular(
                              Dimensions.paddingSizeMediumBorder),
                        ),
                        child: DropdownButton<int>(
                          hint: Text(
                              'select_category'.tr, style: ubuntuRegular.copyWith(
                            fontSize: Dimensions.fontSizeSmall,
                            color: Theme.of(context).textTheme.bodyLarge?.color,
                          )),
                          iconEnabledColor: Theme.of(context).hintColor,
                          menuMaxHeight: height,
                          value: categoryController.selectedCategoryId,
                          items: categoryController.categoryModel?.categoriesList
                              ?.map((Categories? value) =>
                              DropdownMenuItem<int>(
                                value: value?.id,
                                child: Text(value?.name ?? '',
                                    style: ubuntuMedium.copyWith(
                                        fontSize: Dimensions.fontSizeSmall)),
                              )).toList(),
                          onChanged: (int? value) =>
                              categoryController.setCategoryIndex(value!, true),
                          isExpanded: true,
                          underline: const SizedBox(),
                        ),
                      ),
                      const SizedBox(height: Dimensions.paddingSizeSmall),
                    ],);
                  }),
                ),
                SizedBox(width: Dimensions.paddingSizeLarge),
              
                Expanded(
                  child: GetBuilder<CategoryController>(builder: (categoryController) {
                    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Text('sub_category'.tr, style: ubuntuRegular.copyWith(fontSize: Dimensions.fontSizeSmall)),
                      const SizedBox(height: Dimensions.paddingSizeSmall),
                      Container(
                        height: 50,
                        padding: const EdgeInsets.symmetric(horizontal:Dimensions.paddingSizeSmall),
                        decoration: BoxDecoration(color: Theme.of(context).cardColor,
                            border: Border.all(width: .5, color: Theme.of(context).hintColor.withValues(alpha:.7)),
                            borderRadius: BorderRadius.circular(Dimensions.paddingSizeMediumBorder)),
                        child: DropdownButton<int>(
                          menuMaxHeight: height,
                          value: categoryController.selectedSubCategoryId,
                          hint: Text('select_sub_category'.tr, style: ubuntuRegular.copyWith(
                            fontSize: Dimensions.fontSizeSmall,
                            color: Theme.of(context).textTheme.bodyLarge?.color,
                          )),
                          iconEnabledColor: Theme.of(context).hintColor,
                          items: categoryController.subCategoryModel?.subCategoriesList?.map((SubCategories? value) {
                            return DropdownMenuItem<int>(
                                value: value?.id,
                                child: Text(value?.name ?? '', style: ubuntuMedium.copyWith(fontSize: Dimensions.fontSizeSmall)));
                          }).toList(),
                          onChanged: (int? value) {
                            categoryController.setSubCategoryIndex(value, true);
                          },
                          isExpanded: true,
                          underline: const SizedBox(),
                        ),
                      ),
                      const SizedBox(height: Dimensions.paddingSizeSmall),
                    ]);
                  }),
                ),
              ]),
            )

          ]),
        ),
      );
    });
  }
}
