class Currency {
  final int id;
  final String country;
  final String code;
  final String symbol;
  final bool isBase;
  final bool isActive;
  final double exchangeRate;
  final ExchangeRate currentRate;
  final DateTime createdAt;
  final DateTime updatedAt;

  Currency({
    required this.id,
    required this.country,
    required this.code,
    required this.symbol,
    required this.isBase,
    required this.isActive,
    required this.exchangeRate,
    required this.currentRate,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Currency.fromJson(Map<String, dynamic> json) {
    try {
      return Currency(
        id: int.tryParse(json['id']?.toString() ?? '0') ?? 0,
        country: json['country']?.toString() ?? '',
        code: json['code']?.toString() ?? '',
        symbol: json['symbol']?.toString() ?? '',
        isBase: json['is_base'] == true,
        isActive: json['is_active'] == true,
        exchangeRate:
            double.tryParse(json['exchange_rate']?.toString() ?? '0') ?? 0.0,
        currentRate: ExchangeRate.fromJson(json['current_rate'] ?? {}),
        createdAt: _parseDateTime(json['created_at']),
        updatedAt: _parseDateTime(json['updated_at']),
      );
    } catch (e) {
      throw Exception('Error parsing Currency from JSON: $e');
    }
  }

  static DateTime _parseDateTime(dynamic dateString) {
    if (dateString == null) return DateTime.now();
    try {
      return DateTime.parse(dateString.toString());
    } catch (e) {
      return DateTime.now();
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'country': country,
      'code': code,
      'symbol': symbol,
      'is_base': isBase,
      'is_active': isActive,
      'exchange_rate': exchangeRate,
      'current_rate': currentRate.toJson(),
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  String formatAmount(double amount) {
    return '$symbol ${amount.toStringAsFixed(2)}';
  }

  double convertFromUSD(double usdAmount) {
    if (isBase) return usdAmount;
    return usdAmount * currentRate.rate;
  }

  double convertToUSD(double amount) {
    if (isBase) return amount;
    return amount / currentRate.rate;
  }
}

class ExchangeRate {
  final double rate;
  final double buyRate;
  final double sellRate;
  final String date;
  final bool isActive;

  ExchangeRate({
    required this.rate,
    required this.buyRate,
    required this.sellRate,
    required this.date,
    required this.isActive,
  });

  factory ExchangeRate.fromJson(Map<String, dynamic> json) {
    return ExchangeRate(
      rate: double.tryParse(json['rate']?.toString() ?? '0') ?? 0.0,
      buyRate: double.tryParse(json['buy_rate']?.toString() ?? '0') ?? 0.0,
      sellRate: double.tryParse(json['sell_rate']?.toString() ?? '0') ?? 0.0,
      date:
          json['date']?.toString() ??
          DateTime.now().toString().substring(0, 10),
      isActive: json['is_active'] == true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'rate': rate,
      'buy_rate': buyRate,
      'sell_rate': sellRate,
      'date': date,
      'is_active': isActive,
    };
  }
}

class ProductPrice {
  final int productId;
  final String productName;
  final String productCode;
  final String unitType;
  final double basePriceUSD;
  final Map<String, PriceDetail> prices;
  final String? unit;

  ProductPrice({
    required this.productId,
    required this.productName,
    required this.productCode,
    required this.unitType,
    required this.basePriceUSD,
    required this.prices,
    this.unit,
  });

  factory ProductPrice.fromJson(Map<String, dynamic> json) {
    Map<String, PriceDetail> pricesMap = {};
    if (json['prices'] != null) {
      (json['prices'] as Map<String, dynamic>).forEach((key, value) {
        pricesMap[key] = PriceDetail.fromJson(value);
      });
    }

    return ProductPrice(
      productId: json['id'],
      productName: json['name'] ?? '',
      productCode: json['product_code'] ?? '',
      unitType: json['unit_type'] ?? 'piece',
      basePriceUSD: (json['base_price_usd'] ?? 0).toDouble(),
      prices: pricesMap,
      unit: json['unit'],
    );
  }

  PriceDetail? getPriceInCurrency(String currencyCode) {
    return prices[currencyCode];
  }

  double calculatePrice(double quantity, String currencyCode) {
    final priceDetail = getPriceInCurrency(currencyCode);
    if (priceDetail == null) return 0;

    switch (unitType) {
      case 'piece':
        return priceDetail.price * quantity;
      case 'weight_kg':
        return priceDetail.price * quantity; // quantity in KG
      case 'weight_gr':
        return priceDetail.price * quantity; // quantity in grams
      case 'volume':
        return priceDetail.price * quantity; // quantity in liters
      case 'mixed':
        return priceDetail.price * quantity; // can be unit or weight
      default:
        return priceDetail.price * quantity;
    }
  }
}

class PriceDetail {
  final double price;
  final String formatted;

  PriceDetail({required this.price, required this.formatted});

  factory PriceDetail.fromJson(Map<String, dynamic> json) {
    return PriceDetail(
      price: (json['price'] ?? 0).toDouble(),
      formatted: json['formatted'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {'price': price, 'formatted': formatted};
  }
}
