class CoinGeckoCoin {
  final String id;
  final String symbol;
  final String name;
  final String image;

  CoinGeckoCoin({
    required this.id,
    required this.symbol,
    required this.name,
    required this.image,
  });

  factory CoinGeckoCoin.fromJson(Map<String, dynamic> json) {
    return CoinGeckoCoin(
      id: json['id'],
      symbol: json['symbol'],
      name: json['name'],
      image: json['image'],
    );
  }
}
