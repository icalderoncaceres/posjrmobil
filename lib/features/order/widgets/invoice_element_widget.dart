import 'package:flutter/material.dart';
import 'package:six_pos/helper/extension_helper.dart';
import 'package:six_pos/util/dimensions.dart';
import 'package:six_pos/util/styles.dart';

class InvoiceElementWidget extends StatelessWidget {
  final bool isBold;
  final String? title;
  final String? serial;
  final String? quantity;
  final String? price;
  final String? total;
  const InvoiceElementWidget({
    super.key,
    this.serial,
    this.isBold = false,
    this.title,
    this.quantity,
    this.price,
    this.total,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // Serial + Product Name (40%)
        Expanded(
          flex: 4,
          child: serial != null
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    _textView(context, serial!, false),
                    const SizedBox(width: Dimensions.paddingSizeDefault),
                    Expanded(child: _textView(context, title!, false)),
                  ],
                )
              : _textView(context, title!, false),
        ),

        // Quantity (15%)
        Expanded(
          flex: 1,
          child: quantity != null
              ? Center(child: _textView(context, quantity!, false))
              : const SizedBox(),
        ),

        // Unit Price (20%)
        Expanded(
          flex: 2,
          child: price != null
              ? Align(
                  alignment: Alignment.centerRight,
                  child: _textView(context, price!, false),
                )
              : const SizedBox(),
        ),

        // Total (25%)
        Expanded(
          flex: 2,
          child: total != null
              ? Align(
                  alignment: Alignment.centerRight,
                  child: _textView(context, total!, true),
                )
              : const SizedBox(),
        ),
      ],
    );
  }

  Text _textView(BuildContext context, String text, bool isBold) {
    return Text(
      text,
      style: isBold
          ? ubuntuRegular.copyWith(
              color: context.customThemeColors.textColor,
              fontSize: Dimensions.fontSizeLarge,
            )
          : ubuntuRegular.copyWith(
              color: context.customThemeColors.textOpacityColor,
            ),
    );
  }
}
