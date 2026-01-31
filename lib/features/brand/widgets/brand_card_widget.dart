import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:six_pos/common/enums/menu_pop_up_enum.dart';
import 'package:six_pos/common/widgets/custom_asset_image_widget.dart';
import 'package:six_pos/common/widgets/custom_image_widget.dart';
import 'package:six_pos/common/widgets/custom_menu_item_widget.dart';
import 'package:six_pos/common/widgets/custom_switch_widget.dart';
import 'package:six_pos/features/brand/controllers/brand_controller.dart';
import 'package:six_pos/features/brand/screens/brand_details_screen.dart';
import 'package:six_pos/features/splash/controllers/splash_controller.dart';
import 'package:six_pos/features/brand/domain/models/brand_model.dart';
import 'package:six_pos/helper/delete_dialog_helper.dart';
import 'package:six_pos/helper/extension_helper.dart';
import 'package:six_pos/util/dimensions.dart';
import 'package:six_pos/util/images.dart';
import 'package:six_pos/util/styles.dart';
import 'package:six_pos/features/brand/screens/add_new_brand_screen.dart';
class BrandCardWidget extends StatelessWidget {
  final Brands? brand;
  final int? index;
  const BrandCardWidget({Key? key, this.brand, this.index}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: ()=> Get.to(()=> BrandDetailsScreen(brand: brand, index: index)),
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

          ClipRRect(
            borderRadius: BorderRadius.circular(Dimensions.paddingSizeMediumBorder),
            child: CustomImageWidget(
              fit: BoxFit.cover,
              height: Dimensions.paddingSizeRevenueBottom,
              width: Dimensions.paddingSizeRevenueBottom,
              image: '${Get.find<SplashController>().baseUrls?.brandImageUrl}/${brand?.image}',
            ),
          ),
          const SizedBox(width: Dimensions.paddingSizeSmall),

          Expanded(child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,children: [

            Text(brand?.name ?? '',maxLines: 2, overflow: TextOverflow.ellipsis, style: ubuntuMedium.copyWith(
              color: Theme.of(context).textTheme.bodyLarge?.color,
              fontSize: Dimensions.fontSizeDefault,
            )),

            Text('${'total_product'.tr} : ${brand?.productCount}',maxLines: 1, overflow: TextOverflow.ellipsis,style: ubuntuRegular.copyWith(
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
                    Get.find<BrandController>().onChangeBrandStatus(
                      brandId: brand?.id, status: brand?.status == 1 ? 0 : 1, index: index,
                    );
                    break;
                  case MenuPopUpEnum.details:
                    Get.to(()=> BrandDetailsScreen(brand: brand, index: index));
                    break;
                  case MenuPopUpEnum.edit:
                    Get.to(()=> AddNewBrandScreen(brand: brand, index: index));
                    break;
                  case MenuPopUpEnum.delete:
                    showDeleteBrandDialog(context: context, brand: brand, fromDetailsScreen: false);
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
                    child: GetBuilder<BrandController>(builder: (brandController) {
                      return CustomSwitchWidget(
                        value: brand?.status == 1,
                        activeColor: Theme.of(context).primaryColor,
                        onChanged: (value)=>  brandController.onChangeBrandStatus(
                          brandId: brand?.id, status: brand?.status == 1 ? 0 : 1, index: index,
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
