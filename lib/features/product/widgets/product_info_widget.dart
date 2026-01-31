import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:six_pos/common/models/product_model.dart';
import 'package:six_pos/features/product/widgets/product_details_widget.dart';
import 'package:six_pos/helper/extension_helper.dart';
import 'package:six_pos/helper/price_converter_helper.dart';
import 'package:six_pos/helper/responsive_helper.dart';
import 'package:six_pos/util/dimensions.dart';
import 'package:six_pos/util/styles.dart';

class ProductInfoWidget extends StatelessWidget {
  final Products? product;
  const ProductInfoWidget({super.key, this.product});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(child: Column(children: [

      SizedBox(height: Dimensions.paddingSizeLarge),

      ProductDetailsWidget(product: product),
      SizedBox(height: Dimensions.paddingSizeSmall),

      ResponsiveHelper.isTab(context) ?
      IntrinsicHeight(
        child: Row(children: [
          Flexible(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeLarge, vertical: Dimensions.fontSizeSmall),
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                boxShadow: [BoxShadow(
                  blurRadius: 5,
                  color: Theme.of(context).primaryColor.withValues(alpha: 0.05),
                )],
              ),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start,children: [

                Text('general_information'.tr, style: ubuntuBold),
                SizedBox(height: Dimensions.paddingSizeDefault),

                if(product?.category?.name != null)
                  _ProductInfoItemWidget(label: 'category', info: '${product?.category?.name}'),

                if(product?.subCategory?.name != null)
                  _ProductInfoItemWidget(label: 'sub_category', info: '${product?.subCategory?.name}'),

                if(product?.brand?.name != null)
                  _ProductInfoItemWidget(label: 'brand', info: '${product?.brand?.name}'),

                if(product?.unitType != null)
                  _ProductInfoItemWidget(label: 'product_unit', info: '${product?.unitType?.unitType}'),

                if(product?.quantity != null)
                  _ProductInfoItemWidget(label: 'quantity', info: '${product?.quantity}'),

              ]),
            ),
          ),
          SizedBox(width: Dimensions.fontSizeSmall),


          Flexible(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeLarge, vertical: Dimensions.fontSizeSmall),
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                boxShadow: [BoxShadow(
                  blurRadius: 5,
                  color: Theme.of(context).primaryColor.withValues(alpha: 0.05),
                )],
              ),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start,children: [

                Text('price_information'.tr, style: ubuntuBold),
                SizedBox(height: Dimensions.paddingSizeDefault),

                if(product?.purchasePrice != null)
                  _ProductInfoItemWidget(label: 'purchase_price', info: '${product?.purchasePrice}'),

                if(product?.sellingPrice != null)
                  _ProductInfoItemWidget(label: 'selling_price', info: '${product?.sellingPrice}'),

                if(product?.tax != null)
                  _ProductInfoItemWidget(label: 'tax', info: '${product?.tax}'),

                if(product?.discountType != null)
                  _ProductInfoItemWidget(label: 'discount_type', info: '${product?.discountType}'.capitalizeFirst),

                if(product?.discount != null)
                  _ProductInfoItemWidget(
                    label: 'discount_percent',
                    info: '${PriceConverterHelper.discountWithLogo(
                      context,
                      product?.discount,
                      product?.discountType,
                    )}',
                  ),

              ]),
            ),
          ),
          SizedBox(width: Dimensions.fontSizeSmall),


          Flexible(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeLarge, vertical: Dimensions.fontSizeSmall),
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                boxShadow: [BoxShadow(
                  blurRadius: 5,
                  color: Theme.of(context).primaryColor.withValues(alpha: 0.05),
                )],
              ),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start,children: [

                Text('supplier_information'.tr, style: ubuntuBold),
                SizedBox(height: Dimensions.paddingSizeDefault),

                if(product?.supplier?.name != null)
                  _ProductInfoItemWidget(label: 'name', info: '${product?.supplier?.name}'),

                if(product?.supplier?.mobile != null)
                  _ProductInfoItemWidget(label: 'phone_number', info: '${product?.supplier?.mobile}'),

              ]),
            ),
          )

        ]),
      ) :
      Column(children: [
        Container(
          padding: EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeLarge, vertical: Dimensions.fontSizeSmall),
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            boxShadow: [BoxShadow(
              blurRadius: 5,
              color: Theme.of(context).primaryColor.withValues(alpha: 0.05),
            )],
          ),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start,children: [

            Text('general_information'.tr, style: ubuntuBold),
            SizedBox(height: Dimensions.paddingSizeDefault),

            if(product?.category?.name != null)
              _ProductInfoItemWidget(label: 'category', info: '${product?.category?.name}'),

            if(product?.subCategory?.name != null)
              _ProductInfoItemWidget(label: 'sub_category', info: '${product?.subCategory?.name}'),

            if(product?.brand?.name != null)
              _ProductInfoItemWidget(label: 'brand', info: '${product?.brand?.name}'),

            if(product?.unitType != null)
              _ProductInfoItemWidget(label: 'product_unit', info: '${product?.unitType?.unitType}'),

            if(product?.quantity != null)
              _ProductInfoItemWidget(label: 'quantity', info: '${product?.quantity}'),

          ]),
        ),
        SizedBox(height: Dimensions.fontSizeSmall),


        Container(
          padding: EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeLarge, vertical: Dimensions.fontSizeSmall),
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            boxShadow: [BoxShadow(
              blurRadius: 5,
              color: Theme.of(context).primaryColor.withValues(alpha: 0.05),
            )],
          ),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start,children: [

            Text('price_information'.tr, style: ubuntuBold),
            SizedBox(height: Dimensions.paddingSizeDefault),

            if(product?.purchasePrice != null)
              _ProductInfoItemWidget(label: 'purchase_price', info: '${product?.purchasePrice}'),

            if(product?.sellingPrice != null)
              _ProductInfoItemWidget(label: 'selling_price', info: '${product?.sellingPrice}'),

            if(product?.tax != null)
              _ProductInfoItemWidget(label: 'tax', info: '${product?.tax}'),

            if(product?.discountType != null)
              _ProductInfoItemWidget(label: 'discount_type', info: '${product?.discountType}'.capitalizeFirst),

            if(product?.discount != null)
              _ProductInfoItemWidget(
                label: 'discount_percent',
                info: '${PriceConverterHelper.discountWithLogo(
                  context,
                  product?.discount,
                  product?.discountType,
                )}',
              ),

          ]),
        ),
        SizedBox(height: Dimensions.fontSizeSmall),


        Container(
          padding: EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeLarge, vertical: Dimensions.fontSizeSmall),
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            boxShadow: [BoxShadow(
              blurRadius: 5,
              color: Theme.of(context).primaryColor.withValues(alpha: 0.05),
            )],
          ),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start,children: [

            Text('supplier_information'.tr, style: ubuntuBold),
            SizedBox(height: Dimensions.paddingSizeDefault),

            if(product?.supplier?.name != null)
              _ProductInfoItemWidget(label: 'name', info: '${product?.supplier?.name}'),

            if(product?.supplier?.mobile != null)
              _ProductInfoItemWidget(label: 'phone_number', info: '${product?.supplier?.mobile}'),

          ]),
        ),
        SizedBox(height: Dimensions.fontSizeSmall),
      ])

    ]));
  }
}


class _ProductInfoItemWidget extends StatelessWidget {
  final String? label;
  final String? info;
  const _ProductInfoItemWidget({this.label, this.info,});

  @override
  Widget build(BuildContext context) {
    return Row(children: [
      Text('${label?.tr} : ', style: ubuntuRegular.copyWith(fontSize: Dimensions.fontSizeSmall, color: context.customThemeColors.textOpacityColor)),

      Flexible(child: Text(info ?? '', style: ubuntuRegular.copyWith(
        fontSize: Dimensions.fontSizeSmall,
        color: Theme.of(context).textTheme.bodyLarge?.color,
      ), overflow: TextOverflow.ellipsis, maxLines: 2)),

    ]);
  }
}
