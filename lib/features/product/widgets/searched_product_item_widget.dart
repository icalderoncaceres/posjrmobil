import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:six_pos/common/controllers/cart_controller.dart';
import 'package:six_pos/features/splash/controllers/splash_controller.dart';
import 'package:six_pos/common/models/cart_model.dart';
import 'package:six_pos/features/product/domain/models/categories_product_model.dart';
import 'package:six_pos/common/models/product_model.dart';
import 'package:six_pos/features/unit/domain/models/unit_model.dart';
import 'package:six_pos/helper/extension_helper.dart';
import 'package:six_pos/helper/price_converter_helper.dart';
import 'package:six_pos/util/dimensions.dart';
import 'package:six_pos/util/images.dart';
import 'package:six_pos/util/styles.dart';
import 'package:six_pos/common/widgets/custom_image_widget.dart';
import 'package:six_pos/helper/show_custom_snackbar_helper.dart';
class SearchedProductItemWidget extends StatelessWidget {
  final Products? product;
  const SearchedProductItemWidget({super.key, this.product});

  @override
  Widget build(BuildContext context) {
    final double widthSize = MediaQuery.sizeOf(context).width;

    return GetBuilder<CartController>(builder: (cartController) {
      return Container(
        padding: const EdgeInsets.all(Dimensions.paddingSizeExtraSmall),
        margin: const EdgeInsets.only(bottom: Dimensions.paddingSizeExtraSmall),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(Dimensions.paddingSizeSmall),
          color:_isAvailable(product?.availableStartTime, product?.availableEndTime) ? Colors.black.withValues(alpha: 0.7) : null,
        ),
        child: InkWell(
          onTap: (){
            if(_isAvailable(product?.availableStartTime, product?.availableEndTime)){

            }else{
              if(product!.quantity!<1){
                showCustomSnackBarHelper('stock_out'.tr);
              }else{
                CartModel cartModel = CartModel(product!.sellingPrice, product!.discount, 1, product!.tax, CategoriesProduct(
                    id: product!.id,title: product!.title,productCode: product!.productCode,unitType: Units(id: product?.unitType?.id, unitType: product?.unitType?.unitType), unitValue: product!.unitValue,
                    image: product!.image, sellingPrice: product!.sellingPrice, purchasePrice: product!.sellingPrice,discountType: product!.discountType,
                    discount: product!.discount,tax: product!.tax,quantity: product!.quantity
                ));
                cartController.addToCart(cartModel);
              }
            }

          },
          child: Stack(children: [
            Row(children: [
              Container(
                width: Dimensions.productImageSize, height: Dimensions.productImageSize,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(Dimensions.paddingSizeExtraSmall),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(Dimensions.paddingSizeExtraSmall),
                  child: Padding(
                    padding: const EdgeInsets.all(Dimensions.paddingSizeBorder),
                    child: CustomImageWidget(
                      fit: BoxFit.cover,
                      placeholder: Images.placeholder,
                      image: '${Get.find<SplashController>().baseUrls!.productImageUrl}/${product!.image}',
                    ),
                  ),
                ),
              ),
              const SizedBox(width: Dimensions.paddingSizeDefault),

              SizedBox(
                width: widthSize / 2.4,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      product!.title!,
                      style: ubuntuRegular.copyWith(fontSize: Dimensions.fontSizeDefault),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),

                    Text.rich(
                      TextSpan (children: [
                        TextSpan(text: '${"sku".tr}: '),

                        TextSpan(text: "${product?.productCode}"),
                      ]),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),


                    Row(children: [
                      (product?.discount ?? 0) > 0 ?
                      Text(
                        PriceConverterHelper.priceWithSymbol(product!.sellingPrice!),
                        style: ubuntuLight.copyWith(fontSize: Dimensions.fontSizeSmall,
                            color: context.customThemeColors.textColor,
                            decoration: TextDecoration.lineThrough
                        ),
                        overflow: TextOverflow.ellipsis,
                      ) : const SizedBox(),
                      const SizedBox(width: Dimensions.paddingSizeMediumBorder),

                      Expanded(
                        child: Text(
                          PriceConverterHelper.convertPrice(context, product!.sellingPrice, discount: product!.discount ,discountType : product!.discountType),
                          style: ubuntuRegular,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ]),
                  ],
                ),
              ),

              const Expanded(child: SizedBox()),
              Text.rich(TextSpan (children: [
                TextSpan(text: '${"stock".tr}: '),

                TextSpan(text: "${product?.quantity}", style: ubuntuBold.copyWith(color: Colors.green)),
              ])),
            ]),

            if(_isAvailable(product?.availableStartTime, product?.availableEndTime))
            SizedBox(
              height: Get.height * 0.06,
              child: Center(child: Text('unavailable'.tr, style: ubuntuRegular.copyWith(color: Theme.of(context).cardColor))),
            )
          ]),
        ),
      );
    });
  }
}


bool _isAvailable(String? startTime, String? endTime){

  DateTime now = DateTime.now();
  DateTime? _startTime = startTime != null ? parseTimeWithSeconds(startTime) : null;
  DateTime? _endTime = endTime != null ? parseTimeWithSeconds(endTime) : null;


  if (_startTime != null && _endTime != null) {
    return !(now.isAfter(_startTime) && now.isBefore(_endTime));
  }else{
    return false;
  }
}

DateTime parseTimeWithSeconds(String timeStr) {
  final now = DateTime.now();
  final format = DateFormat("HH:mm:ss");
  final time = format.parse(timeStr);
  return DateTime(now.year, now.month, now.day, time.hour, time.minute, time.second);
}