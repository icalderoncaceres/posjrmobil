import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:six_pos/common/controllers/cart_controller.dart';
import 'package:six_pos/common/models/temporary_cart_list_model.dart';
import 'package:six_pos/common/widgets/custom_button_widget.dart';
import 'package:six_pos/features/hold_orders/widget/hold_order_item_dialog_widget.dart';
import 'package:six_pos/features/pos/widgets/resume_cart_dialog.dart';
import 'package:six_pos/helper/animated_custom_dialog_helper.dart';
import 'package:six_pos/util/dimensions.dart';
import 'package:six_pos/util/styles.dart';

class HoldOrderItemCardWidget extends StatelessWidget {
  final TemporaryCartListModel? holdOrder;
  final int? index;
  const HoldOrderItemCardWidget({super.key, this.holdOrder, this.index});

  @override
  Widget build(BuildContext context) {
    final double widthSize = MediaQuery.sizeOf(context).width;

    return SizedBox(
      child: Stack(
        children: [
          Container(
            margin: const EdgeInsets.all(Dimensions.paddingSizeDefault),
            decoration: BoxDecoration(
                color: Theme.of(context).hintColor.withValues(alpha: .1),
                borderRadius: BorderRadius.circular(Dimensions.paddingSizeSmall)
            ),
            child: Column(mainAxisSize: MainAxisSize.min,children: [

              Padding(
                padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
                child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [

                  Text.rich(TextSpan(children: [
                    TextSpan(text: '${"hold_id".tr}: ', style: ubuntuRegular.copyWith(fontSize: Dimensions.fontSizeLarge)),

                    TextSpan(text: holdOrder?.holdId.toString() ?? '0', style: ubuntuBold.copyWith(fontSize: Dimensions.fontSizeLarge))
                  ])),

                  Expanded(
                    child: Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
                      Text(
                        '${holdOrder?.customerName}',
                        style: ubuntuBold.copyWith(fontSize: Dimensions.fontSizeSmall),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),

                      Text('${holdOrder?.customerPhone}', style: ubuntuRegular.copyWith(fontSize: Dimensions.fontSizeSmall)),
                    ]),
                  )
                ]),
              ),

              Divider(height: 5, thickness: 1, color: Theme.of(context).hintColor.withValues(alpha: .2)),

              Padding(
                padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
                child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, crossAxisAlignment: CrossAxisAlignment.start, children: [

                  InkWell(
                    onTap: (){
                      showAnimatedDialogHelper(context, HoldOrderItemDialogWidget(holdOrder: holdOrder), dismissible: false, isFlip: false);
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(top: Dimensions.paddingSizeSmall),
                      child: Text('${holdOrder?.cart?.length} ${"items".tr}', style: ubuntuBold.copyWith(
                          fontSize: Dimensions.fontSizeLarge,
                          color: Theme.of(context).primaryColor,
                          decoration: TextDecoration.underline,
                          decorationColor: Theme.of(context).primaryColor
                      )),
                    ),
                  ),

                  const Expanded(child: SizedBox()),

                  GetBuilder<CartController>(
                      builder: (cartController) {
                      return SizedBox(
                        width: widthSize / 5,
                        child: CustomButtonWidget(
                          buttonText: 'resume'.tr,
                          onPressed: (){
                            if(cartController.currentCartModel?.cart != null && (cartController.currentCartModel?.cart?.isNotEmpty ?? false) ) {
                              showAnimatedDialogHelper(context,
                                ConfirmResumeDialogWidget(
                                  onYesPressed: () {
                                    Get.back();
                                    cartController.addToHoldUserList();
                                    cartController.resumeCartFromHoldOrder(holdOrder!, index!);
                                  },
                                  onNoPressed: () {
                                    cartController.resumeCartFromHoldOrder(holdOrder!, index!);
                                  },
                                ),
                                dismissible: false,
                                isFlip: false,
                              );
                            } else {
                              Get.find<CartController>().resumeCartFromHoldOrder(holdOrder!, index!);
                            }
                          },
                          height: Dimensions.paddingSizeRevenueBottom,
                        ),
                      );
                      }
                  ),
                ]),
              ),
            ]),
          ),

          Positioned(right: 7, top: 5, child: InkWell(
            onTap: () {
              Get.find<CartController>().removeCartFromHoldData(index!);
            },
            child: Center(child: Icon(Icons.cancel_rounded, color: Theme.of(context).hintColor)))
          ),
        ],
      ),
    );

  }
}
