import 'package:commons_domain/data/models/markets/response/coin_gecko_coin.dart';
import 'package:commons_domain/data/models/markets/response/coin_ticker.dart';

class CoinTickerMapper {
  static Map<String, CoinTicker> mapToCryptoModel(CoinGeckoCoin? coin) {
    return {
      '${coin?.symbol.toUpperCase()}USDT': CoinTicker(
        symbol: '${coin?.symbol.toUpperCase()}USDT',
        baseAsset: coin?.symbol.toUpperCase() ?? '',
        name: coin?.name ?? '',
        imageUrl: coin?.image ?? '',
        openPrice: 0.0,
        price: 0.0,
        priceChangePercentage24h: 0.0,
      ),
    };
  }
}
