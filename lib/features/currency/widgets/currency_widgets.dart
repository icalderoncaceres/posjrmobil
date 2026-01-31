import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:six_pos/features/currency/controllers/currency_controller.dart';
import 'package:six_pos/features/currency/data/models/currency_model.dart';
import 'package:six_pos/util/dimensions.dart';

class CurrencySelectorWidget extends StatelessWidget {
  final VoidCallback? onCurrencyChanged;
  final bool showExchangeRate;

  const CurrencySelectorWidget({
    Key? key,
    this.onCurrencyChanged,
    this.showExchangeRate = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CurrencyController>(
      builder: (currencyController) {
        if (currencyController.currencyList.isEmpty) {
          return Container(
            padding: EdgeInsets.all(Dimensions.paddingSizeDefault),
            child: const CircularProgressIndicator(),
          );
        }

        final selectedCurrency = currencyController.selectedCurrencyObject;
        if (selectedCurrency == null) {
          return Container();
        }

        return Container(
          padding: const EdgeInsets.symmetric(
            horizontal: Dimensions.paddingSizeDefault,
            vertical: Dimensions.paddingSizeSmall,
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
            border: Border.all(color: Theme.of(context).dividerColor),
          ),
          child: Row(
            children: [
              Icon(
                Icons.monetization_on,
                color: Theme.of(context).hintColor,
                size: 20,
              ),
              const SizedBox(width: Dimensions.paddingSizeSmall),
              Expanded(
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: currencyController.selectedCurrency,
                    isExpanded: true,
                    items: currencyController.activeCurrencies.map((
                      Currency currency,
                    ) {
                      return DropdownMenuItem<String>(
                        value: currency.code,
                        child: Row(
                          children: [
                            Text(
                              currency.symbol,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(
                              width: Dimensions.paddingSizeExtraSmall,
                            ),
                            Text(currency.code),
                            if (currency.isBase) ...[
                              const SizedBox(
                                width: Dimensions.paddingSizeExtraSmall,
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 6,
                                  vertical: 2,
                                ),
                                decoration: BoxDecoration(
                                  color: Theme.of(context).primaryColor,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: const Text(
                                  'BASE',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ],
                        ),
                      );
                    }).toList(),
                    onChanged: (String? value) {
                      if (value != null) {
                        currencyController.selectCurrency(value);
                        onCurrencyChanged?.call();
                      }
                    },
                  ),
                ),
              ),
              if (showExchangeRate && !selectedCurrency.isBase) ...[
                const SizedBox(width: Dimensions.paddingSizeSmall),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Rate: ${selectedCurrency.currentRate.rate.toStringAsFixed(4)}',
                      style: TextStyle(
                        fontSize: 12,
                        color: Theme.of(context).hintColor,
                      ),
                    ),
                    Text(
                      'Per 1 USD',
                      style: TextStyle(
                        fontSize: 10,
                        color: Theme.of(context).hintColor,
                      ),
                    ),
                  ],
                ),
              ],
            ],
          ),
        );
      },
    );
  }
}

class CurrencyAmountWidget extends StatelessWidget {
  final double amount;
  final String? currencyCode;
  final TextStyle? textStyle;
  final bool showCode;

  const CurrencyAmountWidget({
    Key? key,
    required this.amount,
    this.currencyCode,
    this.textStyle,
    this.showCode = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CurrencyController>(
      builder: (currencyController) {
        final code = currencyCode ?? currencyController.selectedCurrency;
        final formatted = currencyController.formatAmount(
          amount,
          currencyCode: code,
        );

        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              formatted,
              style: textStyle ?? Theme.of(context).textTheme.bodyMedium,
            ),
            if (showCode && !formatted.contains(code)) ...[
              const SizedBox(width: Dimensions.paddingSizeExtraSmall),
              Text(
                code,
                style: TextStyle(
                  fontSize: (textStyle?.fontSize ?? 14) * 0.8,
                  color: Theme.of(context).hintColor,
                ),
              ),
            ],
          ],
        );
      },
    );
  }
}

class ExchangeRateInfoWidget extends StatelessWidget {
  final Currency currency;
  final bool showFullDetails;

  const ExchangeRateInfoWidget({
    Key? key,
    required this.currency,
    this.showFullDetails = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (currency.isBase) {
      return Container(
        padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
        decoration: BoxDecoration(
          color: Theme.of(context).primaryColor.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
        ),
        child: Text(
          'Base Currency',
          style: TextStyle(
            color: Theme.of(context).primaryColor,
            fontWeight: FontWeight.bold,
            fontSize: 12,
          ),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          children: [
            Icon(
              Icons.trending_up,
              size: 16,
              color: Theme.of(context).hintColor,
            ),
            const SizedBox(width: Dimensions.paddingSizeExtraSmall),
            Text(
              'Exchange Rate',
              style: TextStyle(
                fontWeight: FontWeight.w500,
                color: Theme.of(context).hintColor,
              ),
            ),
          ],
        ),
        const SizedBox(height: Dimensions.paddingSizeExtraSmall),
        Text(
          '1 USD = ${currency.currentRate.rate.toStringAsFixed(4)} ${currency.code}',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        if (showFullDetails) ...[
          const SizedBox(height: Dimensions.paddingSizeExtraSmall),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Buy Rate',
                      style: TextStyle(
                        fontSize: 12,
                        color: Theme.of(context).hintColor,
                      ),
                    ),
                    Text(
                      currency.currentRate.buyRate.toStringAsFixed(4),
                      style: const TextStyle(
                        fontWeight: FontWeight.w500,
                        color: Colors.green,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Sell Rate',
                      style: TextStyle(
                        fontSize: 12,
                        color: Theme.of(context).hintColor,
                      ),
                    ),
                    Text(
                      currency.currentRate.sellRate.toStringAsFixed(4),
                      style: const TextStyle(
                        fontWeight: FontWeight.w500,
                        color: Colors.red,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
        const SizedBox(height: Dimensions.paddingSizeExtraSmall),
        Text(
          'Last Updated: ${currency.currentRate.date}',
          style: TextStyle(fontSize: 10, color: Theme.of(context).hintColor),
        ),
      ],
    );
  }
}

class MultiCurrencyConverterWidget extends StatefulWidget {
  final double baseAmount;
  final String baseCurrency;
  final List<String> targetCurrencies;

  const MultiCurrencyConverterWidget({
    Key? key,
    required this.baseAmount,
    required this.baseCurrency,
    this.targetCurrencies = const [],
  }) : super(key: key);

  @override
  State<MultiCurrencyConverterWidget> createState() =>
      _MultiCurrencyConverterWidgetState();
}

class _MultiCurrencyConverterWidgetState
    extends State<MultiCurrencyConverterWidget> {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<CurrencyController>(
      builder: (currencyController) {
        final currencies = widget.targetCurrencies.isNotEmpty
            ? widget.targetCurrencies
            : currencyController.activeCurrencies.map((c) => c.code).toList();

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Amount in Different Currencies:',
              style: Theme.of(context).textTheme.titleSmall,
            ),
            const SizedBox(height: Dimensions.paddingSizeSmall),
            ...currencies.map((currencyCode) {
              if (currencyCode == widget.baseCurrency) return SizedBox.shrink();

              final convertedAmount = currencyController.convertAmount(
                widget.baseAmount,
                widget.baseCurrency,
                currencyCode,
              );

              final symbol = currencyController.getCurrencySymbol(currencyCode);

              return Container(
                padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                margin: const EdgeInsets.only(
                  bottom: Dimensions.paddingSizeExtraSmall,
                ),
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor.withValues(alpha: 0.5),
                  borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      currencyCode,
                      style: const TextStyle(fontWeight: FontWeight.w500),
                    ),
                    Text(
                      '$symbol ${convertedAmount.toStringAsFixed(2)}',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              );
            }).toList(),
          ],
        );
      },
    );
  }
}
