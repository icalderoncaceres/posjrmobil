import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:just_the_tooltip/just_the_tooltip.dart';
import 'package:six_pos/common/models/order_model.dart';
import 'package:six_pos/common/widgets/custom_app_bar_widget.dart';
import 'package:six_pos/common/widgets/custom_asset_image_widget.dart';
import 'package:six_pos/common/widgets/custom_divider.dart';
import 'package:six_pos/common/widgets/custom_drawer_widget.dart';
import 'package:six_pos/common/widgets/custom_image_widget.dart';
import 'package:six_pos/common/widgets/custom_loader_widget.dart';
import 'package:six_pos/features/order/controllers/order_controller.dart';
import 'package:six_pos/features/order/screens/invoice_screen.dart';
import 'package:six_pos/features/order/widgets/customer_employee_details_widget.dart';
import 'package:six_pos/features/order/widgets/order_info_widget.dart';
import 'package:six_pos/features/order/widgets/payment_info_widget.dart';
import 'package:six_pos/features/order/widgets/refund_order_bottomsheet_widget.dart';
import 'package:six_pos/features/pos/widgets/item_price_widget.dart';
import 'package:six_pos/features/splash/controllers/splash_controller.dart';
import 'package:six_pos/helper/extension_helper.dart';
import 'package:six_pos/helper/price_converter_helper.dart';
import 'package:six_pos/helper/responsive_helper.dart';
import 'package:six_pos/util/dimensions.dart';
import 'package:six_pos/util/images.dart';
import 'package:six_pos/util/styles.dart';

class OrderDetailsScreen extends StatefulWidget {
  final int? orderId;
  const OrderDetailsScreen({super.key, this.orderId});

  @override
  State<OrderDetailsScreen> createState() => _OrderDetailsScreenState();
}

class _OrderDetailsScreenState extends State<OrderDetailsScreen> {

  @override
  void initState() {
    Get.find<OrderController>().getOrderDetails(orderId: widget.orderId ?? -1, isUpdate: false);
    super.initState();
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBarWidget(title: 'order_details'.tr),
      endDrawer: const CustomDrawerWidget(),
      body: SafeArea(
        child: Padding(
          padding: ResponsiveHelper.isTab(context) ? const EdgeInsets.all(Dimensions.paddingSizeDefault) : EdgeInsets.zero,
          child: GetBuilder<OrderController>(builder: (orderController){
            Orders? order = orderController.orderDetail;
            return order != null ?
            Column(spacing: Dimensions.paddingSizeSmall, children: [

              Padding(
                padding: const EdgeInsets.all(Dimensions.paddingSizeLarge).copyWith(bottom: 0),
                child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, spacing: Dimensions.paddingSizeSmall, children: [

                  if(order.orderStatus == 'completed')
                    Flexible(
                      flex: 1,
                      child: _ButtonWidget(text: 'refund'.tr,onTap: () =>
                          showModalBottomSheet(
                            context: context,
                            isScrollControlled: true,
                            constraints: BoxConstraints(maxHeight: Get.height * 0.9, maxWidth: double.infinity),
                            builder: (ctx){
                              return RefundOrderBottomSheetWidget(orderId: order.orderId ?? -1);
                            },
                          )
                      ),
                    ),

                  // Flexible(flex: 1, child: _ButtonWidget(text: 'edit'.tr,image: Images.editIcon,onTap: (){
                  //   ///
                  // })),

                  Flexible(flex: 1, child: _ButtonWidget(text: 'print'.tr,image: Images.printIconSvg,onTap: ()=> Get.to(()=> InVoiceScreen(orderId: order.orderId)))),

                ]),
              ),

              Expanded(child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(Dimensions.paddingSizeLarge).copyWith(top: Dimensions.paddingSizeSmall),
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, spacing: Dimensions.paddingSizeLarge, children: [

                    Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(Dimensions.paddingSizeSmall),
                          border: Border.all(color: Colors.black.withValues(alpha: 0.1))
                      ),
                      child: Column(spacing: Dimensions.paddingSizeSmall, children: [
                        const SizedBox(height: Dimensions.paddingSizeSmall),

                        if(ResponsiveHelper.isTab(context))...[

                          if(order.orderStatus != 'completed')...[
                              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                                OrderInfoWidget(order: order,fromRefund: true),
                                const SizedBox(height: Dimensions.paddingSizeSmall),

                                if(order.refundReason != null)
                                  _NoteCardWidget(title: 'refund_note',text: order.refundReason),
                              ]),

                            const SizedBox(height: Dimensions.paddingSizeDefault),
                          ],

                          IntrinsicHeight(
                            child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                              Expanded(flex: 8, child: OrderInfoWidget(order: order)),

                              Expanded(flex: 1, child: VerticalDivider(thickness: 1, color: Theme.of(context).hintColor.withValues(alpha: 0.3))),

                              Expanded(flex: 8,child: PaymentInfoWidget(order: order)),
                            ]),
                          )
                        ],



                        if(!ResponsiveHelper.isTab(context))...[
                          if(order.orderStatus != 'completed')...[
                            OrderInfoWidget(order: order,fromRefund: true),

                            if(order.refundReason != null)
                              _NoteCardWidget(title: 'refund_note',text: order.refundReason),

                            Divider(color: Theme.of(context).hintColor.withValues(alpha: 0.3)),
                          ],

                          OrderInfoWidget(order: order),

                          Divider(color: Theme.of(context).hintColor.withValues(alpha: 0.3)),

                          PaymentInfoWidget(order: order),

                          if(order.orderNote != null)
                            Divider(color: Theme.of(context).hintColor.withValues(alpha: 0.3)),
                        ],

                        if(order.orderNote != null)
                          _NoteCardWidget(title: 'note', text: order.orderNote),
                        const SizedBox(height: Dimensions.paddingSizeSmall)
                      ]),
                    ),
                    if(ResponsiveHelper.isTab(context))
                      const SizedBox(height: Dimensions.paddingSizeSmall),

                    RichText(
                      text: TextSpan(text: 'item_details'.tr, children: [
                        TextSpan(text: ' (${order.orderDetails?.length} ${'items'.tr})',style: ubuntuRegular.copyWith(color: Theme.of(context).hintColor))
                      ],style: ubuntuMedium.copyWith(color: Theme.of(context).textTheme.bodyLarge?.color)),
                    ),

                    ListView.separated(
                      padding: EdgeInsets.zero,
                      shrinkWrap: true,
                      itemCount: order.orderDetails?.length ?? 0,
                      physics: const NeverScrollableScrollPhysics(),
                      itemBuilder: (ctx,index){
                        return  _ItemCartWidget(orderDetails: order.orderDetails![index]);
                      },
                      separatorBuilder: (ctx,index){
                        return Divider(color: Theme.of(context).hintColor.withValues(alpha: 0.1));
                      },
                    ),

                    if(!ResponsiveHelper.isTab(context))
                      Divider(color: Theme.of(context).textTheme.bodyLarge?.color?.withValues(alpha: 0.20)),

                    Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(Dimensions.paddingSizeSmall),
                          color: Theme.of(context).primaryColor.withValues(alpha: 0.05)
                      ),
                      child: Column(children: [
                        ItemPriceWidget(title: 'subtotal'.tr,amount: PriceConverterHelper.convertPrice(context, order.subtotal), isBold: true, titleColor: context.customThemeColors.textColor),

                        ItemPriceWidget(title: 'discount'.tr,amount: '- ${PriceConverterHelper.convertPrice(context, order.discount)}', titleColor: context.customThemeColors.textColor),

                        ItemPriceWidget(title: 'coupon_discount'.tr,amount: '- ${PriceConverterHelper.convertPrice(context, order.orderCouponDiscountAmount)}', titleColor: context.customThemeColors.textColor),

                        ItemPriceWidget(title: 'extra_discount'.tr,amount: '- ${PriceConverterHelper.convertPrice(context, order.orderExtraDiscount)}', titleColor: context.customThemeColors.textColor),

                        ItemPriceWidget(title: 'vat/tax'.tr,amount: '+ ${PriceConverterHelper.convertPrice(context, order.orderTax)}', titleColor: context.customThemeColors.textColor),

                        Padding(
                          padding: const EdgeInsets.only(left: Dimensions.paddingSizeDefault,right: Dimensions.paddingSizeDefault,bottom: Dimensions.paddingSizeSmall),
                          child: CustomDividerWidget(height: 0.5,color: Theme.of(context).hintColor.withValues(alpha: 0.5)),
                        ),

                        ItemPriceWidget(title: 'total'.tr,amount: PriceConverterHelper.convertPrice(context, order.orderTotal),isBold: true, titleColor: context.customThemeColors.textColor),

                        ItemPriceWidget(title: 'cash'.tr,amount: PriceConverterHelper.convertPrice(context, order.paidAmount), titleColor: context.customThemeColors.textColor),
                        const SizedBox(height: Dimensions.paddingSizeSmall),

                        ItemPriceWidget(title: 'paid'.tr,amount: PriceConverterHelper.convertPrice(context, order.paidAmount),isBold: true, titleColor: context.customThemeColors.textColor),

                        if(order.changeAmount != 0)
                          ItemPriceWidget(title: 'change_amount'.tr,amount: PriceConverterHelper.convertPrice(context, order.changeAmount), titleColor: context.customThemeColors.textColor),
                      ]),
                    ),
                    if(ResponsiveHelper.isTab(context))
                      const SizedBox(height: Dimensions.paddingSizeSmall),

                    CustomerEmployeeDetailsWidget(text: 'customer_details'.tr, customer: order.customer),

                  ]),
                ),
              ))
            ]) :
            Center(child: const CustomLoaderWidget());
          }),
        ),
      ),
    );
  }
}


class _ButtonWidget extends StatelessWidget {
  final String text;
  final String? image;
  final Function onTap;
  const _ButtonWidget({required this.text, this.image, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: ()=> onTap(),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault, vertical: Dimensions.paddingSizeExtraSmall),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(Dimensions.paddingSizeMediumBorder),
          border: Border.all(width: 1, color: Theme.of(context).hintColor.withValues(alpha: 0.3,)),
          boxShadow: [BoxShadow(
            offset: Offset(0, 2),
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 4,
          )],
        ),
        child: Row(spacing: Dimensions.paddingSizeSmall,mainAxisAlignment: MainAxisAlignment.center, children: [
          Text(text,style: ubuntuRegular.copyWith(color: Theme.of(context).primaryColor)),

          if(image != null)
            CustomAssetImageWidget(image!,height: 14,width: 14)
        ]),
      ),
    );
  }
}

class _ItemCartWidget extends StatefulWidget {
  final OrderDetails orderDetails;

  const _ItemCartWidget({required this.orderDetails});

  @override
  State<_ItemCartWidget> createState() => _ItemCartWidgetState();
}

class _ItemCartWidgetState extends State<_ItemCartWidget> {
  JustTheController tooltipController = JustTheController();

  @override
  void initState() {
    if(!(widget.orderDetails.isExist ?? true)){
      WidgetsBinding.instance.addPostFrameCallback((_){
        tooltipController.showTooltip();
      });
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: (){
        if(!(widget.orderDetails.isExist ?? true)){
          tooltipController.showTooltip();
        }
      },
      child: Opacity(
        opacity: (widget.orderDetails.isExist ?? true) ? 1 : 0.5,
        child: Row(spacing: Dimensions.paddingSizeSmall, mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Flexible(flex: ResponsiveHelper.isTab(context) ? 3 : 8, child: Row(spacing: Dimensions.paddingSizeSmall,children: [
            Container(height: 50,width: 50,
              decoration: BoxDecoration(
                  border: Border.all(color: Theme.of(context).hintColor.withValues(alpha: 0.2)),
                  borderRadius: BorderRadius.circular(Dimensions.paddingSizeSmall)
              ),
              child: ClipRRect(
                  borderRadius: BorderRadius.circular(Dimensions.paddingSizeSmall),
                  child: CustomImageWidget(image: '${Get.find<SplashController>().baseUrls!.productImageUrl}/${widget.orderDetails.image}',fit: BoxFit.cover)
              ),
            ),

            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text('${widget.orderDetails.name}',style: ubuntuRegular,overflow: TextOverflow.ellipsis),

              JustTheTooltip(
                backgroundColor: Get.isDarkMode ?
                Theme.of(context).primaryColor :
                Theme.of(context).textTheme.bodyMedium!.color,
                controller: tooltipController,
                preferredDirection: AxisDirection.up,
                tailLength: 10,
                tailBaseWidth: 20,
                margin: EdgeInsets.only(left: Get.width * 0.2),
                content: Container(width: 200,
                  padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                  child: Text(
                    'this_product_is_unavailable'.tr,
                    style: ubuntuRegular.copyWith(
                      color: Colors.white, fontSize: Dimensions.fontSizeDefault,
                    ),
                  ),
                ),
                child: Text(PriceConverterHelper.convertPrice(context, widget.orderDetails.basePrice),style: ubuntuRegular.copyWith(color: Theme.of(context).primaryColor)),
              ),
            ])),
          ])),

          Flexible(
            flex: ResponsiveHelper.isTab(context) ? 4 : 2,
            child: Text('${'qty'.tr}: ${widget.orderDetails.quantity}',style: ubuntuRegular.copyWith(
              color: context.customThemeColors.textOpacityColor,
            )),
          ),

          Flexible(
            flex: ResponsiveHelper.isTab(context) ? 4 : 3,
            child: Text(PriceConverterHelper.convertPrice(context, widget.orderDetails.totalPrice),style: ubuntuBold.copyWith(
              color: Theme.of(context).primaryColor,
              fontSize: Dimensions.fontSizeLarge,
            )),
          ),
        ]),
      ),
    );
  }
}

class _NoteCardWidget extends StatelessWidget {
  final String? title;
  final String? text;
  const _NoteCardWidget({this.title, this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault),
      padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault,vertical: Dimensions.paddingSizeSmall),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(Dimensions.paddingSizeMediumBorder),
          color: Theme.of(context).primaryColor.withValues(alpha: 0.05)
      ),
      child: Row(crossAxisAlignment: CrossAxisAlignment.start, spacing: Dimensions.paddingSizeSmall, children: [
        Text('# ${'$title'.tr}:',style: ubuntuBold.copyWith(
          fontSize: Dimensions.fontSizeSmall,
          color: Theme.of(context).primaryColor,
        )),

        Text('$text'.tr,style: ubuntuRegular.copyWith(fontSize: Dimensions.fontSizeSmall))
      ]),
    );
  }
}
