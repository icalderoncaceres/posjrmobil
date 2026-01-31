import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:six_pos/helper/extension_helper.dart';
import 'package:six_pos/helper/responsive_helper.dart';
import 'package:six_pos/util/dimensions.dart';
import 'package:six_pos/util/images.dart';
import 'package:six_pos/common/widgets/custom_button_widget.dart';

class ConfirmPurchaseDialogWidget extends StatelessWidget {
  final Function? onYesPressed;
  final String text;
  const ConfirmPurchaseDialogWidget({super.key, required this.onYesPressed, required this.text});

  @override
  Widget build(BuildContext context) {
    return Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(Dimensions.paddingSizeSmall)),
        child: Container(padding: const EdgeInsets.all(Dimensions.paddingSizeExtraLarge),
        width: ResponsiveHelper.isTab(context) ? Get.width * 0.3 : null,
        height: 210,
          child: Column(children: [
          SizedBox(width: 70,height: 70,
            child: Image.asset(Images.confirmPurchase),),
          Text(text),
          Padding(
          padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
          child: SizedBox(height: 40,
            child: Row(children: [
              Expanded(child: CustomButtonWidget(buttonText: 'cancel'.tr,
                  buttonColor: Theme.of(context).hintColor,textColor: context.customThemeColors.textColor,isClear: true,
                  onPressed: ()=>Get.back())),
              const SizedBox(width: Dimensions.paddingSizeDefault),
              Expanded(child: CustomButtonWidget(buttonText: 'yes'.tr, onPressed: (){
                if (onYesPressed != null) {
                  onYesPressed!();
                }
                Get.back(closeOverlays: true);
              },)),
            ],),
          ),
        )

      ],),
    ));
  }
}
