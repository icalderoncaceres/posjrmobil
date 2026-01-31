import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:six_pos/common/widgets/custom_asset_image_widget.dart';
import 'package:six_pos/common/widgets/custom_button_widget.dart';
import 'package:six_pos/common/widgets/custom_text_field_widget.dart';
import 'package:six_pos/features/account_management/controllers/transaction_controller.dart';
import 'package:six_pos/features/order/controllers/order_controller.dart';
import 'package:six_pos/features/splash/controllers/splash_controller.dart';
import 'package:six_pos/helper/extension_helper.dart';
import 'package:six_pos/helper/responsive_helper.dart';
import 'package:six_pos/helper/show_custom_snackbar_helper.dart';
import 'package:six_pos/util/dimensions.dart';
import 'package:six_pos/util/images.dart';
import 'package:six_pos/util/styles.dart';


class RefundOrderBottomSheetWidget extends StatefulWidget {
  final int? orderId;
  const RefundOrderBottomSheetWidget({super.key, required this.orderId});

  @override
  State<RefundOrderBottomSheetWidget> createState() => _RefundOrderBottomSheetWidgetState();
}

class _RefundOrderBottomSheetWidgetState extends State<RefundOrderBottomSheetWidget> {
  final TextEditingController _refundAmountController = TextEditingController();
  final TextEditingController _refundCauseController = TextEditingController();
  final TextEditingController _paymentMethodController = TextEditingController();
  final TextEditingController _paymentInfoController = TextEditingController();

  @override
  void initState() {
    _refundAmountController.text = (Get.find<OrderController>().orderDetail?.orderTotal ?? '').toString();
    super.initState();
  }

  @override
  void dispose() {
    _refundAmountController.dispose();
    _refundCauseController.dispose();
    _paymentMethodController.dispose();
    _paymentInfoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: GetBuilder<OrderController>(builder: (orderController){
        return SingleChildScrollView(
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            Padding(
              padding: const EdgeInsets.only(left: Dimensions.paddingSizeSmall,right: Dimensions.paddingSizeSmall,top: Dimensions.paddingSizeSmall),
              child: Column(mainAxisSize:MainAxisSize.min, children: [
                const CustomAssetImageWidget(Images.lineIconSvg),

                Align(alignment: Alignment.topRight,
                  child: InkWell(
                    onTap: ()=> Get.back(),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Theme.of(context).hintColor.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(50),
                      ),
                      padding: const EdgeInsets.all(Dimensions.paddingSizeExtraSmall),

                      child: CustomAssetImageWidget(Images.crossIcon,height: 14,width: 14,color: context.customThemeColors.textColor),
                    ),
                  ),
                ),

                Text('order_refund'.tr,style: ubuntuBold.copyWith(fontSize: Dimensions.fontSizeLarge,color: context.customThemeColors.textColor)),
                const SizedBox(height: Dimensions.paddingSizeSmall),
              ]),
            ),

            Container(
              margin: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall, vertical: Dimensions.paddingSizeDefault),
              padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(Dimensions.paddingSizeSmall),
                  color: Theme.of(context).hintColor.withValues(alpha: 0.07)
              ),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, spacing: Dimensions.paddingSizeDefault, children: [
                Text('${'refund_amount'.tr} (${Get.find<SplashController>().configModel?.currencySymbol})',style: ubuntuMedium.copyWith(fontSize: Dimensions.fontSizeLarge,color: context.customThemeColors.textColor)),

                CustomTextFieldWidget(
                  controller: _refundAmountController,
                  inputType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*$'))],
                  hintText: '${Get.find<SplashController>().configModel?.currencySymbol}0.00',
                ),

                Text('refund_cause'.tr,style: ubuntuMedium.copyWith(fontSize: Dimensions.fontSizeLarge,color: context.customThemeColors.textColor)),

                CustomTextFieldWidget(
                  controller: _refundCauseController,
                  maxLines: 3,
                  maxLength: 100,
                  hintText: 'type_refund_note'.tr,
                ),

                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(Dimensions.paddingSizeSmall),
                    border: Border.all(color: Theme.of(context).primaryColor.withValues(alpha:0.1), width: 1),
                    color: Theme.of(context).cardColor
                  ),
                  padding: EdgeInsets.all(Dimensions.paddingSizeDefault).copyWith(right: 0),
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, spacing: Dimensions.paddingSizeSmall, children: [
                    Text('give_refund_from(admin_account)'.tr,style: ubuntuMedium.copyWith(fontSize: Dimensions.fontSizeLarge,color: context.customThemeColors.textColor)),

                    (orderController.adminWalletList?.isNotEmpty ?? false) ?
                    SizedBox(height: 40, width: Get.width, child: ListView.separated(
                      itemCount: orderController.adminWalletList?.length ?? 0,
                      shrinkWrap: true,
                      scrollDirection: Axis.horizontal,
                      physics: const AlwaysScrollableScrollPhysics(),
                      separatorBuilder: (context, index) => const SizedBox(width: Dimensions.paddingSizeDefault),
                      itemBuilder: (context, index){
                        return InkWell(
                          onTap: ()=> orderController.updateRefundAdminAccountId(orderController.adminWalletList?[index].id),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: Dimensions.paddingSizeDefault,
                              vertical: Dimensions.paddingSizeSmall,
                            ),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                              border: Border.all(
                                color: orderController.selectedRefundAdminAccountId == orderController.adminWalletList?[index].id ?
                                Colors.transparent : Theme.of(context).hintColor.withValues(alpha: 0.4),
                              ),
                              color: orderController.selectedRefundAdminAccountId == orderController.adminWalletList?[index].id ?
                              Theme.of(context).primaryColor : Theme.of(context).cardColor,
                            ),
                            child: Text(
                              orderController.adminWalletList?[index].account ?? '',
                              style: ubuntuMedium.copyWith(
                                  color: orderController.selectedRefundAdminAccountId == orderController.adminWalletList?[index].id ?
                                  Theme.of(context).cardColor :
                                  Theme.of(context).textTheme.bodyLarge?.color,
                                  overflow: TextOverflow.ellipsis
                              ),
                            ),
                          ),
                        );
                      },
                    )) :
                    const SizedBox.shrink(),


                  ]),
                ),

                Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(Dimensions.paddingSizeSmall),
                      border: Border.all(color: Theme.of(context).primaryColor.withValues(alpha:0.1), width: 1),
                      color: Theme.of(context).cardColor
                  ),
                  padding: EdgeInsets.all(Dimensions.paddingSizeDefault),
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, spacing: Dimensions.paddingSizeSmall, children: [
                    Text('give_customer_via'.tr,style: ubuntuRegular.copyWith(fontSize: Dimensions.fontSizeLarge,color: context.customThemeColors.textColor)),

                    (orderController.refundCustomerWalletList?.isNotEmpty ?? false) ?
                    SizedBox(height: 40, width: Get.width, child: ListView.separated(
                      itemCount: orderController.refundCustomerWalletList?.length ?? 0,
                      shrinkWrap: true,
                      scrollDirection: Axis.horizontal,
                      physics: const AlwaysScrollableScrollPhysics(),
                      separatorBuilder: (context, index) => const SizedBox(width: Dimensions.paddingSizeDefault),
                      itemBuilder: (context, index){
                        return InkWell(
                          onTap: ()=> orderController.updateRefundCustomerWallet(orderController.refundCustomerWalletList?[index]),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: Dimensions.paddingSizeDefault,
                              vertical: Dimensions.paddingSizeSmall,
                            ),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                              border: Border.all(
                                color: orderController.selectedWalletCustomer == orderController.refundCustomerWalletList?[index] ?
                                Colors.transparent : Theme.of(context).hintColor.withValues(alpha: 0.4),
                              ),
                              color: orderController.selectedWalletCustomer == orderController.refundCustomerWalletList?[index] ?
                              Theme.of(context).primaryColor : Theme.of(context).cardColor,
                            ),
                            child: Text(
                              orderController.refundCustomerWalletList?[index].tr ?? '',
                              style: ubuntuMedium.copyWith(
                                  color: orderController.selectedWalletCustomer == orderController.refundCustomerWalletList?[index] ?
                                  Theme.of(context).cardColor :
                                  Theme.of(context).textTheme.bodyLarge?.color,
                                  overflow: TextOverflow.ellipsis
                              ),
                            ),
                          ),
                        );
                      },
                    )) :
                    const SizedBox.shrink(),

                    if(orderController.selectedWalletCustomer == 'other')...[
                      Text('payment_method'.tr,style: ubuntuRegular.copyWith(fontSize: Dimensions.fontSizeLarge,color: context.customThemeColors.textColor)),

                      CustomTextFieldWidget(
                        controller: _paymentMethodController,
                        maxLines: 1,
                        hintText: 'abc_bank'.tr,
                      ),

                      Text('payment_info'.tr,style: ubuntuRegular.copyWith(fontSize: Dimensions.fontSizeLarge,color: context.customThemeColors.textColor)),

                      CustomTextFieldWidget(
                        controller: _paymentInfoController,
                        maxLines: 1,
                        hintText: 'account_hint'.tr,
                      ),
                    ]

                  ]),
                ),
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
                    Expanded(child: CustomButtonWidget(
                      buttonText: 'cancel'.tr,
                      buttonColor: Theme.of(context).colorScheme.error.withValues(alpha: 0.1),
                      borderColor: Theme.of(context).colorScheme.error.withValues(alpha: 0.1),
                      isBorder: true,
                      textColor: Theme.of(context).colorScheme.error,
                      isClear: true,
                      onPressed: ()=> Get.back(),
                    )),
                    const SizedBox(width: Dimensions.paddingSizeExtraLarge),

                    Expanded(
                      child: orderController.isLoading ?
                      const Center(child: CircularProgressIndicator()) :
                      CustomButtonWidget(
                        buttonText: 'submit'.tr,
                        onPressed: (){
                          try{
                            if(double.parse(_refundAmountController.text) <= 0){
                              showCustomSnackBarHelper('${'amount_should_be_greater_than'.tr} 0');
                            }else if(double.parse(_refundAmountController.text) > (orderController.orderDetail?.orderTotal ?? 0)){
                              showCustomSnackBarHelper('${'amount_should_be_less_than'.tr} ${orderController.orderDetail?.orderTotal ?? 0}');
                            }else if(orderController.selectedWalletCustomer == 'other' && _paymentMethodController.text.isEmpty && _paymentInfoController.text.isEmpty){
                              showCustomSnackBarHelper('payment_method_and_info_are_required'.tr);
                            }else{
                              if(orderController.selectedWalletCustomer == 'other'){
                                orderController.sendRefundRequest(
                                  orderId: widget.orderId ?? -1, orderAmount: _refundAmountController.text.trim(),
                                  orderNote: _refundCauseController.text,
                                  adminWallet: orderController.selectedRefundAdminAccountId.toString(),
                                  customerWallet: orderController.selectedWalletCustomer,
                                  paymentMethod: _paymentMethodController.text,
                                  paymentInfo: _paymentInfoController.text
                                );
                              }else{
                                orderController.sendRefundRequest(
                                    orderId: widget.orderId ?? -1, orderAmount: _refundAmountController.text.trim(),
                                    orderNote: _refundCauseController.text,
                                    adminWallet: orderController.selectedRefundAdminAccountId.toString(),
                                    customerWallet: orderController.selectedWalletCustomer,
                                );
                              }

                            }

                          }catch(e){
                            showCustomSnackBarHelper('please_enter_amount'.tr);
                          }
                        },
                      ),
                    ),
                  ]),
                ),
              ),
            ]),
          ]),
        );
      }),
    );
  }
}
