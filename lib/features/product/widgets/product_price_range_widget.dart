import 'package:another_xlider/another_xlider.dart';
import 'package:another_xlider/models/handler.dart';
import 'package:another_xlider/models/tooltip/tooltip.dart';
import 'package:another_xlider/models/trackbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:six_pos/common/widgets/custom_debounce_widget.dart';
import 'package:six_pos/common/widgets/custom_text_field_widget.dart';
import 'package:six_pos/features/product/controllers/product_controller.dart';
import 'package:six_pos/util/dimensions.dart';
import 'package:six_pos/util/styles.dart';

class ProductPriceRangeWidget extends StatefulWidget {
  final TextEditingController minPriceController;
  final TextEditingController maxPriceController;
  final bool fromProductScreen;
  const ProductPriceRangeWidget({super.key, required this.minPriceController, required this.maxPriceController, required this.fromProductScreen});

  @override
  State<ProductPriceRangeWidget> createState() => _ProductPriceRangeWidgetState();
}

class _ProductPriceRangeWidgetState extends State<ProductPriceRangeWidget> {
  final ProductController productController = Get.find<ProductController>();
  double sliderMax = 1;
  double sliderMin = 0;
  final CustomDebounceWidget customDebounceWidget = CustomDebounceWidget(milliseconds: 1000);

  @override
  void initState() {
    sliderMax = widget.fromProductScreen ? productController.productModel?.productMaximumPrice ?? 1 : productController.limitedStockProductModel?.productMaximumPrice ??  1;
    sliderMin = widget.fromProductScreen ? productController.productModel?.productMinimumPrice ?? 0 : productController.limitedStockProductModel?.productMinimumPrice ?? 0;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ProductController>(builder: (productController) {

      final double minPrice = productController.minPrice ?? 0;
      final double maxPrice = productController.maxPrice ?? 1;
      widget.minPriceController.text = minPrice.toString();
      widget.maxPriceController.text = maxPrice.toString();

      return Column(children: [
        FlutterSlider(
          values: [minPrice, maxPrice],
          rangeSlider: true,
          max: sliderMax,
          min: sliderMin,
          trackBar: FlutterSliderTrackBar(
            activeTrackBarHeight: 5,
            activeTrackBar: BoxDecoration(borderRadius: BorderRadius.circular(4), color: Theme.of(context).primaryColor),
            inactiveTrackBar: BoxDecoration(color: Theme.of(context).primaryColor.withValues(alpha: 0.20)),
          ),
          tooltip: FlutterSliderTooltip(
            // To always show the tooltip for demonstration
            alwaysShowTooltip: false,
            custom: (value) {
              return Transform.translate(
                offset: const Offset(0, - Dimensions.iconSizeLarge),
                child: CustomPaint(
                  painter: _PointyTooltipPainter(),
                  child: Container(
                    width: 120,
                    height: 40,
                    padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeSmall, horizontal: Dimensions.paddingSizeSmall),
                    child: Center(
                      child: Text(
                        value.toStringAsFixed(0),
                        style: TextStyle(color: Theme.of(context).cardColor, fontSize: Dimensions.fontSizeExtraLarge, overflow: TextOverflow.ellipsis),
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
          handler: FlutterSliderHandler(
            decoration: const BoxDecoration(),
            child: Container(
              width: Dimensions.paddingSizeDefault,
              height: Dimensions.paddingSizeDefault,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Theme.of(context).primaryColor, width: 4),
                color: Theme.of(context).cardColor,
              ),
            ),
          ),
          rightHandler: FlutterSliderHandler(
            decoration: const BoxDecoration(),
            child: Container(
              width: Dimensions.paddingSizeDefault,
              height: Dimensions.paddingSizeDefault,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Theme.of(context).primaryColor, width: 4),
                color: Theme.of(context).cardColor,
              ),
            ),
          ),
          handlerWidth: 40,
          handlerHeight: 20,
          disabled: false,
          onDragging: (handlerIndex, lowerValue, upperValue) {
            widget.minPriceController.text = lowerValue.toStringAsFixed(0);
            widget.maxPriceController.text = upperValue.toStringAsFixed(0);

            productController.setPriceRange(lowerValue, upperValue, true, true);
          },
        ),

        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Flexible(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisSize: MainAxisSize.min, children: [

                Text('min'.tr, style: ubuntuMedium,),

                CustomTextFieldWidget(
                  controller: widget.minPriceController,
                  borderColor: Theme.of(context).hintColor.withValues(alpha: .5),
                  inputType: TextInputType.number,
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r'^[0-9]*$')), // Allow only digits
                  ],
                  onChanged: (String text) {

                    final double tempMinPrice = double.tryParse(widget.minPriceController.text) ?? 0;
                    final double tempMaxPrice = double.tryParse(widget.maxPriceController.text) ?? 0;

                    customDebounceWidget.run((){
                      if(tempMinPrice >= sliderMin) {
                        if(tempMinPrice >= tempMaxPrice){
                          productController.setPriceRange(sliderMax, tempMaxPrice, true, false);
                        }else{
                          productController.setPriceRange(tempMinPrice, tempMaxPrice, true, false);
                        }
                      } else {
                        productController.setPriceRange(sliderMin, sliderMax, true, false);
                      }
                    });
                  },
                )
              ]),
            ),
          ),

          Flexible(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall),
              child: Column(crossAxisAlignment: CrossAxisAlignment.end, mainAxisSize: MainAxisSize.min, children: [

                Text('max'.tr, style: ubuntuMedium),

                CustomTextFieldWidget(
                  controller: widget.maxPriceController,
                  borderColor: Theme.of(context).hintColor.withValues(alpha: .5),
                  inputType: TextInputType.number,
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r'^[0-9]*$')), // Allow only digits
                  ],
                  onChanged: (String text) {

                    final double tempMinPrice = double.tryParse(widget.minPriceController.text) ?? 0;
                    final double tempMaxPrice = double.tryParse(widget.maxPriceController.text) ?? 0;

                    customDebounceWidget.run((){
                      if(tempMaxPrice <= sliderMax) {
                        if(tempMaxPrice <= sliderMin){
                          productController.setPriceRange(tempMinPrice, sliderMin, false, true);
                        }else{
                          productController.setPriceRange(tempMinPrice, tempMaxPrice, false, true);
                        }

                      } else {
                        productController.setPriceRange(sliderMin, sliderMax, false, true);
                      }
                    });
                  },
                )
              ],),
            ),
          )
        ],)
      ]);
    }
    );
  }
}

class _PointyTooltipPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()..color = Theme.of(Get.context!).primaryColor;

    const double borderRadius = 5.0;
    const double triangleHeight = 10.0;
    const double triangleWidth = 16.0;

    final RRect roundedRect = RRect.fromRectAndRadius(
      Rect.fromLTWH(0, 0, size.width, size.height),
      const Radius.circular(borderRadius),
    );

    final Path path = Path()
    // Add the rounded rectangle's path as the base
      ..addRRect(roundedRect)
      ..moveTo(size.width / 2 - triangleWidth / 2, size.height) // Left triangle edge
      ..lineTo(size.width / 2, size.height + triangleHeight) // Triangle point
      ..lineTo(size.width / 2 + triangleWidth / 2, size.height) // Right triangle edge
      ..close(); // Close the path for the triangle

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

