import 'package:flutter/material.dart';
import 'package:six_pos/common/widgets/custom_asset_image_widget.dart';
import 'package:six_pos/helper/extension_helper.dart';
import 'package:six_pos/util/dimensions.dart';
import 'package:six_pos/util/images.dart';
import 'package:six_pos/util/styles.dart';

class ItemPriceWidget extends StatelessWidget {
  final String? title;
  final String? amount;
  final bool isBold;
  final bool isEditButton;
  final Function? onTap;
  final String? sign;
  final Color? titleColor;
  const ItemPriceWidget({super.key, this.title, this.amount, this.isBold = false, this.isEditButton = false, this.onTap, this.sign, this.titleColor});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(Dimensions.paddingSizeDefault,
          Dimensions.paddingSizeExtraSmall, Dimensions.paddingSizeDefault, Dimensions.paddingSizeExtraSmall),
      child: Row(children: [

        Text(title ?? '', style: ubuntuRegular.copyWith(
          color: titleColor ?? (isBold
              ? Theme.of(context).primaryColor
              : context.customThemeColors.checkOutTextColor),
          fontWeight: isBold ? FontWeight.w700 : FontWeight.w400,
          fontSize: isBold ? Dimensions.fontSizeLarge : Dimensions.paddingSizeDefault,
        )),
        const Spacer(),

        isEditButton?
        InkWell(
          onTap: onTap as void Function()?,
          child: const Padding(
            padding: EdgeInsets.all(Dimensions.paddingSizeExtraSmall),
            child: CustomAssetImageWidget(Images.editIcon, width: Dimensions.paddingSizeLarge, height: Dimensions.paddingSizeLarge),
          ),
        ) : const SizedBox(),

        Text('${sign ?? ''} ${amount ?? ''}', style: ubuntuRegular.copyWith(
          color: titleColor ?? (isBold
              ? Theme.of(context).primaryColor
              : context.customThemeColors.checkOutTextColor),
          fontWeight: isBold ? FontWeight.w700 : FontWeight.w400,
          fontSize: isBold? Dimensions.fontSizeLarge: Dimensions.paddingSizeDefault,
        )),

      ],),
    );
  }
}