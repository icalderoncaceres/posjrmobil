import 'package:flutter/material.dart';
import 'package:six_pos/helper/date_converter_helper.dart';
import 'package:six_pos/helper/extension_helper.dart';
import 'package:six_pos/util/dimensions.dart';
import 'package:six_pos/util/styles.dart';

class DateFormatWidget extends StatelessWidget {
  final String date;
  const DateFormatWidget({
    super.key, required this.date,
  });

  @override
  Widget build(BuildContext context) {
    return Row(crossAxisAlignment: CrossAxisAlignment.center,children: [
      
      Text(DateConverterHelper.isoStringToLocalDateOnly(date), style: ubuntuMedium.copyWith(fontSize: Dimensions.fontSizeLarge)),

      SizedBox(
        height: Dimensions.fontSizeDefault,
        child: VerticalDivider(
          // width: 10,
          thickness: 2,
          color: context.customThemeColors.textOpacityColor,
        ),
      ),

      Text(DateConverterHelper.isoStringToLocalTimeOnly(date), style: ubuntuMedium.copyWith(fontSize: Dimensions.fontSizeLarge)),
    ]);
  }
}