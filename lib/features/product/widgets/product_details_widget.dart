import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:readmore/readmore.dart';
import 'package:six_pos/common/models/product_model.dart';
import 'package:six_pos/common/widgets/custom_image_widget.dart';
import 'package:six_pos/features/splash/controllers/splash_controller.dart';
import 'package:six_pos/helper/date_converter_helper.dart';
import 'package:six_pos/helper/extension_helper.dart';
import 'package:six_pos/helper/price_converter_helper.dart';
import 'package:six_pos/helper/responsive_helper.dart';
import 'package:six_pos/util/dimensions.dart';
import 'package:six_pos/util/images.dart';
import 'package:six_pos/util/styles.dart';

class ProductDetailsWidget extends StatelessWidget {
  final Products? product;
  final Color? backgroundColor;
  final bool isShowDescription;

  const ProductDetailsWidget({super.key, this.product, this.backgroundColor, this.isShowDescription = true});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric( horizontal: Dimensions.paddingSizeLarge, vertical: Dimensions.fontSizeSmall),
      decoration: BoxDecoration(
          color: backgroundColor ?? Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(ResponsiveHelper.isTab(context) ? Dimensions.paddingSizeSmall : 0),
          boxShadow: [BoxShadow(blurRadius: 5, color: Theme.of(context).primaryColor.withValues(alpha: .05))]
      ),
      child: Column(children: [
        Row(crossAxisAlignment: CrossAxisAlignment.start, children:  [

          ClipRRect(borderRadius: BorderRadius.circular(Dimensions.paddingSizeMediumBorder),
            child: CustomImageWidget(
              height: Dimensions.productImageSizeItem,
              width: Dimensions.productImageSizeItem,
              image: '${Get.find<SplashController>().configModel?.baseUrls?.productImageUrl}/${product?.image}',
              fit: BoxFit.cover,
              placeholder: Images.placeholder,
            ),
          ),
          const SizedBox(width: Dimensions.paddingSizeDefault),

          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.start, children: [

            Text(
              '${product?.title} #${product?.id}',
              style: ubuntuMedium.copyWith(fontSize: Dimensions.fontSizeLarge),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),

            _CustomProductDetailText(fieldName: 'price', textValue: product?.sellingPrice.toString()),

            _CustomProductDetailText(fieldName: 'product_sku_code', textValue: product?.productCode),

            _CustomProductDetailText(fieldName: 'created', textValue: DateConverterHelper.isoStringToLocalDateOnly(product!.createdAt!)),

          ])),

        ]),
        SizedBox(height: Dimensions.paddingSizeSmall),

        if(isShowDescription)...[

          if(product?.description != null)
          ReadMoreText(
            '${product?.description}',
            style: ubuntuRegular.copyWith(color: context.customThemeColors.textOpacityColor),
            trimMode: TrimMode.Line,
            trimLines: 4,
            trimCollapsedText: '   ${'see_more'.tr}',
            trimExpandedText: '   ${'see_less'.tr}',
            moreStyle: ubuntuMedium.copyWith(fontSize: Dimensions.fontSizeDefault, color: context.customThemeColors.downloadFormatColor),
            lessStyle: ubuntuMedium.copyWith(fontSize: Dimensions.fontSizeDefault, color: context.customThemeColors.downloadFormatColor),
          ),
          SizedBox(height: Dimensions.paddingSizeDefault),

          IntrinsicHeight(
            child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, spacing: Dimensions.paddingSizeSmall, children: [
              Expanded(child: _OrderInfoItemWidget(fieldName: 'total_orders', textValue: '${product?.totalOrder ?? 0}')),
            
              Expanded(child: _OrderInfoItemWidget(fieldName: 'total_sold', textValue: '${product?.totalSold ?? 0}')),
            
              Expanded(child: _OrderInfoItemWidget(fieldName: 'total_sold_amount', textValue: PriceConverterHelper.convertPrice(context, product?.totalSoldAmount ?? 0, isShowLongPrice: true))),
            ]),
          ),
        ]

      ]),
    );
  }
}

class _CustomProductDetailText extends StatelessWidget {
  final String? fieldName;
  final String? textValue;
  const _CustomProductDetailText({this.fieldName, this.textValue});

  @override
  Widget build(BuildContext context) {
    return Text.rich(TextSpan(children: [
      TextSpan(text: '${fieldName?.tr} : ', style: ubuntuRegular.copyWith(color: context.customThemeColors.textOpacityColor)),

      TextSpan(text: textValue ?? '', style: ubuntuBold.copyWith(fontSize: Dimensions.fontSizeSmall)),
    ]));
  }
}

class _OrderInfoItemWidget extends StatelessWidget {
  final String? fieldName;
  final String? textValue;
  const _OrderInfoItemWidget({this.fieldName, this.textValue});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault, vertical: Dimensions.paddingSizeSmall),
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(Dimensions.paddingSizeMediumBorder),
      ),
      child: Column(children: [
        Text(textValue ?? '', style: ubuntuBold.copyWith(fontSize: Dimensions.fontSizeLarge)),

        Text(fieldName?.tr ?? '', style: ubuntuMedium.copyWith(color: context.customThemeColors.textOpacityColor, fontSize: Dimensions.fontSizeSmall)),
      ]),
    );
  }
}