import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:six_pos/util/dimensions.dart';
import 'package:six_pos/util/styles.dart';

class CustomDropDownButtonWidget extends StatelessWidget {
  final String value;
  final List<String> itemList;
  final Function(String? value) onChanged;
  final double? borderRadius;
  final Color? borderColor;
  final Color? textColor;
  final Color? iconColor;
  const CustomDropDownButtonWidget({
    super.key,
    required this.value,
    required this.itemList,
    required this.onChanged,
    this.borderRadius,
    this.borderColor,
    this.textColor,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start,children: [

      Text('choose_category'.tr, style: ubuntuRegular.copyWith(
          fontSize: Dimensions.fontSizeDefault,
          color: Theme.of(context).textTheme.bodyLarge?.color,
      )),
      SizedBox(height: Dimensions.paddingSizeSmall),

      Container(
        padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(borderRadius ?? Dimensions.fontSizeSmall),
          border: Border.all(color: borderColor ?? Theme.of(context).primaryColor.withValues(alpha:0.3)),
        ),
        child: DropdownButton<String>(
          value: value,
          icon: Icon(Icons.arrow_drop_down, color: iconColor ?? Theme.of(context).textTheme.bodyLarge?.color),
          style: TextStyle(color: textColor ?? Theme.of(context).hintColor),
          underline: const SizedBox(),
          onChanged: (String? value)=> onChanged(value),
          items: itemList.map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(value: value, child: Text(value.tr,
              style: ubuntuRegular.copyWith(fontSize: Dimensions.fontSizeDefault),
            ));
          }).toList(),
          isExpanded: true,
        ),
      ),
    ]);
  }
}
