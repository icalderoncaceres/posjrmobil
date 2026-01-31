import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:six_pos/features/splash/controllers/splash_controller.dart';
import 'package:six_pos/helper/extension_helper.dart';
import 'package:six_pos/util/dimensions.dart';
import 'package:six_pos/util/images.dart';
import 'package:six_pos/util/styles.dart';

class CategoryItemWidget extends StatelessWidget {
  final String? title;
  final String? icon;
  final bool isSelected;
  final int index;
  const CategoryItemWidget({super.key, required this.title, required this.icon, required this.isSelected, required this.index});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(Dimensions.paddingSizeMediumBorder),
      width: 110,
      height: 110,
      decoration: BoxDecoration(
        color: isSelected ? Theme.of(context).primaryColor : null,
      ),
      child: Center(
        child: Column(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
          Container(
            height: 65,
            width: 65,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: FadeInImage.assetNetwork(
                placeholder: Images.placeholder, fit: BoxFit.cover,
                image: '${Get.find<SplashController>().baseUrls!.categoryImageUrl}/$icon',
                imageErrorBuilder: (c, o, s) => Image.asset(index == 0 ? Images.allProductImage : Images.placeholder, fit: BoxFit.cover),
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeExtraSmall),
            child: Text(title!.tr, maxLines: 2, overflow: TextOverflow.ellipsis, textAlign: TextAlign.center, style: ubuntuBold.copyWith(
              fontSize: Dimensions.fontSizeSmall,
              color: isSelected ? Theme.of(context).cardColor : context.customThemeColors.titleColor,
            )),
          ),
        ]),
      ),
    );
  }
}