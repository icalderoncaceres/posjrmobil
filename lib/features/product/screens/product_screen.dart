import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:six_pos/common/controllers/category_controller.dart';
import 'package:six_pos/common/widgets/custom_debounce_widget.dart';
import 'package:six_pos/common/widgets/custom_screen_bar_widget.dart';
import 'package:six_pos/common/widgets/custom_sliver_header_delegate_widget.dart';
import 'package:six_pos/common/widgets/show_custom_bottom_sheet.dart';
import 'package:six_pos/features/brand/controllers/brand_controller.dart';
import 'package:six_pos/features/product/controllers/product_controller.dart';
import 'package:six_pos/features/product/widgets/product_filter_bottom_sheet_widget.dart';
import 'package:six_pos/features/product_setup/screens/add_product_screen.dart';
import 'package:six_pos/features/user/controllers/supplier_controller.dart';
import 'package:six_pos/helper/animated_custom_dialog_helper.dart';
import 'package:six_pos/helper/download_helper.dart';
import 'package:six_pos/helper/extension_helper.dart';
import 'package:six_pos/helper/responsive_helper.dart';
import 'package:six_pos/util/app_constants.dart';
import 'package:six_pos/util/dimensions.dart';
import 'package:six_pos/common/widgets/custom_app_bar_widget.dart';
import 'package:six_pos/common/widgets/custom_drawer_widget.dart';
import 'package:six_pos/features/product/widgets/product_list_widget.dart';
import 'package:six_pos/util/styles.dart';

class ProductScreen extends StatefulWidget {
  final int? supplierId;
  const ProductScreen({Key? key, this.supplierId}) : super(key: key);

  @override
  State<ProductScreen> createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
  TextEditingController searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final CustomDebounceWidget customDebounceWidget = CustomDebounceWidget(milliseconds: 500);


  @override
  void initState() {
    super.initState();
    Get.find<CategoryController>().getProductFilterCategoryList(1);
    Get.find<CategoryController>().getProductFilterSubCategoryList(1);
    Get.find<BrandController>().getProductFilterBrandList(1);
    Get.find<SupplierController>().getProductFilterSupplierList();
    final ProductController productController = Get.find<ProductController>();
    if(widget.supplierId != null){
      productController.getSupplierProductList(1, widget.supplierId);
    }else{
      productController.getProductList(1, isUpdate: false).then((_){
        productController.setPriceRange(productController.productModel?.productMinimumPrice, productController.productModel?.productMaximumPrice , true, true, isUpdate: false);
      });
    }

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.customThemeColors.screenBackgroundColor,
      endDrawer: const CustomDrawerWidget(),
      appBar: CustomAppBarWidget(title: 'product'.tr),
      body: SafeArea(
        child: GetBuilder<ProductController>(builder: (productController){
          return RefreshIndicator(
            color: Theme.of(context).cardColor,
            backgroundColor: Theme.of(context).primaryColor,
            onRefresh: () async {
              searchController.clear();

              if(widget.supplierId != null) {
                productController.getSupplierProductList(1, widget.supplierId);

              }else {
                productController.getProductList(1);
              }

            },

            child: CustomScrollView(
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
                        isFiltered: _isFiltered(productController),
                        isSearchApplied: _checkIsSearchApplied(productController),
                        elementCount: '${productController.productModel?.totalSize ?? 0}',
                        searchText: productController.productModel?.searchText ?? '',
                        onFilterButtonTap: ()=> ResponsiveHelper.isTab(context) ?
                        showAnimatedDialogHelper(context, Dialog(
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(Dimensions.paddingSizeSmall)),
                          child: ProductFilterBottomSheetWidget(
                            fromProductScreen: true,
                            onClearTap: ()=> productController.clearFilter(true),
                            onSubmitTap: (){
                              Get.back();
                              _getProductList(productController);
                            },
                          ),
                        )) :
                        showCustomBottomSheet(
                          child: ProductFilterBottomSheetWidget(
                            fromProductScreen: true,
                            onClearTap: ()=> productController.clearFilter(true),
                            onSubmitTap: (){
                              Get.back();
                              _getProductList(productController);
                            },
                          ),
                          topLeftRadius: Dimensions.paddingSizeLarge,
                          topRightRadius: Dimensions.paddingSizeLarge,
                        ),
                        searchOnChange: (value)=> customDebounceWidget.run(()=> _getProductSuggestionList(productController, value)),
                        onSubmit: (value){
                          Get.back();
                          _getProductList(productController);
                        },
                        suggestionListWidget: GetBuilder<ProductController>(builder: (productController) {
                          return Flexible(child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start,children: [

                            if(productController.productModelSuggestingList?.products?.isNotEmpty ?? false)...[
                              const SizedBox(height: Dimensions.paddingSizeExtraLarge),

                              Text('search_suggestion'.tr, style: ubuntuMedium.copyWith(fontSize: Dimensions.fontSizeSmall)),
                              SizedBox(height: Dimensions.paddingSizeMediumBorder),
                            ],

                            productController.isLoading ?
                            Center(child: CircularProgressIndicator()) :
                            Flexible(child: ListView.builder(
                              padding: EdgeInsets.zero,
                              shrinkWrap: true,
                              itemCount: productController.productModelSuggestingList?.products?.length ?? 0,
                              itemBuilder: (context, index) {
                                return ListTile(
                                  visualDensity: const VisualDensity(vertical: -4),
                                  minVerticalPadding: 0,
                                  contentPadding: EdgeInsets.zero,
                                  leading: Icon(Icons.search, color: Theme.of(context).hintColor.withValues(alpha: 0.5)),
                                  title: Text(productController.productModelSuggestingList?.products?[index].title ?? '', style: ubuntuRegular.copyWith(fontSize: Dimensions.fontSizeSmall)),
                                  trailing: Icon(Icons.arrow_forward_rounded, color: Theme.of(context).hintColor),
                                  onTap: () {
                                    Get.back();
                                    _getProductSuggestionList(productController, productController.productModelSuggestingList?.products?[index].title);
                                    _getProductList(productController);
                                  },
                                );
                              },
                            )),
                          ]));
                        }),
                        onDownloadPress: () {
                          DownloadHelper.downloadPDf(Uri.parse('${AppConstants.baseUrl}${AppConstants.productPdfDownloadUri}'));
                        },
                      );
                    }),
                  ),

                ),

                SliverToBoxAdapter(
                  child: Column(children: [
                    ProductListWidget(
                      scrollController: _scrollController,
                      searchName: searchController.text,
                      supplierId: widget.supplierId,
                    ),

                  ]),
                ),

              ],
            ),
          );
        }),
      ),

      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: Dimensions.paddingSizeLarge, right: Dimensions.paddingSizeSmall),
        child: FloatingActionButton(
          backgroundColor: Theme.of(context).primaryColor,
          shape: CircleBorder(),
          onPressed: () => Get.to(()=> AddProductScreen(supplierId: widget.supplierId)),
          child: Icon(Icons.add, color: Theme.of(context).cardColor),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
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


void _getProductList(ProductController productController){

  productController.getProductList(
      1,minPrice: productController.minPrice, maxPrice: productController.maxPrice,
      stocks: productController.selectedQuantityType.toList(),
      categoryIds: Get.find<CategoryController>().selectedProductCategoryFilter.toList(),
      subCategoryIds: Get.find<CategoryController>().selectedProductSubCategoryFilter.toList(),
      brandsIds: Get.find<BrandController>().selectedProductBrandFilter.toList(),
      supplierId: Get.find<SupplierController>().selectedSupplierId,
      availability: productController.selectedAvailableType,
      query: productController.searchText
  );
}

void _getProductSuggestionList(ProductController productController, String? searchText){

  productController.getProductSuggestionList(
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
