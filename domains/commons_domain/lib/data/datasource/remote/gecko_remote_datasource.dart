import 'package:commons_domain/data/models/markets/response/coin_gecko_coin.dart';
import 'package:core/network/dio_handler.dart';

abstract class GeckoRemoteDataSource {
  Future<List<CoinGeckoCoin>> getCoinGeckoCoin(List<String> ids);
}

class GeckoRemoteDataSourceImpl implements GeckoRemoteDataSource {
  final DioHandler dio;
  GeckoRemoteDataSourceImpl(this.dio);

  @override
  Future<List<CoinGeckoCoin>> getCoinGeckoCoin(List<String> ids) async {
    try {
      final response = await dio.dio.get(
        'https://api.coingecko.com/api/v3/coins/markets',
        queryParameters: {
          'vs_currency': 'usd',
          'ids': ids.join(','),
        },
      );
      return (response.data as List).map((json) => CoinGeckoCoin.fromJson(json)).toList();
    } catch (e) {
      rethrow;
    }
  }
}
