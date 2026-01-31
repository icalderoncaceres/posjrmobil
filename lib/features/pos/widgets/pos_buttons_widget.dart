import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:six_pos/common/controllers/cart_controller.dart';
import 'package:six_pos/common/widgets/custom_button_widget.dart';
import 'package:six_pos/helper/extension_helper.dart';
import 'package:six_pos/util/dimensions.dart';

class PosButtonsWidget extends StatelessWidget {
  final VoidCallback? onClearButtonTap;
  final VoidCallback? onHoldButtonTap;
  final VoidCallback? onPlaceOrderButtonTap;

  const PosButtonsWidget({super.key,  this.onClearButtonTap,  this.onHoldButtonTap,  this.onPlaceOrderButtonTap});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CartController>(builder: (cartController) {
      return Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, mainAxisSize: MainAxisSize.min, children: [

        Expanded(
          flex: 2,
          child: CustomButtonWidget(
            onPressed: onClearButtonTap ?? (){},
            buttonText: "clear".tr,
            buttonColor: Theme.of(context).secondaryHeaderColor.withValues(alpha: .05),
            textColor: Theme.of(context).secondaryHeaderColor,
            borderColor: Theme.of(context).secondaryHeaderColor.withValues(alpha: .15),
            isClear: true,
            isBorder: true,
          ),
        ),
        const SizedBox(width: Dimensions.paddingSizeSmall),

        Expanded(
          flex: 2,
          child: CustomButtonWidget(
            onPressed: onHoldButtonTap ?? (){},
            icon: Icons.pause,
            iconColor: context.customThemeColors.holdButtonColor,
            buttonText: "hold".tr,
            buttonColor: Theme.of(context).colorScheme.primary.withValues(alpha: .25),
            textColor: context.customThemeColors.holdButtonColor,
            borderColor: context.customThemeColors.holdButtonColor.withValues(alpha: .3),
            isClear: true,
            isBorder: true,
          ),
        ),
        const SizedBox(width: Dimensions.paddingSizeSmall),

        Expanded(
          flex: 3,
          child: CustomButtonWidget(
            onPressed: onPlaceOrderButtonTap ?? (){},
            buttonText: "place_order".tr,
          ),
        ),
      ]);
    }
    );
  }
}
