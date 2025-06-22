import 'package:common/error/failure_response.dart';
import 'package:commons_domain/data/datasource/remote/gecko_remote_datasource.dart';
import 'package:commons_domain/data/models/markets/response/coin_gecko_coin.dart';
import 'package:commons_domain/domain/repository/gecko_repository.dart';
import 'package:dartz/dartz.dart';

class CoinGeckoRepositoryImpl extends GeckoRepository {
  final GeckoRemoteDataSource remoteDataSource;

  CoinGeckoRepositoryImpl(this.remoteDataSource);

  @override
  Future<Either<FailureResponse, List<CoinGeckoCoin>>> getCoinGeckoCoin(List<String> ids) {
    return remoteDataSource.getCoinGeckoCoin(ids).then(
          (coinGeckoCoin) => Right(coinGeckoCoin),
          onError: (error) => Left(
            FailureResponse(
              errorMessage: error,
            ),
          ),
        );
  }
}
