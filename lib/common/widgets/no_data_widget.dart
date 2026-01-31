import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:six_pos/common/widgets/custom_asset_image_widget.dart';
import 'package:six_pos/util/dimensions.dart';
import 'package:six_pos/util/images.dart';
import 'package:six_pos/util/styles.dart';


class NoDataWidget extends StatelessWidget {
  final double? fontSize;
  final double? imageSize;
  final String? image;
  final String? text;
  const NoDataWidget({super.key, this.fontSize, this.imageSize, this.image, this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(Dimensions.paddingSizeLarge),
      child: Center(
        child: Column(mainAxisAlignment: MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.center, children: [

          CustomAssetImageWidget(image ?? Images.noDataFound, width: imageSize ?? 150, height: imageSize ?? 150),

          Text(text ?? 'no_data_found'.tr,
            style: ubuntuBold.copyWith(
              color: Theme.of(context).primaryColor,
              fontSize: fontSize ?? MediaQuery.of(context).size.height * 0.023,
            ),
            textAlign: TextAlign.center,
          ),

        ]),
      ),
    );
  }
}
