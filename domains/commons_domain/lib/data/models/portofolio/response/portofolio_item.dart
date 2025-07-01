class PortfolioItem {
  final String name;
  final String image;
  final String symbol;
  final double totalQuantity;
  final double avgBuyPrice;
  final double currentPrice;
  final double openPrice;

  double get totalValue => totalQuantity * currentPrice;

  // Unrealized profit/loss
  double get unrealizedPnL => (currentPrice - avgBuyPrice) * totalQuantity;

  // Today's PnL
  double get todayPnL => (currentPrice - openPrice) * totalQuantity;

  // Average cost per unit (already provided as avgBuyPrice)
  double get averageCost => avgBuyPrice;

  PortfolioItem({
    required this.name,
    required this.image,
    required this.symbol,
    required this.totalQuantity,
    required this.avgBuyPrice,
    required this.currentPrice,
    required this.openPrice,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'image': image,
      'symbol': symbol,
      'totalQuantity': totalQuantity,
      'avgBuyPrice': avgBuyPrice,
      'currentPrice': currentPrice,
      'openPrice': openPrice,
    };
  }

  factory PortfolioItem.fromJson(Map<String, dynamic> json) {
    return PortfolioItem(
      name: json['name'],
      image: json['image'],
      symbol: json['symbol'],
      totalQuantity: (json['totalQuantity'] as num).toDouble(),
      avgBuyPrice: (json['avgBuyPrice'] as num).toDouble(),
      currentPrice: (json['currentPrice'] as num).toDouble(),
      openPrice: (json['openPrice'] as num).toDouble(),
    );
  }
}
