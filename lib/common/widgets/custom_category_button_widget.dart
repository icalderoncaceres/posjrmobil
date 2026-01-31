import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:six_pos/common/widgets/custom_asset_image_widget.dart';
import 'package:six_pos/features/shop/controllers/profile_controller.dart';
import 'package:six_pos/helper/gradient_color_helper.dart';
import 'package:six_pos/util/dimensions.dart';
import 'package:six_pos/util/styles.dart';

class CustomCategoryButtonWidget extends StatelessWidget {
  final String icon;
  final String buttonText;
  final bool isSelected;
  final double padding;
  final bool isDrawer;
  final Function? onTap;
  final bool? showDivider;
  const CustomCategoryButtonWidget({
    Key? key,
    required this.icon,
    required this.buttonText,
    this.isSelected = false,
    this.padding = Dimensions.paddingSizeDefault,
    this.isDrawer = true, this.onTap,
    this.showDivider = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ProfileController>(
      builder: (profileController) {
        return Column(children: [

          InkWell(onTap: onTap as void Function()?,
            child: Padding(
              padding: isDrawer? const EdgeInsets.all(0.0):
              const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault, vertical: Dimensions.paddingSizeSmall),
              child: Container(width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  borderRadius: isDrawer ? BorderRadius.zero : BorderRadius.circular(Dimensions.paddingSizeSmall),
                  gradient: isSelected ? LinearGradient(
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                    colors: [
                      Theme.of(context).primaryColorLight.withValues(alpha:0.5),
                      Theme.of(context).colorScheme.onError.withValues(alpha:0.2),
                    ],
                  ) : GradientColorHelper.gradientColor(opacity: 0.03),
                ),
                child: Padding(padding: EdgeInsets.symmetric(vertical: padding),
                  child: Column(children: [

                    CustomAssetImageWidget(icon, width: 30,
                      color: isSelected ? Theme.of(context).secondaryHeaderColor : Theme.of(context).primaryColor,
                    ),

                    Text(buttonText, style: ubuntuMedium.copyWith(
                      color: isSelected ?  Theme.of(context).secondaryHeaderColor : Theme.of(context).primaryColor,
                      fontSize: Dimensions.fontSizeExtraLarge,
                    )),

                  ]),
                ),
              ),
            ),
          ),

          if(isDrawer) Divider(height: 3, color: Theme.of(context).cardColor),

        ]);
      }
    );
  }
}
