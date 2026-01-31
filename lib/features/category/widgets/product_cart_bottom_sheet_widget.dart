import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:six_pos/common/controllers/cart_controller.dart';
import 'package:six_pos/common/models/cart_model.dart';
import 'package:six_pos/common/widgets/custom_button_widget.dart';
import 'package:six_pos/common/widgets/custom_image_widget.dart';
import 'package:six_pos/features/product/controllers/product_controller.dart';
import 'package:six_pos/features/product/domain/models/categories_product_model.dart';
import 'package:six_pos/features/splash/controllers/splash_controller.dart';
import 'package:six_pos/helper/extension_helper.dart';
import 'package:six_pos/helper/price_converter_helper.dart';
import 'package:six_pos/helper/responsive_helper.dart';
import 'package:six_pos/helper/show_custom_snackbar_helper.dart';
import 'package:six_pos/util/dimensions.dart';
import 'package:six_pos/util/images.dart';
import 'package:six_pos/util/styles.dart';

class ProductCartBottomSheetWidget extends StatelessWidget {
  final CategoriesProduct? product;
  const ProductCartBottomSheetWidget({super.key, this.product});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SizedBox(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _ProductDetailsWidget(product: product),

            if (ResponsiveHelper.isTab(context))
              const SizedBox(height: Dimensions.paddingSizeExtraLarge),

            Container(
              color: Theme.of(context).hintColor.withValues(alpha: 0.1),
              padding: const EdgeInsets.symmetric(
                horizontal: Dimensions.paddingSizeExtraLarge,
                vertical: Dimensions.paddingSizeDefault,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (!ResponsiveHelper.isTab(context)) ...[
                    _ProductTotalPriceWidget(product: product),
                    const SizedBox(height: Dimensions.paddingSizeSmall),
                  ],

                  Row(
                    children: [
                      if (ResponsiveHelper.isTab(context)) ...[
                        Expanded(
                          flex: 4,
                          child: _ProductTotalPriceWidget(product: product),
                        ),
                        const SizedBox(width: Dimensions.paddingSizeSmall),
                      ],

                      Expanded(
                        flex: ResponsiveHelper.isTab(context) ? 2 : 3,
                        child: _ItemCountIncreaseDecreaseWidget(
                          product: product,
                        ),
                      ),
                      const SizedBox(width: Dimensions.paddingSizeSmall),

                      Expanded(
                        flex: ResponsiveHelper.isTab(context) ? 5 : 7,
                        child: GetBuilder<CartController>(
                          builder: (cartController) {
                            return CustomButtonWidget(
                              onPressed: () {
                                CartModel cartModel = CartModel(
                                  product?.sellingPrice,
                                  product?.discount,
                                  Get.find<ProductController>().itemQuantity,
                                  product?.tax,
                                  product,
                                );
                                cartController.addToCart(cartModel).then((_) {
                                  Get.back();
                                });
                              },
                              buttonText: "add_to_cart".tr,
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ItemCountIncreaseDecreaseWidget extends StatelessWidget {
  final CategoriesProduct? product;
  const _ItemCountIncreaseDecreaseWidget({required this.product});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ProductController>(
      builder: (productController) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            InkWell(
              onTap: () => productController.onUpdateItemQuantity(false),
              child: Icon(
                Icons.remove_circle,
                color: productController.itemQuantity == 1
                    ? Theme.of(context).cardColor
                    : Theme.of(context).primaryColor,
                size: Dimensions.dropDownHeight,
              ),
            ),

            Text(
              "${productController.itemQuantity}",
              style: ubuntuRegular.copyWith(
                color: context.customThemeColors.textColor,
                overflow: TextOverflow.ellipsis,
                fontSize: Dimensions.fontSizeLarge,
              ),
              maxLines: 1,
            ),

            InkWell(
              onTap: () {
                if ((product?.quantity ?? 0) <=
                    Get.find<ProductController>().itemQuantity) {
                  showCustomSnackBarHelper('out_of_stock'.tr, isError: true);
                } else {
                  productController.onUpdateItemQuantity(true);
                }
              },
              child: Icon(
                Icons.add_circle,
                color: Theme.of(context).primaryColor,
                size: Dimensions.dropDownHeight,
              ),
            ),
          ],
        );
      },
    );
  }
}

class _ProductDetailsWidget extends StatelessWidget {
  const _ProductDetailsWidget({required this.product});
  final CategoriesProduct? product;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: Dimensions.paddingSizeLarge,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(
              vertical: Dimensions.paddingSizeSmall,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  height: 5,
                  width: Dimensions.iconSizeExtraLarge,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(25),
                    color: Theme.of(context).hintColor.withValues(alpha: .5),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: Dimensions.paddingSizeDefault),

          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: Dimensions.productCartImageSize,
                height: Dimensions.productCartImageSize,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(
                    Dimensions.fontSizeExtraLarge,
                  ),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(
                    Dimensions.fontSizeExtraLarge,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(Dimensions.paddingSizeBorder),
                    child: CustomImageWidget(
                      fit: BoxFit.cover,
                      placeholder: Images.placeholder,
                      image:
                          '${Get.find<SplashController>().baseUrls!.productImageUrl}/${product!.image}',
                    ),
                  ),
                ),
              ),
              const SizedBox(width: Dimensions.paddingSizeDefault),

              Flexible(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Flexible(
                      child: Text(
                        product?.title ?? '',
                        style: ubuntuRegular.copyWith(
                          fontSize: Dimensions.fontSizeDefault,
                          color: context.customThemeColors.textColor,
                        ),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                      ),
                    ),
                    const SizedBox(height: Dimensions.paddingSizeSmall),

                    Row(
                      spacing: Dimensions.paddingSizeSmall,
                      children: [
                        Text.rich(
                          TextSpan(
                            children: [
                              TextSpan(
                                text: '${"sku".tr}: ',
                                style: ubuntuRegular.copyWith(
                                  color: context.customThemeColors.textColor,
                                ),
                              ),

                              TextSpan(
                                text: "${product?.productCode}",
                                style: ubuntuBold.copyWith(
                                  color: context.customThemeColors.textColor,
                                ),
                              ),
                            ],
                          ),
                        ),

                        Container(
                          height: Dimensions.paddingSizeSmall,
                          width: 1,
                          color: context.customThemeColors.textColor,
                        ),

                        Flexible(
                          child: Text.rich(
                            TextSpan(
                              children: [
                                TextSpan(
                                  text: '${"unit".tr}: ',
                                  style: ubuntuRegular.copyWith(
                                    color: context.customThemeColors.textColor,
                                  ),
                                ),

                                TextSpan(
                                  text:
                                      "${product?.unitValue ?? 0} ${product?.unitType?.unitType}",
                                  style: ubuntuBold.copyWith(
                                    color: context.customThemeColors.textColor,
                                  ),
                                ),
                              ],
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),

                    Row(
                      children: [
                        (product?.discount ?? 0) > 0
                            ? Text(
                                PriceConverterHelper.priceWithSymbol(
                                  product!.sellingPrice!,
                                ),
                                style: ubuntuRegular.copyWith(
                                  fontSize: Dimensions.fontSizeSmall,
                                  color: context.customThemeColors.textColor,
                                  decoration: TextDecoration.lineThrough,
                                  decorationColor:
                                      context.customThemeColors.textColor,
                                ),
                              )
                            : const SizedBox(),
                        const SizedBox(
                          width: Dimensions.paddingSizeMediumBorder,
                        ),

                        Text(
                          PriceConverterHelper.convertPrice(
                            context,
                            product!.sellingPrice,
                            discount: product!.discount,
                            discountType: product!.discountType,
                          ),
                          style: ubuntuBold.copyWith(
                            fontSize: Dimensions.fontSizeLarge,
                            color: Theme.of(context).primaryColor,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              if (ResponsiveHelper.isTab(context)) ...[
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(
                      left: Dimensions.paddingSizeSmall,
                      top: Dimensions.paddingSizeBorder,
                    ),
                    child: _CategoryBrandWidget(product: product),
                  ),
                ),
              ],
            ],
          ),

          if (!ResponsiveHelper.isTab(context)) ...[
            Padding(
              padding: const EdgeInsets.symmetric(
                vertical: Dimensions.paddingSizeSmall,
              ),
              child: _CategoryBrandWidget(product: product),
            ),
          ],
        ],
      ),
    );
  }
}

class _CategoryBrandWidget extends StatelessWidget {
  final CategoriesProduct? product;
  const _CategoryBrandWidget({this.product});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              '${"categories".tr}: ',
              style: ubuntuRegular.copyWith(
                color: Theme.of(context).hintColor,
                fontSize: ResponsiveHelper.isTab(context)
                    ? Dimensions.fontSizeExtraSmall
                    : Dimensions.fontSizeDefault,
              ),
            ),

            Text(
              "${product?.category?.name}",
              style: ubuntuBold.copyWith(
                fontSize: ResponsiveHelper.isTab(context)
                    ? Dimensions.fontSizeExtraSmall
                    : Dimensions.fontSizeDefault,
                overflow: TextOverflow.ellipsis,
                color: context.customThemeColors.textColor,
              ),
              maxLines: 1,
            ),
          ],
        ),
        SizedBox(
          width: ResponsiveHelper.isTab(context)
              ? Dimensions.paddingSizeSmall
              : Dimensions.paddingSizeExtraLarge,
        ),

        if (product?.brand?.name != null)
          Flexible(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  '${"brands".tr}: ',
                  style: ubuntuRegular.copyWith(
                    color: Theme.of(context).hintColor,
                    fontSize: ResponsiveHelper.isTab(context)
                        ? Dimensions.fontSizeExtraSmall
                        : Dimensions.fontSizeDefault,
                  ),
                ),

                Flexible(
                  child: Text(
                    "${product?.brand?.name}",
                    style: ubuntuBold.copyWith(
                      fontSize: ResponsiveHelper.isTab(context)
                          ? Dimensions.fontSizeExtraSmall
                          : Dimensions.fontSizeDefault,
                      overflow: TextOverflow.ellipsis,
                      color: context.customThemeColors.textColor,
                    ),
                    maxLines: 1,
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }
}

class _ProductTotalPriceWidget extends StatelessWidget {
  final CategoriesProduct? product;
  const _ProductTotalPriceWidget({this.product});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text.rich(
          TextSpan(
            children: [
              TextSpan(
                text: "total".tr,
                style: ubuntuBold.copyWith(
                  fontSize: Dimensions.fontSizeDefault,
                  color: Theme.of(context).primaryColor,
                ),
              ),

              TextSpan(
                text: ' (${"including_vat_tax".tr})',
                style: ubuntuBold.copyWith(
                  color: Theme.of(context).hintColor,
                  fontSize: Dimensions.fontSizeExtraSmall,
                ),
              ),
            ],
          ),
        ),

        Expanded(
          child: Text(
            PriceConverterHelper.priceWithSymbol(product!.sellingPrice!),
            style: ubuntuBold.copyWith(
              fontSize: Dimensions.fontSizeDefault,
              color: Theme.of(context).primaryColor,
            ),
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.end,
          ),
        ),
      ],
    );
  }
}
