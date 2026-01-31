import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:six_pos/common/models/config_model.dart';
import 'package:six_pos/common/widgets/custom_asset_image_widget.dart';
import 'package:six_pos/common/widgets/custom_button_widget.dart';
import 'package:six_pos/common/widgets/custom_debounce_widget.dart';
import 'package:six_pos/common/widgets/custom_text_field_widget.dart';
import 'package:six_pos/features/order/controllers/order_controller.dart';
import 'package:six_pos/features/order/widgets/customer_search_widget.dart';
import 'package:six_pos/features/splash/controllers/splash_controller.dart';
import 'package:six_pos/helper/responsive_helper.dart';
import 'package:six_pos/util/dimensions.dart';
import 'package:six_pos/util/images.dart';
import 'package:six_pos/util/styles.dart';

class FilterOrderListBottomSheetWidget extends StatefulWidget {
  final bool isCustomer;
  const FilterOrderListBottomSheetWidget({super.key, this.isCustomer = false});

  @override
  State<FilterOrderListBottomSheetWidget> createState() => _FilterOrderListBottomSheetWidgetState();
}

class _FilterOrderListBottomSheetWidgetState extends State<FilterOrderListBottomSheetWidget> {


  @override
  Widget build(BuildContext context) {
    return GetBuilder<OrderController>(builder: (orderController){
      final ConfigModel? configModel = Get.find<SplashController>().configModel;
      return SafeArea(child: Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: SingleChildScrollView(
            child: Column(mainAxisSize: MainAxisSize.min, children: [
              Padding(
                padding: const EdgeInsets.only(left: Dimensions.paddingSizeSmall,right: Dimensions.paddingSizeSmall,top: Dimensions.paddingSizeSmall),
                child: Column(mainAxisSize:MainAxisSize.min, children: [
                  const CustomAssetImageWidget(Images.lineIconSvg),
        
                  InkWell(
                    onTap: ()=> Get.back(),
                    child: Align(alignment: Alignment.topRight,
                      child: Container(
                        decoration: BoxDecoration(
                          color: Theme.of(context).hintColor.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(50),
                        ),
                        padding: const EdgeInsets.all(Dimensions.paddingSizeExtraSmall),
        
                        child: const CustomAssetImageWidget(Images.crossIcon,height: 14,width: 14),
                      ),
                    ),
                  ),
        
                  Text('filter'.tr,style: ubuntuBold.copyWith(fontSize: Dimensions.fontSizeLarge)),
        
                  Text('filter_to_quick_find_what'.tr,style: ubuntuRegular.copyWith(fontSize: Dimensions.fontSizeSmall)),
                  const SizedBox(height: Dimensions.paddingSizeSmall),
                ]),
              ),
        
              Divider(color: Theme.of(context).primaryColor.withValues(alpha: 0.1)),
        
              Container(
                padding: ResponsiveHelper.isTab(context) ?
                const EdgeInsets.only(left: Dimensions.paddingSizeDefault * 2 ,right: Dimensions.paddingSizeDefault * 2,top: Dimensions.paddingSizeSmall * 2) :
                const EdgeInsets.only(left: Dimensions.paddingSizeDefault,right: Dimensions.paddingSizeDefault,top: Dimensions.paddingSizeSmall),
                child: Column(mainAxisSize: MainAxisSize.min, children: [
        
                  if(ResponsiveHelper.isTab(context))...[
                    Row(children: [
                      const Flexible(child: _CounterDropDownWidget()),
                      const SizedBox(width: Dimensions.paddingSizeDefault),
                      if(!widget.isCustomer)
                      Flexible(child: _CustomerDropDownWidget()),
                    ])
                  ],
        
                  if(!ResponsiveHelper.isTab(context))...[
                    const _CounterDropDownWidget(),
                    const SizedBox(height: Dimensions.paddingSizeSmall),
        
                    if(!widget.isCustomer)
                     _CustomerDropDownWidget(),
                  ],
        
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text('payment_method'.tr, style: ubuntuMedium.copyWith(
                      fontSize: Dimensions.fontSizeDefault,
                    )),
                  ),
                  const SizedBox(height: Dimensions.paddingSizeSmall),
        
                  GridView.builder(
                      padding: EdgeInsets.zero,
                      itemCount: configModel?.paymentMethods?.length ?? 0,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2, childAspectRatio: ResponsiveHelper.isTab(context) ? 6 : 4,
                        mainAxisSpacing: Dimensions.paddingSizeSmall,
                        crossAxisSpacing: Dimensions.paddingSizeSmall,
                      ),
                      shrinkWrap: true,
                      itemBuilder: (ctx,index){
                        return InkWell(
                         onTap: ()=> orderController.onUpdatePaymentMethod(configModel?.paymentMethods?[index].id),
                          child: Container(
                            padding: EdgeInsets.only(right: Dimensions.paddingSizeSmall),
                            decoration: BoxDecoration(
                                border: Border.all(color: Theme.of(context).primaryColor.withValues(alpha: 0.2)),
                                borderRadius: BorderRadius.circular(Dimensions.paddingSizeSmall)
                            ),
                            child: Row(children: [
                              Checkbox(
                                  value: orderController.selectedPaymentMethodId.contains(configModel?.paymentMethods?[index].id),
                                  checkColor: Theme.of(context).cardColor,
                                  activeColor: Theme.of(context).primaryColor,
                                  onChanged: (value){
                                    orderController.onUpdatePaymentMethod(configModel?.paymentMethods?[index].id);
                                  }
                              ),
        
                              Expanded(child: Text(
                                configModel?.paymentMethods?[index].account ?? '',
                                overflow: TextOverflow.ellipsis,
                              ))
                            ]),
                          ),
                        );
                      }
                  ),
                  const SizedBox(height: 35),
        
                ]),
              ),
        
              Row(children: [
                if(ResponsiveHelper.isTab(context))
                  const Expanded(flex: 1, child: SizedBox()),
        
                Expanded(flex: 1,
                  child: Container(
                    padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
                    margin: ResponsiveHelper.isTab(context) ? const EdgeInsets.all(Dimensions.paddingSizeDefault) : null,
                    decoration: BoxDecoration(
                        color: Theme.of(context).cardColor,
                        borderRadius: ResponsiveHelper.isTab(context) ?BorderRadius.circular(Dimensions.paddingSizeSmall) : null,
                        boxShadow: [BoxShadow(
                            color: Theme.of(context).hintColor.withValues(alpha: 0.3),
                            offset: const Offset(0, -5),
                            blurRadius: 7
                        )]
                    ),
                    child: Row(children: [
                      Flexible(child: CustomButtonWidget(
                        buttonText: 'clear_filter'.tr,
                        isButtonTextBold: true,
                        buttonColor: Theme.of(context).hintColor.withValues(alpha: 0.1),
                        textColor: Colors.black,
                        isClear: true,
                        onPressed: (){
                          orderController.clearFilter();
                          Get.back();
                          orderController.getOrderList(1);
                        },
                      )),
                      const SizedBox(width: Dimensions.paddingSizeExtraLarge),
        
                      Flexible(child: CustomButtonWidget(
                        buttonText: 'apply'.tr,
                        isButtonTextBold: true,
                        buttonColor: _canFiltered() ? null : Theme.of(context).hintColor,
                        onPressed: (){
                          if(_canFiltered()){
                            Get.back();
                            orderController.getOrderList(1);
                          }
                        },
                      )),
                    ]),
                  ),
                ),
              ]),
            ]),
          ),
      ));
    });
  }
}

bool _canFiltered(){
  OrderController controller = Get.find<OrderController>();
  if(controller.orderModel?.customerId == null || controller.orderModel?.counterId == null || controller.orderModel?.paymentMethodId == null){
    return true;
  }else if(controller.orderModel?.customerId != controller.customerId){
    return true;
  }else if(controller.orderModel?.counterId != controller.counterId){
    return true;
  }else if(
  !(controller.orderModel!.paymentMethodId!.containsAll(controller.selectedPaymentMethodId) &&
      controller.orderModel!.paymentMethodId!.length == controller.selectedPaymentMethodId.length)
  ){
    return true;
  }else{
    return false;
  }
}

class _CounterDropDownWidget extends StatelessWidget {
  const _CounterDropDownWidget();

  @override
  Widget build(BuildContext context) {
    return GetBuilder<OrderController>(builder: (orderController){
      return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

        Text('counter_number'.tr, style: ubuntuMedium.copyWith(
          fontSize: Dimensions.fontSizeDefault,
        )),
        const SizedBox(height: Dimensions.paddingSizeSmall),

        GetBuilder<OrderController>( id: 'counter-list', builder: (orderController) {
          return DropdownButtonHideUnderline(
            child: Container(
              width: Get.width,
              decoration: BoxDecoration(
                  border: Border.all(color: Theme.of(context).hintColor.withValues(alpha: 0.5)),
                  borderRadius: BorderRadius.circular(Dimensions.paddingSizeSmall)
              ),
              child: DropdownButton2<int>(
                isExpanded: true,
                hint: Text('all_counter'.tr, style: TextStyle(fontSize: 14, color: Theme.of(context).hintColor)),
                items: orderController.counterModel?.counter?.asMap().map((int i, item) {
                  return MapEntry(i, DropdownMenuItem(
                    value: i,
                    child: Text("${item.number ?? ''} ${item.name?.tr}", style: ubuntuRegular.copyWith(
                      color: Theme.of(context).textTheme.bodyLarge?.color,
                      fontSize: Dimensions.fontSizeLarge,
                    )),
                  ));
                }).values.toList(),

                onChanged: (value) {
                  orderController.onUpdateCounterId(value ?? 0);
                },

                value: orderController.counterSelectIndex,
                buttonStyleData: const ButtonStyleData(padding: EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeExtraSmall), width: 300, elevation: 0),
                dropdownStyleData: DropdownStyleData(maxHeight: 400, width: Get.width - (ResponsiveHelper.isTab(context) ? Get.width *.52 : Get.width *.06),
                  decoration: BoxDecoration(
                    color: Theme.of(context).cardColor,
                    border: Border.all(color: Theme.of(context).disabledColor, width: 0.5),
                    borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                  ),
                ),
                menuItemStyleData: MenuItemStyleData(selectedMenuItemBuilder: (ctx, item) {
                  return Container(
                    decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor.withValues(alpha: 0.1),
                    ),
                    child: Center(child: item),
                  );
                }),

                selectedItemBuilder: (context) {
                  return (orderController.counterModel?.counter ?? []).map((item) {
                    return Align(alignment: Alignment.centerLeft, child: Text((item.name ?? '').tr));
                  }).toList();
                },
              ),
            ),
          );
        }),
        SizedBox(height: ResponsiveHelper.isTab(context) ? Dimensions.paddingSizeExtraLarge : Dimensions.paddingSizeDefault),

      ]);
    });
  }
}

class _CustomerDropDownWidget extends StatelessWidget {
   _CustomerDropDownWidget();
  final OverlayPortalController _overlayPortalController = OverlayPortalController();

  final LayerLink _link = LayerLink();

  final CustomDebounceWidget customDebounceWidget = CustomDebounceWidget(milliseconds: 500);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<OrderController>(builder: (orderController){
      return Column(children: [
        Align(
          alignment: Alignment.centerLeft,
          child: Text('customer_info'.tr, style: ubuntuMedium.copyWith(
            fontSize: Dimensions.fontSizeDefault,
          )),
        ),
        const SizedBox(height: Dimensions.paddingSizeSmall),

        CompositedTransformTarget(
          link: _link,
          child: OverlayPortal(controller: _overlayPortalController,
            overlayChildBuilder: (BuildContext context) {
              return CompositedTransformFollower(
                link: _link,
                targetAnchor: Alignment.bottomLeft,
                child: Align(
                  alignment: Alignment.topLeft,
                  child: CustomerSearchWidget(overlayPortalController: _overlayPortalController),
                ),
              );
            },
            child: CustomTextFieldWidget(
              hintText: 'search_customer'.tr,
              controller: orderController.customerSearchController,
              onChanged: (value) {
                if(value.isEmpty){
                  _overlayPortalController.hide();
                  Get.find<OrderController>().onUpdateCustomerId(null);
                }

                customDebounceWidget.run(() {
                  Get.find<OrderController>().customerSearch(orderController.customerSearchController.text);
                  _overlayPortalController.show();
                });
              },
              suffixIcon: Images.search,
              suffix: true,
            ),
          ),
        ),

        const SizedBox(height: Dimensions.paddingSizeExtraLarge)
      ]);
    });
  }
}


