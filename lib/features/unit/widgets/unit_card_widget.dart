import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:six_pos/common/enums/menu_pop_up_enum.dart';
import 'package:six_pos/common/widgets/custom_asset_image_widget.dart';
import 'package:six_pos/common/widgets/custom_menu_item_widget.dart';
import 'package:six_pos/common/widgets/custom_switch_widget.dart';
import 'package:six_pos/features/unit/controllers/unit_controller.dart';
import 'package:six_pos/features/unit/domain/models/unit_model.dart';
import 'package:six_pos/helper/delete_dialog_helper.dart';
import 'package:six_pos/helper/extension_helper.dart';
import 'package:six_pos/util/dimensions.dart';
import 'package:six_pos/util/images.dart';
import 'package:six_pos/util/styles.dart';
import 'package:six_pos/features/unit/screens/add_new_unit_screen.dart';
class UnitCardWidget extends StatelessWidget {
  final Units? unit;
  final int? index;
  const UnitCardWidget({Key? key, this.unit, this.index}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
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

          Text(unit?.unitType ?? '',maxLines: 2, overflow: TextOverflow.ellipsis, style: ubuntuMedium.copyWith(
            color: Theme.of(context).textTheme.bodyLarge?.color,
            fontSize: Dimensions.fontSizeDefault,
          )),

          Text('${'total_product'.tr} : ${unit?.productCount ?? 0}',maxLines: 1, overflow: TextOverflow.ellipsis,style: ubuntuRegular.copyWith(
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
                  Get.find<UnitController>().onChangeUnitStatus(
                    unitId: unit?.id, status: unit?.status == 1 ? 0 : 1, index: index,
                  );
                  break;
                case MenuPopUpEnum.details:
                  break;
                case MenuPopUpEnum.edit:
                  Get.to(()=> AddNewUnitScreen(unit: unit, index: index));
                  break;
                case MenuPopUpEnum.delete:
                  showDeleteUnitDialog(context: context, unit: unit);
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
                  child: GetBuilder<UnitController>(builder: (unitController) {
                    return CustomSwitchWidget(
                      value: unit?.status == 1,
                      activeColor: Theme.of(context).primaryColor,
                      onChanged: (value){
                        Get.find<UnitController>().onChangeUnitStatus(
                          unitId: unit?.id, status: unit?.status == 1 ? 0 : 1, index: index,
                        );
                        },
                    );
                  }),
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
    );
  }
}
