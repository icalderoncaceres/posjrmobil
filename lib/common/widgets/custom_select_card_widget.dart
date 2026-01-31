import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:six_pos/util/dimensions.dart';
import 'package:six_pos/util/styles.dart';

class CustomSelectCardWidget extends StatelessWidget {
  final Function() onTap;
  final bool isSelected;
  final String label;
  final bool isCheckBox;
  const CustomSelectCardWidget({super.key, required this.onTap, required this.isSelected, required this.label, this.isCheckBox = false});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
        decoration: BoxDecoration(
            border: Border.all(width: 1, color: isSelected ? Theme.of(context).primaryColor : Theme.of(context).hintColor.withValues(alpha: 0.3)),
            borderRadius: BorderRadius.circular(Dimensions.paddingSizeMediumBorder)
        ),
        child: Row(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.center,children: [

          isCheckBox ?
          Container(
            padding: const EdgeInsets.all(Dimensions.barWidthFlowChart),
            decoration: BoxDecoration(
              color: isSelected ? Theme.of(context).primaryColor : Colors.transparent,
              border: Border.all(width: 1, color: isSelected ? Theme.of(context).primaryColor : Theme.of(context).hintColor.withValues(alpha: 0.3)),
              shape: BoxShape.rectangle,
              borderRadius: BorderRadius.circular(Dimensions.barWidthFlowChart),
            ),
            child: Icon(
              Icons.check,
              size: Dimensions.paddingSizeDefault,
              color: isSelected ? Theme.of(context).cardColor : Colors.transparent,
            ),
          ) :
          Container(
            padding: const EdgeInsets.all(Dimensions.barWidthFlowChart),
            decoration: BoxDecoration(
              border: Border.all(width: 1, color: isSelected ? Theme.of(context).primaryColor : Theme.of(context).hintColor.withValues(alpha: 0.3)),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.circle,
              size: Dimensions.paddingSizeDefault,
              color: isSelected ? Theme.of(context).primaryColor : Colors.transparent,
            ),
          ),
          const SizedBox(width: Dimensions.fontSizeSmall),

          Flexible(
            child: Text(
              label.tr,
              style: ubuntuRegular.copyWith(
                color: Theme.of(context).textTheme.bodyLarge?.color,
                fontSize: Dimensions.fontSizeSmall,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),

        ]),
      ),
    );
  }
}
