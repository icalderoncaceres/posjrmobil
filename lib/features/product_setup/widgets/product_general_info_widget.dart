import 'dart:io';
import 'dart:math';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:six_pos/common/widgets/custom_clear_icon_widget.dart';
import 'package:six_pos/features/product/controllers/product_controller.dart';
import 'package:six_pos/features/product_setup/widgets/general_setup_mobile_widget.dart';
import 'package:six_pos/features/product_setup/widgets/general_setup_tab_widget.dart';
import 'package:six_pos/features/splash/controllers/splash_controller.dart';
import 'package:six_pos/common/models/product_model.dart';
import 'package:six_pos/helper/extension_helper.dart';
import 'package:six_pos/helper/responsive_helper.dart';
import 'package:six_pos/util/dimensions.dart';
import 'package:six_pos/util/images.dart';
import 'package:six_pos/util/styles.dart';
import 'package:six_pos/common/widgets/custom_text_field_widget.dart';
import 'package:six_pos/common/widgets/custom_field_with_title_widget.dart';


class ProductGeneralInfoWidget extends StatefulWidget {
  final Products? product;
  final int? index;
  const ProductGeneralInfoWidget({Key? key, this.product, this.index}) : super(key: key);

  @override
  State<ProductGeneralInfoWidget> createState() => _ProductGeneralInfoWidgetState();
}

class _ProductGeneralInfoWidgetState extends State<ProductGeneralInfoWidget> {


  @override
  Widget build(BuildContext context) {
    return GetBuilder<ProductController>(builder: (productController) {
      return SingleChildScrollView(
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

          /// Basic Setup
          Padding(
            padding: const EdgeInsets.all(Dimensions.paddingSizeLarge).copyWith(top: 0),
            child: Text('basic_setup'.tr, style: ubuntuMedium.copyWith(fontSize: Dimensions.fontSizeDefault)),
          ),

          Container(
            padding: const EdgeInsets.all(Dimensions.paddingSizeLarge),
            color: Theme.of(context).cardColor,
            child: Column(children: [

              /// upload image section
              Container(
                padding: EdgeInsets.all(Dimensions.fontSizeSmall),
                decoration: BoxDecoration(
                  color: Theme.of(context).hintColor.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(Dimensions.paddingSizeExtraSmall),
                ),
                child: Column(children: [

                  Padding(
                    padding: const EdgeInsets.all(Dimensions.paddingSizeLarge).copyWith(bottom: Dimensions.paddingSizeSmall),
                    child: Text('upload_image'.tr, style: ubuntuBold),
                  ),
                  const SizedBox(height: Dimensions.paddingSizeSmall),

                  Align(
                    alignment: Alignment.center,
                    child: Stack(
                      clipBehavior: Clip.none,
                      children: [

                        ClipRRect(
                          borderRadius: BorderRadius.circular(Dimensions.paddingSizeMediumBorder),
                          child: productController.productImage != null
                              ? Image.file(
                            File(productController.productImage!.path),
                            width: Dimensions.productDetailsImageSize,
                            height: Dimensions.productDetailsImageSize,
                            fit: BoxFit.cover,
                          )
                              : widget.product != null
                              ? FadeInImage.assetNetwork(
                            placeholder: Images.placeholder,
                            image:
                            '${Get.find<SplashController>().baseUrls!.productImageUrl}/${widget.product!.image ?? ''}',
                            height: Dimensions.productDetailsImageSize,
                            width: Dimensions.productDetailsImageSize,
                            fit: BoxFit.cover,
                            imageErrorBuilder: (c, o, s) => Image.asset(
                              Images.placeholder,
                              height: Dimensions.productDetailsImageSize,
                              width: Dimensions.productDetailsImageSize,
                              fit: BoxFit.cover,
                            ),
                          )
                              : Container(
                            height: Dimensions.productDetailsImageSize,
                            width: Dimensions.productDetailsImageSize,
                            color: Theme.of(context).cardColor,
                          ),
                        ),

                        if (productController.productImage == null && widget.product?.image == null)
                          Positioned.fill(
                            child: InkWell(
                              onTap: () => productController.pickImage(false),
                              child: DottedBorder(
                                padding: EdgeInsets.all(Dimensions.fontSizeLarge),
                                dashPattern: [4, 2],
                                color: Theme.of(context).hintColor.withOpacity(0.5),
                                borderType: BorderType.RRect,
                                radius: Radius.circular(Dimensions.paddingSizeMediumBorder),
                                child: Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(Icons.camera_alt, color: Theme.of(context).primaryColor),
                                      SizedBox(height: Dimensions.paddingSizeMediumBorder),
                                      Text(
                                        'add_image'.tr,
                                        style: ubuntuRegular.copyWith(
                                          fontSize: Dimensions.fontSizeExtraSmall,
                                          color: context.customThemeColors.textOpacityColor,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),

                        if (productController.productImage != null || widget.product?.image != null)
                          Positioned(
                            top: -10, right: 0, left: 0,
                            child: Container(
                              padding: EdgeInsets.all(Dimensions.paddingSizeBorder),
                              margin: EdgeInsets.symmetric(
                                horizontal: ResponsiveHelper.isTab(context)
                                    ? Dimensions.paddingSizeLarge
                                    : Get.width * 0.05,
                              ),
                              decoration: BoxDecoration(
                                color: Theme.of(context).cardColor,
                                borderRadius: BorderRadius.circular(Dimensions.paddingSizeLarge),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  CustomClearIconWidget(
                                    onTap: () => productController.pickImage(false),
                                    size: Dimensions.fontSizeSmall,
                                    backgroundColor: context.customThemeColors.infoColor,
                                    iconColor: Theme.of(context).cardColor,
                                    icons: Icons.edit,
                                  ),
                                  CustomClearIconWidget(
                                    onTap: () {
                                      if (productController.productImage != null) {
                                        productController.pickImage(true);
                                      } else {
                                        productController.pickOldImage(true, widget.index!);
                                      }
                                    },
                                    size: Dimensions.fontSizeSmall,
                                    backgroundColor: Theme.of(context).colorScheme.error,
                                    iconColor: Theme.of(context).cardColor,
                                  ),
                                ],
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                  SizedBox(height: Dimensions.paddingSizeLarge),

                  Text.rich(TextSpan(children: [
                    TextSpan(text: 'JPG, JPEG, PNG ${'image_size_max'.tr} 5 MB', style: ubuntuRegular.copyWith(fontSize: Dimensions.fontSizeExtraSmall)),

                    TextSpan(text: ' (1:1)', style: ubuntuBold.copyWith(fontSize: Dimensions.fontSizeExtraSmall)),
                  ])),
                  SizedBox(height: Dimensions.paddingSizeDefault),

                ]),
              ),
              SizedBox(height: Dimensions.paddingSizeLarge),

              Container(
                padding: EdgeInsets.all(Dimensions.fontSizeSmall),
                decoration: BoxDecoration(
                  color: Theme.of(context).hintColor.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(Dimensions.paddingSizeExtraSmall),
                ),
                child: ResponsiveHelper.isTab(context) ?
                Row(children: [
                  Expanded(
                    child: CustomFieldWithTitleWidget(
                      customTextField: CustomTextFieldWidget(hintText: 'type_product_name'.tr,
                        fontSize: Dimensions.fontSizeSmall,
                        controller: productController.productNameController,
                        contentPadding: Dimensions.paddingSizeDefault,
                      ),
                      title: 'product_name'.tr,
                      requiredField: true,
                      padding: 0,
                    ),
                  ),
                  SizedBox(width: Dimensions.paddingSizeLarge),

                  Expanded(
                    child: CustomFieldWithTitleWidget(
                      customTextField: CustomTextFieldWidget(hintText: 'type_description'.tr,
                        contentPadding: Dimensions.paddingSizeDefault,
                        fontSize: Dimensions.fontSizeSmall,
                        controller: productController.productDescriptionController,
                        inputType: TextInputType.multiline,
                        inputAction: TextInputAction.newline,
                        maxLines: 6,
                      ),
                      title: 'description'.tr,
                      padding: 0,
                    ),
                  ),
                  SizedBox(width: Dimensions.paddingSizeLarge),

                  Expanded(
                    child: CustomFieldWithTitleWidget(
                      onTap: (){
                        var rng = Random();
                        var code = rng.nextInt(900000) + 100000;
                        productController.productSkuController.text = code.toString();
                      },
                      customTextField: CustomTextFieldWidget(hintText: 'sku_hint'.tr,
                        contentPadding: Dimensions.paddingSizeDefault,
                        fontSize: Dimensions.fontSizeSmall,
                        controller: productController.productSkuController,
                      ),
                      title: 'product_sku_code'.tr,
                      requiredField: true,
                      padding: 0,
                    ),
                  ),
                ]) :
                Column(children: [
                  CustomFieldWithTitleWidget(
                    customTextField: CustomTextFieldWidget(hintText: 'type_product_name'.tr,
                      fontSize: Dimensions.fontSizeSmall,
                      controller: productController.productNameController,
                      contentPadding: Dimensions.paddingSizeDefault,
                    ),
                    title: 'product_name'.tr,
                    requiredField: true,
                    padding: 0,
                  ),
                  SizedBox(height: Dimensions.paddingSizeLarge),

                  CustomFieldWithTitleWidget(
                    customTextField: CustomTextFieldWidget(hintText: 'type_description'.tr,
                      contentPadding: Dimensions.paddingSizeDefault,
                      fontSize: Dimensions.fontSizeSmall,
                      controller: productController.productDescriptionController,
                      inputType: TextInputType.multiline,
                      inputAction: TextInputAction.newline,
                      maxLines: 6,
                    ),
                    title: 'description'.tr,
                    padding: 0,
                  ),
                  SizedBox(height: Dimensions.paddingSizeLarge),

                  CustomFieldWithTitleWidget(
                    onTap: (){
                      var rng = Random();
                      var code = rng.nextInt(900000) + 100000;
                      productController.productSkuController.text = code.toString();
                    },
                    customTextField: CustomTextFieldWidget(hintText: 'sku_hint'.tr,
                      contentPadding: Dimensions.paddingSizeDefault,
                      fontSize: Dimensions.fontSizeSmall,
                      controller: productController.productSkuController,
                    ),
                    title: 'product_sku_code'.tr,
                    requiredField: true,
                    padding: 0,
                  ),
                ]),
              )

            ]),
          ),


          /// General Setup
          Padding(
            padding: const EdgeInsets.all(Dimensions.paddingSizeLarge),
            child: Text('general_setup'.tr, style: ubuntuMedium.copyWith(fontSize: Dimensions.fontSizeDefault)),
          ),

          ResponsiveHelper.isTab(context) ?
          GeneralSetupTabWidget() :
          GeneralSetupMobileWidget(),
        ]),
      );
    }
    );
  }
}
