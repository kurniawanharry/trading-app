class CoinGeckoCoin {
  final String id;
  final String symbol;
  final String name;
  final String image;
  final double? priceChangePercentage24h;

  CoinGeckoCoin({
    required this.id,
    required this.symbol,
    required this.name,
    required this.image,
    required this.priceChangePercentage24h,
  });

  factory CoinGeckoCoin.fromJson(Map<String, dynamic> json) {
    return CoinGeckoCoin(
      id: json['id'],
      symbol: json['symbol'],
      name: json['name'],
      image: json['image'],
      priceChangePercentage24h: json['price_change_percentage_24h'] != null
          ? (json['price_change_percentage_24h'] as num).toDouble()
          : null,
    );
  }
}
