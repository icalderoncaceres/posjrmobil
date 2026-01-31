import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:six_pos/features/splash/controllers/splash_controller.dart';
import 'package:six_pos/features/currency/controllers/currency_controller.dart';

class PriceConverterHelper {
  static String convertPrice(
    BuildContext context,
    double? price, {
    double? discount,
    String? discountType,
    bool isShowLongPrice = false,
  }) {
    if (discount != null) {
      if (discountType == 'amount' || discountType == null) {
        price = price! - discount;
      } else if (discountType == 'percent') {
        price = price! - ((discount / 100) * price);
      }
    }

    // Convert price to selected currency
    double convertedPrice = convertToActiveCurrency(price ?? 0.0);
    String currencySymbol = getActiveCurrencySymbol();

    return '$currencySymbol'
        '${isShowLongPrice == true ? '${longToShortPrice(convertedPrice).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')} ' : convertedPrice.toStringAsFixed(2).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')}';
  }

  static String convertWithDiscount(
    BuildContext context,
    double price,
    double discount,
    String discountType,
  ) {
    if (discountType == 'amount') {
      price = price - discount;
    } else if (discountType == 'percent') {
      price = price - ((discount / 100) * price);
    }

    double convertedPrice = convertToActiveCurrency(price);
    String currencySymbol = getActiveCurrencySymbol();

    return '$currencySymbol'
        '${convertedPrice.toStringAsFixed(2)}';
  }

  static double discountCalculation(
    BuildContext context,
    double price,
    double discount,
    String? discountType,
  ) {
    if (discountType == 'amount') {
      discount = discount;
    } else if (discountType == 'percent') {
      discount = ((discount / 100) * price);
    }
    return discount;
  }

  static String discountCalculationWithOutSymbol(
    BuildContext context,
    double price,
    double discount,
    String? discountType,
  ) {
    if (discountType == 'amount') {
      discount = discount;
    } else if (discountType == 'percent') {
      discount = ((discount / 100) * price);
    }
    return discount.toStringAsFixed(2);
  }

  static String calculation(
    double amount,
    double discount,
    String type,
    int quantity,
  ) {
    double calculatedAmount = 0;
    if (type == 'amount') {
      calculatedAmount = discount * quantity;
    } else if (type == 'percent') {
      calculatedAmount = (discount / 100) * (amount * quantity);
    }

    double convertedAmount = convertToActiveCurrency(calculatedAmount);
    String currencySymbol = getActiveCurrencySymbol();

    return '$currencySymbol ${convertedAmount.toStringAsFixed(2)}';
  }

  static String percentageCalculation(
    BuildContext context,
    String price,
    String discount,
    String discountType,
  ) {
    String currencySymbol = getActiveCurrencySymbol();
    return '$discount${discountType == 'percent' ? '%' : '$currencySymbol'} OFF';
  }

  static String priceWithSymbol(double amount) {
    double convertedAmount = convertToActiveCurrency(amount);
    String currencySymbol = getActiveCurrencySymbol();
    return '$currencySymbol ${convertedAmount.toStringAsFixed(2)}';
  }

  static String symbolWithPrice(double amount) {
    double convertedAmount = convertToActiveCurrency(amount);
    String currencySymbol = getActiveCurrencySymbol();
    return '${convertedAmount.toStringAsFixed(2)} $currencySymbol';
  }

  static String longToShortPrice(double amount, {int decimalPoint = 2}) {
    if (amount.abs() >= 1e12) {
      return '${(amount / 1e12).toStringAsFixed(decimalPoint)}T';
    } else if (amount.abs() >= 1e9) {
      return '${(amount / 1e9).toStringAsFixed(decimalPoint)}B';
    } else if (amount.abs() >= 1e6) {
      return '${(amount / 1e6).toStringAsFixed(decimalPoint)}M';
    } else if (amount.abs() >= 1e3) {
      return '${(amount / 1e3).toStringAsFixed(decimalPoint)}K';
    } else {
      return amount.toStringAsFixed(decimalPoint);
    }
  }

  static String discountWithLogo(
    BuildContext context,
    double? discount,
    String? discountType,
  ) {
    String currencySymbol = getActiveCurrencySymbol();
    return '$discount${discountType == 'percent' ? '%' : '$currencySymbol'}';
  }

  // Helper methods for currency conversion
  static double convertToActiveCurrency(double baseAmount) {
    try {
      final currencyController = Get.find<CurrencyController>();
      final activeCurrency = currencyController.selectedCurrencyObject;

      if (activeCurrency != null && !activeCurrency.isBase) {
        // Convert from base currency to active currency
        // Base amount is in USD, convert to selected currency
        double rate =
            double.tryParse(activeCurrency.currentRate.rate.toString()) ?? 1.0;
        return baseAmount * rate;
      }

      return baseAmount;
    } catch (e) {
      // Fallback to base amount if currency controller is not available
      return baseAmount;
    }
  }

  static String getActiveCurrencySymbol() {
    try {
      final currencyController = Get.find<CurrencyController>();
      final activeCurrency = currencyController.selectedCurrencyObject;

      if (activeCurrency != null) {
        return activeCurrency.symbol;
      }

      // Fallback to splash controller currency
      return Get.find<SplashController>().configModel?.currencySymbol ?? '\$';
    } catch (e) {
      // Fallback to splash controller currency
      return Get.find<SplashController>().configModel?.currencySymbol ?? '\$';
    }
  }

  static double convertFromActiveCurrencyToBase(double activeCurrencyAmount) {
    try {
      final currencyController = Get.find<CurrencyController>();
      final activeCurrency = currencyController.selectedCurrencyObject;

      if (activeCurrency != null && !activeCurrency.isBase) {
        // Convert from active currency back to base currency (USD)
        double rate =
            double.tryParse(activeCurrency.currentRate.rate.toString()) ?? 1.0;
        return activeCurrencyAmount / rate;
      }

      return activeCurrencyAmount;
    } catch (e) {
      // Fallback to original amount if currency controller is not available
      return activeCurrencyAmount;
    }
  }
}
