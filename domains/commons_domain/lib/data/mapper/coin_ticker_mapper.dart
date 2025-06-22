import 'package:commons_domain/data/models/markets/response/coin_gecko_coin.dart';
import 'package:commons_domain/data/models/markets/response/crypto_model.dart';

class CoinTickerMapper {
  CryptoModel mapToCryptoModel(String name, CoinGeckoCoin? coinGeckoCoin) {
    return CryptoModel(
      name: name,
      geckoCoin: coinGeckoCoin,
    );
  }
}
