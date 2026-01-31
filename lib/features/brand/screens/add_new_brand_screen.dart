import 'dart:io';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:six_pos/common/models/product_model.dart';
import 'package:six_pos/common/widgets/custom_clear_icon_widget.dart';
import 'package:six_pos/features/brand/controllers/brand_controller.dart';
import 'package:six_pos/features/brand/widgets/brand_status_header_widget.dart';
import 'package:six_pos/features/splash/controllers/splash_controller.dart';
import 'package:six_pos/features/brand/domain/models/brand_model.dart';
import 'package:six_pos/helper/extension_helper.dart';
import 'package:six_pos/helper/responsive_helper.dart';
import 'package:six_pos/helper/show_custom_snackbar_helper.dart';
import 'package:six_pos/util/dimensions.dart';
import 'package:six_pos/util/images.dart';
import 'package:six_pos/common/widgets/custom_app_bar_widget.dart';
import 'package:six_pos/common/widgets/custom_button_widget.dart';
import 'package:six_pos/common/widgets/custom_drawer_widget.dart';
import 'package:six_pos/common/widgets/custom_text_field_widget.dart';
import 'package:six_pos/util/styles.dart';

class AddNewBrandScreen extends StatefulWidget {
  final Brands? brand;
  final int? index;
  final bool fromDetails;
  const AddNewBrandScreen({Key? key, this.brand, this.index, this.fromDetails = false}) : super(key: key);

  @override
  State<AddNewBrandScreen> createState() => _AddNewBrandScreenState();
}

class _AddNewBrandScreenState extends State<AddNewBrandScreen> {
  final TextEditingController _brandController = TextEditingController();
  final TextEditingController _descriptionTextController = TextEditingController();
  final FocusNode _brandFocusNode = FocusNode();
  final FocusNode _descriptionFocusNode = FocusNode();

  late bool update;

  @override
  void initState() {
    super.initState();

    Get.find<BrandController>().pickImage(true, isUpdate: false);

    update = widget.brand != null;
    if(update){
      _brandController.text = widget.brand?.name ?? '';
      _descriptionTextController.text = widget.brand?.description ?? '';
      Get.find<BrandController>().brandLocalStatus = widget.brand?.status ?? 0;
      Get.find<BrandController>().setOldBrandImage(widget.brand?.image);
    }
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBarWidget(title: update ? 'edit_brand'.tr : 'brand'.tr),
      endDrawer: const CustomDrawerWidget(),
      body: GetBuilder<BrandController>(builder: (brandController) {
        return Column(crossAxisAlignment: CrossAxisAlignment.start,children: [

          if(!update)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeLarge, vertical: Dimensions.paddingSizeSmall),
              child: Text('add_brand'.tr, style: ubuntuMedium),
            )
          else
            BrandStatusHeaderWidget(brand: widget.brand, index: widget.index, forLocalChange: true),

          Expanded(child: SingleChildScrollView(child: Padding(
            padding: EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeLarge),
            child: Column(crossAxisAlignment : CrossAxisAlignment.start, children: [

              Container(
                padding: EdgeInsets.all(Dimensions.fontSizeSmall),
                decoration: BoxDecoration(
                  color: Theme.of(context).hintColor.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(Dimensions.paddingSizeSmall),
                ),
                child: Column(crossAxisAlignment : CrossAxisAlignment.start, children: [

                  Text.rich(TextSpan(children: [
                    TextSpan(text: 'brand_name'.tr, style: ubuntuRegular.copyWith(
                      fontSize: Dimensions.fontSizeSmall,
                      color: Theme.of(context).textTheme.bodyLarge?.color,
                    )),

                    TextSpan(text: '*', style: ubuntuRegular.copyWith(color: Theme.of(context).colorScheme.error))
                  ])),
                  const SizedBox(height: Dimensions.paddingSizeSmall),

                  CustomTextFieldWidget(
                    controller: _brandController,
                    focusNode: _brandFocusNode,
                    hintText: 'brand_name'.tr,
                    fontSize: Dimensions.fontSizeSmall,
                  ),
                  const SizedBox(height: Dimensions.paddingSizeSmall),


                  Text('description'.tr, style: ubuntuRegular.copyWith(
                    fontSize: Dimensions.fontSizeSmall,
                    color: Theme.of(context).textTheme.bodyLarge?.color,
                  )),
                  const SizedBox(height: Dimensions.paddingSizeSmall),

                  CustomTextFieldWidget(
                    controller: _descriptionTextController,
                    focusNode: _descriptionFocusNode,
                    hintText: 'description'.tr,
                    fontSize: Dimensions.fontSizeSmall,
                    inputType: TextInputType.multiline,
                    inputAction: TextInputAction.newline,
                    maxLines: 3,
                  ),
                  const SizedBox(height: Dimensions.paddingSizeSmall),
                ]),
              ),
              const SizedBox(height: Dimensions.paddingSizeLarge),



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

                  Align(alignment: Alignment.center, child: Stack(clipBehavior: Clip.none, children: [

                        ClipRRect(
                          borderRadius: BorderRadius.circular(Dimensions.paddingSizeMediumBorder),
                          child: brandController.brandImage != null ? Image.file(
                            File(brandController.brandImage!.path),
                            width: Dimensions.productDetailsImageSize,
                            height: Dimensions.productDetailsImageSize,
                            fit: BoxFit.cover,
                          ) : widget.brand != null ? FadeInImage.assetNetwork(
                            placeholder: Images.placeholder,
                            image:
                            '${Get.find<SplashController>().baseUrls!.brandImageUrl}/${widget.brand!.image ?? ''}',
                            height: Dimensions.productDetailsImageSize,
                            width: Dimensions.productDetailsImageSize,
                            fit: BoxFit.cover,
                            imageErrorBuilder: (c, o, s) => Image.asset(
                              Images.placeholder,
                              height: Dimensions.productDetailsImageSize,
                              width: Dimensions.productDetailsImageSize,
                              fit: BoxFit.cover,
                            ),
                          ) : Container(
                            height: Dimensions.productDetailsImageSize,
                            width: Dimensions.productDetailsImageSize,
                            color: Theme.of(context).cardColor,
                          ),
                        ),

                        if (brandController.brandImage == null && widget.brand?.image == null)
                          Positioned.fill(
                            child: InkWell(
                              onTap: () => brandController.pickImage(false),
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

                        if (brandController.brandImage != null || widget.brand?.image != null)
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
                              child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [

                                  CustomClearIconWidget(
                                    onTap: () => brandController.pickImage(false),
                                    size: Dimensions.fontSizeSmall,
                                    backgroundColor: context.customThemeColors.infoColor,
                                    iconColor: Theme.of(context).cardColor,
                                    icons: Icons.edit,
                                  ),

                                  CustomClearIconWidget(
                                    onTap: () {
                                      if (brandController.brandImage != null) {
                                        brandController.pickImage(true);
                                      } else {
                                        brandController.pickOldImage(true, widget.index!);
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
                      ])),
                  SizedBox(height: Dimensions.paddingSizeLarge),

                  Text.rich(TextSpan(children: [
                    TextSpan(text: 'JPG, JPEG, PNG ${'image_size_max'.tr} 5 ${'mb'.tr}', style: ubuntuRegular.copyWith(fontSize: Dimensions.fontSizeExtraSmall)),

                    TextSpan(text: ' (1:1)', style: ubuntuBold.copyWith(fontSize: Dimensions.fontSizeExtraSmall)),
                  ])),
                  SizedBox(height: Dimensions.paddingSizeDefault),

                ]),
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
                  buttonText: 'reset'.tr,
                  isClear: true,
                  isButtonTextBold: true,
                  textColor: Theme.of(context).textTheme.bodyLarge?.color,
                  buttonColor: Theme.of(context).hintColor.withValues(alpha: 0.20),
                  onPressed:()=> {
                    _brandController.text = widget.brand?.name ?? '',
                    _descriptionTextController.text = widget.brand?.description ?? '',
                    brandController.onChangeBrandLocalStatus(widget.brand?.status ?? 0),
                    if(widget.brand != null){
                      brandController.pickOldImage(false, widget.index!)
                    }else{
                      brandController.pickImage(true)
                    }
                  },
                ),
              ),
              SizedBox(width: Dimensions.paddingSizeLarge),

              Expanded(
                child: CustomButtonWidget(
                  isLoading: brandController.isLoading,
                  buttonText: update ? 'update'.tr :'submit'.tr,
                  isButtonTextBold: true,
                  onPressed: (){
                    int? categoryId  =  update ? widget.brand!.id : null;
                    String categoryName  =  _brandController.text.trim();
                    brandController.addBrand(categoryName, categoryId, _descriptionTextController.text.trim(), widget.index).then((value){
                      if(widget.fromDetails){
                        Get.back(closeOverlays: true);
                        showCustomSnackBarHelper('brand_updated_successfully'.tr, isError: false);
                      }
                    });
                  },
                ),
              ),
            ]),
          ),
        ]);
      }),
    );
  }
}
