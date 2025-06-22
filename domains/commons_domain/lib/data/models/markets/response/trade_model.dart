class Trade {
  final String symbol;
  final double price;
  final double quantity;
  final int timestamp;

  Trade({
    required this.symbol,
    required this.price,
    required this.quantity,
    required this.timestamp,
  });
}

class TradeModel extends Trade {
  TradeModel({
    required super.symbol,
    required super.price,
    required super.quantity,
    required super.timestamp,
  });

  factory TradeModel.fromJson(Map<String, dynamic> json) {
    return TradeModel(
      symbol: json['s'] ?? '',
      price: double.tryParse(json['p'] ?? '0') ?? 0.0,
      quantity: double.tryParse(json['q'] ?? '0') ?? 0.0,
      timestamp: json['T'] ?? 0,
    );
  }
}
