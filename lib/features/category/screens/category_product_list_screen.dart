import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';
import 'package:six_pos/common/controllers/category_controller.dart';
import 'package:six_pos/common/widgets/custom_loader_widget.dart';
import 'package:six_pos/common/widgets/custom_shimmer_widget.dart';
import 'package:six_pos/common/widgets/paginated_list_widget.dart';
import 'package:six_pos/features/category/domain/models/category_model.dart';
import 'package:six_pos/features/product/domain/models/categories_product_model.dart';
import 'package:six_pos/helper/extension_helper.dart';
import 'package:six_pos/helper/responsive_helper.dart';
import 'package:six_pos/util/dimensions.dart';
import 'package:six_pos/util/images.dart';
import 'package:six_pos/util/styles.dart';
import 'package:six_pos/common/widgets/custom_header_widget.dart';
import 'package:six_pos/common/widgets/custom_search_field_widget.dart';
import 'package:six_pos/common/widgets/no_data_widget.dart';
import 'package:six_pos/features/product/widgets/category_item_widget.dart';
import 'package:six_pos/features/product/widgets/item_card_widget.dart';
import 'package:six_pos/features/category/widgets/product_search_dialog_widget.dart';
import 'package:skeletonizer/skeletonizer.dart';


class CategoryProductListScreen extends StatefulWidget {
  const CategoryProductListScreen({super.key});


  @override
  State<CategoryProductListScreen> createState() => _CategoryProductListScreenState();
}


class _CategoryProductListScreenState extends State<CategoryProductListScreen> {
  TextEditingController searchController = TextEditingController();
  ScrollController scrollController = ScrollController();


  @override
  void initState() {
    super.initState();
    final CategoryController categoryController = Get.find<CategoryController>();

    categoryController.getPosCategoryList(1);
    categoryController.getSearchProductList('');
    categoryController.changeSelectedIndex(0);
  }




  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        Get.find<CategoryController>().getSearchProductList('', isReset: true);
        searchController.clear();
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Column(children: [
          CustomHeaderWidget(title: 'products'.tr, headerImage: Images.product),

          GetBuilder<CategoryController>(
              builder: (searchProductController) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal : Dimensions.paddingSizeDefault, vertical: Dimensions.paddingSizeDefault),
                  child: CustomSearchFieldWidget(
                    controller: searchController,
                    hint: 'search_product_by_name_or_barcode'.tr,
                    prefix: Icons.search,
                    iconPressed: () => (){},
                    onSubmit: (text) => (){},
                    onChanged: (value){
                      searchProductController.getSearchProductList(value);
                    },
                    isFilter: false,
                  ),
                );
              }
          ),


          Expanded(
            child: Stack(children: [
              GetBuilder<CategoryController>(builder: (categoryController) {
                return categoryController.posCategoryModel?.categoriesList != null ?
                (categoryController.posCategoryModel?.categoriesList?.isNotEmpty ?? false) ?
                Row(children: [
                  Container(
                    width: 100,
                    height: double.infinity,
                    decoration: BoxDecoration(
                        color: context.customThemeColors.categoryWithProductColor,
                        borderRadius: const BorderRadius.only(topRight: Radius.circular(Dimensions.paddingSizeLarge))
                    ),
                    child: PaginatedListWidget(
                      scrollController: scrollController,
                      onPaginate: (int? offset) async => await categoryController.getPosCategoryList(offset ?? 1),
                      offset: categoryController.posCategoryModel?.offset,
                      totalSize: categoryController.posCategoryModel?.totalSize,
                      itemView: Expanded(
                        child: ListView.builder(
                          controller: scrollController,
                          physics: const BouncingScrollPhysics(),
                          itemCount: categoryController.posCategoryModel?.categoriesList?.length,
                          padding: const EdgeInsets.all(0),
                          itemBuilder: (context, index) {
                            Categories? category = categoryController.posCategoryModel?.categoriesList?[index];
                            return category?.status == 1 ? InkWell(
                              onTap: () {
                                Get.find<CategoryController>().changeSelectedIndex(index);
                                Get.find<CategoryController>().getCategoryWiseProductList(category?.id);
                              },
                              child: CategoryItemWidget(
                                title: category?.name,
                                icon: category?.image,
                                isSelected: categoryController.categorySelectedIndex == index,
                                index: index,
                              ),
                            ) : const SizedBox();


                          },
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: Dimensions.paddingSizeMediumBorder),


                  Expanded(child: categoryController.categoriesProductList == null ?
                  Skeletonizer(child: GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: ResponsiveHelper.isTab(context) ? 4 : 3,
                      mainAxisSpacing: 5,
                      crossAxisSpacing: 5,
                      childAspectRatio: ResponsiveHelper.isTab(context) ? 0.9 : 0.5,
                    ),
                    padding: EdgeInsets.zero,
                    itemCount: categoryController.categoriesProductList?.length,
                    itemBuilder: (context, index) {
                      return ItemCardWidget(categoriesProduct: CategoriesProduct(image: 'fake_image_url', sellingPrice: 420, title: 'fake_name'), index: index);
                    },
                  )) :
                  (categoryController.categoriesProductList?.isNotEmpty ?? false) ?
                  Column(children: [

                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall),
                      child: Row(crossAxisAlignment: CrossAxisAlignment.center, mainAxisAlignment: MainAxisAlignment.center,
                        children: [

                          if(categoryController.categorySelectedIndex == 0)
                          Text('all_products'.tr, style: ubuntuMedium.copyWith(fontSize: Dimensions.fontSizeLarge))
                          else...[
                            Text('all_product_from'.tr, style: ubuntuMedium.copyWith(fontSize: Dimensions.fontSizeLarge)),

                            Expanded(
                              child: Text(' ${categoryController.posCategoryModel?.categoriesList?[categoryController.categorySelectedIndex!].name}',
                                textAlign: TextAlign.start,
                                maxLines:1,
                                style: ubuntuMedium.copyWith(color: Theme.of(context).secondaryHeaderColor, fontSize: Dimensions.fontSizeLarge),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),

                    Expanded(child: Padding(
                      padding: const EdgeInsets.only(top: Dimensions.paddingSizeExtraSmall, bottom: Dimensions.paddingSizeSmall),
                      child: GridView.builder(
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: ResponsiveHelper.isTab(context) ? 4 : 3,
                          mainAxisSpacing: 5,
                          crossAxisSpacing: 5,
                          childAspectRatio: ResponsiveHelper.isTab(context) ? 0.9 : 0.48,
                        ),
                        padding: EdgeInsets.zero,
                        itemCount: categoryController.categoriesProductList?.length,
                        itemBuilder: (context, index) {
                          return ItemCardWidget(categoriesProduct: categoryController.categoriesProductList![index], index: index);
                        },
                      ),
                    )),
                  ]) : const NoDataWidget()),

                ]) :
                const NoDataWidget() :
                CustomLoaderWidget();
              }),


              ProductSearchDialogWidget(searchTextController: searchController),
            ]),
          ),
        ]),
      ),
    );
  }
}














