import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:six_pos/common/controllers/category_controller.dart';
import 'package:six_pos/common/controllers/filter_controller.dart';
import 'package:six_pos/common/widgets/common_filter_bottom_sheet_widget.dart';
import 'package:six_pos/common/widgets/custom_debounce_widget.dart';
import 'package:six_pos/common/widgets/custom_screen_bar_widget.dart';
import 'package:six_pos/common/widgets/custom_sliver_header_delegate_widget.dart';
import 'package:six_pos/common/widgets/show_custom_bottom_sheet.dart';
import 'package:six_pos/features/brand/controllers/brand_controller.dart';
import 'package:six_pos/helper/animated_custom_dialog_helper.dart';
import 'package:six_pos/helper/download_helper.dart';
import 'package:six_pos/helper/extension_helper.dart';
import 'package:six_pos/helper/responsive_helper.dart';
import 'package:six_pos/util/app_constants.dart';
import 'package:six_pos/util/dimensions.dart';
import 'package:six_pos/common/widgets/custom_app_bar_widget.dart';
import 'package:six_pos/common/widgets/custom_drawer_widget.dart';
import 'package:six_pos/features/brand/screens/add_new_brand_screen.dart';
import 'package:six_pos/features/brand/widgets/brand_list_widget.dart';
import 'package:six_pos/util/styles.dart';


class BrandListScreen extends StatefulWidget {
  const BrandListScreen({Key? key}) : super(key: key);

  @override
  State<BrandListScreen> createState() => _BrandListScreenState();
}

class _BrandListScreenState extends State<BrandListScreen> {

  final ScrollController _scrollController = ScrollController();
  final CustomDebounceWidget customDebounceWidget = CustomDebounceWidget(milliseconds: 500);

  @override
  void initState() {
    super.initState();
    Get.find<BrandController>().getBrandList(1, isUpdate: false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.customThemeColors.screenBackgroundColor,
      appBar: CustomAppBarWidget(title: 'brand'.tr),
      endDrawer: const CustomDrawerWidget(),
      body: SafeArea(
        child: RefreshIndicator(
          color: Theme.of(context).cardColor,
          backgroundColor: Theme.of(context).primaryColor,
          onRefresh: () async {
            Get.find<BrandController>().getBrandList(
                1, startDate: Get.find<FilterController>().startDate.toString(),
                endDate: Get.find<FilterController>().endDate.toString(),
                sortingType: Get.find<FilterController>().selectedSortingType
            );
          },
          child: CustomScrollView(
            physics: AlwaysScrollableScrollPhysics(),
            controller: _scrollController,
            slivers: [

              SliverPersistentHeader(
                floating: true,
                pinned: false,
                delegate: CustomSliverHeaderDelegateWidget(
                  height: Dimensions.productImageSizeItem,
                  child: GetBuilder<BrandController>(builder: (brandController){
                    return CustomScreenBarWidget(
                      title: 'brand_list'.tr,
                      isFiltered: _checkIsFiltered(),
                      isSearchApplied: _checkIsSearchApplied(brandController),
                      searchText: brandController.brandModel?.searchText ?? '',
                      elementCount: '${brandController.brandModel?.totalSize ?? 0}',
                      onFilterButtonTap: ()=> ResponsiveHelper.isTab(context) ?
                      showAnimatedDialogHelper(context, Dialog(
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(Dimensions.paddingSizeSmall)),
                        child: GetBuilder<FilterController>(builder: (filterController){
                          return CommonFilterBottomSheetWidget(
                            canFilter: _canFilter(),
                            onSubmitTap: (){
                              Get.back();
                              _getBrandList(brandController);
                            },
                            onClearTap: ()=> brandController.clearFilter(),
                          );
                        }),
                      )) :
                      showCustomBottomSheet(
                        child: GetBuilder<FilterController>(builder: (filterController){
                          return CommonFilterBottomSheetWidget(
                            canFilter: _canFilter(),
                            onSubmitTap: (){
                              Get.back();
                              _getBrandList(brandController);
                            },
                            onClearTap: ()=> brandController.clearFilter(),
                          );
                        }),
                        topLeftRadius: Dimensions.paddingSizeLarge,
                        topRightRadius: Dimensions.paddingSizeLarge,
                      ),
                      searchOnChange: (value)=> customDebounceWidget.run(()=> _getSuggestionList(brandController, value)),
                      suggestionListWidget: GetBuilder<BrandController>(
                          builder: (brandController) {
                            return Flexible(child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start,children: [

                              if(brandController.brandSuggestionList?.brandList?.isNotEmpty ?? false)...[
                                const SizedBox(height: Dimensions.paddingSizeExtraLarge),

                                Text('search_suggestion'.tr, style: ubuntuMedium.copyWith(fontSize: Dimensions.fontSizeSmall)),
                                SizedBox(height: Dimensions.paddingSizeMediumBorder),
                              ],

                              brandController.isLoading ?
                              Center(child: CircularProgressIndicator()) :
                              Flexible(child: ListView.builder(
                                padding: EdgeInsets.zero,
                                shrinkWrap: true,
                                itemCount: brandController.brandSuggestionList?.brandList?.length ?? 0,
                                itemBuilder: (context, index) {
                                  return ListTile(
                                    visualDensity: const VisualDensity(vertical: -4),
                                    minVerticalPadding: 0,
                                    contentPadding: EdgeInsets.zero,
                                    leading: Icon(Icons.search, color: Theme.of(context).hintColor.withValues(alpha: 0.5)),
                                    title: Text(brandController.brandSuggestionList?.brandList?[index].name ?? '', style: ubuntuRegular.copyWith(fontSize: Dimensions.fontSizeSmall)),
                                    trailing: Icon(Icons.arrow_forward_rounded, color: Theme.of(context).hintColor),
                                    onTap: () {
                                      Get.back();
                                      _getSuggestionList(brandController, brandController.brandSuggestionList?.brandList?[index].name);
                                      _getBrandList(brandController);
                                    },
                                  );
                                },
                              )),
                            ]));
                          }
                      ),
                      onSubmit: (value){
                        Get.back();
                        _getBrandList(brandController);
                      },
                      onDownloadPress: () {
                        DownloadHelper.downloadPDf(Uri.parse('${AppConstants.baseUrl}${AppConstants.brandPdfDownloadUri}'));
                      },
                    );
                  }),
                ),

              ),

              SliverToBoxAdapter(
                child: Column(
                  children: [
                    BrandListWidget(scrollController: _scrollController,),
                    const SizedBox(height: 100),
                  ],
                ),
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
          onPressed: () => Get.to(const AddNewBrandScreen()),
          child: Icon(Icons.add, color: Theme.of(context).cardColor),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}

bool _checkIsFiltered(){
  BrandController brandController = Get.find<BrandController>();

  if(brandController.brandModel?.startDate != null || brandController.brandModel?.endDate != null || brandController.brandModel?.sortingType != null){
    return true;
  }else{
    return false;
  }
}

bool _canFilter(){

  FilterController filterController = Get.find<FilterController>();
  BrandController brandController = Get.find<BrandController>();

  if((filterController.startDate == null || filterController.startDate.toString() != brandController.brandModel?.startDate)){
    return true;
  }else if((filterController.endDate == null || filterController.endDate.toString() != brandController.brandModel?.endDate)){
    return true;
  }else if((filterController.selectedSortingType == null || filterController.selectedSortingType != brandController.brandModel?.sortingType)){
    return true;
  }else {
    return false;
  }
}

void _getSuggestionList(BrandController brandController, String? searchText){
  FilterController filterController = Get.find<FilterController>();

  brandController.getSuggestionList(
      startDate: filterController.startDate.toString(),
      endDate: filterController.endDate.toString(),
      sortingType: filterController.selectedSortingType,
      query: searchText
  );
}

void _getBrandList(BrandController brandController){
  FilterController filterController = Get.find<FilterController>();

  brandController.getBrandList(
      1, startDate: filterController.startDate.toString(),
      endDate: filterController.endDate.toString(),
      sortingType: filterController.selectedSortingType,
      searchText: brandController.searchText
  );
}

bool _checkIsSearchApplied(BrandController brandController){

  if(brandController.brandModel?.searchText != null){
    return true;
  }else{
    return false;
  }
}