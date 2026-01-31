import 'dart:math';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:six_pos/common/controllers/category_controller.dart';
import 'package:six_pos/common/widgets/custom_button_widget.dart';
import 'package:six_pos/common/widgets/custom_clear_icon_widget.dart';
import 'package:six_pos/common/widgets/custom_select_card_widget.dart';
import 'package:six_pos/common/widgets/manual_paginated_widget.dart';
import 'package:six_pos/features/brand/controllers/brand_controller.dart';
import 'package:six_pos/features/product/controllers/product_controller.dart';
import 'package:six_pos/features/product/widgets/product_price_range_widget.dart';
import 'package:six_pos/features/user/controllers/supplier_controller.dart';
import 'package:six_pos/features/user/domain/models/supplier_model.dart';
import 'package:six_pos/helper/extension_helper.dart';
import 'package:six_pos/helper/responsive_helper.dart';
import 'package:six_pos/util/app_constants.dart';
import 'package:six_pos/util/dimensions.dart';
import 'package:six_pos/util/styles.dart';


class ProductFilterBottomSheetWidget extends StatefulWidget {
  final VoidCallback onSubmitTap;
  final VoidCallback onClearTap;
  final bool fromProductScreen;
  const ProductFilterBottomSheetWidget({super.key, required this.onClearTap, required this.onSubmitTap, required this.fromProductScreen});

  @override
  State<ProductFilterBottomSheetWidget> createState() => _ProductFilterBottomSheetWidgetState();
}

class _ProductFilterBottomSheetWidgetState extends State<ProductFilterBottomSheetWidget> {
  final TextEditingController minPriceController = TextEditingController();
  final TextEditingController maxPriceController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ProductController>(builder: (productController){
      return GetBuilder<CategoryController>(builder: (categoryController){
        return GetBuilder<BrandController>(builder: (brandController){
          return GetBuilder<SupplierController>(builder: (supplierController){
            return Column(crossAxisAlignment: CrossAxisAlignment.start,mainAxisSize: MainAxisSize.min,children: [
              Padding(
                padding: const EdgeInsets.all(Dimensions.paddingSizeLarge),
                child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                  Column(crossAxisAlignment: CrossAxisAlignment.start,children: [
                    Text('filter'.tr, style: ubuntuBold.copyWith(fontSize: Dimensions.fontSizeLarge)),

                    Text('filter_to_quickly_find_what_you_need'.tr, style: ubuntuRegular.copyWith(
                      fontSize: Dimensions.fontSizeSmall,
                      color: context.customThemeColors.textOpacityColor,
                    )),
                  ]),

                  CustomClearIconWidget(transform: Matrix4.translationValues(10, -15, 0)),
                ]),
              ),

              Flexible(child: SingleChildScrollView(child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeLarge),
                child: Column(crossAxisAlignment: CrossAxisAlignment.start,children: [

                  Text('availability'.tr, style: ubuntuBold.copyWith(fontSize: Dimensions.fontSizeDefault)),
                  SizedBox(height: Dimensions.paddingSizeSmall),

                  ListView.separated(
                    physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: AppConstants.availableTypeList.length,
                    itemBuilder: (context, index){
                      final String availableType = AppConstants.availableTypeList[index];
                      final bool isSelected = productController.selectedAvailableType == availableType;

                      return CustomSelectCardWidget(onTap: ()=> productController.updateSelectedAvailableType(availableType), isSelected: isSelected, label: availableType);
                    },
                    separatorBuilder: (context, index) => SizedBox(height: Dimensions.fontSizeSmall),
                  ),
                  SizedBox(height: Dimensions.paddingSizeExtraLarge),

                  Text('quantity'.tr, style: ubuntuBold.copyWith(fontSize: Dimensions.fontSizeDefault)),
                  SizedBox(height: Dimensions.paddingSizeSmall),

                  ListView.separated(
                    physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: AppConstants.quantityTypeList.length,
                    itemBuilder: (context, index){
                      return CustomSelectCardWidget(
                        isCheckBox: true,
                        onTap: ()=> productController.updateSelectedQuantityType(AppConstants.quantityTypeList[index]),
                        isSelected: productController.selectedQuantityType.contains(AppConstants.quantityTypeList[index]),
                        label: AppConstants.quantityTypeList[index],
                      );
                    },
                    separatorBuilder: (context, index) => SizedBox(height: Dimensions.fontSizeSmall),
                  ),
                  SizedBox(height: Dimensions.paddingSizeExtraLarge),

                  Text('price_range'.tr, style: ubuntuBold.copyWith(fontSize: Dimensions.fontSizeDefault)),
                  SizedBox(height: Dimensions.paddingSizeSmall),

                  ProductPriceRangeWidget(minPriceController: minPriceController, maxPriceController: maxPriceController, fromProductScreen: widget.fromProductScreen),
                  SizedBox(height: Dimensions.paddingSizeExtraLarge),

                  Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text('category'.tr, style: ubuntuBold.copyWith(fontSize: Dimensions.fontSizeDefault)),
                    SizedBox(height: Dimensions.paddingSizeSmall),

                    ManualPaginatedWidget(
                      totalSize: categoryController.productFilterCategoryModel?.totalSize,
                      itemListSize: categoryController.productFilterCategoryModel?.categoriesList?.length,
                      offset: categoryController.productFilterCategoryModel?.offset,
                      onPaginate: (offset)=> categoryController.getProductFilterCategoryList(offset ?? 1),
                      itemView: GridView.builder(
                          itemCount: (categoryController.productFilterCategoryModel?.offset == 1) ?
                          (min(categoryController.productFilterCategoryModel?.categoriesList?.length ?? 0, 6)) :
                          categoryController.productFilterCategoryModel?.categoriesList?.length ?? 0,
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          padding: EdgeInsets.zero,
                          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: ResponsiveHelper.isTab(context) ? 3 : 2,
                            mainAxisSpacing: 10, crossAxisSpacing: 10,
                            childAspectRatio: ResponsiveHelper.isTab(context) ? 6 : 3,
                          ),
                          itemBuilder: (context, index){
                            return CustomSelectCardWidget(
                              isCheckBox: true,
                              onTap: ()=> categoryController.onUpdateCategorySelection(categoryController.productFilterCategoryModel?.categoriesList?[index].id),
                              isSelected: categoryController.selectedProductCategoryFilter.contains(categoryController.productFilterCategoryModel?.categoriesList?[index].id),
                              label: categoryController.productFilterCategoryModel?.categoriesList?[index].name ?? '',
                            );
                          }
                      ),
                    ),
                    SizedBox(height: Dimensions.paddingSizeSmall),

                    Text('sub_category'.tr, style: ubuntuBold.copyWith(fontSize: Dimensions.fontSizeDefault)),
                    SizedBox(height: Dimensions.paddingSizeSmall),

                    categoryController.isLoading ?
                    Center(child: CircularProgressIndicator()) :
                    ManualPaginatedWidget(
                      totalSize: categoryController.productFilterSubCategoryModel?.totalSize,
                      offset: categoryController.productFilterSubCategoryModel?.offset,
                      itemListSize: categoryController.productFilterSubCategoryModel?.subCategoriesList?.length,
                      onPaginate: (value)=> categoryController.getProductFilterSubCategoryList(value ?? 1),
                      itemView: GridView.builder(
                          itemCount: (categoryController.productFilterSubCategoryModel?.offset == 1) ?
                          (min(categoryController.productFilterSubCategoryModel?.subCategoriesList?.length ?? 0, 6)) :
                          categoryController.productFilterSubCategoryModel?.subCategoriesList?.length ?? 0,
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          padding: EdgeInsets.zero,
                          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: ResponsiveHelper.isTab(context) ? 3 : 2,
                            mainAxisSpacing: 10, crossAxisSpacing: 10,
                            childAspectRatio: ResponsiveHelper.isTab(context) ? 6 : 3,
                          ),
                          itemBuilder: (context, index){
                            return CustomSelectCardWidget(
                              isCheckBox: true,
                              onTap: ()=> categoryController.onUpdateSubCategorySelection(categoryController.productFilterSubCategoryModel?.subCategoriesList?[index].id),
                              isSelected: categoryController.selectedProductSubCategoryFilter.contains(categoryController.productFilterSubCategoryModel?.subCategoriesList?[index].id),
                              label: categoryController.productFilterSubCategoryModel?.subCategoriesList?[index].name ?? '',
                            );
                          }
                      ),
                    ),

                  ]),
                  SizedBox(height: Dimensions.paddingSizeSmall),

                  Text('brand'.tr, style: ubuntuBold.copyWith(fontSize: Dimensions.fontSizeDefault)),
                  SizedBox(height: Dimensions.paddingSizeSmall),

                  ManualPaginatedWidget(
                    totalSize: brandController.productFilterBrandModel?.totalSize,
                    offset: brandController.productFilterBrandModel?.offset,
                    onPaginate: (value)=> brandController.getProductFilterBrandList(value ?? 1),
                    itemListSize: brandController.productFilterBrandModel?.brandList?.length,
                    itemView: GridView.builder(
                        itemCount: (brandController.productFilterBrandModel?.offset == 1) ?
                        (min(brandController.productFilterBrandModel?.brandList?.length ?? 0, 6)) :
                        brandController.productFilterBrandModel?.brandList?.length ?? 0,
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        padding: EdgeInsets.zero,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: ResponsiveHelper.isTab(context) ? 3 : 2,
                          mainAxisSpacing: 10, crossAxisSpacing: 10,
                          childAspectRatio: ResponsiveHelper.isTab(context) ? 6 : 3,
                        ),
                        itemBuilder: (context, index){
                          return CustomSelectCardWidget(
                            isCheckBox: true,
                            onTap: ()=> brandController.onUpdateBrandSelection(brandController.productFilterBrandModel?.brandList?[index].id),
                            isSelected: brandController.selectedProductBrandFilter.contains(brandController.productFilterBrandModel?.brandList?[index].id),
                            label: brandController.productFilterBrandModel?.brandList?[index].name ?? '',
                          );
                        }
                    ),
                  ),
                  const SizedBox(height: Dimensions.paddingSizeSmall),

                  Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text('supplier'.tr, style: ubuntuRegular.copyWith(fontSize: Dimensions.fontSizeSmall)),
                    const SizedBox(height: Dimensions.paddingSizeSmall),

                    Container(
                      height: 50,
                      padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall),
                      decoration: BoxDecoration(
                        color: Theme.of(context).cardColor,
                        border: Border.all(width: .5, color: Theme.of(context).hintColor.withValues(alpha: .7)),
                        borderRadius: BorderRadius.circular(Dimensions.paddingSizeMediumBorder),
                      ),
                      child: DropdownButton<int>(
                        hint: Text(
                            'select_supplier'.tr, style: ubuntuRegular.copyWith(
                          fontSize: Dimensions.fontSizeSmall,
                          color: Theme.of(context).textTheme.bodyLarge?.color,
                        )),
                        iconEnabledColor: Theme.of(context).hintColor,
                        // menuMaxHeight: height,
                        value: supplierController.selectedSupplierId,
                        items: supplierController.supplierProductFilterModel?.supplierList?.map((Suppliers? value) =>
                            DropdownMenuItem<int>(
                              value: value?.id,
                              child: Text((value?.name ?? '').tr, style: ubuntuMedium.copyWith(fontSize: Dimensions.fontSizeSmall)),
                            )).toList(),
                        onChanged: (int? value)=> supplierController.setSelectedSupplier(value),
                        isExpanded: true,
                        underline: const SizedBox(),
                      ),
                    ),
                    const SizedBox(height: Dimensions.paddingSizeSmall),
                  ])
                ]),
              ))),

              Container(
                padding: const EdgeInsets.symmetric(horizontal: Dimensions.iconSizeExtraLarge, vertical: Dimensions.paddingSizeSmall),
                decoration: BoxDecoration(
                    boxShadow: [BoxShadow(color: Theme.of(context).hintColor.withValues(alpha: 0.6), blurRadius: 5)],
                    color: Theme.of(context).cardColor
                ),
                child: SizedBox(
                  height: Dimensions.paddingSizeRevenueBottom,
                  child: Row(children: [
                    if(ResponsiveHelper.isTab(context))
                      Expanded(flex: 4, child: const SizedBox()),

                    Expanded(flex: 1, child: CustomButtonWidget(
                      buttonText: 'clear_filter'.tr,
                      isClear: true,
                      isButtonTextBold: true,
                      textColor: Theme.of(context).textTheme.bodyLarge?.color,
                      buttonColor: Theme.of(context).hintColor.withValues(alpha: 0.20),
                      onPressed: widget.onClearTap,
                    )),
                    const SizedBox(width: Dimensions.paddingSizeLarge),

                    Expanded(flex: 1, child: CustomButtonWidget(
                      isLoading: false,
                      buttonText: 'apply'.tr,
                      isButtonTextBold: true,
                      onPressed:
                      widget.fromProductScreen ?
                      _canFilteredFromProduct() ?
                      widget.onSubmitTap :
                      null :
                      _canFilteredFromLimitedStock() ?
                      widget.onSubmitTap :
                      null,
                    )),
                  ]),
                ),
              ),

            ]);
          });
        });
      });
    });
  }
}

bool _canFilteredFromProduct(){
  ProductController productController = Get.find<ProductController>();
  SupplierController supplierController = Get.find<SupplierController>();
  CategoryController categoryController = Get.find<CategoryController>();
  BrandController brandController = Get.find<BrandController>();

  if(
  productController.productModel?.minPrice == null || productController.productModel?.maxPrice == null ||
      productController.productModel?.stocks == null || productController.productModel?.categoryIds == null ||
      productController.productModel?.subCategoryIds == null || productController.productModel?.brandIds == null ||
      productController.productModel?.supplierId == null || productController.productModel?.availability == null
  ){
    return true;
  }else if(productController.productModel?.minPrice != productController.minPrice){
    return true;
  }else if(productController.productModel?.maxPrice != productController.maxPrice){
    return true;
  }else if(productController.productModel?.supplierId != supplierController.selectedSupplierId){
    return true;
  }else if(productController.productModel?.availability != productController.selectedAvailableType){
    return true;
  }else if(
  !(productController.selectedQuantityType.containsAll(productController.productModel!.stocks!) &&
      productController.selectedQuantityType.length == productController.productModel!.stocks!.length)
  ){
    return true;
  }else if(
  !(categoryController.selectedProductCategoryFilter.containsAll(productController.productModel!.categoryIds!) &&
      categoryController.selectedProductCategoryFilter.length == productController.productModel!.categoryIds!.length)
  ){
    return true;
  }else if(
  !(categoryController.selectedProductSubCategoryFilter.containsAll(productController.productModel!.subCategoryIds!) &&
      categoryController.selectedProductSubCategoryFilter.length == productController.productModel!.subCategoryIds!.length)
  ){
    return true;
  }else if(
  !(brandController.selectedProductBrandFilter.containsAll(productController.productModel!.brandIds!) &&
      brandController.selectedProductBrandFilter.length == productController.productModel!.brandIds!.length)
  ){
    return true;
  }else{
    return false;
  }
}


bool _canFilteredFromLimitedStock(){
  ProductController productController = Get.find<ProductController>();
  SupplierController supplierController = Get.find<SupplierController>();
  CategoryController categoryController = Get.find<CategoryController>();
  BrandController brandController = Get.find<BrandController>();

  if(
  productController.limitedStockProductModel?.minPrice == null || productController.limitedStockProductModel?.maxPrice == null ||
      productController.limitedStockProductModel?.stocks == null || productController.limitedStockProductModel?.categoryIds == null ||
      productController.limitedStockProductModel?.subCategoryIds == null || productController.limitedStockProductModel?.brandIds == null ||
      productController.limitedStockProductModel?.supplierId == null || productController.limitedStockProductModel?.availability == null
  ){
    return true;
  }else if(productController.limitedStockProductModel?.minPrice != productController.minPrice){
    return true;
  }else if(productController.limitedStockProductModel?.maxPrice != productController.maxPrice){
    return true;
  }else if(productController.limitedStockProductModel?.supplierId != supplierController.selectedSupplierId){
    return true;
  }else if(productController.limitedStockProductModel?.availability != productController.selectedAvailableType){
    return true;
  }else if(
  !(productController.selectedQuantityType.containsAll(productController.limitedStockProductModel!.stocks!) &&
      productController.selectedQuantityType.length == productController.limitedStockProductModel!.stocks!.length)
  ){
    return true;
  }else if(
  !(categoryController.selectedProductCategoryFilter.containsAll(productController.limitedStockProductModel!.categoryIds!) &&
      categoryController.selectedProductCategoryFilter.length == productController.limitedStockProductModel!.categoryIds!.length)
  ){
    return true;
  }else if(
  !(categoryController.selectedProductSubCategoryFilter.containsAll(productController.limitedStockProductModel!.subCategoryIds!) &&
      categoryController.selectedProductSubCategoryFilter.length == productController.limitedStockProductModel!.subCategoryIds!.length)
  ){
    return true;
  }else if(
  !(brandController.selectedProductBrandFilter.containsAll(productController.limitedStockProductModel!.brandIds!) &&
      brandController.selectedProductBrandFilter.length == productController.limitedStockProductModel!.brandIds!.length)
  ){
    return true;
  }else{
    return false;
  }
}