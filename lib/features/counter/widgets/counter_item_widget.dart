import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:six_pos/common/widgets/custom_asset_image_widget.dart';
import 'package:six_pos/common/widgets/custom_dialog_widget.dart';
import 'package:six_pos/common/widgets/custom_horizontal_dotted_widget.dart';
import 'package:six_pos/features/counter/controllers/counter_controller.dart';
import 'package:six_pos/features/counter/domain/models/counter.dart';
import 'package:six_pos/features/counter/screens/counter_details_screen.dart';
import 'package:six_pos/features/counter/screens/counter_setup_screen.dart';
import 'package:six_pos/features/pos/widgets/confirm_purchase_dialog_widget.dart';
import 'package:six_pos/helper/animated_custom_dialog_helper.dart';
import 'package:six_pos/helper/responsive_helper.dart';
import 'package:six_pos/util/dimensions.dart';
import 'package:six_pos/util/images.dart';
import 'package:six_pos/util/styles.dart';

class CounterItemWidget extends StatelessWidget {
  final Counter counter;
  final int index;
  const CounterItemWidget({
    super.key, required this.counter, required this.index
  });

  @override
  Widget build(BuildContext context) {

    return InkWell(
      onTap: () => Get.to(()=> CounterDetailsScreen(counter: counter)),
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(ResponsiveHelper.isTab(context) ? Dimensions.paddingSizeSmall : 0),
          boxShadow: [
            BoxShadow(
              color: Theme.of(context).primaryColor.withValues(alpha: 0.05),
              blurRadius: 5,
            ),
          ],
        ),
        padding: const EdgeInsets.symmetric(
          horizontal: Dimensions.paddingSizeExtraSmall,
          vertical: Dimensions.paddingSizeSmall,
        ),
        child: Column(children: [

          Row(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [

            Expanded(flex: 1,
              child: Align(
                alignment: Alignment.centerLeft,
                child: Container(
                  padding: const EdgeInsets.all(Dimensions.paddingSizeExtraSmall),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Theme.of(context).primaryColor.withValues(alpha: 0.06),
                  ),
                  child: CustomAssetImageWidget(Images.counterListIcon,
                    fit: BoxFit.contain,
                    height: ResponsiveHelper.isTab(context) ? 50 : 35,
                    width: ResponsiveHelper.isTab(context) ? 50 : 35,
                  ),
                ),
              ),
            ),

            Expanded(flex: ResponsiveHelper.isTab(context) ? 8 : 4,
              child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [

                Row(children: [

                  Flexible(
                    child: Text(counter.name ?? '',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: ubuntuRegular.copyWith(
                        fontSize: Dimensions.fontSizeLarge,
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                  ),

                  Text(" - ${counter.number ?? ''}",
                    style: ubuntuRegular.copyWith(
                      fontSize: Dimensions.fontSizeLarge,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),

                ]),

                Row(children: [
                  Expanded(
                    child: Text(counter.description ?? '',
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      style: ubuntuLight.copyWith(
                        fontSize: Dimensions.fontSizeSmall,
                        color: Theme.of(context).hintColor,
                      ),
                    ),
                  ),
                ])

              ]),
            ),

            Expanded(flex: 1,
              child: GetBuilder<CounterController>(
                id: 'change_status_counter',
                builder: (counterController) {
                  return Align(
                    alignment: Alignment.centerRight,
                    child: Transform.scale(
                      scale: 0.7,
                      child: Switch(
                        activeTrackColor: Theme.of(context).primaryColor,
                        activeColor: Theme.of(context).cardColor,
                        value: counter.status == 1,
                        onChanged: (value) async{
                          showAnimatedDialogHelper(context,
                            ConfirmPurchaseDialogWidget(
                              text: 'are_you_sure'.tr,
                              onYesPressed: () async {
                                await counterController.changeStatusCounter(
                                  id: counter.id ?? -1, index: index, status: counter.status == 1 ? 0 : 1,
                                );
                                },
                            ),
                            dismissible: false,
                            isFlip: false,
                          );
                        },
                      ),
                    ),
                  );
                }
              ),
            ),

          ]),
          const SizedBox(height: Dimensions.paddingSizeSmall),

          CustomHorizontalDottedWidget(
            numberOfDashes: ResponsiveHelper.isTab(context) ? 100 : 50,
            dashWidth: 5,
            dashHeight: 1,
            horizontalPadding: Dimensions.paddingSizeSmall,
            dashColor: Theme.of(context).hintColor.withValues(alpha: 0.5),   // Color of the dots
          ),
          const SizedBox(height: Dimensions.paddingSizeDefault),


          Row(mainAxisAlignment: MainAxisAlignment.end, children: [

            InkWell(
              onTap: () => Get.to(()=> CounterDetailsScreen(counter: counter)),
              child: const CustomAssetImageWidget(
                Images.eyeIcon, height: 18,
              ),
            ),
            SizedBox(width: Dimensions.paddingSizeSmall * 3),

            InkWell(onTap: ()=> Get.to(()=> CounterSetupScreen(counter: counter)),
              child: const CustomAssetImageWidget(
                Images.editIcon, height:18,
              ),
            ),
            SizedBox(width: Dimensions.paddingSizeSmall * 3),

            InkWell(onTap: (){
              showAnimatedDialogHelper(context,
                GetBuilder<CounterController>(
                  id: 'delete_counter',
                  builder: (counterController) {
                    return CustomDialogWidget(
                      delete: true,
                      isLoading: counterController.isDeleteButtonLoading,
                      icon: Icons.exit_to_app_rounded, title: '',
                      description: 'are_you_sure_you_want_to_delete_counter'.tr,
                      onTapFalse:() => Navigator.of(context).pop(true),
                      onTapTrue:() async{
                        await counterController.deleteCounter(id: counter.id ?? 0);
                      },
                      onTapTrueText: 'yes'.tr, onTapFalseText: 'cancel'.tr,
                    );
                  }
                ),
                dismissible: false,
                isFlip: true,
              );
            },
              child: const CustomAssetImageWidget(Images.deleteIcon, height: 18),
            ),
            SizedBox(width: Dimensions.paddingSizeSmall),


          ])

        ]),

      ),
    );
  }
}