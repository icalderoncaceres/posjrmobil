import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:six_pos/common/models/cart_model.dart';
import 'package:six_pos/common/widgets/custom_image_widget.dart';
import 'package:six_pos/features/splash/controllers/splash_controller.dart';
import 'package:six_pos/helper/price_converter_helper.dart';
import 'package:six_pos/util/dimensions.dart';
import 'package:six_pos/util/images.dart';
import 'package:six_pos/util/styles.dart';

class HoldOrderItemDetailsCardWidget extends StatelessWidget {
  final CartModel? item;
  const HoldOrderItemDetailsCardWidget({super.key, this.item});

  @override
  Widget build(BuildContext context) {

    return Padding(
      padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
      child: Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(Dimensions.paddingSizeMediumBorder),
            border: Border.all(color: Theme.of(context).cardColor, width: 1)
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(Dimensions.paddingSizeMediumBorder),
            child: CustomImageWidget(
              width: 40,
              height: 40,
              fit: BoxFit.cover,
              placeholder: Images.logo,
              image: '${Get.find<SplashController>().baseUrls!.productImageUrl}/${item?.product?.image}',
            ),
          ),
        ),
        const SizedBox(width: Dimensions.paddingSizeDefault),

        Expanded(
          flex: 2,
          child: SizedBox(
            height: Dimensions.iconSizeExtraLarge,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Expanded(
                  child: Text(
                    item?.product?.title ?? '',
                    style: ubuntuRegular.copyWith(fontSize: Dimensions.fontSizeDefault, color: Theme.of(context).cardColor),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),

                Expanded(
                  child: Text('${item?.quantity}', style: ubuntuRegular.copyWith(fontSize: Dimensions.fontSizeDefault, color: Theme.of(context).cardColor),),
                ),
              ],
            ),
          ),
        ),

        Expanded(
            flex: 1,
            child: Center(child: Text('x ${item?.quantity}', style: ubuntuBold.copyWith(color: Theme.of(context).cardColor))),
        ),

        Expanded(
          flex: 1,
          child: Align(
            alignment: Alignment.centerRight,
            child: Text(
              PriceConverterHelper.priceWithSymbol(item?.price ?? 0),
              style: ubuntuBold.copyWith(color: Theme.of(context).cardColor),
              textAlign: TextAlign.left,
            ),
          ),
        ),

      ]),
    );
  }
}
