import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:six_pos/common/models/order_model.dart';
import 'package:six_pos/common/widgets/custom_asset_image_widget.dart';
import 'package:six_pos/common/widgets/custom_image_widget.dart';
import 'package:six_pos/helper/responsive_helper.dart';
import 'package:six_pos/util/dimensions.dart';
import 'package:six_pos/util/images.dart';
import 'package:six_pos/util/styles.dart';

class CustomerEmployeeDetailsWidget extends StatelessWidget {
  final String text;
  final Customer? customer;
  const CustomerEmployeeDetailsWidget({super.key,required this.text, this.customer});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault,vertical: Dimensions.paddingSizeSmall),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(Dimensions.paddingSizeSmall),
          border: Border.all(color: Theme.of(context).hintColor.withValues(alpha: 0.2))
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, spacing: Dimensions.paddingSizeSmall,children: [
        Container(
          width: Get.width,
          padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault,vertical: Dimensions.paddingSizeSmall),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(Dimensions.paddingSizeMediumBorder),
              color: Theme.of(context).hintColor.withValues(alpha: 0.1)
          ),
          child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Text(text,style: ubuntuSemiBold),

            if(customer?.id != 0)
            Row(spacing: Dimensions.paddingSizeSmall, children: [
              Text('total_orders'.tr),

              Container(
                  padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall, vertical: Dimensions.paddingSizeCard),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(Dimensions.paddingSizeSmall),
                      color: Theme.of(context).colorScheme.error
                  ),
                  child: Text('${customer?.totalOrderCount}',style: ubuntuRegular.copyWith(color: Theme.of(context).cardColor))
              )
            ])
          ]),
        ),

        if(ResponsiveHelper.isTab(context))...[
          Row(spacing: Dimensions.paddingSizeDefault, children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(50),
              child: CustomImageWidget(image: customer?.imageFullpath ?? '',height: 50,width: 50),
            ),

            Flexible(
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Row(mainAxisAlignment: MainAxisAlignment.start, children: [
                  Flexible(child: _DetailsItemWidget(image: Images.profileIconSvg, text: customer?.name ?? '')),

                  if(customer?.mobile != null && customer?.mobile != '1')
                    Flexible(child: _DetailsItemWidget(image: Images.callIconSvg, text: customer?.mobile ?? '')),

                  if(customer?.email != null)
                    Flexible(child: _DetailsItemWidget(image: Images.emailIconSvg, text: customer?.email ?? '')),
                ]),
                const SizedBox(height: Dimensions.paddingSizeSmall),

                Row(mainAxisAlignment: MainAxisAlignment.start, children: [
                  if(customer?.state != null)
                    Flexible(child: _DetailsItemWidget(image: Images.homeIconSvg, text: customer?.state ?? '')),

                  if(customer?.zipCode != null)
                    Flexible(child: _DetailsItemWidget(image: Images.zipIconSvg, text: customer?.zipCode ?? '')),

                  if(customer?.address != null)
                    Flexible(child: _DetailsItemWidget(image: Images.locationIconSvg, text: customer?.address ?? '')),
                ])
              ]),
            )
          ])

        ]
        else...[
          ClipRRect(
            borderRadius: BorderRadius.circular(50),
            child: CustomImageWidget(image: customer?.imageFullpath ?? '',height: 50,width: 50),
          ),

          _DetailsItemWidget(image: Images.profileIconSvg, text: customer?.name ?? ''),

          if(customer?.mobile != null && customer?.mobile != '1')
            _DetailsItemWidget(image: Images.callIconSvg, text: customer?.mobile ?? ''),

          if(customer?.email != null)
            _DetailsItemWidget(image: Images.emailIconSvg, text: customer?.email ?? ''),

          if(customer?.state != null)
            _DetailsItemWidget(image: Images.homeIconSvg, text: customer?.state ?? ''),

          if(customer?.zipCode != null)
            _DetailsItemWidget(image: Images.zipIconSvg, text: customer?.zipCode ?? ''),

          if(customer?.address != null)
            _DetailsItemWidget(image: Images.locationIconSvg, text: customer?.address ?? ''),
        ]

      ]),
    );
  }
}

class _DetailsItemWidget extends StatelessWidget {
  final String image;
  final String text;
  const _DetailsItemWidget({required this.image, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(spacing: Dimensions.paddingSizeDefault, children: [
      CustomAssetImageWidget(image,height: 16,width: 16),

      Text(text,style: ubuntuRegular.copyWith(fontSize: Dimensions.fontSizeSmall))
    ]);
  }
}

