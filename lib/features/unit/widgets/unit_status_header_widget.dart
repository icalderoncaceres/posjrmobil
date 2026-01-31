import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:six_pos/common/widgets/custom_asset_image_widget.dart';
import 'package:six_pos/common/widgets/custom_icon_button.dart';
import 'package:six_pos/common/widgets/custom_switch_widget.dart';
import 'package:six_pos/features/unit/controllers/unit_controller.dart';
import 'package:six_pos/features/unit/domain/models/unit_model.dart';
import 'package:six_pos/util/dimensions.dart';
import 'package:six_pos/util/images.dart';
import 'package:six_pos/util/styles.dart';

class UnitStatusHeaderWidget extends StatelessWidget {
  final Units? unit;
  final int? index;
  final bool isShowDeleteButton;
  const UnitStatusHeaderWidget({super.key, this.index, this.isShowDeleteButton = false, this.unit});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeLarge, vertical: Dimensions.paddingSizeSmall).copyWith(right: Dimensions.paddingSizeSmall),
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,children: [

        Text('${'unit'.tr} #${unit?.id}', style: ubuntuMedium),

        Row(children: [
          Transform.scale(
            scale: 0.82,
            child: Container(
              padding: EdgeInsets.only(left: Dimensions.paddingSizeSmall),
              decoration: BoxDecoration(
                border: Border.all(width: 1, color: Colors.black.withValues(alpha: 0.1)),
                borderRadius: BorderRadius.circular(Dimensions.paddingSizeMediumBorder),
              ),
              child: Row(children: [
                Text('status'.tr, style: ubuntuRegular),
                SizedBox(width: Dimensions.paddingSizeMediumBorder),

                GetBuilder<UnitController>(builder: (unitController) {
                  return CustomSwitchWidget(
                    value: unitController.unitActiveState == 1,
                    activeColor: Theme.of(context).primaryColor,
                    onChanged: (value) => unitController.onChangeUnitActiveStatus(unitController.unitActiveState == 1 ? 0 : 1),
                  );
                }),
              ]),
            ),
          ),
        ])
      ]),
    );
  }
}
