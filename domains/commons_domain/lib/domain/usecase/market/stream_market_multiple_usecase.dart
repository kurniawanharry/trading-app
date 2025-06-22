import 'package:common/error/failure_response.dart';
import 'package:common/use_case/use_case.dart';
import 'package:commons_domain/data/models/markets/response/trade_model.dart';
import 'package:commons_domain/domain/repository/market_repository.dart';
import 'package:dependencies/dartz/dartz.dart';

class StreamMarketMultipleUsecase extends UseCaseStream<Trade, List<String>> {
  final MarketRepository marketRepository;

  StreamMarketMultipleUsecase(this.marketRepository);

  @override
  Stream<Either<FailureResponse, Trade>> call(List<String> params) {
    return marketRepository.streamTradeMultipleData(params);
  }
}
