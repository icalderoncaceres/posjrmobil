import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:six_pos/common/controllers/category_controller.dart';
import 'package:six_pos/common/controllers/filter_controller.dart';
import 'package:six_pos/common/widgets/common_filter_bottom_sheet_widget.dart';
import 'package:six_pos/common/widgets/custom_debounce_widget.dart';
import 'package:six_pos/common/widgets/custom_screen_bar_widget.dart';
import 'package:six_pos/common/widgets/custom_sliver_header_delegate_widget.dart';
import 'package:six_pos/common/widgets/show_custom_bottom_sheet.dart';
import 'package:six_pos/helper/animated_custom_dialog_helper.dart';
import 'package:six_pos/helper/download_helper.dart';
import 'package:six_pos/helper/extension_helper.dart';
import 'package:six_pos/helper/responsive_helper.dart';
import 'package:six_pos/util/app_constants.dart';
import 'package:six_pos/util/dimensions.dart';
import 'package:six_pos/common/widgets/custom_app_bar_widget.dart';
import 'package:six_pos/common/widgets/custom_drawer_widget.dart';
import 'package:six_pos/features/category/screens/add_new_category_screen.dart';
import 'package:six_pos/features/category/widgets/category_list_widget.dart';
import 'package:six_pos/util/styles.dart';


class CategoryListScreen extends StatefulWidget {
  const CategoryListScreen({Key? key}) : super(key: key);

  @override
  State<CategoryListScreen> createState() => _CategoryListScreenState();
}

class _CategoryListScreenState extends State<CategoryListScreen> {
  final ScrollController _scrollController = ScrollController();
  final CustomDebounceWidget customDebounceWidget = CustomDebounceWidget(milliseconds: 500);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.customThemeColors.screenBackgroundColor,
      appBar: CustomAppBarWidget(title: 'category'.tr),
      endDrawer: const CustomDrawerWidget(),
      body: SafeArea(
        child: RefreshIndicator(
          color: Theme.of(context).cardColor,
          backgroundColor: Theme.of(context).primaryColor,
          onRefresh: () async {
          },
          child: CustomScrollView(
            controller: _scrollController,
            slivers: [

              SliverPersistentHeader(
                floating: true,
                pinned: false,
                delegate: CustomSliverHeaderDelegateWidget(
                  height: Dimensions.productImageSizeItem,
                  child: GetBuilder<CategoryController>(builder: (categoryController) {
                    return CustomScreenBarWidget(
                      title: 'category_list'.tr,
                      isFiltered: _checkIsFiltered(categoryController),
                      isSearchApplied: _checkIsSearchApplied(categoryController),
                      searchText: categoryController.categoryModel?.searchText ?? '',
                      elementCount: '${categoryController.categoryModel?.totalSize ?? 0}',
                      onFilterButtonTap: ()=> ResponsiveHelper.isTab(context) ?
                      showAnimatedDialogHelper(context, Dialog(
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(Dimensions.paddingSizeSmall)),
                        child: GetBuilder<FilterController>(builder: (filterController){
                          return CommonFilterBottomSheetWidget(
                            canFilter: _canFilter(categoryController),
                            onSubmitTap: (){
                              Get.back();
                              _getCategoryList(categoryController);
                            },
                            onClearTap: ()=> categoryController.clearCategoryFilter(),
                          );
                        }),
                      )) :
                      showCustomBottomSheet(
                        child: GetBuilder<FilterController>(builder: (filterController){
                          return CommonFilterBottomSheetWidget(
                            canFilter: _canFilter(categoryController),
                            onSubmitTap: (){
                              Get.back();
                              _getCategoryList(categoryController);
                            },
                            onClearTap: ()=> categoryController.clearCategoryFilter(),
                          );
                        }),
                        topLeftRadius: Dimensions.paddingSizeLarge,
                        topRightRadius: Dimensions.paddingSizeLarge,
                      ),
                      searchOnChange: (value)=> customDebounceWidget.run(()=> _getSuggestionList(categoryController, value)),
                      onSubmit: (value){
                        Get.back();
                        _getCategoryList(categoryController);
                      },
                      suggestionListWidget: GetBuilder<CategoryController>(
                          builder: (categoryController) {
                            return Flexible(child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start,children: [

                              if(categoryController.categorySuggestionList?.categoriesList?.isNotEmpty ?? false)...[
                                const SizedBox(height: Dimensions.paddingSizeExtraLarge),

                                Text('search_suggestion'.tr, style: ubuntuMedium.copyWith(fontSize: Dimensions.fontSizeSmall)),
                                SizedBox(height: Dimensions.paddingSizeMediumBorder),
                              ],

                              categoryController.isLoading ?
                              Center(child: CircularProgressIndicator()) :
                              Flexible(child: ListView.builder(
                                padding: EdgeInsets.zero,
                                shrinkWrap: true,
                                itemCount: categoryController.categorySuggestionList?.categoriesList?.length ?? 0,
                                itemBuilder: (context, index) {
                                  return ListTile(
                                    visualDensity: const VisualDensity(vertical: -4),
                                    minVerticalPadding: 0,
                                    contentPadding: EdgeInsets.zero,
                                    leading: Icon(Icons.search, color: Theme.of(context).hintColor.withValues(alpha: 0.5)),
                                    title: Text(categoryController.categorySuggestionList?.categoriesList?[index].name ?? '', style: ubuntuRegular.copyWith(fontSize: Dimensions.fontSizeSmall)),
                                    trailing: Icon(Icons.arrow_forward_rounded, color: Theme.of(context).hintColor),
                                    onTap: () {
                                      Get.back();
                                      _getSuggestionList(categoryController, categoryController.categorySuggestionList?.categoriesList?[index].name);
                                      _getCategoryList(categoryController);
                                    },
                                  );
                                },
                              )),
                            ]));
                          }
                      ),
                      onDownloadPress: () {
                        DownloadHelper.downloadPDf(Uri.parse('${AppConstants.baseUrl}${AppConstants.categoryPdfDownloadUri}'));
                      },
                    );
                  }),
                ),

              ),

              SliverToBoxAdapter(
                child: Column(children: [
                  CategoryListWidget(scrollController: _scrollController),
                  const SizedBox(height: Dimensions.paddingSizeExtraExtraLarge)
                ]),
              ),
            ],
          ),
        ),
      ),

      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: Dimensions.paddingSizeLarge, right: Dimensions.paddingSizeSmall),
        child: FloatingActionButton(
          backgroundColor: Theme.of(context).primaryColor,
          shape: CircleBorder(),
          onPressed: () => Get.to(const AddNewCategoryScreen()),
          child: Icon(Icons.add, color: Theme.of(context).cardColor),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}

bool _checkIsFiltered(CategoryController categoryController){

  if(categoryController.categoryModel?.startDate != null || categoryController.categoryModel?.endDate != null || categoryController.categoryModel?.sortingType != null){
    return true;
  }else{
    return false;
  }
}

bool _checkIsSearchApplied(CategoryController categoryController){

  if(categoryController.categoryModel?.searchText != null){
    return true;
  }else{
    return false;
  }
}

bool _canFilter(CategoryController categoryController){
  FilterController filterController = Get.find<FilterController>();

  if((filterController.startDate == null || filterController.startDate.toString() != categoryController.categoryModel?.startDate)){
    return true;
  }else if((filterController.endDate == null || filterController.endDate.toString() != categoryController.categoryModel?.endDate)){
    return true;
  }else if((filterController.selectedSortingType == null || filterController.selectedSortingType != categoryController.categoryModel?.sortingType)){
    return true;
  }else {
    return false;
  }
}

void _getCategoryList(CategoryController categoryController){
  FilterController filterController = Get.find<FilterController>();

  categoryController.getCategoryList(
      1,
      startDate: filterController.startDate.toString(),
      endDate: filterController.endDate.toString(),
      sortingType: filterController.selectedSortingType,
      searchText: categoryController.categorySearchText
  );
}

void _getSuggestionList(CategoryController categoryController, String? searchText){
  FilterController filterController = Get.find<FilterController>();

  categoryController.getSuggestionList(
      startDate: filterController.startDate.toString(),
      endDate: filterController.endDate.toString(),
      sortingType: filterController.selectedSortingType,
      query: searchText
  );
}
