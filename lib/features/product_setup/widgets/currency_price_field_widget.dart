import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:six_pos/features/currency/controllers/currency_controller.dart';
import 'package:six_pos/features/currency/data/models/currency_model.dart';
import 'package:six_pos/common/widgets/custom_field_with_title_widget.dart';
import 'package:six_pos/common/widgets/custom_text_field_widget.dart';
import 'package:six_pos/util/dimensions.dart';
import 'package:six_pos/util/styles.dart';

class CurrencyPriceFieldWidget extends StatefulWidget {
  final TextEditingController priceController;
  final String title;
  final String hint;
  final bool isRequired;
  final Function(Currency currency, double originalPrice)? onCurrencyChanged;

  const CurrencyPriceFieldWidget({
    Key? key,
    required this.priceController,
    required this.title,
    required this.hint,
    this.isRequired = true,
    this.onCurrencyChanged,
  }) : super(key: key);

  @override
  State<CurrencyPriceFieldWidget> createState() =>
      _CurrencyPriceFieldWidgetState();
}

class _CurrencyPriceFieldWidgetState extends State<CurrencyPriceFieldWidget> {
  Currency? selectedCurrency;
  double? originalPrice;

  @override
  void initState() {
    super.initState();
    // Inicializar con moneda base por defecto
    final currencyController = Get.find<CurrencyController>();
    selectedCurrency = currencyController.baseCurrency;
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CurrencyController>(
      builder: (currencyController) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Título del campo
            Row(
              children: [
                Text(
                  widget.title,
                  style: ubuntuMedium.copyWith(
                    fontSize: Dimensions.fontSizeDefault,
                  ),
                ),
                if (widget.isRequired)
                  Text(' *', style: ubuntuMedium.copyWith(color: Colors.red)),
              ],
            ),
            const SizedBox(height: 8),

            // Selector de moneda
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                border: Border.all(
                  color: Theme.of(context).hintColor.withValues(alpha: 0.3),
                ),
                borderRadius: BorderRadius.circular(8),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<Currency>(
                  value: selectedCurrency,
                  isExpanded: true,
                  hint: Text('select_currency'.tr),
                  items: currencyController.currencyList
                      .where((c) => c.isActive)
                      .map((currency) {
                        return DropdownMenuItem<Currency>(
                          value: currency,
                          child: Text(
                            '${currency.code} (${currency.symbol})',
                            style: ubuntuRegular.copyWith(
                              fontSize: Dimensions.fontSizeDefault,
                            ),
                          ),
                        );
                      })
                      .toList(),
                  onChanged: (Currency? newValue) {
                    setState(() {
                      selectedCurrency = newValue;
                    });

                    // Notificar el cambio
                    if (newValue != null &&
                        widget.priceController.text.isNotEmpty) {
                      double price =
                          double.tryParse(widget.priceController.text) ?? 0;
                      widget.onCurrencyChanged?.call(newValue, price);
                    }
                  },
                ),
              ),
            ),
            const SizedBox(height: 8),

            // Campo de precio
            CustomTextFieldWidget(
              controller: widget.priceController,
              hintText: widget.hint,
              inputType: TextInputType.number,
              fontSize: Dimensions.fontSizeSmall,
              contentPadding: Dimensions.paddingSizeDefault,
              onChanged: (value) {
                // Calcular conversión en tiempo real
                if (selectedCurrency != null && value.isNotEmpty) {
                  double price = double.tryParse(value) ?? 0;
                  widget.onCurrencyChanged?.call(selectedCurrency!, price);
                }
              },
            ),

            // Mostrar conversión a USD si no es la moneda base
            if (selectedCurrency != null &&
                !selectedCurrency!.isBase &&
                widget.priceController.text.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Text(
                  _getConversionText(),
                  style: ubuntuRegular.copyWith(
                    fontSize: Dimensions.fontSizeExtraSmall,
                    color: Theme.of(context).hintColor,
                  ),
                ),
              ),
          ],
        );
      },
    );
  }

  String _getConversionText() {
    if (selectedCurrency == null || widget.priceController.text.isEmpty) {
      return '';
    }

    double price = double.tryParse(widget.priceController.text) ?? 0;
    if (price <= 0) return '';

    double usdPrice = selectedCurrency!.isBase
        ? price
        : price / selectedCurrency!.exchangeRate;

    return 'equivalent_to'.tr + ' \$${usdPrice.toStringAsFixed(2)} USD';
  }
}
