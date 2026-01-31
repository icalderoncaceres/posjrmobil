import 'package:flutter/material.dart';
import 'package:six_pos/common/widgets/custom_divider.dart';
import 'package:six_pos/features/order/controllers/order_controller.dart';
import 'package:six_pos/util/dimensions.dart';
import 'package:get/get.dart';
import 'package:six_pos/util/styles.dart';

class CustomerSearchWidget extends StatelessWidget {
  final OverlayPortalController? overlayPortalController;
  const CustomerSearchWidget({super.key, this.overlayPortalController});

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height * 0.25;
    return GetBuilder<OrderController>(builder: (orderController){
      return orderController.customerModel != null && orderController.customerModel!.customerList!.isNotEmpty ?
      Padding(
        padding: const EdgeInsets.only(right: Dimensions.paddingSizeExtraLarge),
        child: Container(
          height: height,
          padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(Dimensions.paddingSizeBorder),
            boxShadow: [
              BoxShadow(
                color: Theme.of(context).shadowColor.withValues(alpha:0.1),
                spreadRadius: .5,
                blurRadius: 12,
                offset: const Offset(3,5),
              ),
            ],
          ),
          child: ListView.builder(
            itemCount: orderController.customerModel?.customerList?.length ?? 0,
            physics: const BouncingScrollPhysics(),
            itemBuilder: (ctx,index){
              return InkWell(
                onTap: (){
                  orderController.customerSearchController.text = orderController.customerModel?.customerList?[index].name ?? '';
                  orderController.onUpdateCustomerId(orderController.customerModel?.customerList?[index].id);
                  overlayPortalController?.hide();
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeSmall),
                  child: Column(mainAxisAlignment: MainAxisAlignment.start,crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('${orderController.customerModel?.customerList?[index].name}'.tr, style: ubuntuRegular.copyWith(fontSize: Dimensions.fontSizeDefault)),
                      const SizedBox(height: Dimensions.paddingSizeMediumBorder),

                      CustomDividerWidget(height: .5,color: Theme.of(context).hintColor),
                    ],
                  ),
                ),
              );
            }),
        ),
      ):
      const SizedBox.shrink();
    });
  }
}
