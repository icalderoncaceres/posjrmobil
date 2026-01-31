import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:six_pos/features/product/controllers/product_controller.dart';
import 'package:six_pos/features/splash/controllers/splash_controller.dart';
import 'package:six_pos/features/product/domain/models/limite_stock_product_model.dart';
import 'package:six_pos/helper/extension_helper.dart';
import 'package:six_pos/util/dimensions.dart';
import 'package:six_pos/util/styles.dart';
import 'package:six_pos/helper/animated_custom_dialog_helper.dart';
import 'package:six_pos/common/widgets/custom_image_widget.dart';
import 'package:six_pos/features/product/widgets/product_update_dialog_widget.dart';
import 'package:six_pos/features/user/widgets/custom_divider_widget.dart';
class LimitedStockProductCardViewWidget extends StatelessWidget {
  final StockLimitedProducts? product;
  final bool isHome;
  final int? index;
  const LimitedStockProductCardViewWidget({Key? key, this.product, this.isHome = false, this.index}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bool isOutOfStock = product?.quantity == 0;
    return isHome ?
    Container(padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault), child: Column(children: [

      Row(children: [

        Text('${index! + 1}.', style: ubuntuRegular.copyWith(color: Theme.of(context).primaryColor)),
        const SizedBox(width: Dimensions.paddingSizeLarge),
        Expanded(child: Text('${product!.name}', maxLines: 1,overflow: TextOverflow.ellipsis,
            style: ubuntuRegular.copyWith(color: Theme.of(context).primaryColor))),
        const Spacer(),
        Text('${product!.quantity}', style: ubuntuRegular.copyWith(color: Theme.of(context).primaryColor)),

      ]),
      const SizedBox(height: Dimensions.paddingSizeSmall),

      CustomDividerWidget(color: Theme.of(context).hintColor,height: .5)
    ])) :
    Container(
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        boxShadow: [BoxShadow(
          blurRadius: 5,
          color: Theme.of(context).primaryColor.withValues(alpha: 0.05),
        )],
      ),
      padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeLarge, vertical: Dimensions.paddingSizeDefault),
      child: IntrinsicHeight(child: Row(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.start,children: [

        ClipRRect(
          borderRadius: BorderRadius.circular(Dimensions.paddingSizeMediumBorder),
          child: CustomImageWidget(
            fit: BoxFit.cover,
            height: Dimensions.paddingSizeRevenueBottom,
            width: Dimensions.paddingSizeRevenueBottom,
            image: '${Get.find<SplashController>().baseUrls?.productImageUrl}/${product!.image}',
          ),
        ),
        SizedBox(width: Dimensions.fontSizeSmall),



        Expanded(
          flex: 11,
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.start,children: [
            Text(product?.name ?? '', maxLines: 1, overflow: TextOverflow.ellipsis, style: ubuntuMedium.copyWith(
              color: Theme.of(context).textTheme.bodyLarge?.color,
              fontSize: Dimensions.fontSizeDefault,
            )),
            SizedBox(height:Dimensions.paddingSizeMediumBorder),


            Row(children: [
              Text('Id #${product?.id}',style: ubuntuRegular.copyWith(
                color: context.customThemeColors.textOpacityColor,
                fontSize: Dimensions.fontSizeSmall,
              )),
              SizedBox(width: Dimensions.paddingSizeSmall),

              Container(
                padding: EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeMediumBorder, vertical: Dimensions.paddingSizeBorder),
                decoration: BoxDecoration(
                  color: isOutOfStock
                      ? context.customThemeColors.deleteButtonColor.withValues(alpha: 0.1)
                      : context.customThemeColors.holdButtonColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(Dimensions.paddingSizeBorder),
                ),
                child: Text(isOutOfStock ? 'out_of_stock'.tr : 'low_stock'.tr, style: ubuntuRegular.copyWith(
                  fontSize: Dimensions.fontSizeSmall,
                  color: isOutOfStock
                      ? context.customThemeColors.deleteButtonColor
                      : context.customThemeColors.holdButtonColor,
                )),
              ),
            ]),
          ]),
        ),
        SizedBox(width: Dimensions.fontSizeSmall),



        Expanded(
          flex: 5,
          child: Align(
            alignment: Alignment.center,
            child: GetBuilder<ProductController>(builder: (productController) {
              return InkWell(
                onTap: (){
                  productController.productQuantityController.text = (product?.quantity ?? 0).toString();
                  showAnimatedDialogHelper(context,
                      ProductUpdateDialogWidget(
                        onYesPressed: (){
                          int inputQuantity = int.tryParse(productController.productQuantityController.text.trim()) ?? 0;

                          if(product?.quantity != null) {
                            productController.updateProductQuantity(product?.id, inputQuantity);
                            Get.back();
                          }
                        },
                      ),
                      dismissible: false,
                      isFlip: false
                  );
                },
                child: Container(padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeExtraSmall, vertical: Dimensions.paddingSizeMediumBorder),
                  decoration: BoxDecoration(
                    border: Border.all(width: 1, color: Theme.of(context).hintColor.withValues(alpha: 0.15)),
                    borderRadius: BorderRadius.circular(Dimensions.paddingSizeMediumBorder),

                  ),
                  child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,children: [
                    Text('${product!.quantity}', style: ubuntuRegular.copyWith(
                      fontSize: Dimensions.fontSizeSmall,
                      color: Theme.of(context).textTheme.bodyLarge?.color,
                    )),

                    const Icon(Icons.add_circle, size: Dimensions.paddingSizeDefault),
                  ]),
                ),
              );
            }),
          ),
        ),
      ]),
      ),
    );
  }
}
