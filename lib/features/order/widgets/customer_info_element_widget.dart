import 'package:flutter/material.dart';
import 'package:six_pos/helper/extension_helper.dart';
import 'package:six_pos/util/dimensions.dart';
import 'package:six_pos/util/styles.dart';

class CustomerInfoElementWidget extends StatelessWidget {
  final String? title;
  final String? info;
  final bool isTitleBold;
  final bool isInfoBold;
  const CustomerInfoElementWidget({super.key, this.title, this.info, this.isTitleBold = false, this.isInfoBold = false,});

  @override
  Widget build(BuildContext context) {
    return Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,children: [

      Text(title ?? '', style: isTitleBold ? ubuntuBold.copyWith(
        color: context.customThemeColors.textOpacityColor,
        fontSize: Dimensions.fontSizeLarge,
      ) : ubuntuRegular.copyWith(color: context.customThemeColors.textOpacityColor)),

      const Expanded(child: SizedBox()),

      Expanded(
        child: Text(
          info ?? '',
          style: isInfoBold ? ubuntuBold.copyWith(
          color: context.customThemeColors.textColor,
          fontSize: Dimensions.fontSizeDefault,
          overflow: TextOverflow.ellipsis
        ) : ubuntuRegular.copyWith(color: context.customThemeColors.textColor, overflow: TextOverflow.ellipsis),
        maxLines: 2,
          textAlign: TextAlign.right,
        ),
      ),
    ]);
  }
}
