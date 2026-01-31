import 'package:flutter/material.dart';
import 'package:six_pos/util/dimensions.dart';
import 'package:six_pos/util/styles.dart';

class CustomMenuItemWidget extends StatelessWidget {
  final String title;
  final Widget child;
  final TextStyle? titleStyle;
  final Color? backgroundColor;
  final EdgeInsets? padding;
  const CustomMenuItemWidget({super.key, required this.title, required this.child, this.titleStyle, this.backgroundColor, this.padding});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding ?? EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault, vertical: Dimensions.paddingSizeSmall),
      color: backgroundColor ?? Colors.transparent,
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,children: [

        Text(title, style: titleStyle ?? ubuntuRegular),

        child,

      ]),
    );
  }
}
