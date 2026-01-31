import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:six_pos/common/widgets/custom_button_widget.dart';
import 'package:six_pos/helper/extension_helper.dart';
import 'package:six_pos/helper/responsive_helper.dart';
import 'package:six_pos/util/dimensions.dart';
import 'package:six_pos/util/images.dart';
import 'package:six_pos/util/styles.dart';

class ConfirmResumeDialogWidget extends StatelessWidget {
  final Function? onYesPressed;
  final Function? onNoPressed;
  const ConfirmResumeDialogWidget({super.key, required this.onYesPressed, this.onNoPressed});

  @override
  Widget build(BuildContext context) {
    Orientation orientation = MediaQuery.of(context).orientation;

    return Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(Dimensions.paddingSizeSmall)),
        child: Container(padding: const EdgeInsets.all(Dimensions.paddingSizeExtraLarge),
          height: ResponsiveHelper.isMobile(context) ? Get.height * 0.32 : ResponsiveHelper.isTab(context)
              ? orientation.name == 'landscape' ? Get.height * 0.55
              : Get.height * 0.2 : Get.height * 0.35,
          child: Column(children: [
            SizedBox(width: 70,height: 70,
              child: Image.asset(Images.confirmPurchase),),
            Text('another_user_already_exists'.tr, style: ubuntuRegular, textAlign: TextAlign.center),
            Padding(
              padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
              child: SizedBox(height: 40,
                child: Row(children: [
                  Expanded(child: CustomButtonWidget(buttonText: 'no'.tr,
                      buttonColor: Theme.of(context).hintColor,textColor: context.customThemeColors.textColor,isClear: true,
                      onPressed: () {
                        if (onNoPressed != null) {
                          onNoPressed!();
                        }
                        Get.back();
                      }
                  )),
                  const SizedBox(width: Dimensions.paddingSizeDefault),
                  Expanded(child: CustomButtonWidget(buttonText: 'yes'.tr, onPressed: (){
                    if (onYesPressed != null) {
                      onYesPressed!();
                    }

                  },)),
                ],),
              ),
            )

          ],),
        ));
  }
}
