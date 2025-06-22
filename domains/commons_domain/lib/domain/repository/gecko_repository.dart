import 'package:common/error/failure_response.dart';
import 'package:commons_domain/data/models/markets/response/coin_gecko_coin.dart';
import 'package:dependencies/dartz/dartz.dart';

abstract class GeckoRepository {
  Future<Either<FailureResponse, List<CoinGeckoCoin>>> getCoinGeckoCoin(List<String> ids);
}
