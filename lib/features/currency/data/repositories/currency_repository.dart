import 'package:six_pos/data/api/api_checker.dart';
import 'package:six_pos/data/api/api_client.dart';
import 'package:six_pos/features/currency/data/models/currency_model.dart';
import 'package:six_pos/util/app_constants.dart';
import 'package:get/get.dart';

class CurrencyRepository extends GetxService {
  final ApiClient apiClient;

  CurrencyRepository({required this.apiClient});

  Future<Response> getCurrencyList() async {
    try {
      return await apiClient.getData(AppConstants.getCurrencyListUrl);
    } catch (e) {
      return Response(
        statusCode: 1,
        statusText: 'Error fetching currencies: ${e.toString()}',
      );
    }
  }

  Future<Response> getExchangeRates({String? date}) async {
    try {
      String url = AppConstants.getExchangeRatesUrl;
      if (date != null) {
        url += '?date=$date';
      }
      return await apiClient.getData(url);
    } catch (e) {
      return Response(
        statusCode: 1,
        statusText: 'Error fetching exchange rates: ${e.toString()}',
      );
    }
  }

  Future<Response> updateExchangeRate({
    required int currencyId,
    required double rate,
    double? buyRate,
    double? sellRate,
    String? date,
  }) async {
    try {
      Map<String, dynamic> data = {'currency_id': currencyId, 'rate': rate};

      if (buyRate != null) data['buy_rate'] = buyRate;
      if (sellRate != null) data['sell_rate'] = sellRate;
      if (date != null) data['date'] = date;

      return await apiClient.postData(AppConstants.updateExchangeRateUrl, data);
    } catch (e) {
      return Response(
        statusCode: 1,
        statusText: 'Error updating exchange rate: ${e.toString()}',
      );
    }
  }

  Future<Response> getProductPrices({int? productId, int? limit}) async {
    try {
      String url = AppConstants.getProductPricesUrl;
      List<String> params = [];

      if (productId != null) {
        params.add('product_id=$productId');
      }
      if (limit != null) {
        params.add('limit=$limit');
      }

      if (params.isNotEmpty) {
        url += '?' + params.join('&');
      }

      return await apiClient.getData(url);
    } catch (e) {
      return Response(
        statusCode: 1,
        statusText: 'Error fetching product prices: ${e.toString()}',
      );
    }
  }

  Future<Response> convertCurrency({
    required double amount,
    required String fromCurrency,
    required String toCurrency,
  }) async {
    try {
      Map<String, dynamic> data = {
        'amount': amount,
        'from_currency': fromCurrency,
        'to_currency': toCurrency,
      };

      return await apiClient.postData(
        '${AppConstants.baseUrl}/api/v1/currency/convert',
        data,
      );
    } catch (e) {
      return Response(
        statusCode: 1,
        statusText: 'Error converting currency: ${e.toString()}',
      );
    }
  }

  // Cache methods for offline access
  Future<void> cacheCurrencies(List<Currency> currencies) async {
    try {
      final currencyData = currencies.map((c) => c.toJson()).toList();
      await apiClient.sharedPreferences.setString(
        'cached_currencies',
        currencyData.toString(),
      );
      await apiClient.sharedPreferences.setString(
        'currency_cache_timestamp',
        DateTime.now().toIso8601String(),
      );
    } catch (e) {
      print('Error caching currencies: $e');
    }
  }

  List<Currency>? getCachedCurrencies() {
    try {
      final cachedData = apiClient.sharedPreferences.getString(
        'cached_currencies',
      );
      final cacheTimestamp = apiClient.sharedPreferences.getString(
        'currency_cache_timestamp',
      );

      if (cachedData != null && cacheTimestamp != null) {
        final timestamp = DateTime.parse(cacheTimestamp);
        final now = DateTime.now();

        // Check if cache is less than 1 hour old
        if (now.difference(timestamp).inHours < 1) {
          // Parse cached data - this would need proper JSON parsing
          // For now, returning null to force refresh
          return null;
        }
      }
      return null;
    } catch (e) {
      print('Error reading cached currencies: $e');
      return null;
    }
  }

  Future<void> saveSelectedCurrency(String currencyCode) async {
    await apiClient.sharedPreferences.setString(
      'selected_currency',
      currencyCode,
    );
  }

  String? getSelectedCurrency() {
    return apiClient.sharedPreferences.getString('selected_currency');
  }

  Future<void> saveExchangeRates(Map<String, double> rates) async {
    final rateData = rates.entries.map((e) => '${e.key}:${e.value}').join(',');
    await apiClient.sharedPreferences.setString('cached_rates', rateData);
    await apiClient.sharedPreferences.setString(
      'rates_cache_timestamp',
      DateTime.now().toIso8601String(),
    );
  }

  Map<String, double>? getCachedExchangeRates() {
    try {
      final cachedData = apiClient.sharedPreferences.getString('cached_rates');
      final cacheTimestamp = apiClient.sharedPreferences.getString(
        'rates_cache_timestamp',
      );

      if (cachedData != null && cacheTimestamp != null) {
        final timestamp = DateTime.parse(cacheTimestamp);
        final now = DateTime.now();

        // Check if cache is less than 30 minutes old
        if (now.difference(timestamp).inMinutes < 30) {
          Map<String, double> rates = {};
          final entries = cachedData.split(',');
          for (final entry in entries) {
            final parts = entry.split(':');
            if (parts.length == 2) {
              rates[parts[0]] = double.tryParse(parts[1]) ?? 0;
            }
          }
          return rates;
        }
      }
      return null;
    } catch (e) {
      print('Error reading cached rates: $e');
      return null;
    }
  }
}
