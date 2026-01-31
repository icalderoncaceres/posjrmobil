import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:six_pos/common/controllers/category_controller.dart';
import 'package:six_pos/common/widgets/common_filter_bottom_sheet_widget.dart';
import 'package:six_pos/common/widgets/custom_debounce_widget.dart';
import 'package:six_pos/common/widgets/custom_screen_bar_widget.dart';
import 'package:six_pos/common/widgets/custom_sliver_header_delegate_widget.dart';
import 'package:six_pos/common/widgets/show_custom_bottom_sheet.dart';
import 'package:six_pos/features/brand/controllers/brand_controller.dart';
import 'package:six_pos/features/product/controllers/product_controller.dart';
import 'package:six_pos/features/product/widgets/product_filter_bottom_sheet_widget.dart';
import 'package:six_pos/features/user/controllers/supplier_controller.dart';
import 'package:six_pos/helper/animated_custom_dialog_helper.dart';
import 'package:six_pos/helper/download_helper.dart';
import 'package:six_pos/helper/extension_helper.dart';
import 'package:six_pos/helper/responsive_helper.dart';
import 'package:six_pos/util/app_constants.dart';
import 'package:six_pos/util/dimensions.dart';
import 'package:six_pos/features/product/widgets/limited_stock_product_list_widget.dart';
import 'package:six_pos/util/styles.dart';


class LimitedStockProductScreen extends StatefulWidget {
  const LimitedStockProductScreen({Key? key}) : super(key: key);

  @override
  State<LimitedStockProductScreen> createState() => _LimitedStockProductScreenState();
}

class _LimitedStockProductScreenState extends State<LimitedStockProductScreen> {
  final ScrollController _scrollController = ScrollController();
  final CustomDebounceWidget customDebounceWidget = CustomDebounceWidget(milliseconds: 500);
  final ProductController productController = Get.find<ProductController>();

  @override
  void initState() {
    Get.find<CategoryController>().getProductFilterCategoryList(1);
    Get.find<CategoryController>().getProductFilterSubCategoryList(1);
    Get.find<BrandController>().getProductFilterBrandList(1);
    Get.find<SupplierController>().getProductFilterSupplierList();
    productController.getLimitedStockProductList(1).then((_){
      productController.setPriceRange(productController.limitedStockProductModel?.productMinimumPrice, productController.limitedStockProductModel?.productMaximumPrice , true, true, isUpdate: false);

    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.customThemeColors.screenBackgroundColor,
      body: SafeArea(
        child: GetBuilder<ProductController>(builder: (productController){
          return RefreshIndicator(
            color: Theme.of(context).cardColor,
            backgroundColor: Theme.of(context).primaryColor,
            onRefresh: () async {
              productController.getLimitedStockProductList(1);
            },
            child: CustomScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              controller: _scrollController,
              slivers: [

                SliverPersistentHeader(
                  floating: true,
                  pinned: false,
                  delegate: CustomSliverHeaderDelegateWidget(
                    height: Dimensions.productImageSizeItem,
                    child: GetBuilder<ProductController>(builder: (productController){
                      return CustomScreenBarWidget(
                        title: 'product_list'.tr,
                        elementCount: '${productController.limitedStockProductModel?.totalSize ?? 0}',
                        isFiltered: _isFiltered(productController),
                        isSearchApplied: _checkIsSearchApplied(productController),
                        searchText: productController.limitedStockProductModel?.searchText ?? '',
                        onFilterButtonTap: ()=> ResponsiveHelper.isTab(context) ?
                        showAnimatedDialogHelper(context, Dialog(
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(Dimensions.paddingSizeSmall)),
                          child: ProductFilterBottomSheetWidget(
                            fromProductScreen: false,
                            onClearTap: ()=> productController.clearFilter(false),
                            onSubmitTap: (){
                              Get.back();
                              _getLimitedStockList(productController);
                            },
                          ),
                        )) :
                        showCustomBottomSheet(
                          child: ProductFilterBottomSheetWidget(
                            fromProductScreen: false,
                            onClearTap: ()=> productController.clearFilter(false),
                            onSubmitTap: (){
                              Get.back();
                              _getLimitedStockList(productController);
                            },
                          ),
                          topLeftRadius: Dimensions.paddingSizeLarge,
                          topRightRadius: Dimensions.paddingSizeLarge,
                        ),
                        searchOnChange: (value)=> customDebounceWidget.run(()=> _getSuggestionList(productController, value)),
                        onSubmit: (value){
                          Get.back();
                          _getLimitedStockList(productController);
                        },
                        suggestionListWidget: GetBuilder<ProductController>(builder: (productController) {
                          return Flexible(child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start,children: [

                            if(productController.limitedStockProductSuggestionList?.stockLimitedProducts?.isNotEmpty ?? false)...[
                              const SizedBox(height: Dimensions.paddingSizeExtraLarge),

                              Text('search_suggestion'.tr, style: ubuntuMedium.copyWith(fontSize: Dimensions.fontSizeSmall)),
                              SizedBox(height: Dimensions.paddingSizeMediumBorder),
                            ],

                            productController.isLoading ?
                            Center(child: CircularProgressIndicator()) :
                            Flexible(child: ListView.builder(
                              padding: EdgeInsets.zero,
                              shrinkWrap: true,
                              itemCount: productController.limitedStockProductSuggestionList?.stockLimitedProducts?.length ?? 0,
                              itemBuilder: (context, index) {
                                return ListTile(
                                  visualDensity: const VisualDensity(vertical: -4),
                                  minVerticalPadding: 0,
                                  contentPadding: EdgeInsets.zero,
                                  leading: Icon(Icons.search, color: Theme.of(context).hintColor.withValues(alpha: 0.5)),
                                  title: Text(productController.limitedStockProductSuggestionList?.stockLimitedProducts?[index].name ?? '', style: ubuntuRegular.copyWith(fontSize: Dimensions.fontSizeSmall)),
                                  trailing: Icon(Icons.arrow_forward_rounded, color: Theme.of(context).hintColor),
                                  onTap: () {
                                    Get.back();
                                    _getSuggestionList(productController, productController.limitedStockProductSuggestionList?.stockLimitedProducts?[index].name);
                                    _getLimitedStockList(productController);
                                  },
                                );
                              },
                            )),
                          ]));
                        }),
                        onDownloadPress: () {
                          DownloadHelper.downloadPDf(Uri.parse('${AppConstants.baseUrl}${AppConstants.stockLimitPdfDownloadUri}'));
                        },
                      );
                    }),
                  ),

                ),

                SliverToBoxAdapter(
                  child: LimitedStockProductListWidget(scrollController: _scrollController, isHome: false),
                )
              ],
            ),
          );
        }),
      ),
    );
  }
}

bool _isFiltered(ProductController productController){

  if(
  productController.productModel?.availability != null || productController.productModel?.stocks != null ||
      productController.productModel?.minPrice != null || productController.productModel?.maxPrice != null || productController.productModel?.categoryIds != null ||
      productController.productModel?.subCategoryIds != null || productController.productModel?.brandIds != null ||
      productController.productModel?.supplierId != null
  ){
    return true;
  }else{
    return false;
  }
}


void _getLimitedStockList(ProductController productController){

  productController.getLimitedStockProductList(
      1,minPrice: productController.minPrice, maxPrice: productController.maxPrice,
      stocks: productController.selectedQuantityType.toList(),
      categoryIds: Get.find<CategoryController>().selectedProductCategoryFilter.toList(),
      subCategoryIds: Get.find<CategoryController>().selectedProductSubCategoryFilter.toList(),
      brandsIds: Get.find<BrandController>().selectedProductBrandFilter.toList(),
      supplierId: Get.find<SupplierController>().selectedSupplierId,
      availability: productController.selectedAvailableType, 
      searchText: productController.searchText
  );
}

void _getSuggestionList(ProductController productController, String? searchText){

  productController.getLimitedStockProductSuggestionList(
      minPrice: productController.minPrice, maxPrice: productController.maxPrice,
      stocks: productController.selectedQuantityType.toList(),
      categoryIds: Get.find<CategoryController>().selectedProductCategoryFilter.toList(),
      subCategoryIds: Get.find<CategoryController>().selectedProductSubCategoryFilter.toList(),
      brandsIds: Get.find<BrandController>().selectedProductBrandFilter.toList(),
      supplierId: Get.find<SupplierController>().selectedSupplierId,
      availability: productController.selectedAvailableType,
      query: searchText
  );
}

bool _checkIsSearchApplied(ProductController productController){

  if(productController.limitedStockProductModel?.searchText != null){
    return true;
  }else{
    return false;
  }
}