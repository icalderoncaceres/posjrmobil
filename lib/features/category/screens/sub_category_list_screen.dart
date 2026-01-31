import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:six_pos/common/controllers/category_controller.dart';
import 'package:six_pos/common/controllers/filter_controller.dart';
import 'package:six_pos/common/widgets/common_filter_bottom_sheet_widget.dart';
import 'package:six_pos/common/widgets/custom_debounce_widget.dart';
import 'package:six_pos/common/widgets/custom_screen_bar_widget.dart';
import 'package:six_pos/common/widgets/custom_sliver_header_delegate_widget.dart';
import 'package:six_pos/common/widgets/show_custom_bottom_sheet.dart';
import 'package:six_pos/features/category/domain/models/category_model.dart';
import 'package:six_pos/helper/animated_custom_dialog_helper.dart';
import 'package:six_pos/helper/download_helper.dart';
import 'package:six_pos/helper/extension_helper.dart';
import 'package:six_pos/helper/responsive_helper.dart';
import 'package:six_pos/util/app_constants.dart';
import 'package:six_pos/util/dimensions.dart';
import 'package:six_pos/util/styles.dart';
import 'package:six_pos/common/widgets/custom_app_bar_widget.dart';
import 'package:six_pos/common/widgets/custom_drawer_widget.dart';
import 'package:six_pos/features/category/screens/add_new_sub_category_screen.dart';
import 'package:six_pos/features/category/widgets/sub_category_list_widget.dart';
class SubCategoryListScreen extends StatefulWidget {
  const SubCategoryListScreen({Key? key}) : super(key: key);

  @override
  State<SubCategoryListScreen> createState() => _SubCategoryListScreenState();
}

class _SubCategoryListScreenState extends State<SubCategoryListScreen> {
  final ScrollController _scrollController = ScrollController();
  final CustomDebounceWidget customDebounceWidget = CustomDebounceWidget(milliseconds: 500);

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.customThemeColors.screenBackgroundColor,
      appBar: CustomAppBarWidget(title: 'sub_category'.tr),
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
                  height: 192,
                  child: Column(children: [
                    GetBuilder<CategoryController>(builder: (categoryController){
                      return CustomScreenBarWidget(
                        title: 'sub_category_list'.tr,
                        elementCount: '${categoryController.subCategoryModel?.totalSize ?? 0}',
                        isFiltered: _checkIsFiltered(categoryController),
                        isSearchApplied: _checkIsSearchApplied(categoryController),
                        searchText: categoryController.subCategoryModel?.searchText ?? '',
                        onFilterButtonTap: ()=> ResponsiveHelper.isTab(context) ?
                        showAnimatedDialogHelper(context, Dialog(
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(Dimensions.paddingSizeSmall)),
                          child: GetBuilder<FilterController>(builder: (filterController){
                            return CommonFilterBottomSheetWidget(
                              canFilter: _canFilter(categoryController),
                              onSubmitTap: (){
                                Get.back();
                                _getSubCategoryList(categoryController);
                              },
                              onClearTap: ()=> categoryController.clearSubCategoryFilter(),
                            );
                          }),
                        )) :
                        showCustomBottomSheet(
                          child: GetBuilder<FilterController>(builder: (filterController){
                            return CommonFilterBottomSheetWidget(
                              canFilter: _canFilter(categoryController),
                              onSubmitTap: (){
                                Get.back();
                                _getSubCategoryList(categoryController);
                              },
                              onClearTap: ()=> categoryController.clearSubCategoryFilter(),
                            );
                          }),
                          topLeftRadius: Dimensions.paddingSizeLarge,
                          topRightRadius: Dimensions.paddingSizeLarge,
                        ),
                        searchOnChange: (value)=> customDebounceWidget.run(()=> _getSuggestionList(categoryController, value)),
                        onSubmit: (value){
                          Get.back();
                          _getSubCategoryList(categoryController);
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
                                  itemCount: categoryController.subCategorySuggestionList?.subCategoriesList?.length ?? 0,
                                  itemBuilder: (context, index) {
                                    return ListTile(
                                      visualDensity: const VisualDensity(vertical: -4),
                                      minVerticalPadding: 0,
                                      contentPadding: EdgeInsets.zero,
                                      leading: Icon(Icons.search, color: Theme.of(context).hintColor.withValues(alpha: 0.5)),
                                      title: Text(categoryController.subCategorySuggestionList?.subCategoriesList?[index].name ?? '', style: ubuntuRegular.copyWith(fontSize: Dimensions.fontSizeSmall)),
                                      trailing: Icon(Icons.arrow_forward_rounded, color: Theme.of(context).hintColor),
                                      onTap: () {
                                        Get.back();
                                        _getSuggestionList(categoryController, categoryController.subCategorySuggestionList?.subCategoriesList?[index].name);
                                        _getSubCategoryList(categoryController);
                                      },
                                    );
                                  },
                                )),
                              ]));
                            }
                        ),
                        onDownloadPress: () {
                          DownloadHelper.downloadPDf(Uri.parse('${AppConstants.baseUrl}${AppConstants.subCategoryPdfDownloadUri}'));
                        },
                      );
                    }),

                    GetBuilder<CategoryController>(builder: (categoryController) {
                      return Container(
                        color: Theme.of(context).cardColor,
                        padding: EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeLarge, vertical: Dimensions.paddingSizeDefault),
                        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

                          Text('select_category_name'.tr, style: ubuntuRegular.copyWith(fontSize: Dimensions.fontSizeSmall)),
                          const SizedBox(height: Dimensions.paddingSizeSmall),

                          Container(
                            padding: const EdgeInsets.symmetric(horizontal:Dimensions.paddingSizeSmall),
                            decoration: BoxDecoration(
                              color: Theme.of(context).cardColor,
                              border: Border.all(width: 1, color: Theme.of(context).hintColor.withValues(alpha: 0.2)),
                              borderRadius: BorderRadius.circular(Dimensions.paddingSizeMediumBorder),
                            ),
                            child: DropdownButton<int>(
                              hint: Text('select'.tr),
                              value: categoryController.selectedCategoryId,
                              items: categoryController.categoryModel?.categoriesList?.map((Categories? value) {
                                return DropdownMenuItem<int>(
                                    value: value?.id,
                                    child: Text(value?.name ?? '', style: ubuntuRegular.copyWith(fontSize: Dimensions.fontSizeSmall)));
                              }).toList(),
                              onChanged: (int? value) {
                                categoryController.setCategoryIndex(value!, true);
                              },
                              isExpanded: true,
                              underline: const SizedBox(),
                              iconEnabledColor: Theme.of(context).hintColor,
                            ),
                          ),
                          const SizedBox(height: Dimensions.paddingSizeSmall),
                        ]),
                      );
                    }),
                    const SizedBox(height: Dimensions.paddingSizeDefault),

                  ]),
                ),
              ),

              SliverToBoxAdapter(
                child: SubCategoryListWidget(scrollController: _scrollController),
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
          onPressed: () => Get.to(()=> const AddNewSubCategoryScreen()),
          child: Icon(Icons.add, color: Theme.of(context).cardColor),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}

bool _checkIsFiltered(CategoryController categoryController){
  if(categoryController.subCategoryModel?.startDate != null || categoryController.subCategoryModel?.endDate != null || categoryController.subCategoryModel?.sortingType != null){
    return true;
  }else{
    return false;
  }
}

bool _canFilter(CategoryController categoryController){
  FilterController filterController = Get.find<FilterController>();

  if((filterController.startDate == null || filterController.startDate.toString() != categoryController.subCategoryModel?.startDate)){
    return true;
  }else if((filterController.endDate == null || filterController.endDate.toString() != categoryController.subCategoryModel?.endDate)){
    return true;
  }else if((filterController.selectedSortingType == null || filterController.selectedSortingType != categoryController.subCategoryModel?.sortingType)){
    return true;
  }else {
    return false;
  }
}

void _getSubCategoryList(CategoryController categoryController){
  FilterController filterController = Get.find<FilterController>();

  categoryController.getSubCategoryList(
      1, categoryController.selectedCategoryId,
      startDate: filterController.startDate.toString(),
      endDate: filterController.endDate.toString(),
      sortingType: filterController.selectedSortingType,
      searchText: categoryController.subCategorySearchText
  );
}

void _getSuggestionList(CategoryController categoryController, String? searchText){
  FilterController filterController = Get.find<FilterController>();

  categoryController.getSubSuggestionList(
      startDate: filterController.startDate.toString(),
      endDate: filterController.endDate.toString(),
      sortingType: filterController.selectedSortingType,
      query: searchText
  );
}

bool _checkIsSearchApplied(CategoryController categoryController){

  if(categoryController.subCategoryModel?.searchText != null){
    return true;
  }else{
    return false;
  }
}