import 'package:common/error/failure_response.dart';
import 'package:common/use_case/use_case.dart';
import 'package:commons_domain/data/models/trades/response/simulated_trade.dart';
import 'package:commons_domain/domain/repository/trade_repository.dart';
import 'package:dependencies/dartz/dartz.dart';

class TradeHistoryUsecase extends UseCase<List<SimulatedTrade>, String> {
  TradeRepository tradeRepository;
  TradeHistoryUsecase(this.tradeRepository);
  @override
  Future<Either<FailureResponse, List<SimulatedTrade>>> call(params) {
    return tradeRepository.getTradeHistory(params);
  }
}
