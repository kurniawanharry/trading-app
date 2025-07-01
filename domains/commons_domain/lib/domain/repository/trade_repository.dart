import 'package:common/error/failure_response.dart';
import 'package:commons_domain/data/models/trades/response/simulated_trade.dart';
import 'package:dependencies/dartz/dartz.dart';

abstract class TradeRepository {
  Future<Either<FailureResponse, void>> recordTrade(SimulatedTrade trade);
  Future<List<SimulatedTrade>> getAllTrades();
  Future<Either<FailureResponse, List<SimulatedTrade>>> getTradeHistory(String symbol);
}
