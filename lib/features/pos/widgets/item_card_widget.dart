import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:six_pos/common/controllers/cart_controller.dart';
import 'package:six_pos/features/splash/controllers/splash_controller.dart';
import 'package:six_pos/common/models/cart_model.dart';
import 'package:six_pos/helper/extension_helper.dart';
import 'package:six_pos/helper/price_converter_helper.dart';
import 'package:six_pos/util/dimensions.dart';
import 'package:six_pos/util/images.dart';
import 'package:six_pos/util/styles.dart';
import 'package:six_pos/common/widgets/custom_divider.dart';
import 'package:six_pos/common/widgets/custom_image_widget.dart';



class ItemCartWidget extends StatelessWidget {
  final CartModel? cartModel;
  final int index;
  const ItemCartWidget({super.key, this.cartModel, required this.index});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: Dimensions.paddingSizeBorder),
      child: Dismissible(
        key: UniqueKey(),
        onDismissed: (DismissDirection direction) {
          Get.find<CartController>().removeFromCart(index);

        },
        child: Container(
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
              boxShadow: [BoxShadow(color: Theme.of(context).shadowColor.withValues(alpha:0.1),
                  spreadRadius: 0.5, blurRadius: 0.3)]
          ),
          padding: const EdgeInsets.fromLTRB(Dimensions.paddingSizeExtraSmall, Dimensions.paddingSizeSmall, Dimensions.paddingSizeExtraSmall, Dimensions.paddingSizeSmall),
          child: Column(
            children: [
              Row(children: [

                Expanded(flex:5,
                  child: Row(crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(height: Dimensions.productImageSize,
                          width: Dimensions.productImageSize,
                          padding: const EdgeInsets.all(Dimensions.paddingSizeBorder),
                          child: CustomImageWidget(image: '${Get.find<SplashController>().configModel!.baseUrls!.productImageUrl}/${cartModel!.product!.image}',
                              placeholder: Images.placeholder,
                              fit: BoxFit.cover,
                              width: Dimensions.productImageSizeItem,height: Dimensions.productImageSizeItem),),
                      const SizedBox(width: Dimensions.paddingSizeSmall),

                      Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        Text(
                          '${cartModel!.product!.title}', maxLines: 2,overflow: TextOverflow.ellipsis,
                          style: ubuntuRegular.copyWith(fontSize: Dimensions.fontSizeSmall),
                        ),

                        Text(
                          '${cartModel?.product?.unitValue} ${cartModel?.product?.unitType?.unitType}', maxLines: 1,overflow: TextOverflow.ellipsis,
                          style: ubuntuRegular.copyWith(fontSize: Dimensions.fontSizeSmall, color: context.customThemeColors.textOpacityColor),
                        )
                      ])),
                    ],
                  ),
                ),

                Expanded(
                  flex: 4,
                  child: GetBuilder<CartController>(
                    builder: (cartController) {
                      return Row(children: [
                        InkWell(
                          onTap: (){
                            cartController.setQuantity(false, index);
                          },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeExtraSmall),
                            child: Icon(Icons.remove_circle, color: Theme.of(context).primaryColor),
                          ),
                        ),
                        Container(width: 40,height: 25,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(Dimensions.paddingSizeBorder),
                            border: Border.all(width: 1, color: Theme.of(context).primaryColor),
                          ),
                          child: Center(child: Text(cartModel!.quantity.toString(),
                            style: ubuntuRegular.copyWith(color: Theme.of(context).primaryColor),)),),
                        InkWell(
                          onTap: (){
                            cartController.setQuantity(true, index);
                          },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeExtraSmall),
                            child: Icon(Icons.add_circle, color: Theme.of(context).primaryColor),
                          ),
                        ),
                      ]);
                    }
                  ),
                ),

                Expanded(
                  flex: 2,
                  child: Text(
                    PriceConverterHelper.priceWithSymbol(cartModel!.price!),
                    style: ubuntuRegular.copyWith(color: Theme.of(context).secondaryHeaderColor),
                    textAlign: TextAlign.right,
                  ),
                ),


              ]),
              const SizedBox(height: Dimensions.paddingSizeExtraSmall),

              CustomDividerWidget(height: 1, color: Theme.of(context).hintColor.withValues(alpha: .5),),

            ],
          ),
        ),
      ),
    );
  }
}
