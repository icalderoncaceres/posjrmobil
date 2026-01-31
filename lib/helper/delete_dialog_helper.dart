import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:six_pos/common/controllers/category_controller.dart';
import 'package:six_pos/common/models/product_model.dart';
import 'package:six_pos/common/models/sub_category_model.dart';
import 'package:six_pos/features/brand/controllers/brand_controller.dart';
import 'package:six_pos/features/brand/domain/models/brand_model.dart';
import 'package:six_pos/features/brand/widgets/brand_delete_dialog_widget.dart';
import 'package:six_pos/features/category/domain/models/category_model.dart';
import 'package:six_pos/features/category/widgets/sub_category_delete_dialog_widget.dart';
import 'package:six_pos/features/product/controllers/product_controller.dart';
import 'package:six_pos/features/product/widgets/product_delete_dialog_widget.dart';
import 'package:six_pos/features/unit/controllers/unit_controller.dart';
import 'package:six_pos/features/unit/domain/models/unit_model.dart';
import 'package:six_pos/features/unit/widgets/unit_delete_dialog_widget.dart';
import 'package:six_pos/helper/animated_custom_dialog_helper.dart';
import 'package:six_pos/helper/show_custom_snackbar_helper.dart';
import '../features/category/widgets/category_delete_dialog_widget.dart';




void showDeleteCategoryDialog({required BuildContext context, required Categories? category, required bool fromDetails}) {

  if((Get.find<CategoryController>().categoryModel?.categoriesList?.length ?? 0) < 2){
    Get.find<CategoryController>().changeSelectedIndex(null);
  }else{
    if(Get.find<CategoryController>().categoryModel?.categoriesList?[0].id != category?.id){
      Get.find<CategoryController>().changeSelectedIndex(Get.find<CategoryController>().categoryModel?.categoriesList?[0].id);
    }else{
      Get.find<CategoryController>().changeSelectedIndex(Get.find<CategoryController>().categoryModel?.categoriesList?[1].id);
    }
  };

  if(((category?.productCount ?? 0) > 0) && (Get.find<CategoryController>().categoryModel?.categoriesList?.length == 1)){
    showCustomSnackBarHelper('category_delete_validation_error'.tr, isError: true);
  }else{
    showAnimatedDialogHelper(
      context,
      GetBuilder<CategoryController>(
          builder: (categoryController) {
            return CategoryDeleteDialogWidget(
              categoryProductCount: category?.productCount ?? 0,
              category: category,

              onDeleteTap: (){
                if((category?.productCount ?? 0) > 0){
                  if(categoryController.categorySelectedIndex == null){
                    showCustomSnackBarHelper('select_category'.tr, isError: true);
                  }else{
                    categoryController.deleteCategory(category?.id, categoryController.categorySelectedIndex, null, fromDetails);
                  }

                }else{
                  categoryController.deleteCategory(category?.id, null, null, fromDetails);
                }

              },
            );
          }
      ),
    );
  }

}


void showDeleteSubCategoryDialog({required BuildContext context, required SubCategories? subCategory, required bool fromDetailsScreen}) {
  showAnimatedDialogHelper(
    context,
    GetBuilder<CategoryController>(builder: (categoryController) {
      return SubCategoryDeleteDialogWidget(
        productCount: subCategory?.productCount ?? 0,
        subCategory: subCategory,
        onDeleteTap: (){
          if((subCategory?.productCount ?? 0) > 0){
            if(categoryController.shiftedCategoryId == null){
              showCustomSnackBarHelper('select_sub_category'.tr, isError: true);
            }else{
              categoryController.deleteSubCategory(subCategory, categoryController.shiftedCategoryId, categoryController.selectedSubCategoryId, fromDetailsScreen);
            }
          }else{
            categoryController.deleteSubCategory(subCategory, null, null, fromDetailsScreen);
          }
        },
      );
    }),
  );
}


void showDeleteBrandDialog({required BuildContext context, required Brands? brand, required bool fromDetailsScreen}) {
  showAnimatedDialogHelper(
    context,
    GetBuilder<BrandController>(builder: (brandController) {
      return BrandDeleteDialogWidget(
        brandProductCount: brand?.productCount ?? 0,
        brand: brand,
        onDeleteTap: (isShiftDelete){
          if(isShiftDelete){
            brandController.deleteBrand(brand?.id, brandController.selectedBrandId, fromDetailsScreen);
          }else{
            brandController.deleteBrand(brand?.id, null, fromDetailsScreen);
          }
        },
      );
    }),
  );
}


void showDeleteUnitDialog({required BuildContext context, required Units? unit}) {

  if((Get.find<UnitController>().unitList?.length ?? 0) < 2){
    Get.find<UnitController>().onChangeUnitId(null, false);
  }else{
    if(Get.find<UnitController>().unitList?[0].id != unit?.id){
      Get.find<UnitController>().onChangeUnitId(Get.find<UnitController>().unitList?[0].id, false);
    }else{
      Get.find<UnitController>().onChangeUnitId(Get.find<UnitController>().unitList?[1].id, false);
    }
  };

  if(((unit?.productCount ?? 0) > 0) && (Get.find<UnitController>().unitList?.length == 1)){
    showCustomSnackBarHelper('unit_delete_validation_error'.tr, isError: true);
  }else{
    showAnimatedDialogHelper(
      context,
      GetBuilder<UnitController>(builder: (unitController) {
        return UnitDeleteDialogWidget(
          unitProductCount: unit?.productCount ?? 0,
          unit: unit,
          onDeleteTap: (){
            if((unit?.productCount ?? 0) > 0){
              unitController.deleteUnit(unit?.id, unitController.selectedUnitId);
            }else{
              unitController.deleteUnit(unit?.id, null);
            }
          },
        );
      }),
    );
  }

}


void showDeleteProductDialog({required BuildContext context, required Products? product, bool fromDetails = false}) {
  showAnimatedDialogHelper(
    context,
    GetBuilder<ProductController>(builder: (productController) {
      return ProductDeleteDialogWidget(
        product: product,
        title:'are_you_sure_you_want_to_delete_product'.tr,
        description: 'once_you_delete_this_product_it_will_be_lost_permanently'.tr,
        onTapDelete: ()=> productController.deleteProduct(product?.id, fromDetails: fromDetails),
      );
    }),
  );
}