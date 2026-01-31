import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:readmore/readmore.dart';
import 'package:six_pos/common/widgets/custom_app_bar_widget.dart';
import 'package:six_pos/common/widgets/custom_button_widget.dart';
import 'package:six_pos/common/widgets/custom_drawer_widget.dart';
import 'package:six_pos/features/brand/domain/models/brand_model.dart';
import 'package:six_pos/features/brand/screens/add_new_brand_screen.dart';
import 'package:six_pos/features/brand/widgets/brand_status_header_widget.dart';
import 'package:six_pos/features/category/widgets/date_format_widget.dart';
import 'package:six_pos/features/splash/controllers/splash_controller.dart';
import 'package:six_pos/helper/delete_dialog_helper.dart';
import 'package:six_pos/helper/extension_helper.dart';
import 'package:six_pos/util/dimensions.dart';
import 'package:six_pos/util/images.dart';
import 'package:six_pos/util/styles.dart';

class BrandDetailsScreen extends StatefulWidget {
  final Brands? brand;
  final int? index;
  const BrandDetailsScreen({super.key, required this.brand, this.index});

  @override
  State<BrandDetailsScreen> createState() => _BrandDetailsScreenState();
}

class _BrandDetailsScreenState extends State<BrandDetailsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBarWidget(title: 'brand'.tr),
      endDrawer: const CustomDrawerWidget(),
      body: Column(children: [

        BrandStatusHeaderWidget(
          onDeleteButtonTap: ()=> showDeleteBrandDialog(context: context, brand: widget.brand, fromDetailsScreen: true),
          brand: widget.brand,
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
                image: '${Get.find<SplashController>().baseUrls!.brandImageUrl}/${widget.brand?.image ?? ''}',
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

            Text('${widget.brand?.name}', style: ubuntuMedium.copyWith(fontSize: Dimensions.fontSizeLarge)),
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

                Text('${widget.brand?.productCount}', style: ubuntuMedium.copyWith(fontSize: Dimensions.fontSizeLarge)),
                SizedBox(height: Dimensions.paddingSizeLarge),


                Text('created_date'.tr, style: ubuntuRegular.copyWith(fontSize: Dimensions.fontSizeSmall, color: context.customThemeColors.textOpacityColor)),
                SizedBox(height: Dimensions.paddingSizeSmall),

                DateFormatWidget(date: widget.brand?.createdAt ?? ''),
                SizedBox(height: Dimensions.paddingSizeLarge),


                Text('last_modified_date'.tr, style: ubuntuRegular.copyWith(fontSize: Dimensions.fontSizeSmall, color: context.customThemeColors.textOpacityColor)),
                SizedBox(height: Dimensions.paddingSizeSmall),

                DateFormatWidget(date: widget.brand?.updatedAt ?? ''),

              ]),
            ),
            SizedBox(height: Dimensions.paddingSizeExtraLarge),



            Align(
              alignment: Alignment.centerLeft,
              child: Text('description'.tr, style: ubuntuMedium.copyWith(fontSize: Dimensions.fontSizeLarge)),
            ),
            SizedBox(height: Dimensions.paddingSizeSmall),

            ReadMoreText(
              '${widget.brand?.description ?? ''}',
              style: ubuntuRegular.copyWith(color: context.customThemeColors.textOpacityColor),
              trimMode: TrimMode.Line,
              trimLines: 4,
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
                onPressed: ()=> Get.to(()=> AddNewBrandScreen(brand: widget.brand, index: widget.index, fromDetails: true)),
              ),
            ),

          ]),
        ),

      ]),
    );
  }
}
