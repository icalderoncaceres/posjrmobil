import 'package:flutter/material.dart';
import 'package:six_pos/common/widgets/custom_asset_image_widget.dart';
import 'package:six_pos/util/dimensions.dart';
import 'package:six_pos/util/styles.dart';

class CustomHeaderWidget extends StatelessWidget {
  final String? headerImage;
  final String title;
  final double? fontSize;
  final TextStyle? titleStyle;
  final MainAxisAlignment? customMainAxis;

  const CustomHeaderWidget({super.key,
    required this.title,
    this.headerImage,
    this.fontSize,
    this.customMainAxis,
    this.titleStyle
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
      color: Theme.of(context).primaryColor.withValues(alpha: 0.06),
      child: Row( mainAxisAlignment: customMainAxis ?? MainAxisAlignment.center,
        children: [
          if(headerImage?.isNotEmpty ?? false)...[
            CustomAssetImageWidget(headerImage!, height: 30),
          ],

          const SizedBox(width: Dimensions.paddingSizeSmall),
          Text(title, style: titleStyle ?? ubuntuMedium.copyWith(
            fontSize: fontSize ?? Dimensions.fontSizeOverLarge,
            color: Theme.of(context).primaryColor,
          ),),
        ],
      ),
    );
  }
}
