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
import 'package:six_pos/common/widgets/sliver_paginated_list_widget.dart';
import 'package:six_pos/features/counter/controllers/counter_controller.dart';
import 'package:six_pos/features/counter/widgets/counter_details_info_card_widget.dart';
import 'package:six_pos/features/counter/widgets/counter_details_order_card_widget.dart';
import 'package:six_pos/helper/responsive_helper.dart';
import 'package:six_pos/util/dimensions.dart';
import 'package:six_pos/util/images.dart';
import 'package:six_pos/util/styles.dart';

import '../domain/models/counter.dart';

class CounterDetailsScreen extends StatefulWidget {
  final Counter counter;
  const CounterDetailsScreen({super.key, required this.counter});

  @override
  State<CounterDetailsScreen> createState() => _CounterDetailsScreenState();
}

class _CounterDetailsScreenState extends State<CounterDetailsScreen> {

  TextEditingController searchController = TextEditingController();
  final CustomDebounceWidget customDebounceWidget = CustomDebounceWidget(milliseconds: 500);
  final scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    Get.find<CounterController>().getCounterDetails(counterID: widget.counter.id ?? -1, isUpdate: false);
  }

  @override
  void dispose() {
    searchController.dispose();
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white.withValues(alpha:0.97),
      appBar: const CustomAppBarWidget(),
      endDrawer: const CustomDrawerWidget(),
      body: SafeArea(child: GetBuilder<CounterController>(
          id : 'counter-details',
          builder: (counterController) {
            return !counterController.isLoading ? RefreshIndicator(
              color: Theme.of(context).cardColor,
              backgroundColor: Theme.of(context).primaryColor,
              onRefresh: () async {
                Get.find<CounterController>().getCounterDetails(counterID: widget.counter.id ?? -1, isUpdate: true);
              },
              child: SliverPaginatedListWidget(
                scrollController: scrollController,
                onPaginate: (int? offset) async => await counterController.getCounterSearchDetails(
                    offset: offset, counterID: widget.counter.id ?? -1,searchText: searchController.text
                ),
                totalSize: counterController.counterDetailsModel?.total,
                offset: counterController.counterDetailsModel?.offset,
                limit: counterController.counterDetailsModel?.limit,
                builder: (loaderWidget){
                  return Expanded(child: CustomScrollView(controller: scrollController, slivers: [

                    SliverAppBar(
                      automaticallyImplyLeading: false,
                      actions: <Widget>[Container()],
                      title: CustomHeaderWidget(title: 'counter_details'.tr),
                      titleSpacing: 0,
                      centerTitle: true,
                      pinned: true,
                      toolbarHeight: 45,
                    ),

                    SliverToBoxAdapter(child: Column(children: [
                      GetBuilder<CounterController>(
                        builder: (counterController) {
                          return Container(
                            margin: ResponsiveHelper.isTab(context) ? const EdgeInsets.all(Dimensions.paddingSizeSmall) : null,
                            padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                            decoration: BoxDecoration(
                              color: Theme.of(context).cardColor,
                              borderRadius: ResponsiveHelper.isTab(context) ? BorderRadius.circular(Dimensions.paddingSizeSmall) : null,
                              boxShadow: [
                                BoxShadow(
                                  color: Theme.of(context).primaryColor.withValues(alpha: 0.05),
                                  blurRadius: 5,
                                ),
                              ],
                            ),
                            child: ResponsiveHelper.isTab(context)
                                ? Row(children: [
                              Expanded(flex: 1,
                                child: _CounterDetailsNameDescriptionWidget(
                                  counterName: widget.counter.name ?? '',
                                  counterDescription: widget.counter.description ?? '',
                                ),
                              ),
                              const SizedBox(height: Dimensions.paddingSizeDefault),

                              Expanded(flex: 2,
                                child: Padding(padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeExtraSmall),
                                  child: IntrinsicHeight(
                                    child: Row(children: [

                                      CounterDetailsInfoCardWidget(
                                        info: "${counterController.counterDetailsModel?.total ?? 0}",
                                        isPrice: false,
                                      ),
                                      const SizedBox(width: Dimensions.paddingSizeDefault),

                                      CounterDetailsInfoCardWidget(
                                        info: ((widget.counter.ordersSumOrderAmount ?? 0)
                                            + (widget.counter.ordersSumTotalTax ?? 0)).toString(),
                                        isPrice: true,
                                      ),

                                    ]),
                                  ),
                                ),
                              ),
                              const SizedBox(height: Dimensions.paddingSizeDefault),
                            ])
                                : Column(children: [

                              _CounterDetailsNameDescriptionWidget(
                                counterName: widget.counter.name ?? '',
                                counterDescription: widget.counter.description ?? '',
                              ),
                              const SizedBox(height: Dimensions.paddingSizeDefault),

                              Padding(padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeExtraSmall),
                                child: IntrinsicHeight(
                                  child: Row(children: [

                                    CounterDetailsInfoCardWidget(
                                      info: "${widget.counter.ordersCount ?? 0}",
                                      isPrice: false,
                                    ),
                                    const SizedBox(width: Dimensions.paddingSizeDefault),

                                    CounterDetailsInfoCardWidget(
                                      info: ((widget.counter.ordersSumOrderAmount ?? 0)
                                          + (widget.counter.ordersSumTotalTax ?? 0)).toString(),
                                      isPrice: true,
                                    ),

                                  ]),
                                ),
                              ),
                              const SizedBox(height: Dimensions.paddingSizeDefault),

                            ]),
                          );
                        },
                      ),
                      const SizedBox(height: Dimensions.paddingSizeSmall),

                    ])),

                    SliverPersistentHeader(
                        pinned: true,
                        delegate: _PersistentHeader(
                          widget: Container(color: Theme.of(context).primaryColor.withValues(alpha: 0.03),
                            child: Column(children: [

                              CustomHeaderWidget(
                                title: 'order_list'.tr,
                                customMainAxis: MainAxisAlignment.start,
                                fontSize: Dimensions.fontSizeDefault,
                              ),

                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: Dimensions.paddingSizeDefault,
                                    vertical: Dimensions.paddingSizeDefault
                                ),
                                child: CustomSearchFieldWidget(
                                  controller: searchController,
                                  prefix: Icons.search,
                                  iconPressed: () => (){},
                                  onSubmit: (text) => (){},
                                  onChanged: (String value){
                                    customDebounceWidget.run((){
                                      counterController.getCounterSearchDetails(counterID: widget.counter.id ?? -1, searchText: value, offset: 1);
                                    });
                                  },
                                  isFilter: false,
                                  hint: 'search'.tr,
                                ),
                              ),
                            ]),
                          ),
                        )),

                    GetBuilder<CounterController>(id: 'counter-search-details', builder: (counterController) {
                      return (counterController.counterDetailsModel?.orders?.isNotEmpty ?? false) ?
                      SliverList(delegate: SliverChildBuilderDelegate(
                            (context, index) =>  CounterDetailsOrderCardWidget(orders: counterController.counterDetailsModel?.orders?[index]),
                        childCount:  counterController.counterDetailsModel?.orders?.length ?? 0,
                      )) :
                      const SliverToBoxAdapter(child: NoDataWidget(
                        fontSize: Dimensions.fontSizeDefault,
                        imageSize: 100,
                      ));
                    }),

                    SliverToBoxAdapter(child: loaderWidget)
                  ]));
                },
              ),
            ) :  const Center(child: CustomLoaderWidget());
          }
      )),
    );
  }
}

class _PersistentHeader extends SliverPersistentHeaderDelegate {
  final Widget widget;

  _PersistentHeader({required this.widget});

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(color: Theme.of(context).cardColor,child: widget);
  }

  @override
  double get maxExtent => 120;

  @override
  double get minExtent => 120;

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) {
    return true;
  }
}


class _CounterDetailsNameDescriptionWidget extends StatelessWidget {
  final String counterName;
  final String counterDescription;
  const _CounterDetailsNameDescriptionWidget({required this.counterName, required this.counterDescription});

  @override
  Widget build(BuildContext context) {
    return Row(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [

      Expanded(flex: 1, child: Container(
        padding: const EdgeInsets.all(Dimensions.paddingSizeExtraSmall),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Theme.of(context).primaryColor.withValues(alpha:0.06),
        ),
        child: const CustomAssetImageWidget(Images.counterListIcon,
          fit: BoxFit.contain,
          height: 35,
        ),
      )),

      Expanded(flex: 4,
        child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [

          Text(counterName,
            style: ubuntuRegular.copyWith(
              fontSize: Dimensions.fontSizeLarge,
              color: Theme.of(context).primaryColor,
            ),
          ),

          Row(children: [

            Expanded(flex: 3, child: Text(counterDescription,
              style: ubuntuLight.copyWith(
                fontSize: Dimensions.fontSizeSmall,
                color: Theme.of(context).hintColor,
              ),
            )),

            Expanded(child: Container()),

          ]),

        ]),
      ),

    ]);
  }
}





