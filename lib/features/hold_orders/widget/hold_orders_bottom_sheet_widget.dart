import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:six_pos/common/controllers/cart_controller.dart';
import 'package:six_pos/common/widgets/custom_asset_image_widget.dart';
import 'package:six_pos/common/widgets/custom_debounce_widget.dart';
import 'package:six_pos/features/hold_orders/widget/hold_order_item_card_widget.dart';
import 'package:six_pos/features/pos/widgets/hold_order_search_bar_widget.dart';
import 'package:six_pos/helper/extension_helper.dart';
import 'package:six_pos/util/dimensions.dart';
import 'package:six_pos/util/images.dart';
import 'package:six_pos/util/styles.dart';

class HoldOrdersBottomSheetWidget extends StatefulWidget {
  const HoldOrdersBottomSheetWidget({super.key});

  @override
  State<HoldOrdersBottomSheetWidget> createState() => _HoldOrdersBottomSheetWidgetState();
}

class _HoldOrdersBottomSheetWidgetState extends State<HoldOrdersBottomSheetWidget> {
  TextEditingController searchController = TextEditingController();
  final CustomDebounceWidget customDebounceWidget = CustomDebounceWidget(milliseconds: 500);


  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    searchController.dispose();
  }


  @override
  Widget build(BuildContext context) {
    final double heightSize = MediaQuery.sizeOf(context).height;
    const double searchBarSize = 165;
    const double itemHeight = 190;

    int itemCount = Get.find<CartController>().customerCartList.length;

    return Container(
      height: itemCount < 3 ? (searchBarSize + (itemHeight * itemCount)) : heightSize * .95,
      color: Theme.of(context).cardColor,
      child: GetBuilder<CartController>(builder: (cartController) {
          return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Padding(
              padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start,children: [
                Padding(
                  padding: const EdgeInsets.only(top: Dimensions.paddingSizeSmall),
                  child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [

                    Row(children: [

                      Text('hold_orders'.tr, style: ubuntuMedium.copyWith(fontSize: Dimensions.fontSizeExtraLarge, color: Theme.of(context).primaryColor)),
                      const SizedBox(width: Dimensions.paddingSizeDefault),

                      Container(
                        width: 25, height : 25,
                        decoration: BoxDecoration(
                          color: Theme.of(context).secondaryHeaderColor,
                          borderRadius: BorderRadius.circular(100),
                        ),
                        child: Center(child: Text(cartController.customerCartList.length.toString(), style: ubuntuMedium.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).cardColor))),
                      ),
                    ]),

                    Transform.translate(
                      offset: const Offset(0, -5),
                      child: InkWell(
                        onTap: () {
                          Get.back();
                        },
                        child: CustomAssetImageWidget(
                          Images.crossIcon,
                          width: Dimensions.paddingSizeExtraLarge,
                          height: Dimensions.paddingSizeExtraLarge,
                          color: context.customThemeColors.textColor,
                        ),
                      ),
                    ),
                  ]),
                ),

                Text('your_hold_orders'.tr, style: ubuntuRegular),
                const SizedBox(height: Dimensions.paddingSizeDefault),

                cartController.customerCartList.length > 0 ?
                const HoldOrderSearchBarWidget() : const SizedBox(),

              ]),
            ),

            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(5),
                child: ListView.separated(
                  itemCount: cartController.customerCartList.length,
                  separatorBuilder: (builder, context) => const SizedBox(height: Dimensions.paddingSizeMediumBorder),
                  itemBuilder: (BuildContext context, int index) {
                    return HoldOrderItemCardWidget(holdOrder: cartController.customerCartList[index], index: index);
                  },
                ),
              ),
            )
          ]);
      }),
    );
  }
}



