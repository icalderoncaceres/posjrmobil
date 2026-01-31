import 'package:get/get.dart';
import 'package:six_pos/data/api/api_checker.dart';
import 'package:six_pos/features/currency/data/models/currency_model.dart';
import 'package:six_pos/features/currency/data/repositories/currency_repository.dart';

class CurrencyController extends GetxController implements GetxService {
  final CurrencyRepository currencyRepository;

  CurrencyController({required this.currencyRepository});

  // Observable variables
  final RxList<Currency> _currencyList = <Currency>[].obs;
  final RxMap<String, double> _exchangeRates = <String, double>{}.obs;
  final RxString _selectedCurrency = 'USD'.obs;
  final RxBool _isLoading = false.obs;
  final RxString _errorMessage = ''.obs;

  // Getters
  List<Currency> get currencyList => _currencyList;
  Map<String, double> get exchangeRates => _exchangeRates;
  String get selectedCurrency => _selectedCurrency.value;
  bool get isLoading => _isLoading.value;
  String get errorMessage => _errorMessage.value;

  Currency? get baseCurrency => _currencyList.firstWhereOrNull((c) => c.isBase);
  Currency? get selectedCurrencyObject =>
      _currencyList.firstWhereOrNull((c) => c.code == _selectedCurrency.value);

  @override
  void onInit() {
    super.onInit();
    _loadSelectedCurrency();
    getCurrencyList();
  }

  // Load selected currency from storage
  void _loadSelectedCurrency() {
    final saved = currencyRepository.getSelectedCurrency();
    if (saved != null) {
      _selectedCurrency.value = saved;
    }
  }

  // Get currency list from API
  Future<void> getCurrencyList() async {
    try {
      _isLoading.value = true;
      _errorMessage.value = '';

      // Try to load from cache first
      final cached = currencyRepository.getCachedCurrencies();
      if (cached != null) {
        _currencyList.value = cached;
        _updateExchangeRates();
      }

      // Fetch from API
      Response response = await currencyRepository.getCurrencyList();

      if (response.statusCode == 200) {
        final data = response.body;
        if (data['success'] == true) {
          _currencyList.clear();
          (data['data'] as List).forEach((currencyJson) {
            _currencyList.add(Currency.fromJson(currencyJson));
          });

          // Cache currencies
          await currencyRepository.cacheCurrencies(_currencyList);

          // Update exchange rates
          _updateExchangeRates();

          // Ensure selected currency is valid
          if (!_currencyList.any((c) => c.code == _selectedCurrency.value)) {
            final base = baseCurrency;
            if (base != null) {
              await selectCurrency(base.code);
            }
          }

          // Notify UI update
          update();
        } else {
          _errorMessage.value = data['message'] ?? 'Error loading currencies';
        }
      } else {
        ApiChecker.checkApi(response);
        _errorMessage.value = 'Failed to load currencies';
      }
    } catch (e) {
      _errorMessage.value = 'Error: ${e.toString()}';
    } finally {
      _isLoading.value = false;
    }
  }

  // Update exchange rates from currency list
  void _updateExchangeRates() {
    _exchangeRates.clear();
    for (final currency in _currencyList) {
      _exchangeRates[currency.code] = currency.currentRate.rate;
    }

    // Cache rates
    currencyRepository.saveExchangeRates(_exchangeRates);
  }

  // Select a currency
  Future<void> selectCurrency(String currencyCode) async {
    final currency = _currencyList.firstWhereOrNull(
      (c) => c.code == currencyCode,
    );
    if (currency != null) {
      _selectedCurrency.value = currencyCode;
      await currencyRepository.saveSelectedCurrency(currencyCode);
      update();
    }
  }

  // Convert amount between currencies
  double convertAmount(double amount, String fromCurrency, String toCurrency) {
    if (fromCurrency == toCurrency) return amount;

    final fromRate = _exchangeRates[fromCurrency] ?? 1.0;
    final toRate = _exchangeRates[toCurrency] ?? 1.0;

    // Convert to USD first, then to target currency
    final usdAmount = amount / fromRate;
    return usdAmount * toRate;
  }

  // Format amount with currency symbol
  String formatAmount(double amount, {String? currencyCode}) {
    final code = currencyCode ?? _selectedCurrency.value;
    final currency = _currencyList.firstWhereOrNull((c) => c.code == code);

    if (currency != null) {
      return currency.formatAmount(amount);
    }

    return '${code} ${amount.toStringAsFixed(2)}';
  }

  // Get currency symbol
  String getCurrencySymbol(String currencyCode) {
    final currency = _currencyList.firstWhereOrNull(
      (c) => c.code == currencyCode,
    );
    return currency?.symbol ?? currencyCode;
  }

  // Update exchange rate
  Future<bool> updateExchangeRate({
    required int currencyId,
    required double rate,
    double? buyRate,
    double? sellRate,
    String? date,
  }) async {
    try {
      _isLoading.value = true;
      _errorMessage.value = '';

      Response response = await currencyRepository.updateExchangeRate(
        currencyId: currencyId,
        rate: rate,
        buyRate: buyRate,
        sellRate: sellRate,
        date: date,
      );

      if (response.statusCode == 200) {
        final data = response.body;
        if (data['success'] == true) {
          // Refresh currency list to get updated rates
          await getCurrencyList();
          return true;
        } else {
          _errorMessage.value =
              data['message'] ?? 'Error updating exchange rate';
        }
      } else {
        ApiChecker.checkApi(response);
        _errorMessage.value = 'Failed to update exchange rate';
      }
      return false;
    } catch (e) {
      _errorMessage.value = 'Error: ${e.toString()}';
      return false;
    } finally {
      _isLoading.value = false;
    }
  }

  // Get exchange rates for a specific date
  Future<void> getExchangeRatesForDate(String date) async {
    try {
      _isLoading.value = true;
      _errorMessage.value = '';

      Response response = await currencyRepository.getExchangeRates(date: date);

      if (response.statusCode == 200) {
        final data = response.body;
        if (data['success'] == true) {
          _exchangeRates.clear();
          (data['data'] as List).forEach((rateJson) {
            _exchangeRates[rateJson['currency_code']] = (rateJson['rate'] ?? 0)
                .toDouble();
          });
        } else {
          _errorMessage.value =
              data['message'] ?? 'Error loading exchange rates';
        }
      } else {
        ApiChecker.checkApi(response);
        _errorMessage.value = 'Failed to load exchange rates';
      }
    } catch (e) {
      _errorMessage.value = 'Error: ${e.toString()}';
    } finally {
      _isLoading.value = false;
    }
  }

  // Calculate product price in selected currency
  double calculateProductPrice(ProductPrice product, double quantity) {
    return product.calculatePrice(quantity, _selectedCurrency.value);
  }

  // Get product price detail in current currency
  PriceDetail? getProductPriceDetail(ProductPrice product) {
    return product.getPriceInCurrency(_selectedCurrency.value);
  }

  // Load cached data when offline
  void loadCachedData() {
    final cachedRates = currencyRepository.getCachedExchangeRates();
    if (cachedRates != null) {
      _exchangeRates.value = cachedRates;
    }

    final cachedCurrencies = currencyRepository.getCachedCurrencies();
    if (cachedCurrencies != null) {
      _currencyList.value = cachedCurrencies;
    }
  }

  // Clear error message
  void clearError() {
    _errorMessage.value = '';
  }

  // Refresh all currency data
  Future<void> refreshCurrencyData() async {
    await getCurrencyList();
  }

  // Check if currency is available
  bool isCurrencyAvailable(String currencyCode) {
    return _currencyList.any((c) => c.code == currencyCode && c.isActive);
  }

  // Get active currencies only
  List<Currency> get activeCurrencies =>
      _currencyList.where((c) => c.isActive).toList();

  // Get non-base currencies
  List<Currency> get nonBaseCurrencies =>
      _currencyList.where((c) => !c.isBase && c.isActive).toList();
}
