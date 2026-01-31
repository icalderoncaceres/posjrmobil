import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:six_pos/common/controllers/category_controller.dart';
import 'package:six_pos/common/models/sub_category_model.dart';
import 'package:six_pos/common/widgets/custom_field_with_title_widget.dart';
import 'package:six_pos/features/category/domain/models/category_model.dart';
import 'package:six_pos/features/category/widgets/sub_category_status_header_widget.dart';
import 'package:six_pos/helper/show_custom_snackbar_helper.dart';
import 'package:six_pos/util/dimensions.dart';
import 'package:six_pos/util/styles.dart';
import 'package:six_pos/common/widgets/custom_app_bar_widget.dart';
import 'package:six_pos/common/widgets/custom_button_widget.dart';
import 'package:six_pos/common/widgets/custom_drawer_widget.dart';
import 'package:six_pos/common/widgets/custom_text_field_widget.dart';
class AddNewSubCategoryScreen extends StatefulWidget {
  final SubCategories? subCategory;
  final int? index;
  final bool fromDetails;
  const AddNewSubCategoryScreen({Key? key, this.subCategory, this.index, this.fromDetails = false}) : super(key: key);

  @override
  State<AddNewSubCategoryScreen> createState() => _AddNewSubCategoryScreenState();
}

class _AddNewSubCategoryScreenState extends State<AddNewSubCategoryScreen> {
  final TextEditingController _subCategoryController = TextEditingController();
  final FocusNode _subCategoryFocusNode = FocusNode();
  int? parentCategoryId = 0;
  String  parentCategoryName = '';
  late bool update;



  @override
  void initState() {
    super.initState();

    update = widget.subCategory != null;
    if(update){
      _subCategoryController.text = widget.subCategory?.name ?? '';
      parentCategoryId = widget.subCategory?.parentId;
      Get.find<CategoryController>().subCategoryLocalStatus = widget.subCategory?.status ?? 0;
    }

  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      endDrawer: const CustomDrawerWidget(),
      appBar: CustomAppBarWidget(title: update ? 'edit_sub_category'.tr : 'sub_category'.tr),
      body: GetBuilder<CategoryController>(builder: (categoryController) {
        return Column(crossAxisAlignment: CrossAxisAlignment.start,children: [

          if(!update)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeLarge, vertical: Dimensions.paddingSizeSmall),
              child: Text('add_sub_category'.tr, style: ubuntuMedium),
            )
          else
            SubCategoryStatusHeaderWidget(subCategory: widget.subCategory, index: widget.index, forLocalChange: true),

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
                    title: 'sub_category_name'.tr,
                    requiredField: true,
                    customTextField: CustomTextFieldWidget(
                      controller: _subCategoryController,
                      focusNode: _subCategoryFocusNode,
                      hintText: 'type_sub_category_name'.tr,
                      fontSize: Dimensions.fontSizeSmall,
                      contentPadding: Dimensions.paddingSizeDefault,
                    ),
                  ),
                  const SizedBox(height: Dimensions.paddingSizeLarge),


                  Text.rich(TextSpan(children: [
                    TextSpan(text: 'main_category'.tr, style: ubuntuRegular.copyWith(
                      fontSize: Dimensions.fontSizeSmall,
                      color: Theme.of(context).textTheme.bodyLarge?.color,
                    )),

                    TextSpan(text: ' *', style: ubuntuBold.copyWith(color: Theme.of(context).colorScheme.error))
                  ])),
                  const SizedBox(height: Dimensions.paddingSizeSmall),

                  Container(
                    padding: const EdgeInsets.symmetric(horizontal:Dimensions.paddingSizeSmall),
                    decoration: BoxDecoration(color: Theme.of(context).cardColor,
                        border: Border.all(width: .5, color: Theme.of(context).hintColor.withValues(alpha:.7)),
                        borderRadius: BorderRadius.circular(Dimensions.paddingSizeMediumBorder)),
                    child: DropdownButton<int>(
                      hint: Text('select'.tr, style: ubuntuRegular.copyWith(
                          fontSize:Dimensions.fontSizeSmall,
                          color: Theme.of(context).textTheme.bodyLarge?.color,
                      )),
                      value: categoryController.selectedCategoryId,
                      items: categoryController.categoryModel?.categoriesList?.map((Categories? value) {
                        return DropdownMenuItem<int>(
                          value: value?.id,
                          child: Text('${value?.name}', style: ubuntuRegular.copyWith(
                            fontSize:Dimensions.fontSizeSmall,
                            color: Theme.of(context).textTheme.bodyLarge?.color,
                          )),
                        );
                      }).toList(),
                      onChanged: (int? value) {
                        categoryController.setCategoryIndex(value ?? 0, true);
                      },
                      isExpanded: true,
                      underline: const SizedBox(),
                      iconEnabledColor: Theme.of(context).hintColor,
                    ),
                  ),
                  const SizedBox(height: Dimensions.paddingSizeSmall),
                ]),
              ),
              const SizedBox(height: Dimensions.paddingSizeLarge),
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
                  onPressed:(){
                    setState(() {
                      _subCategoryController.text = widget.subCategory?.name ?? '';
                      parentCategoryId = widget.subCategory?.parentId;
                      categoryController.onChangeSubCategoryLocalStatus(widget.subCategory?.status ?? 0);
                      categoryController.setCategoryIndex(parentCategoryId ?? categoryController.categoryModel?.categoriesList?[0].id, false);
                    });
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
                    if(categoryController.selectedCategoryId != null && (categoryController.categoryModel?.categoriesList?.isNotEmpty ?? false)){
                      String subCategoryName  = _subCategoryController.text.trim();
                      int? parentId = categoryController.selectedCategoryId!;
                      int? id = update? widget.subCategory?.id : null;
                      categoryController.addSubCategory(subCategoryName, id,parentId, update).then((value){
                        if(widget.fromDetails){
                          Get.back(closeOverlays: true);
                          showCustomSnackBarHelper('sub_category_update_successfully'.tr, isError: false);
                        }
                      });
                    }else{
                      showCustomSnackBarHelper('select_category'.tr);
                    }
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
