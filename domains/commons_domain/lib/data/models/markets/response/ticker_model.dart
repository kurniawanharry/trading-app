class TickerData {
  final String symbol;
  final double openPrice;
  final double lastPrice;
  final double highPrice;
  final double lowPrice;
  final double priceChange;
  final double priceChangePercent;

  TickerData({
    required this.symbol,
    required this.openPrice,
    required this.lastPrice,
    required this.highPrice,
    required this.lowPrice,
    required this.priceChange,
    required this.priceChangePercent,
  });

  factory TickerData.fromJson(Map<String, dynamic> json) {
    return TickerData(
      symbol: json['s'],
      openPrice: double.tryParse(json['o'] ?? '0') ?? 0.0,
      lastPrice: double.tryParse(json['c'] ?? '0') ?? 0.0,
      highPrice: double.tryParse(json['h'] ?? '0') ?? 0.0,
      lowPrice: double.tryParse(json['l'] ?? '0') ?? 0.0,
      priceChange: double.tryParse(json['p'] ?? '0') ?? 0.0,
      priceChangePercent: double.tryParse(json['P'] ?? '0') ?? 0.0,
    );
  }
}
