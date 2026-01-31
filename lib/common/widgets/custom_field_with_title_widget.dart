import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:six_pos/helper/extension_helper.dart';
import 'package:six_pos/util/dimensions.dart';
import 'package:six_pos/util/styles.dart';

class CustomFieldWithTitleWidget extends StatelessWidget {
  final Widget customTextField;
  final String? title;
  final bool requiredField;
  final bool limitSet;
  final String? setLimitTitle;
  final Function? onTap;
  final String? toolTipsMessage;
  final TextStyle? titleStyle;
  final double? padding;
  final Color? titleTextColor;

  const CustomFieldWithTitleWidget({
    Key? key,
    required this.customTextField,
    this.title,
    this.setLimitTitle,
    this.requiredField = false,
    this.limitSet = false,
    this.onTap,
    this.toolTipsMessage,
    this.titleStyle,
    this.padding,
    this.titleTextColor
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(padding ?? Dimensions.paddingSizeDefault),
      child: Column( crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Row(children: [

                Text(title ?? '', style: titleStyle ?? ubuntuRegular.copyWith(
                  fontSize: Dimensions.fontSizeSmall,
                  color: titleTextColor ?? Theme.of(context).textTheme.bodyLarge?.color,
                )),

                if(requiredField)
                  Text(' *', style: ubuntuBold.copyWith(color: Colors.red)),

                if(toolTipsMessage != null) Padding(
                  padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall),
                  child: PopupMenuButton(
                    icon: Icon(Icons.info_outline, size: 20, color: Theme.of(context).primaryColor),
                    tooltip: toolTipsMessage,
                    color: const Color(0xFF36454F),
                    shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(Dimensions.radiusLarge))
                    ),

                    itemBuilder: (BuildContext bc) {
                      return [
                        PopupMenuItem(child: Text(
                          toolTipsMessage!,
                          style: ubuntuLight.copyWith(color: Colors.white, fontSize: Dimensions.fontSizeSmall),
                        )),

                      ];
                    },
                  ),
                )
              ]),

            if(onTap != null) InkWell(
              onTap: onTap as void Function()?,
              child: Text(
                limitSet ? setLimitTitle! : 'generate_code'.tr,
                style: ubuntuRegular.copyWith(color: context.customThemeColors.downloadFormatColor, fontSize: Dimensions.fontSizeSmall),
              ),
            ),
          ]),
        // if(showTooltip) Text('(To decrease product quantity use minus before number. Ex: -10 )', style: fontSizeLight.copyWith(color: Theme.of(context).hintColor)),

        const SizedBox(height: Dimensions.paddingSizeExtraSmall),

        customTextField,

      ]),
    );
  }
}
