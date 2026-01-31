import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:six_pos/common/controllers/category_controller.dart';
import 'package:six_pos/common/widgets/custom_asset_image_widget.dart';
import 'package:six_pos/common/widgets/custom_icon_button.dart';
import 'package:six_pos/common/widgets/custom_switch_widget.dart';
import 'package:six_pos/features/category/domain/models/category_model.dart';
import 'package:six_pos/util/dimensions.dart';
import 'package:six_pos/util/images.dart';
import 'package:six_pos/util/styles.dart';

class CategoryStatusHeaderWidget extends StatelessWidget {
  final Categories? category;
  final int? index;
  final bool isShowDeleteButton;
  final bool forLocalChange;
  final Function()? onDeleteButtonTap;
  const CategoryStatusHeaderWidget({super.key, this.category, this.index, this.isShowDeleteButton = false, this.onDeleteButtonTap, this.forLocalChange = false});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeLarge, vertical: Dimensions.paddingSizeSmall).copyWith(right: Dimensions.paddingSizeSmall),
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,children: [

        Text('${'category'.tr} #${category?.id}', style: ubuntuMedium),

        Row(children: [

          if(isShowDeleteButton) ...[
            CustomIconButton(
              onTap: onDeleteButtonTap,
              icon: CustomAssetImageWidget(Images.deleteIcon, height: Dimensions.paddingSizeLarge, width: Dimensions.paddingSizeLarge),
            ),
            SizedBox(width: Dimensions.paddingSizeSmall),
          ],

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

                GetBuilder<CategoryController>(builder: (categoryController) {
                  return CustomSwitchWidget(
                    value: forLocalChange ? categoryController.categoryLocalStatus == 1 : category?.status == 1,
                    activeColor: Theme.of(context).primaryColor,
                    onChanged: (value){
                      if(forLocalChange){
                        categoryController.onChangeCategoryLocalStatus(categoryController.categoryLocalStatus == 1 ? 0 : 1);
                      }else{
                        categoryController.onChangeCategoryStatus(categoryId: category?.id, status: category?.status == 1 ? 0 : 1, index: index);

                      }
                    },
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
