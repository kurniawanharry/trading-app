class CoinTicker {
  final String symbol; // e.g. BTCUSDT
  final String name; // e.g. Bitcoin
  final String baseAsset; // e.g. BTC
  final String imageUrl; // icon
  final double price; // latest price

  CoinTicker({
    required this.symbol,
    required this.name,
    required this.baseAsset,
    required this.imageUrl,
    required this.price,
  });

  CoinTicker copyWith({
    double? price,
  }) {
    return CoinTicker(
      symbol: symbol,
      name: name,
      baseAsset: baseAsset,
      imageUrl: imageUrl,
      price: price ?? this.price,
    );
  }
}
