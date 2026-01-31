import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:six_pos/common/models/temporary_cart_list_model.dart';
import 'package:six_pos/common/widgets/custom_asset_image_widget.dart';
import 'package:six_pos/features/hold_orders/widget/hold_order_item_details_card_widget.dart';
import 'package:six_pos/helper/extension_helper.dart';
import 'package:six_pos/util/dimensions.dart';
import 'package:six_pos/util/images.dart';
import 'package:six_pos/util/styles.dart';

class HoldOrderItemDialogWidget extends StatelessWidget {
  final TemporaryCartListModel? holdOrder;
   const HoldOrderItemDialogWidget({super.key, required this.holdOrder});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
      backgroundColor: Theme.of(context).cardColor.withValues(alpha: .6),
      child: Container(
        decoration: BoxDecoration(
          color: context.customThemeColors.textColor,
          borderRadius: BorderRadius.circular(Dimensions.paddingSizeSmall),
        ),
        child: Column(mainAxisSize: MainAxisSize.min, children: [

          Container(
            decoration: BoxDecoration(
              color: context.customThemeColors.textColor,
              borderRadius: BorderRadius.only(topLeft: Radius.circular(Dimensions.paddingSizeSmall), topRight: Radius.circular(Dimensions.paddingSizeSmall)),
            ),
            child: Padding(
              padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
              child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,children: [

                const Expanded(child: SizedBox(width: Dimensions.paddingSizeSmall)),

                Text('product_list'.tr, style: ubuntuBold.copyWith(color: Theme.of(context).cardColor)),

                const Expanded(child: SizedBox()),

                InkWell(
                  onTap: () {
                    Get.back();
                  },
                  child: CustomAssetImageWidget(
                    Images.crossIcon,
                    width: Dimensions.paddingSizeExtraLarge,
                    height: Dimensions.paddingSizeExtraLarge,
                    color: Theme.of(context).cardColor,
                  ),
                ),
              ]),
            ),
          ),

          ListView.separated(
            itemCount: holdOrder?.cart?.length ?? 0,
            shrinkWrap: true,
            itemBuilder: (BuildContext context, index){
              return HoldOrderItemDetailsCardWidget(item: holdOrder!.cart![index]);
            },
            separatorBuilder: (context,index){
              return Divider(thickness: 1, color: Theme.of(context).hintColor);
            },
          ),
        ]),
      ),
    );
  }
}
