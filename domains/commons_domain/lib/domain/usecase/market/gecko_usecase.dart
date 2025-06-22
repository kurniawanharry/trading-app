import 'package:common/error/failure_response.dart';
import 'package:common/use_case/use_case.dart';
import 'package:commons_domain/data/models/markets/response/coin_gecko_coin.dart';
import 'package:commons_domain/domain/repository/gecko_repository.dart';
import 'package:dependencies/dartz/dartz.dart';

class GeckoUsecase extends UseCase<List<CoinGeckoCoin>, List<String>> {
  final GeckoRepository repository;

  GeckoUsecase(this.repository);

  @override
  Future<Either<FailureResponse, List<CoinGeckoCoin>>> call(List<String> params) {
    return repository.getCoinGeckoCoin(params);
  }
}
