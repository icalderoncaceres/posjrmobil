import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:six_pos/common/enums/menu_pop_up_enum.dart';
import 'package:six_pos/common/widgets/custom_asset_image_widget.dart';
import 'package:six_pos/common/widgets/custom_menu_item_widget.dart';
import 'package:six_pos/common/widgets/custom_switch_widget.dart';
import 'package:six_pos/features/product/controllers/product_controller.dart';
import 'package:six_pos/features/product/screens/product_details_screen.dart';
import 'package:six_pos/features/splash/controllers/splash_controller.dart';
import 'package:six_pos/common/models/product_model.dart';
import 'package:six_pos/helper/delete_dialog_helper.dart';
import 'package:six_pos/helper/extension_helper.dart';
import 'package:six_pos/helper/price_converter_helper.dart';
import 'package:six_pos/helper/responsive_helper.dart';
import 'package:six_pos/helper/show_custom_snackbar_helper.dart';
import 'package:six_pos/util/dimensions.dart';
import 'package:six_pos/util/images.dart';
import 'package:six_pos/util/styles.dart';
import 'package:six_pos/helper/animated_custom_dialog_helper.dart';
import 'package:six_pos/common/widgets/custom_image_widget.dart';
import 'package:six_pos/features/product/screens/bar_code_generate_screen.dart';
import 'package:six_pos/features/product/widgets/product_update_dialog_widget.dart';
import 'package:six_pos/features/product_setup/screens/add_product_screen.dart';

class ProductCardViewWidget extends StatelessWidget {
  final Products? product;
  final int? index;
  const ProductCardViewWidget({super.key, this.product, this.index});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () =>
          Get.to(() => ProductDetailsScreen(product: product, index: index)),
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          boxShadow: [
            BoxShadow(
              blurRadius: 5,
              color: Theme.of(context).primaryColor.withValues(alpha: 0.05),
            ),
          ],
        ),
        padding: const EdgeInsets.symmetric(
          horizontal: Dimensions.paddingSizeLarge,
          vertical: Dimensions.paddingSizeDefault,
        ),
        child: IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(
                      Dimensions.paddingSizeMediumBorder,
                    ),
                    child: CustomImageWidget(
                      fit: BoxFit.cover,
                      height: Dimensions.paddingSizeRevenueBottom,
                      width: Dimensions.paddingSizeRevenueBottom,
                      image:
                          '${Get.find<SplashController>().baseUrls?.productImageUrl}/${product?.image}',
                    ),
                  ),

                  Spacer(),

                  Text(
                    'Id #${product?.id}',
                    style: ubuntuRegular.copyWith(
                      color: context.customThemeColors.textOpacityColor,
                      fontSize: Dimensions.fontSizeSmall,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
              SizedBox(width: Dimensions.fontSizeSmall),

              Expanded(
                flex: 11,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      product?.title ?? '',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: ubuntuMedium.copyWith(
                        color: Theme.of(context).textTheme.bodyLarge?.color,
                        fontSize: Dimensions.fontSizeDefault,
                      ),
                    ),
                    SizedBox(height: Dimensions.paddingSizeExtraSmall),

                    // Check if product is weight-based and show appropriate price
                    Text(
                      product?.isWeightBased == true
                          ? 'price_per_kg'.tr
                          : 'selling_price'.tr,
                      style: ubuntuRegular.copyWith(
                        fontSize: Dimensions.fontSizeDefault,
                        color: context.customThemeColors.textOpacityColor,
                      ),
                    ),
                    SizedBox(height: Dimensions.paddingSizeMediumBorder),

                    Text(
                      product?.isWeightBased == true
                          ? (product?.priceDisplay ??
                                '${product?.pricePerKg?.toStringAsFixed(2)} ${product?.currentCurrencySymbol}/kg')
                          : PriceConverterHelper.convertPrice(
                              context,
                              product?.sellingPrice,
                            ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: ubuntuRegular.copyWith(
                        color: Theme.of(context).textTheme.bodyLarge?.color,
                        fontSize: Dimensions.fontSizeDefault,
                      ),
                    ),

                    // Show additional info for weight-based products
                    if (product?.isWeightBased == true) ...[
                      SizedBox(height: Dimensions.paddingSizeExtraSmall),
                      Text(
                        'weight_based_product'.tr,
                        style: ubuntuRegular.copyWith(
                          fontSize: Dimensions.fontSizeSmall,
                          color: Theme.of(context).primaryColor,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              SizedBox(width: Dimensions.fontSizeSmall),

              Expanded(
                flex: ResponsiveHelper.isTab(context) ? 1 : 5,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      width: Dimensions.paddingSizeLarge,
                      height: Dimensions.paddingSizeLarge,
                      child: PopupMenuButton<MenuPopUpEnum>(
                        padding: EdgeInsets.zero,
                        menuPadding: EdgeInsets.zero,
                        icon: Icon(
                          Icons.more_vert,
                          color: context.customThemeColors.textOpacityColor,
                          size: Dimensions.paddingSizeLarge,
                        ),
                        onSelected: (value) {
                          switch (value) {
                            case MenuPopUpEnum.status:
                              Get.find<ProductController>()
                                  .onChangeProductStatus(
                                    productId: product?.id,
                                    status: product?.status == 1 ? 0 : 1,
                                    index: index,
                                  );
                              break;
                            case MenuPopUpEnum.barcode:
                              Get.to(
                                () => ProductDetailsScreen(
                                  product: product,
                                  index: index,
                                  tabInitialIndex: 1,
                                ),
                              );
                              break;
                            case MenuPopUpEnum.details:
                              Get.to(
                                () => ProductDetailsScreen(
                                  product: product,
                                  index: index,
                                ),
                              );
                              break;
                            case MenuPopUpEnum.edit:
                              Get.to(
                                () => AddProductScreen(
                                  product: product,
                                  index: index,
                                ),
                              );
                              break;
                            case MenuPopUpEnum.delete:
                              showDeleteProductDialog(
                                context: context,
                                product: product,
                              );
                              break;
                          }
                        },
                        itemBuilder: (BuildContext context) => [
                          PopupMenuItem<MenuPopUpEnum>(
                            padding: EdgeInsets.zero,
                            value: MenuPopUpEnum.status,
                            child: CustomMenuItemWidget(
                              padding: EdgeInsets.only(
                                left: Dimensions.paddingSizeDefault,
                                right: Dimensions.paddingSizeMediumBorder,
                                top: Dimensions.paddingSizeMediumBorder,
                                bottom: Dimensions.paddingSizeMediumBorder,
                              ),
                              title: 'status'.tr,
                              backgroundColor: context
                                  .customThemeColors
                                  .downloadFormatColor
                                  .withValues(alpha: 0.05),
                              child: GetBuilder<ProductController>(
                                builder: (productController) {
                                  return CustomSwitchWidget(
                                    value: product?.status == 1,
                                    activeColor: Theme.of(context).primaryColor,
                                    onChanged: (value) =>
                                        productController.onChangeProductStatus(
                                          productId: product?.id,
                                          status: product?.status == 1 ? 0 : 1,
                                          index: index,
                                        ),
                                  );
                                },
                              ),
                            ),
                          ),

                          PopupMenuItem<MenuPopUpEnum>(
                            padding: EdgeInsets.zero,
                            value: MenuPopUpEnum.barcode,
                            child: CustomMenuItemWidget(
                              title: 'barcode'.tr,
                              child: CustomAssetImageWidget(
                                Images.barCode,
                                width: Dimensions.paddingSizeDefault,
                                height: Dimensions.paddingSizeDefault,
                              ),
                            ),
                          ),

                          PopupMenuItem<MenuPopUpEnum>(
                            padding: EdgeInsets.zero,
                            value: MenuPopUpEnum.details,
                            child: CustomMenuItemWidget(
                              title: 'details'.tr,
                              child: Icon(
                                Icons.remove_red_eye,
                                color: context
                                    .customThemeColors
                                    .downloadFormatColor
                                    .withValues(alpha: 0.7),
                              ),
                            ),
                          ),

                          PopupMenuItem<MenuPopUpEnum>(
                            padding: EdgeInsets.zero,
                            value: MenuPopUpEnum.edit,
                            child: CustomMenuItemWidget(
                              title: 'edit'.tr,
                              child: Icon(
                                Icons.edit,
                                color: context
                                    .customThemeColors
                                    .downloadFormatColor,
                              ),
                            ),
                          ),

                          PopupMenuItem<MenuPopUpEnum>(
                            padding: EdgeInsets.zero,
                            value: MenuPopUpEnum.delete,
                            child: CustomMenuItemWidget(
                              title: 'delete'.tr,
                              child: CustomAssetImageWidget(
                                Images.deleteIcon,
                                height: Dimensions.paddingSizeLarge,
                                width: Dimensions.paddingSizeLarge,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    GetBuilder<ProductController>(
                      builder: (productController) {
                        return InkWell(
                          onTap: () {
                            productController.productQuantityController.text =
                                (product?.quantity ?? 0).toString();
                            showAnimatedDialogHelper(
                              context,
                              ProductUpdateDialogWidget(
                                onYesPressed: () {
                                  int inputQuantity =
                                      int.tryParse(
                                        productController
                                            .productQuantityController
                                            .text
                                            .trim(),
                                      ) ??
                                      0;

                                  if (inputQuantity > 0) {
                                    productController.updateProductQuantity(
                                      product?.id,
                                      inputQuantity,
                                    );
                                    Get.back();
                                  } else {
                                    showCustomSnackBarHelper(
                                      'set_minimum_1'.tr,
                                      isError: true,
                                    );
                                  }
                                },
                              ),
                              dismissible: false,
                              isFlip: false,
                            );
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: Dimensions.paddingSizeExtraSmall,
                              vertical: Dimensions.paddingSizeMediumBorder,
                            ),
                            decoration: BoxDecoration(
                              border: Border.all(
                                width: 1,
                                color: Theme.of(
                                  context,
                                ).hintColor.withValues(alpha: 0.15),
                              ),
                              borderRadius: BorderRadius.circular(
                                Dimensions.paddingSizeMediumBorder,
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  '${product!.quantity}',
                                  style: ubuntuRegular.copyWith(
                                    fontSize: Dimensions.fontSizeSmall,
                                    color: Theme.of(
                                      context,
                                    ).textTheme.bodyLarge?.color,
                                  ),
                                ),

                                const Icon(
                                  Icons.add_circle,
                                  size: Dimensions.paddingSizeDefault,
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
