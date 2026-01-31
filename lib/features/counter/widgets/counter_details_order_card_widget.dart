import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:six_pos/common/widgets/custom_asset_image_widget.dart';
import 'package:six_pos/common/widgets/custom_horizontal_dotted_widget.dart';
import 'package:six_pos/features/counter/domain/models/counter_details_model.dart';
import 'package:six_pos/features/order/screens/invoice_screen.dart';
import 'package:six_pos/helper/date_converter_helper.dart';
import 'package:six_pos/helper/extension_helper.dart';
import 'package:six_pos/helper/price_converter_helper.dart';
import 'package:six_pos/helper/responsive_helper.dart';
import 'package:six_pos/util/dimensions.dart';
import 'package:six_pos/util/images.dart';
import 'package:six_pos/util/styles.dart';

class CounterDetailsOrderCardWidget extends StatelessWidget {
  final Orders? orders;
  const CounterDetailsOrderCardWidget({
    super.key, this.orders
  });

  @override
  Widget build(BuildContext context) {
    return Container(color: Theme.of(context).cardColor,
      padding: const EdgeInsets.symmetric(
        horizontal: Dimensions.paddingSizeDefault,
        vertical: Dimensions.paddingSizeSmall,
      ),
      margin: const EdgeInsets.only(bottom: Dimensions.paddingSizeSmall),
      child: Column(children: [

        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [

          Text("${orders?.orderId ?? 0}",
            style: ubuntuMedium.copyWith(
              color: Theme.of(context).colorScheme.onSecondary,
              fontSize: Dimensions.fontSizeDefault,
            ),
          ),

          Text((orders?.customer?.name?.isNotEmpty ?? false) ? "${orders?.customer?.name}" : 'customer_deleted'.tr,
            style: ubuntuBold.copyWith(
              fontSize: Dimensions.fontSizeDefault,
              color: Theme.of(context).textTheme.bodyLarge?.color,
            ),
          )

        ]),
        const SizedBox(height: Dimensions.paddingSizeExtraSmall),

        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [

          Text(DateConverterHelper.isoStringToDateMonthYearWithLocal(orders?.orderDate ?? '0'),
            style: ubuntuRegular.copyWith(
              color: Theme.of(context).textTheme.bodyLarge?.color,
              fontSize: Dimensions.fontSizeDefault,
            ),
          ),

          Text( ((orders?.customer?.mobile?.isNotEmpty ?? false) && (orders?.customer?.id != 0))
              ? "${orders?.customer?.mobile}" : '',
            style: ubuntuRegular.copyWith(
              fontSize: Dimensions.fontSizeDefault,
              color: Theme.of(context).textTheme.bodyLarge?.color,
            ),
          )

        ]),
        const SizedBox(height: Dimensions.paddingSizeDefault),

        CustomHorizontalDottedWidget(
          numberOfDashes: ResponsiveHelper.isTab(context) ? 100 : 50,
          dashWidth: 5,
          dashHeight: 1,
          horizontalPadding: 0,
          dashColor: Theme.of(context).hintColor.withValues(alpha: 0.5),
        ),
        const SizedBox(height: Dimensions.paddingSizeDefault),

        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, crossAxisAlignment:CrossAxisAlignment.start, children: [

          Expanded(
            child: Text('order_summary'.tr,
              style: ubuntuBold.copyWith(
                color: Theme.of(context).colorScheme.onPrimary,
                fontSize: Dimensions.fontSizeDefault,
              ),
            ),
          ),

          Expanded(
            child: RichText(
                textAlign: TextAlign.end,
                text: TextSpan(children: [

                  TextSpan(
                    text: "${'paid_by'.tr} ",
                    style: ubuntuMedium.copyWith(
                        color: Theme.of(context).colorScheme.onPrimary,
                        fontSize: Dimensions.fontSizeDefault
                    ),
                  ),

                  TextSpan(
                    text: orders?.paymentMethod == 'wallet' ? 'wallet'.tr : (orders?.paymentMethod != null) ? '${orders?.paymentMethod}' : 'account_deleted'.tr,
                    style: ubuntuRegular.copyWith(
                        color: context.customThemeColors.textColor,
                        fontSize: Dimensions.fontSizeDefault
                    ),
                  ),

                ]),
            ),
          ),

        ]),
        const SizedBox(height: Dimensions.paddingSizeDefault),

        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [

          Text("${'order_amount'.tr}: ${PriceConverterHelper.convertPrice(
              context, orders?.orderTotal ?? 0.0)}",
            style: ubuntuRegular.copyWith(
              color: Theme.of(context).textTheme.bodyLarge?.color,
              fontSize: Dimensions.fontSizeDefault,
            ),
          ),

          InkWell(
            onTap: ()=> Get.to(()=> InVoiceScreen(orderId: orders?.orderId)),
            child: const CustomAssetImageWidget(
              Images.invoiceIcon,
              height: 20, width: 20,
            ),
          )

        ]),
        const SizedBox(height: Dimensions.paddingSizeExtraSmall),

      ]),
    );
  }
}