class CoinTicker {
  final String symbol; // e.g. BTCUSDT
  final String name; // e.g. Bitcoin
  final String baseAsset; // e.g. BTC
  final String imageUrl; // icon
  final double price; // latest price
  final double priceChangePercentage24h;

  CoinTicker({
    required this.symbol,
    required this.name,
    required this.baseAsset,
    required this.imageUrl,
    required this.price,
    required this.priceChangePercentage24h,
  });

  CoinTicker copyWith({
    double? price,
    double? priceChangePercentage,
  }) {
    return CoinTicker(
        symbol: symbol,
        name: name,
        baseAsset: baseAsset,
        imageUrl: imageUrl,
        price: price ?? this.price,
        priceChangePercentage24h: priceChangePercentage ?? priceChangePercentage24h);
  }
}
