import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:six_pos/common/controllers/category_controller.dart';
import 'package:six_pos/common/widgets/custom_clear_icon_widget.dart';
import 'package:six_pos/common/widgets/custom_field_with_title_widget.dart';
import 'package:six_pos/features/category/widgets/category_status_header_widget.dart';
import 'package:six_pos/features/splash/controllers/splash_controller.dart';
import 'package:six_pos/features/category/domain/models/category_model.dart';
import 'package:six_pos/helper/extension_helper.dart';
import 'package:six_pos/helper/responsive_helper.dart';
import 'package:six_pos/helper/show_custom_snackbar_helper.dart';
import 'package:six_pos/util/dimensions.dart';
import 'package:six_pos/util/images.dart';
import 'package:six_pos/util/styles.dart';
import 'package:six_pos/common/widgets/custom_app_bar_widget.dart';
import 'package:six_pos/common/widgets/custom_button_widget.dart';
import 'package:six_pos/common/widgets/custom_drawer_widget.dart';
import 'package:six_pos/common/widgets/custom_text_field_widget.dart';
class AddNewCategoryScreen extends StatefulWidget {
  final Categories? category;
  final int? index;
  final bool fromDetails;
  const AddNewCategoryScreen({Key? key, this.category, this.index, this.fromDetails = false}) : super(key: key);

  @override
  State<AddNewCategoryScreen> createState() => _AddNewCategoryScreenState();
}

class _AddNewCategoryScreenState extends State<AddNewCategoryScreen> {
  final TextEditingController _categoryController = TextEditingController();
  final TextEditingController _descriptionTextController = TextEditingController();
  final FocusNode _categoryFocusNode = FocusNode();
  final FocusNode _descriptionFocusNode = FocusNode();
  late bool update;


  @override
  void initState() {
    super.initState();

    Get.find<CategoryController>().pickImage(true, isUpdate: false);

    update = widget.category != null;
    if(update){
      _categoryController.text = widget.category?.name ?? '';
      _descriptionTextController.text = widget.category?.description ?? '';
      Get.find<CategoryController>().categoryLocalStatus = widget.category?.status ?? 0;
      Get.find<CategoryController>().setOldCategoryImage(widget.category?.image);
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBarWidget(title: update ? 'edit_category'.tr : 'category'.tr),
      endDrawer: const CustomDrawerWidget(),
      body: GetBuilder<CategoryController>(builder: (categoryController) {
        return Column(crossAxisAlignment: CrossAxisAlignment.start,children: [

          if(!update)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeLarge, vertical: Dimensions.paddingSizeSmall),
              child: Text('add_category'.tr, style: ubuntuMedium),
            )
          else
            CategoryStatusHeaderWidget(category: widget.category, index: widget.index, forLocalChange: true),

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

                  CustomFieldWithTitleWidget(
                    padding: 0,
                    title: 'category_name'.tr,
                    requiredField: true,
                    customTextField: CustomTextFieldWidget(
                      controller: _categoryController,
                      focusNode: _categoryFocusNode,
                      hintText: 'type_category_name'.tr,
                      fontSize: Dimensions.fontSizeSmall,
                    ),
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
                    hintText: 'type_description'.tr,
                    fontSize: Dimensions.fontSizeSmall,
                    inputType: TextInputType.multiline,
                    inputAction: TextInputAction.newline,
                    maxLines: 6,
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


                  Align(
                    alignment: Alignment.center,
                    child: Stack(
                      clipBehavior: Clip.none,  // important: allow overflow if needed
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(Dimensions.paddingSizeMediumBorder),
                          child: categoryController.categoryImage != null ? Image.file(
                            File(categoryController.categoryImage!.path),
                            width: 120,
                            height: 120,
                            fit: BoxFit.cover,
                          ) : widget.category != null ? FadeInImage.assetNetwork(
                            placeholder: Images.placeholder,
                            image:
                            '${Get.find<SplashController>().baseUrls!.categoryImageUrl}/${widget.category!.image ?? ''}',
                            height: 120,
                            width: 120,
                            fit: BoxFit.cover,
                            imageErrorBuilder: (c, o, s) => Image.asset(
                              Images.placeholder,
                              height: 120,
                              width: 120,
                              fit: BoxFit.cover,
                            ),
                          ) : Container(
                            height: 120,
                            width: 120,
                            color: Theme.of(context).cardColor,
                          ),
                        ),

                        if (categoryController.categoryImage == null && widget.category?.image == null)
                          Positioned.fill(
                            child: InkWell(
                              onTap: () => categoryController.pickImage(false),
                              child: DottedBorder(
                                padding: EdgeInsets.all(Dimensions.fontSizeLarge),
                                dashPattern: [4, 2],
                                color: Theme.of(context).hintColor.withValues(alpha: 0.5),
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

                        if (categoryController.categoryImage != null || widget.category?.image != null)
                          Positioned(
                            top: -10, right: 0, left: 0,
                            child: Container(
                              padding: EdgeInsets.all(Dimensions.paddingSizeBorder),
                              margin: EdgeInsets.symmetric(horizontal: ResponsiveHelper.isTab(context) ? Dimensions.paddingSizeLarge : Get.width * 0.05),
                              decoration: BoxDecoration(
                                color: Theme.of(context).cardColor,
                                borderRadius: BorderRadius.circular(Dimensions.paddingSizeLarge),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black26,
                                    blurRadius: 5,
                                    offset: Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  CustomClearIconWidget(
                                    onTap: () => categoryController.pickImage(false),
                                    size: Dimensions.fontSizeSmall,
                                    backgroundColor: context.customThemeColors.infoColor,
                                    iconColor: Theme.of(context).cardColor,
                                    icons: Icons.edit,
                                  ),
                                  CustomClearIconWidget(
                                    onTap: () {
                                      if (categoryController.categoryImage != null) {
                                        categoryController.pickImage(true);
                                      } else {
                                        categoryController.pickOldImage(true, widget.index!);
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
                    _descriptionTextController.text = widget.category?.description ?? '',
                    _categoryController.text = widget.category?.name ?? '',
                    categoryController.onChangeCategoryLocalStatus(widget.category?.status ?? 0),
                    if(widget.category != null){
                      categoryController.pickOldImage(false, widget.index!),
                    }else{
                      categoryController.pickImage(true)
                    }
                  },
                ),
              ),
              SizedBox(width: Dimensions.paddingSizeLarge),

              Expanded(
                child: CustomButtonWidget(
                  isLoading: categoryController.isLoading,
                  buttonText: update ? 'update'.tr :'submit'.tr,
                  isButtonTextBold: true,
                  onPressed: (){
                    int? categoryId  =  update? widget.category!.id : null;
                    String categoryName  =  _categoryController.text.trim();
                    categoryController.addCategory(categoryName, categoryId, update, _descriptionTextController.text, widget.index).then((value){
                      if(widget.fromDetails){
                        Get.back(closeOverlays: true);
                        showCustomSnackBarHelper('category_updated_successfully'.tr, isError: false);
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
