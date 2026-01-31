import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:six_pos/common/controllers/cart_controller.dart';
import 'package:six_pos/features/category/widgets/product_cart_bottom_sheet_widget.dart';
import 'package:six_pos/features/product/controllers/product_controller.dart';
import 'package:six_pos/features/splash/controllers/splash_controller.dart';
import 'package:six_pos/features/product/domain/models/categories_product_model.dart';
import 'package:six_pos/features/pos/widgets/weight_input_dialog_widget.dart';
import 'package:six_pos/helper/pos_screen_helper.dart';
import 'package:six_pos/helper/price_converter_helper.dart';
import 'package:six_pos/util/dimensions.dart';
import 'package:six_pos/util/images.dart';
import 'package:six_pos/util/styles.dart';
import 'package:six_pos/common/widgets/custom_image_widget.dart';
import 'package:six_pos/helper/show_custom_snackbar_helper.dart';
import 'package:six_pos/helper/animated_custom_dialog_helper.dart';

class ItemCardWidget extends StatelessWidget {
  final int? index;
  final CategoriesProduct? categoriesProduct;
  const ItemCardWidget({super.key, this.categoriesProduct, this.index});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CartController>(
      builder: (cartController) {
        return InkWell(
          onTap: () {
            if (PosScreenHelper.isProductUnAvailable(
              categoriesProduct?.availableStartTime,
              categoriesProduct?.availableEndTime,
            )) {
            } else {
              if ((categoriesProduct?.quantity ?? 0) < 1) {
                showCustomSnackBarHelper('stock_out'.tr);
              } else {
                // Check if this is a weight-based product
                bool isWeightProduct =
                    categoriesProduct?.isWeightBased == true ||
                    (categoriesProduct?.unitType?.unitType
                            ?.toLowerCase()
                            .contains('kg') ==
                        true) ||
                    (categoriesProduct?.unitType?.unitType
                            ?.toLowerCase()
                            .contains('gram') ==
                        true) ||
                    (categoriesProduct?.unitType?.unitType
                            ?.toLowerCase()
                            .contains('pound') ==
                        true) ||
                    (categoriesProduct?.unitType?.unitType
                            ?.toLowerCase()
                            .contains('lb') ==
                        true);

                if (isWeightProduct) {
                  // Show weight input dialog
                  showAnimatedDialogHelper(
                    context,
                    WeightInputDialogWidget(
                      product: categoriesProduct!,
                      currencySymbol:
                          Get.find<SplashController>()
                              .configModel
                              ?.currencySymbol ??
                          '\$',
                    ),
                  );
                } else {
                  // Show normal product bottom sheet
                  Get.find<ProductController>().setItemQuantity();
                  showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    constraints: BoxConstraints(minWidth: double.infinity),
                    builder: (context) {
                      return ProductCartBottomSheetWidget(
                        product: categoriesProduct,
                      );
                    },
                    backgroundColor: Theme.of(context).cardColor,
                  );
                }
              }
            }
          },
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(Dimensions.paddingSizeBorder),
            ),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(Dimensions.paddingSizeBorder),
                  child: Stack(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Theme.of(
                              context,
                            ).primaryColor.withValues(alpha: .1),
                            width: 1,
                          ),
                          borderRadius: BorderRadius.circular(
                            Dimensions.paddingSizeBorder,
                          ),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(
                            Dimensions.paddingSizeBorder,
                          ),
                          child: CustomImageWidget(
                            image:
                                '${Get.find<SplashController>().configModel?.baseUrls?.productImageUrl}/${categoriesProduct?.image}',
                            placeholder: Images.placeholder,
                            fit: BoxFit.cover,
                            width: 100,
                            height: 100,
                          ),
                        ),
                      ),

                      if (PosScreenHelper.isProductUnAvailable(
                        categoriesProduct?.availableStartTime,
                        categoriesProduct?.availableEndTime,
                      ))
                        Container(
                          height: 100,
                          width: 100,
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Theme.of(
                                context,
                              ).primaryColor.withValues(alpha: .1),
                              width: 1,
                            ),
                            borderRadius: BorderRadius.circular(
                              Dimensions.paddingSizeBorder,
                            ),
                            color: Colors.black.withValues(alpha: 0.7),
                          ),
                          child: Center(
                            child: Text(
                              'unavailable'.tr,
                              style: ubuntuRegular.copyWith(
                                color: Theme.of(context).cardColor,
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),

                SizedBox(
                  width: 100,
                  child: Column(
                    children: [
                      Text(
                        categoriesProduct?.title ?? '',
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: ubuntuRegular.copyWith(
                          fontSize: Dimensions.fontSizeSmall,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      Text(
                        '${categoriesProduct?.unitValue ?? ''} ${categoriesProduct?.unitType?.unitType ?? ''}',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: ubuntuRegular.copyWith(
                          fontSize: Dimensions.fontSizeSmall,
                        ),
                        textAlign: TextAlign.center,
                      ),

                      Text(
                        PriceConverterHelper.convertPrice(
                          context,
                          categoriesProduct?.sellingPrice,
                          discount: categoriesProduct?.discount,
                          discountType: categoriesProduct?.discountType,
                        ),
                        style: ubuntuRegular.copyWith(
                          color: Theme.of(context).secondaryHeaderColor,
                          fontSize: Dimensions.fontSizeSmall,
                        ),
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.left,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
