import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:six_pos/common/models/product_model.dart';
import 'package:six_pos/common/widgets/custom_asset_image_widget.dart';
import 'package:six_pos/common/widgets/custom_icon_button.dart';
import 'package:six_pos/common/widgets/custom_switch_widget.dart';
import 'package:six_pos/features/brand/controllers/brand_controller.dart';
import 'package:six_pos/features/product/controllers/product_controller.dart';
import 'package:six_pos/util/dimensions.dart';
import 'package:six_pos/util/images.dart';
import 'package:six_pos/util/styles.dart';

class ProductStatusHeaderWidget extends StatelessWidget {
  final Products? product;
  final int? index;
  final bool isShowButton;
  final Function()? onDeleteButtonTap;
  final Function()? onEditButtonTap;
  const ProductStatusHeaderWidget({super.key,  this.product, this.index, this.isShowButton = true, this.onDeleteButtonTap, this.onEditButtonTap,});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeLarge, vertical: Dimensions.paddingSizeSmall).copyWith(
        right: Dimensions.paddingSizeSmall,
        bottom: 0,
      ),
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,children: [

        Text('product_details'.tr, style: ubuntuMedium),

        Row(children: [

          if(isShowButton) ...[
            CustomIconButton(
              onTap: onDeleteButtonTap,
              icon: CustomAssetImageWidget(Images.deleteIcon, height: Dimensions.paddingSizeLarge, width: Dimensions.paddingSizeLarge),
            ),
            SizedBox(width: Dimensions.paddingSizeDefault),
          ],

          if(isShowButton) ...[
            CustomIconButton(
              onTap: onEditButtonTap,
              icon: Icon(Icons.edit, color: Theme.of(context).primaryColor, size: Dimensions.paddingSizeLarge),
            ),
            SizedBox(width: Dimensions.paddingSizeMediumBorder),
          ],

          Transform.scale(
            scale: 0.82,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeMediumBorder),
              decoration: BoxDecoration(
                border: Border.all(width: 1, color: Colors.black.withValues(alpha: 0.1)),
                borderRadius: BorderRadius.circular(Dimensions.paddingSizeMediumBorder),
              ),
              child: GetBuilder<ProductController>(builder: (productController) {
                    return CustomSwitchWidget(
                      value: product?.status == 1,
                      activeColor: Theme.of(context).primaryColor,
                      onChanged: (value) {
                         productController.onChangeProductStatus(
                          productId: product?.id, status: product?.status == 1 ? 0 : 1, index: index,
                        );
                      },
                    );
                  }
              ),
            ),
          ),
        ])
      ]),
    );
  }
}
