import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:six_pos/common/controllers/filter_controller.dart';
import 'package:six_pos/common/widgets/common_filter_bottom_sheet_widget.dart';
import 'package:six_pos/common/widgets/custom_screen_bar_widget.dart';
import 'package:six_pos/common/widgets/custom_sliver_header_delegate_widget.dart';
import 'package:six_pos/common/widgets/show_custom_bottom_sheet.dart';
import 'package:six_pos/features/product/widgets/product_filter_bottom_sheet_widget.dart';
import 'package:six_pos/features/unit/controllers/unit_controller.dart';
import 'package:six_pos/helper/animated_custom_dialog_helper.dart';
import 'package:six_pos/helper/download_helper.dart';
import 'package:six_pos/helper/extension_helper.dart';
import 'package:six_pos/helper/responsive_helper.dart';
import 'package:six_pos/util/app_constants.dart';
import 'package:six_pos/util/dimensions.dart';
import 'package:six_pos/common/widgets/custom_app_bar_widget.dart';
import 'package:six_pos/common/widgets/custom_drawer_widget.dart';
import 'package:six_pos/features/unit/screens/add_new_unit_screen.dart';
import 'package:six_pos/features/unit/widgets/unit_list_view.dart';
class UnitListViewScreen extends StatefulWidget {
  const UnitListViewScreen({Key? key}) : super(key: key);

  @override
  State<UnitListViewScreen> createState() => _UnitListViewScreenState();
}

class _UnitListViewScreenState extends State<UnitListViewScreen> {

  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    Get.find<UnitController>().getUnitList(1);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.customThemeColors.screenBackgroundColor,
      appBar: CustomAppBarWidget(title: 'unit'.tr),
      endDrawer: const CustomDrawerWidget(),
      body: SafeArea(
        child: RefreshIndicator(
          color: Theme.of(context).cardColor,
          backgroundColor: Theme.of(context).primaryColor,
          onRefresh: () async {

          },
          child: GetBuilder<UnitController>(builder: (unitController){
            return CustomScrollView(
              controller: _scrollController,
              slivers: [

                SliverPersistentHeader(
                  floating: true,
                  pinned: false,
                  delegate: CustomSliverHeaderDelegateWidget(
                    height: Dimensions.productImageSizeItem,
                    child: GetBuilder<UnitController>(builder: (unitController){
                      return CustomScreenBarWidget(
                        title: 'unit_list'.tr,
                        isFiltered: _checkIsFiltered(unitController),
                        elementCount: '${unitController.unitListLength ?? 0}',
                        onFilterButtonTap: ()=> ResponsiveHelper.isTab(context) ?
                        showAnimatedDialogHelper(context, Dialog(
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(Dimensions.paddingSizeSmall)),
                          child: GetBuilder<FilterController>(builder: (filterController){
                            return CommonFilterBottomSheetWidget(
                              canFilter: _canFilter(unitController),
                              onSubmitTap: (){
                                Get.back();
                                _getCategoryList(unitController);
                              },
                              onClearTap: ()=> unitController.clearUnitFilter(),
                            );
                          }),
                        )) :
                        showCustomBottomSheet(
                          child: GetBuilder<FilterController>(builder: (filterController){
                            return CommonFilterBottomSheetWidget(
                              canFilter: _canFilter(unitController),
                              onSubmitTap: (){
                                Get.back();
                                _getCategoryList(unitController);
                              },
                              onClearTap: ()=> unitController.clearUnitFilter(),
                            );
                          }),
                          topLeftRadius: Dimensions.paddingSizeLarge,
                          topRightRadius: Dimensions.paddingSizeLarge,
                        ),
                        onDownloadPress: () {
                          DownloadHelper.downloadPDf(Uri.parse('${AppConstants.baseUrl}${AppConstants.unitPdfDownloadUri}'));
                        },
                      );
                    }),
                  ),

                ),

                SliverToBoxAdapter(
                  child: Column(children: [
                    UnitListWidget(scrollController: _scrollController,),
                    const SizedBox(height: 100),
                  ]),
                ),
              ],
            );
          }),
        ),
      ),

      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: Dimensions.paddingSizeLarge, right: Dimensions.paddingSizeSmall),
        child: FloatingActionButton(
          backgroundColor: Theme.of(context).primaryColor,
          shape: CircleBorder(),
          onPressed: () => Get.to(const AddNewUnitScreen()),
          child: Icon(Icons.add, color: Theme.of(context).cardColor),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}

bool _checkIsFiltered(UnitController unitController){

  if(unitController.startDate != null || unitController.endDate != null || unitController.sortingType != null){
    return true;
  }else{
    return false;
  }
}

bool _canFilter(UnitController unitController){
  FilterController filterController = Get.find<FilterController>();

  if((filterController.startDate == null || filterController.startDate.toString() != unitController.startDate)){
    return true;
  }else if((filterController.endDate == null || filterController.endDate.toString() != unitController.endDate)){
    return true;
  }else if((filterController.selectedSortingType == null || filterController.selectedSortingType != unitController.sortingType)){
    return true;
  }else {
    return false;
  }
}

void _getCategoryList(UnitController unitController){
  FilterController filterController = Get.find<FilterController>();

  unitController.getUnitList(
      1,
      startDate: filterController.startDate.toString(),
      endDate: filterController.endDate.toString(),
      sortingType: filterController.selectedSortingType
  );
}