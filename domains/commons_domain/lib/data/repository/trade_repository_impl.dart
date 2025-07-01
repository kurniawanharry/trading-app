import 'dart:convert';

import 'package:common/error/failure_response.dart';
import 'package:commons_domain/data/models/trades/response/simulated_trade.dart';
import 'package:commons_domain/domain/repository/trade_repository.dart';
import 'package:dependencies/dartz/dartz.dart';
import 'package:dependencies/shared_preferences/shared_preferences.dart';

class TradeRepositoryImpl extends TradeRepository {
  final SharedPreferences sharedPreferences;
  static const String key = 'simulated_trades';

  TradeRepositoryImpl(this.sharedPreferences);
  @override
  Future<Either<FailureResponse, List<SimulatedTrade>>> getTradeHistory(String symbol) async {
    final trades = await getAllTrades();
    if (trades.isEmpty) {
      return Right([]);
    }
    if (symbol.isEmpty) {
      return Right(trades);
    }
    return Right(trades.where((t) => t.symbol == symbol).toList());
  }

  @override
  Future<Either<FailureResponse, void>> recordTrade(SimulatedTrade trade) async {
    final trades = await getAllTrades();
    final List<SimulatedTrade> list = [...trades];

    // Group trades by symbol
    final symbolTrades = list.where((t) => t.symbol == trade.symbol).toList();

    // Calculate current holdings for this symbol
    double totalQty = 0;
    for (var t in symbolTrades) {
      if (t.isBuy) {
        totalQty += t.quantity;
      } else {
        totalQty -= t.quantity;
      }
    }

    // If it's a sell, ensure user has enough
    if (!trade.isBuy && trade.quantity > totalQty) {
      return Left(
        FailureResponse(
          statusCode: 400,
          errorMessage: "Insufficient holdings to sell ${trade.symbol.toUpperCase()}",
        ),
      );
    }

    // Record the trade
    list.add(trade);
    final encoded = jsonEncode(list.map((t) => t.toJson()).toList());
    await sharedPreferences.setString(key, encoded);

    return Right(null);
  }

  @override
  Future<List<SimulatedTrade>> getAllTrades() async {
    final jsonString = sharedPreferences.getString(key);
    if (jsonString == null) return [];

    final List<dynamic> jsonList = jsonDecode(jsonString);
    return jsonList.map((json) => SimulatedTrade.fromJson(json)).toList();
  }
}
