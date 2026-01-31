import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:six_pos/common/controllers/cart_controller.dart';
import 'package:six_pos/common/models/cart_model.dart';
import 'package:six_pos/features/product/domain/models/categories_product_model.dart';
import 'package:six_pos/helper/price_converter_helper.dart';
import 'package:six_pos/helper/show_custom_snackbar_helper.dart';
import 'package:six_pos/util/dimensions.dart';
import 'package:six_pos/util/styles.dart';
import 'package:six_pos/common/widgets/custom_button_widget.dart';
import 'package:six_pos/common/widgets/custom_text_field_widget.dart';

class WeightInputDialogWidget extends StatefulWidget {
  final CategoriesProduct product;
  final String currencySymbol;

  const WeightInputDialogWidget({
    Key? key,
    required this.product,
    required this.currencySymbol,
  }) : super(key: key);

  @override
  State<WeightInputDialogWidget> createState() =>
      _WeightInputDialogWidgetState();
}

class _WeightInputDialogWidgetState extends State<WeightInputDialogWidget> {
  final TextEditingController _weightGramsController = TextEditingController();

  double _totalPrice = 0.0;
  double _pricePerGram = 0.0;
  double _pricePerKg = 0.0;

  @override
  void initState() {
    super.initState();
    _calculatePrices();

    // Add listener for automatic price calculation
    _weightGramsController.addListener(_onWeightGramsChanged);
  }

  void _calculatePrices() {
    // Convert selling price to price per gram (assuming it's stored as price per kg)
    double sellingPrice = widget.product.sellingPrice?.toDouble() ?? 0.0;

    // If the product price is per kg, convert to per gram
    // If it's already per gram, use as is
    if (widget.product.unitType?.unitType?.toLowerCase().contains('kg') ==
        true) {
      _pricePerKg = sellingPrice;
      _pricePerGram = sellingPrice / 1000;
    } else {
      // Assume it's per gram or per unit
      _pricePerGram = sellingPrice;
      _pricePerKg = sellingPrice * 1000;
    }
  }

  void _onWeightGramsChanged() {
    if (_weightGramsController.text.isNotEmpty) {
      double grams = double.tryParse(_weightGramsController.text) ?? 0.0;
      _updateTotalPrice(grams);
    } else {
      _updateTotalPrice(0.0);
    }
  }

  void _updateTotalPrice(double grams) {
    setState(() {
      _totalPrice = grams * _pricePerGram;
    });
  }

  Widget _buildQuickWeightButton(
    BuildContext context,
    String label,
    double grams,
  ) {
    return ElevatedButton(
      onPressed: () {
        _weightGramsController.text = grams.toString();
        _updateTotalPrice(grams);
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: Theme.of(context).primaryColor.withOpacity(0.1),
        foregroundColor: Theme.of(context).primaryColor,
        padding: const EdgeInsets.symmetric(
          horizontal: Dimensions.paddingSizeDefault,
          vertical: Dimensions.paddingSizeSmall,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(Dimensions.paddingSizeSmall),
        ),
      ),
      child: Text(
        label,
        style: ubuntuMedium.copyWith(fontSize: Dimensions.fontSizeSmall),
      ),
    );
  }

  void _addToCart() {
    double grams = double.tryParse(_weightGramsController.text) ?? 0.0;

    if (grams <= 0) {
      showCustomSnackBarHelper('please_enter_valid_weight'.tr);
      return;
    }

    // Create cart model with weight-based product
    CartModel cartModel = CartModel(
      _totalPrice,
      0.0, // discount amount will be calculated based on product discount
      1, // quantity is always 1 for weight-based products
      0.0, // tax amount will be calculated
      widget.product,
      isWeightBased: true,
      weight: grams,
      actualPrice: _totalPrice,
      pricePerGram: _pricePerGram,
      unitType: 'g',
    );

    Get.find<CartController>().addToCart(cartModel).then((_) {
      Get.back();
      showCustomSnackBarHelper('product_added_to_cart'.tr);
    });
  }

  @override
  void dispose() {
    _weightGramsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: const EdgeInsets.all(20),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(Dimensions.paddingSizeSmall),
      ),
      child: Container(
        width: double.maxFinite,
        padding: const EdgeInsets.all(Dimensions.paddingSizeLarge),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    'weight_input'.tr,
                    style: ubuntuMedium.copyWith(
                      fontSize: Dimensions.fontSizeExtraLarge,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () => Get.back(),
                  icon: Icon(
                    Icons.close,
                    color: Theme.of(context).disabledColor,
                  ),
                ),
              ],
            ),

            const SizedBox(height: Dimensions.paddingSizeDefault),

            // Product name
            Text(
              widget.product.title ?? '',
              style: ubuntuMedium.copyWith(fontSize: Dimensions.fontSizeLarge),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),

            const SizedBox(height: Dimensions.paddingSizeSmall),

            // Price per kg
            Text(
              '${'price'.tr}: ${PriceConverterHelper.priceWithSymbol(_pricePerKg)}/kg',
              style: ubuntuRegular.copyWith(
                fontSize: Dimensions.fontSizeDefault,
                color: Theme.of(context).primaryColor,
              ),
            ),

            // Price per gram
            Text(
              '${PriceConverterHelper.priceWithSymbol(_pricePerGram)}/g',
              style: ubuntuRegular.copyWith(
                fontSize: Dimensions.fontSizeSmall,
                color: Theme.of(context).hintColor,
              ),
            ),

            const SizedBox(height: Dimensions.paddingSizeLarge),

            // Quick weight buttons
            Text(
              'quick_weights'.tr,
              style: ubuntuMedium.copyWith(
                fontSize: Dimensions.fontSizeDefault,
              ),
            ),
            const SizedBox(height: Dimensions.paddingSizeSmall),
            Wrap(
              spacing: Dimensions.paddingSizeSmall,
              runSpacing: Dimensions.paddingSizeSmall,
              children: [
                _buildQuickWeightButton(context, '100g', 100),
                _buildQuickWeightButton(context, '250g', 250),
                _buildQuickWeightButton(context, '500g', 500),
                _buildQuickWeightButton(context, '1kg', 1000),
                _buildQuickWeightButton(context, '2kg', 2000),
                _buildQuickWeightButton(context, '5kg', 5000),
              ],
            ),

            const SizedBox(height: Dimensions.paddingSizeDefault),

            // Weight input in grams
            Text(
              'weight_grams'.tr,
              style: ubuntuMedium.copyWith(
                fontSize: Dimensions.fontSizeDefault,
              ),
            ),
            const SizedBox(height: Dimensions.paddingSizeSmall),
            CustomTextFieldWidget(
              controller: _weightGramsController,
              hintText: '0',
              inputType: TextInputType.numberWithOptions(decimal: true),
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
              ],
            ),

            const SizedBox(height: Dimensions.paddingSizeLarge),

            // Total price display
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(
                  Dimensions.paddingSizeSmall,
                ),
                border: Border.all(
                  color: Theme.of(context).primaryColor.withOpacity(0.3),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'total_price'.tr,
                    style: ubuntuMedium.copyWith(
                      fontSize: Dimensions.fontSizeDefault,
                    ),
                  ),
                  const SizedBox(height: Dimensions.paddingSizeExtraSmall),
                  Text(
                    PriceConverterHelper.priceWithSymbol(_totalPrice),
                    style: ubuntuBold.copyWith(
                      fontSize: Dimensions.fontSizeExtraLarge,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: Dimensions.paddingSizeLarge),

            // Buttons
            Row(
              children: [
                Expanded(
                  child: CustomButtonWidget(
                    buttonText: 'cancel'.tr,
                    backgroundColor: Theme.of(context).disabledColor,
                    onPressed: () => Get.back(),
                  ),
                ),
                const SizedBox(width: Dimensions.paddingSizeDefault),
                Expanded(
                  child: GetBuilder<CartController>(
                    builder: (cartController) {
                      return CustomButtonWidget(
                        buttonText: 'add_to_cart'.tr,
                        backgroundColor: Theme.of(context).primaryColor,
                        isLoading: cartController.isLoading,
                        onPressed: _addToCart,
                      );
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
