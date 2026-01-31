import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:readmore/readmore.dart';
import 'package:six_pos/common/widgets/custom_app_bar_widget.dart';
import 'package:six_pos/common/widgets/custom_button_widget.dart';
import 'package:six_pos/common/widgets/custom_drawer_widget.dart';
import 'package:six_pos/features/category/domain/models/category_model.dart';
import 'package:six_pos/features/category/screens/add_new_category_screen.dart';
import 'package:six_pos/features/category/widgets/category_status_header_widget.dart';
import 'package:six_pos/features/category/widgets/date_format_widget.dart';
import 'package:six_pos/features/product/controllers/product_controller.dart';
import 'package:six_pos/features/splash/controllers/splash_controller.dart';
import 'package:six_pos/helper/delete_dialog_helper.dart';
import 'package:six_pos/helper/extension_helper.dart';
import 'package:six_pos/util/dimensions.dart';
import 'package:six_pos/util/images.dart';
import 'package:six_pos/util/styles.dart';

class CategoryDetailsScreen extends StatefulWidget {
  final Categories? category;
  final int? index;
  const CategoryDetailsScreen({super.key, this.category, this.index});

  @override
  State<CategoryDetailsScreen> createState() => _CategoryDetailsScreenState();
}

class _CategoryDetailsScreenState extends State<CategoryDetailsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBarWidget(title: 'category'.tr),
      endDrawer: const CustomDrawerWidget(),
      body: Column(children: [

        CategoryStatusHeaderWidget(
          onDeleteButtonTap: ()=> showDeleteCategoryDialog(context: context, category: widget.category, fromDetails: true),
          category: widget.category,
          index: widget.index,
          isShowDeleteButton: true,
        ),
        SizedBox(height: Dimensions.paddingSizeLarge),

        Expanded(child: SingleChildScrollView(child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeLarge),
          child: Column(children: [

            ClipRRect(
              borderRadius: BorderRadius.circular(Dimensions.paddingSizeMediumBorder),
              child: FadeInImage.assetNetwork(
                placeholder: Images.placeholder,
                image: '${Get.find<SplashController>().baseUrls!.categoryImageUrl}/${widget.category!.image ?? ''}',
                height: Dimensions.productImageSizeItem, width: Dimensions.productImageSizeItem, fit: BoxFit.cover,
                imageErrorBuilder: (c, o, s) => Image.asset(
                  Images.placeholder,
                  height: Dimensions.productImageSizeItem,
                  width: Dimensions.productImageSizeItem,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            SizedBox(height: Dimensions.paddingSizeSmall),

            Text('${widget.category?.name}', style: ubuntuMedium.copyWith(fontSize: Dimensions.fontSizeLarge)),
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

                Text('${widget.category?.productCount}', style: ubuntuMedium.copyWith(fontSize: Dimensions.fontSizeLarge)),
                SizedBox(height: Dimensions.paddingSizeLarge),


                Text('created_date'.tr, style: ubuntuRegular.copyWith(fontSize: Dimensions.fontSizeSmall, color: context.customThemeColors.textOpacityColor)),
                SizedBox(height: Dimensions.paddingSizeSmall),

                DateFormatWidget(date: widget.category?.createdAt ?? ''),
                SizedBox(height: Dimensions.paddingSizeLarge),


                Text('last_modified_date'.tr, style: ubuntuRegular.copyWith(fontSize: Dimensions.fontSizeSmall, color: context.customThemeColors.textOpacityColor)),
                SizedBox(height: Dimensions.paddingSizeSmall),

                DateFormatWidget(date: widget.category?.updatedAt ?? ''),

              ]),
            ),
            SizedBox(height: Dimensions.paddingSizeExtraLarge),



            Align(
              alignment: Alignment.centerLeft,
              child: Text('description'.tr, style: ubuntuMedium.copyWith(fontSize: Dimensions.fontSizeLarge)),
            ),
            SizedBox(height: Dimensions.paddingSizeSmall),

            ReadMoreText(
              '${widget.category?.description ?? ''}',
              style: ubuntuRegular.copyWith(color: context.customThemeColors.textOpacityColor,),
              trimMode: TrimMode.Line,
              trimLines: 4,
              textAlign: TextAlign.left,
              trimCollapsedText: '   ${'see_more'.tr}',
              trimExpandedText: '   ${'see_less'.tr}',
              moreStyle: ubuntuMedium.copyWith(fontSize: Dimensions.fontSizeDefault, color: context.customThemeColors.downloadFormatColor),
              lessStyle: ubuntuMedium.copyWith(fontSize: Dimensions.fontSizeDefault, color: context.customThemeColors.downloadFormatColor),

            ),


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
                onPressed: ()=> Get.to(()=> AddNewCategoryScreen(category: widget.category, index: widget.index, fromDetails: true)),
              ),
            ),

          ]),
        ),

      ]),
    );
  }
}
