import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:six_pos/common/controllers/category_controller.dart';
import 'package:six_pos/common/controllers/theme_controller.dart';
import 'package:six_pos/common/widgets/no_data_widget.dart';
import 'package:six_pos/util/dimensions.dart';
import 'package:six_pos/features/product/widgets/searched_product_item_widget.dart';
import 'package:six_pos/util/images.dart';
class ProductSearchDialogWidget extends StatelessWidget {
  final TextEditingController? searchTextController;
  const ProductSearchDialogWidget({super.key, this.searchTextController});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CategoryController>(builder: (searchedProductController){
      return searchedProductController.searchedProductList != null && searchedProductController.searchedProductList!.isNotEmpty ?
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault),
        child: Container(height: 400,
          padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
          decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(Dimensions.paddingSizeSmall),
              boxShadow: [BoxShadow(color: Colors.grey[Get.find<ThemeController>().darkTheme ? 800 : 400]!,
                  spreadRadius: .5, blurRadius: 12, offset: const Offset(3,5))]

          ),
          child: ListView.builder(
              itemCount: searchedProductController.searchedProductList!.length,
              physics: const BouncingScrollPhysics(),
              itemBuilder: (ctx,index){
                return SearchedProductItemWidget(product: searchedProductController.searchedProductList![index]);

              }),
        ),
      ) : (searchTextController?.text.isNotEmpty ?? false) ?
      const _NoProductFoundWidget() : const SizedBox.shrink();
    });
  }
}

class _NoProductFoundWidget extends StatelessWidget {
  const _NoProductFoundWidget();

  @override
  Widget build(BuildContext context) {
    final double widthSize = MediaQuery.sizeOf(context).width;

    return Container(
      height: widthSize / 2.5,
      width: widthSize,
      padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
      margin: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeLarge),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(Dimensions.paddingSizeSmall),
          color: Theme.of(context).cardColor
      ),
      child: Container(
        decoration: BoxDecoration(
            color: Theme.of(context).hintColor.withValues(alpha: .125),
            borderRadius: BorderRadius.circular(Dimensions.paddingSizeExtraSmall)
        ),
        child: NoDataWidget(
          text: "no_product_found".tr,
          image: Images.noProductFound,
          imageSize: 50,
          fontSize: Dimensions.fontSizeDefault,
        ),
      ),
    );
  }
}

