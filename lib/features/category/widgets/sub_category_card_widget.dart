import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:six_pos/common/controllers/category_controller.dart';
import 'package:six_pos/common/enums/menu_pop_up_enum.dart';
import 'package:six_pos/common/models/sub_category_model.dart';
import 'package:six_pos/common/widgets/custom_asset_image_widget.dart';
import 'package:six_pos/common/widgets/custom_menu_item_widget.dart';
import 'package:six_pos/common/widgets/custom_switch_widget.dart';
import 'package:six_pos/features/category/screens/sub_category_details_screen.dart';
import 'package:six_pos/helper/delete_dialog_helper.dart';
import 'package:six_pos/helper/extension_helper.dart';
import 'package:six_pos/util/dimensions.dart';
import 'package:six_pos/util/images.dart';
import 'package:six_pos/util/styles.dart';
import 'package:six_pos/features/category/screens/add_new_sub_category_screen.dart';
class SubCategoryCardWidget extends StatelessWidget {
  final SubCategories? subCategory;
  final int? index;
  const SubCategoryCardWidget({Key? key, this.subCategory, this.index}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: ()=> Get.to(()=> SubCategoryDetailsScreen(subCategory: subCategory, index: index)),
      child: Container(
        decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            boxShadow: [BoxShadow(
              blurRadius: 5,
              color: Theme.of(context).primaryColor.withValues(alpha: 0.05),
            )]
        ),
        padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeLarge, vertical: Dimensions.paddingSizeDefault),
        child: Row(crossAxisAlignment: CrossAxisAlignment.start,children: [

          Expanded(child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,children: [

            Text(subCategory?.name ?? '',maxLines: 2, overflow: TextOverflow.ellipsis, style: ubuntuMedium.copyWith(
              color: Theme.of(context).textTheme.bodyLarge?.color,
              fontSize: Dimensions.fontSizeDefault,
            )),

            Text('Id # ${subCategory?.id}',style: ubuntuRegular.copyWith(
              color: context.customThemeColors.textOpacityColor,
              fontSize: Dimensions.fontSizeSmall,
            )),

            Text('${'total_product'.tr} : ${subCategory?.productCount}',maxLines: 1, overflow: TextOverflow.ellipsis,style: ubuntuRegular.copyWith(
              color: context.customThemeColors.textOpacityColor,
              fontSize: Dimensions.fontSizeDefault,
            )),
          ],
          )),

          SizedBox(
            width: Dimensions.paddingSizeLarge,
            height: Dimensions.paddingSizeLarge,
            child: PopupMenuButton<MenuPopUpEnum>(
              padding: EdgeInsets.zero,
              menuPadding: EdgeInsets.zero,
              icon: Icon(Icons.more_vert, color: context.customThemeColors.textOpacityColor, size: Dimensions.paddingSizeLarge),
              onSelected: (value) {
                switch (value) {
                  case MenuPopUpEnum.status:
                    Get.find<CategoryController>().onChangeSubCategoryStatus(
                      subCategory?.id, subCategory?.status == 1 ? 0 : 1, index
                    );
                    break;
                  case MenuPopUpEnum.details:
                    Get.to(()=> SubCategoryDetailsScreen(subCategory: subCategory, index: index));
                    break;
                  case MenuPopUpEnum.edit:
                    Get.to(()=> AddNewSubCategoryScreen(subCategory: subCategory, index: index));
                    break;
                  case MenuPopUpEnum.delete:
                    showDeleteSubCategoryDialog(context: context, subCategory: subCategory, fromDetailsScreen: false);
                    break;
                  default:
                    break;
                }
              },
              itemBuilder: (BuildContext context) => [
                PopupMenuItem<MenuPopUpEnum>(
                  padding: EdgeInsets.zero,
                  value: MenuPopUpEnum.status,
                  child: CustomMenuItemWidget(
                    padding: EdgeInsets.only(
                      left: Dimensions.paddingSizeDefault,
                      right: Dimensions.paddingSizeMediumBorder,
                      top: Dimensions.paddingSizeMediumBorder,
                      bottom: Dimensions.paddingSizeMediumBorder,
                    ),
                    title: 'status'.tr,
                    backgroundColor: context.customThemeColors.downloadFormatColor.withValues(alpha: 0.05),
                    child: GetBuilder<CategoryController>(builder: (categoryController) {
                      return CustomSwitchWidget(
                        value: subCategory?.status == 1,
                        activeColor: Theme.of(context).primaryColor,
                        onChanged: (value) => categoryController.onChangeSubCategoryStatus(
                          subCategory?.id, subCategory?.status == 1 ? 0 : 1, index
                        ),
                      );
                    }),
                  ),
                ),

                PopupMenuItem<MenuPopUpEnum>(
                  padding: EdgeInsets.zero,
                  value: MenuPopUpEnum.details,
                  child: CustomMenuItemWidget(
                    title: 'details'.tr,
                    child: Icon(Icons.remove_red_eye, color: context.customThemeColors.downloadFormatColor.withValues(alpha: 0.7)),
                  ),
                ),

                PopupMenuItem<MenuPopUpEnum>(
                  padding: EdgeInsets.zero,
                  value: MenuPopUpEnum.edit,
                  child: CustomMenuItemWidget(
                    title: 'edit'.tr,
                    child: Icon(Icons.edit, color: context.customThemeColors.downloadFormatColor),
                  ),
                ),

                PopupMenuItem<MenuPopUpEnum>(
                  padding: EdgeInsets.zero,
                  value: MenuPopUpEnum.delete,
                  child: CustomMenuItemWidget(
                    title: 'delete'.tr,
                    child: CustomAssetImageWidget(Images.deleteIcon, height: Dimensions.paddingSizeLarge, width: Dimensions.paddingSizeLarge),
                  ),
                ),
              ],
            ),
          ),
        ]),
      ),
    );
  }
}
