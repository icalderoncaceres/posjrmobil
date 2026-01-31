import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:six_pos/common/models/sub_category_model.dart';
import 'package:six_pos/common/widgets/custom_app_bar_widget.dart';
import 'package:six_pos/common/widgets/custom_button_widget.dart';
import 'package:six_pos/common/widgets/custom_drawer_widget.dart';
import 'package:six_pos/features/category/screens/add_new_sub_category_screen.dart';
import 'package:six_pos/features/category/widgets/date_format_widget.dart';
import 'package:six_pos/features/category/widgets/sub_category_status_header_widget.dart';
import 'package:six_pos/helper/delete_dialog_helper.dart';
import 'package:six_pos/helper/extension_helper.dart';
import 'package:six_pos/util/dimensions.dart';
import 'package:six_pos/util/styles.dart';

class SubCategoryDetailsScreen extends StatefulWidget {
  final SubCategories? subCategory;
  final int? index;
  const SubCategoryDetailsScreen({super.key, this.subCategory, this.index});

  @override
  State<SubCategoryDetailsScreen> createState() => _SubCategoryDetailsScreenState();
}

class _SubCategoryDetailsScreenState extends State<SubCategoryDetailsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBarWidget(title: 'sub_category'.tr),
      endDrawer: const CustomDrawerWidget(),
      body: Column(children: [

        SubCategoryStatusHeaderWidget(
          onDeleteButtonTap: ()=> showDeleteSubCategoryDialog(context: context, subCategory: widget.subCategory, fromDetailsScreen: true),
          subCategory: widget.subCategory,
          index: widget.index,
          isShowDeleteButton: true,
        ),
        SizedBox(height: Dimensions.paddingSizeLarge),

        Expanded(child: SingleChildScrollView(child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeLarge),
          child: Column(children: [

            Text('${widget.subCategory?.name}', style: ubuntuMedium.copyWith(fontSize: Dimensions.fontSizeLarge)),
            SizedBox(height: Dimensions.paddingSizeSmall),

            Container(
              width: double.maxFinite,
              padding: EdgeInsets.all(Dimensions.fontSizeSmall),
              decoration: BoxDecoration(
                color: Theme.of(context).hintColor.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(Dimensions.paddingSizeExtraSmall),
              ),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start,children: [

                Text('total_product'.tr, style: ubuntuRegular.copyWith(fontSize: Dimensions.fontSizeSmall, color: context.customThemeColors.textOpacityColor)),
                SizedBox(height: Dimensions.paddingSizeSmall),

                Text('${widget.subCategory?.productCount ?? 0}', style: ubuntuMedium.copyWith(fontSize: Dimensions.fontSizeLarge)),
                SizedBox(height: Dimensions.paddingSizeLarge),

                if(widget.subCategory?.mainCategoryName != null)...[
                  Text('main_category_name'.tr, style: ubuntuRegular.copyWith(fontSize: Dimensions.fontSizeSmall, color: context.customThemeColors.textOpacityColor)),
                  SizedBox(height: Dimensions.paddingSizeSmall),

                  Text('${widget.subCategory?.mainCategoryName}', style: ubuntuMedium.copyWith(fontSize: Dimensions.fontSizeLarge)),
                  SizedBox(height: Dimensions.paddingSizeLarge),
                ],

                Text('created_date'.tr, style: ubuntuRegular.copyWith(fontSize: Dimensions.fontSizeSmall, color: context.customThemeColors.textOpacityColor)),
                SizedBox(height: Dimensions.paddingSizeSmall),

                DateFormatWidget(date: widget.subCategory?.createdAt ?? ''),
                SizedBox(height: Dimensions.paddingSizeLarge),


                Text('last_modified_date'.tr, style: ubuntuRegular.copyWith(fontSize: Dimensions.fontSizeSmall, color: context.customThemeColors.textOpacityColor)),
                SizedBox(height: Dimensions.paddingSizeSmall),

                DateFormatWidget(date: widget.subCategory?.updatedAt ?? ''),

              ]),
            ),
            SizedBox(height: Dimensions.paddingSizeExtraLarge),

          ]),
        ))),

        Container(
          padding: EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeLarge, vertical: Dimensions.fontSizeLarge),
          decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              boxShadow: [BoxShadow(
                offset: Offset(0, -10),
                blurRadius: 10,
                color: Colors.black.withValues(alpha: 0.05),
              )]
          ),
          child: Row(children: [

            Expanded(
              child: CustomButtonWidget(
                buttonText: 'close'.tr,
                isClear: true,
                isButtonTextBold: true,
                textColor: Theme.of(context).textTheme.bodyLarge?.color,
                buttonColor: Theme.of(context).hintColor.withValues(alpha: 0.20),
                onPressed:()=> Navigator.pop(context),
              ),
            ),
            SizedBox(width: Dimensions.paddingSizeLarge),

            Expanded(
              child: CustomButtonWidget(
                buttonText: 'edit_details'.tr,
                isButtonTextBold: true,
                onPressed: ()=> Get.to(AddNewSubCategoryScreen(subCategory: widget.subCategory, index: widget.index, fromDetails: true)),
              ),
            ),

          ]),
        ),

      ]),
    );
  }
}
