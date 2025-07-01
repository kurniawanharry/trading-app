class SimulatedTrade {
  final String symbol;
  final double price;
  final double quantity;
  final double total;
  final bool isBuy;
  final DateTime timestamp;

  SimulatedTrade({
    required this.symbol,
    required this.price,
    required this.quantity,
    required this.total,
    required this.isBuy,
    required this.timestamp,
  });

  Map<String, dynamic> toJson() => {
        'symbol': symbol,
        'price': price,
        'quantity': quantity,
        'total': total,
        'isBuy': isBuy,
        'timestamp': timestamp.toIso8601String(),
      };

  factory SimulatedTrade.fromJson(Map<String, dynamic> json) => SimulatedTrade(
        symbol: json['symbol'],
        price: json['price'],
        quantity: json['quantity'],
        total: json['total'],
        isBuy: json['isBuy'],
        timestamp: DateTime.parse(json['timestamp']),
      );
}
