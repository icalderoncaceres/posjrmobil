import 'package:buttons_tabbar/buttons_tabbar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:six_pos/common/widgets/custom_asset_image_widget.dart';
import 'package:six_pos/common/widgets/custom_debounce_widget.dart';
import 'package:six_pos/common/widgets/custom_search_field_widget.dart';
import 'package:six_pos/common/widgets/date_picker_widget.dart';
import 'package:six_pos/features/home/screens/home_screens.dart';
import 'package:six_pos/features/order/widgets/filter_order_list_bottomsheet_widget.dart';
import 'package:six_pos/features/order/widgets/order_list_widget.dart';
import 'package:six_pos/features/user/controllers/customer_controller.dart';
import 'package:six_pos/features/order/controllers/order_controller.dart';
import 'package:six_pos/helper/extension_helper.dart';
import 'package:six_pos/helper/responsive_helper.dart';
import 'package:six_pos/helper/show_custom_snackbar_helper.dart';
import 'package:six_pos/util/dimensions.dart';
import 'package:six_pos/util/images.dart';
import 'package:six_pos/common/widgets/custom_app_bar_widget.dart';
import 'package:six_pos/common/widgets/custom_drawer_widget.dart';
import 'package:six_pos/common/widgets/custom_header_widget.dart';
import 'package:six_pos/util/styles.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class OrderScreen extends StatefulWidget {
  final bool fromNavBar;
  final bool isCustomer;
  final int? customerId;
  const OrderScreen({super.key, this.fromNavBar = true, this.isCustomer = false, this.customerId});

  @override
  State<OrderScreen> createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> with TickerProviderStateMixin {
  final ScrollController _scrollController = ScrollController();
  final CustomDebounceWidget customDebounceWidget = CustomDebounceWidget(milliseconds: 500);
  late TabController filterTabController;
  OrderController _orderController = Get.find<OrderController>();

  @override
  void initState() {
    super.initState();
    _orderController.getCounterList();
    _orderController.clearFilter(isUpdate: false, formOrderScreen: true);

    filterTabController = TabController(length: _orderController.filterTypes.length, vsync: this);
    if(widget.isCustomer){
      _orderController.onUpdateCustomerId(widget.customerId);
    }else{
      _orderController.onUpdateCustomerId(null);
    }

    _orderController.onUpdateTabIndex(0,isUpdate: false);

    filterTabController.addListener((){
      if(!filterTabController.indexIsChanging){
        _orderController.onUpdateTabIndex(filterTabController.index);
      }
    });
  }

  @override
  void dispose() {
    filterTabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBarWidget(),
      endDrawer: const CustomDrawerWidget(),
      body: SafeArea(
        child: RefreshIndicator(
          color: Theme.of(context).cardColor,
          backgroundColor: Theme.of(context).primaryColor,
          onRefresh: () async {
            if(widget.isCustomer){
              Get.find<CustomerController>().getCustomerWiseOrderListList(widget.customerId, 1);
            }else{
              _orderController.getOrderList(1);
            }

          },
          child: Padding(
            padding: ResponsiveHelper.isTab(context) ?
            const EdgeInsets.only(top: Dimensions.paddingSizeDefault, left: Dimensions.paddingSizeDefault, right: Dimensions.paddingSizeDefault) :
            EdgeInsets.zero,
            child: NestedScrollView(
              controller: _scrollController,
              headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled){

                return <Widget> [

                  SliverToBoxAdapter(child: Column(children: [
                    CustomHeaderWidget(title: 'order_list'.tr),

                    Container(
                      color: Theme.of(context).primaryColor.withValues(alpha: 0.03),
                      padding: const EdgeInsets.only(
                        top: Dimensions.paddingSizeSmall, left: Dimensions.paddingSizeSmall,
                        right: Dimensions.paddingSizeSmall,
                      ),
                      child: Row(children: [
                        Flexible(child: CustomSearchFieldWidget(
                          controller: _orderController.searchController,
                          prefix: Icons.search,
                          borderColor: Theme.of(context).primaryColor.withValues(alpha: 0.25),
                          hitColor: context.customThemeColors.textColor,
                          prefixColor: context.customThemeColors.textColor,
                          iconPressed: () => (){},
                          onSubmit: (text) => (){},
                          onChanged: (String value){
                            customDebounceWidget.run((){
                              _orderController.getOrderList(1);
                            });
                          },
                          isFilter: false,
                          hint: 'search'.tr,
                        )),
                        const SizedBox(width: Dimensions.paddingSizeSmall),

                        Container(
                          decoration: BoxDecoration(
                              color: Theme.of(context).cardColor,
                              shape: BoxShape.circle,
                              border: Border.all(color: Theme.of(context).primaryColor.withValues(alpha: 0.15))
                          ),
                          child: PopupMenuButton(
                            offset: Offset(0, ResponsiveHelper.isTab(context) ? Get.height * 0.06 : Get.height * 0.06),
                            itemBuilder: (ctx)=> [
                              PopupMenuItem<int>(value: 0,
                                onTap: (){
                                  Get.dialog(Padding(
                                    padding: ResponsiveHelper.isTab(context) ?
                                    EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeLarge, vertical: Dimensions.paddingSizeLarge) :
                                    const EdgeInsets.all(Dimensions.paddingSizeLarge),
                                    child: CustomCalendarWidget(
                                      initDateRange: PickerDateRange(
                                          _orderController.startDate,
                                          _orderController.endDate
                                      ),
                                        onSubmit: (range){
                                        if(range?.startDate != null){
                                          _orderController.onUpdateStartAndEndDate(startDate: range?.startDate, endDate: range?.endDate);
                                        }else{
                                          showCustomSnackBarHelper('you_did_not_select_range'.tr);
                                        }
                                      }
                                    ),
                                  ));
                                },
                                child: SizedBox(width: Get.width * 0.3,
                                  child: Row(children: [
                                    const CustomAssetImageWidget(Images.calenderSvg, height: 18,width: 18),
                                    const SizedBox(width: Dimensions.paddingSizeSmall),

                                    Text('date'.tr),

                                    const Spacer(),

                                    if(_orderController.startDate != null || _orderController.endDate != null)
                                    Container(
                                      height: 7,width: 7,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(50),
                                        color: Theme.of(context).colorScheme.error
                                      ),
                                    )
                                  ]),
                                ),
                              ),

                              PopupMenuItem<int>(value: 1,
                                onTap: ()=> showModalBottomSheet(
                                  context: context,
                                  isScrollControlled: true,
                                  constraints: BoxConstraints(maxHeight: Get.height * 0.9, maxWidth: double.infinity),
                                  builder: (ctx){
                                    return FilterOrderListBottomSheetWidget(isCustomer: widget.isCustomer);
                                  },
                                ),
                                child: SizedBox(width: Get.width * 0.3,
                                  child: Row(children: [
                                    const CustomAssetImageWidget(Images.filterSvg, height: 18,width: 18),
                                    const SizedBox(width: Dimensions.paddingSizeSmall),

                                    Text('filter'.tr),

                                    const Spacer(),

                                    if(_checkIsFilterApplied(_orderController))
                                    Container(
                                      height: 7,width: 7,
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(50),
                                          color: Theme.of(context).colorScheme.error
                                      ),
                                    )
                                  ]),
                                ),
                              ),

                            ],
                          ),
                        )

                      ]),
                    ),
                  ])),

                  SliverPersistentHeader(pinned: true, delegate: SliverDelegate(
                    child: Container(
                      color: context.customThemeColors.backgroundShadowColor,
                      width: Get.width, height: 70,
                      padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeDefault),
                      child: ButtonsTabBar(
                        width: Get.width * 0.32 ,
                        decoration: BoxDecoration(
                          color: Theme.of(context).primaryColor,
                          borderRadius: BorderRadius.circular(50),
                        ),
                        unselectedDecoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(50),
                          color: Theme.of(context).cardColor,
                        ),
                        borderWidth: 1,
                        radius: 50,
                        borderColor: Theme.of(context).primaryColor,
                        unselectedBorderColor: Theme.of(context).textTheme.bodyLarge!.color!.withValues(alpha: 0.1),
                        buttonMargin: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall, vertical: 0),
                        labelStyle: ubuntuSemiBold.copyWith(fontSize: Dimensions.fontSizeDefault, color: Colors.white),
                        unselectedLabelStyle: ubuntuSemiBold.copyWith(fontSize: Dimensions.fontSizeDefault, color: Theme.of(context).textTheme.bodyMedium?.color?.withValues(alpha: 0.8)),
                        contentCenter: true,
                        controller: filterTabController,
                        tabs: _orderController.filterTypes.map((value)=> Tab(text:value.tr)).toList(),
                      ),
                    ),
                  )),

                ];
              },

              body: TabBarView(
                controller: filterTabController,
                children: _orderController.filterTypes.map((value)=> const OrderListWidget()).toList(),
              ),

            ),
          ),
        ),
      ),
    );
  }
}

bool _checkIsFilterApplied(OrderController _orderController){
  if(_orderController.customerId != null || _orderController.counterId != null || _orderController.selectedPaymentMethodId.isNotEmpty){
    return true;
  }else{
    return false;
  }
}