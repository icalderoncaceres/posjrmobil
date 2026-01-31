import 'package:flutter/material.dart';
import 'package:six_pos/helper/extension_helper.dart';
import 'package:six_pos/util/dimensions.dart';

class CustomClearIconWidget extends StatelessWidget {
  final double? size;
  final Function()? onTap;
  final Color? iconColor;
  final Color? backgroundColor;
  final Matrix4? transform;
  final IconData? icons;
  const CustomClearIconWidget({
    super.key, this.transform, this.iconColor,
    this.backgroundColor, this.onTap, this.size, this.icons
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      transform: transform ??  null,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: backgroundColor ?? Theme.of(context).hintColor.withValues(alpha: 0.125),
      ),
      child: InkWell(
        onTap: onTap ?? ()=> Navigator.pop(context),
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        child: Padding(
          padding: EdgeInsets.all(Dimensions.paddingSizeMediumBorder),
          child: Icon(
            icons ?? Icons.clear,
            color: iconColor ?? context.customThemeColors.textOpacityColor,
            size: size ?? Dimensions.paddingSizeLarge,
          ),
        ),
      ),
    );
  }
}
