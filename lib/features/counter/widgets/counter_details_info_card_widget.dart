import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:six_pos/helper/price_converter_helper.dart';
import 'package:six_pos/util/dimensions.dart';
import 'package:six_pos/util/styles.dart';

class CounterDetailsInfoCardWidget extends StatelessWidget {

  final bool isPrice;
  final String info;

  const CounterDetailsInfoCardWidget({super.key, required this.isPrice, required this.info});

  @override
  Widget build(BuildContext context) {
    return Expanded(child: Container(
      padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeDefault),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
        color: isPrice ? Theme.of(context).colorScheme.tertiaryContainer : Theme.of(context).colorScheme.onTertiary,
      ),
      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [

        Text(isPrice ? "total_earning".tr : "total_order".tr, style: ubuntuRegular.copyWith(
          color: Theme.of(context).textTheme.bodyLarge?.color,
        )),
        const SizedBox(height: Dimensions.paddingSizeExtraSmall),

        Padding(
          padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
          child: Text(isPrice ?
          PriceConverterHelper.convertPrice(context, double.parse(info), isShowLongPrice: true) : info,
            style: ubuntuMedium.copyWith(
              fontSize: Dimensions.fontSizeOverLarge,
              color: Theme.of(context).textTheme.bodyLarge?.color,
            ),
          ),
        ),
      ]),
    ));
  }
}