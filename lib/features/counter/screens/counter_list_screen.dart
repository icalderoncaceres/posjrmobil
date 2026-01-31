import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:six_pos/common/widgets/custom_app_bar_widget.dart';
import 'package:six_pos/common/widgets/custom_asset_image_widget.dart';
import 'package:six_pos/common/widgets/custom_debounce_widget.dart';
import 'package:six_pos/common/widgets/custom_drawer_widget.dart';
import 'package:six_pos/common/widgets/custom_header_widget.dart';
import 'package:six_pos/common/widgets/custom_loader_widget.dart';
import 'package:six_pos/common/widgets/custom_search_field_widget.dart';
import 'package:six_pos/common/widgets/no_data_widget.dart';
import 'package:six_pos/features/counter/controllers/counter_controller.dart';
import 'package:six_pos/features/counter/screens/counter_setup_screen.dart';
import 'package:six_pos/features/counter/widgets/counter_item_widget.dart';
import 'package:six_pos/helper/extension_helper.dart';
import 'package:six_pos/helper/responsive_helper.dart';
import 'package:six_pos/util/dimensions.dart';
import 'package:six_pos/util/images.dart';
import 'package:six_pos/util/styles.dart';

class CounterListScreen extends StatefulWidget {
  const CounterListScreen({super.key});

  @override
  State<CounterListScreen> createState() => _CounterListScreenState();
}

class _CounterListScreenState extends State<CounterListScreen> {

  final ScrollController _scrollController = ScrollController();
  TextEditingController searchController = TextEditingController();
  final CustomDebounceWidget customDebounceWidget = CustomDebounceWidget(milliseconds: 500);


  @override
  void initState() {
    super.initState();
    final CounterController counterController = Get.find<CounterController>();
    counterController.getCounterList(isUpdate: false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white.withValues(alpha: 0.97),
      appBar: const CustomAppBarWidget(),
      endDrawer: const CustomDrawerWidget(),
      body: SafeArea(
        child: RefreshIndicator(
          color: Theme.of(context).cardColor,
          backgroundColor: Theme.of(context).primaryColor,
          onRefresh: () async {
            final CounterController counterController = Get.find<CounterController>();
            counterController.getCounterList(isUpdate: true);
          },
          child: Column(mainAxisSize : MainAxisSize.min, mainAxisAlignment: MainAxisAlignment.start, children: [

            CustomHeaderWidget(title: 'counter_list'.tr),
            const SizedBox(height: Dimensions.paddingSizeDefault),

            Padding(padding: const EdgeInsets.symmetric(
              horizontal: Dimensions.paddingSizeSmall,
              vertical: Dimensions.paddingSizeExtraSmall,
            ), child: GetBuilder<CounterController>(
              builder: (counterController) {
                return CustomSearchFieldWidget(
                  controller: searchController,
                  hint: 'search_by_counter_name_or_number'.tr,
                  hitColor: context.customThemeColors.textColor.withValues(alpha: 0.7),
                  prefix: Icons.search,
                  prefixColor: context.customThemeColors.textColor,
                  borderColor: Theme.of(context).hintColor.withValues(alpha: .7),
                  iconPressed: () => (){},
                  onSubmit: (text) => (){},
                  onChanged: (String value){
                    customDebounceWidget.run((){
                      counterController.getCounterList(searchText: value);
                    });
                  },
                  isFilter: false,
                );
              },
            )),
            const SizedBox(height: Dimensions.paddingSizeSmall),

            CustomHeaderWidget(
              title: 'counter_info'.tr,
              customMainAxis: MainAxisAlignment.start,
              fontSize: Dimensions.fontSizeDefault,
              titleStyle: ubuntuBold.copyWith(fontSize: Dimensions.fontSizeDefault, color: Theme.of(context).primaryColor),
            ),
            const SizedBox(height: Dimensions.paddingSizeSmall),

            Expanded(child: CustomScrollView(controller: _scrollController, slivers: [

              GetBuilder<CounterController>(
                  id: 'counter-list',
                  builder: (counterController) {
                    return SliverToBoxAdapter(
                      child: (counterController.counterModel?.counter?.isNotEmpty ?? false) ?
                      ListView.separated(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        separatorBuilder: (builder, context) => const SizedBox(height: 10),
                        itemCount: counterController.counterModel!.counter!.length,
                        itemBuilder: (context, index) => CounterItemWidget(
                          counter: counterController.counterModel!.counter![index],
                          index: index,
                        ),
                      ) : (counterController.counterModel?.counter == null)
                          ? const CustomLoaderWidget() : const NoDataWidget(),
                      );
                    }
                  ),

              SliverToBoxAdapter(child: SizedBox(height:ResponsiveHelper.isTab(context) ? Get.height * 0.2 : Get.height * 0.1))
            ])),

          ]),
        ),
      ),

      floatingActionButton: FloatingActionButton(backgroundColor: Theme.of(context).primaryColor,
        onPressed: () {
          Get.to(const CounterSetupScreen());
        },
        child: CustomAssetImageWidget(Images.counterSvg, color: Theme.of(context).cardColor),
      ),
    );
  }
}


