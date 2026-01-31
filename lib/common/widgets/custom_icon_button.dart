import 'package:flutter/material.dart';
import 'package:six_pos/util/dimensions.dart';

class CustomIconButton extends StatelessWidget {
  final Function()? onTap;
  final Widget icon;
  final Color? color;
  final bool isBorder;
  final bool isFiltered;
  final GlobalKey? globalKey;
  const CustomIconButton({super.key, this.onTap, required this.icon, this.color, this.isBorder = true, this.isFiltered = false, this.globalKey});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      onTap: onTap,
      child: Stack(children: [
          Container(
            key: globalKey,
            padding: EdgeInsets.all(Dimensions.paddingSizeMediumBorder),
            decoration: BoxDecoration(
                color: color ?? Theme.of(context).cardColor,
                borderRadius: BorderRadius.circular(Dimensions.paddingSizeMediumBorder),
                border: Border.all(width: 1, color: Colors.black.withValues(alpha: 0.1)),
                boxShadow: [BoxShadow(
                  offset: Offset(0, 2),
                  blurRadius: 4,
                  color: Colors.black.withValues(alpha: 0.04),
                )]
            ),
            child: icon,
          ),


        if(isFiltered) Positioned(right: 0, top: 0, child: Container(
          transform: Matrix4.translationValues(3, -3, 0),
            width: Dimensions.fontSizeSmall, height: Dimensions.fontSizeSmall,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.error,
              border: Border.all(color: Theme.of(context).cardColor, width: 1.5),
              shape: BoxShape.circle,
            )),
        ),
        ]),
    );
  }
}
