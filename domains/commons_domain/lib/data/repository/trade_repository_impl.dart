import 'dart:convert';

import 'package:common/error/failure_response.dart';
import 'package:commons_domain/data/models/trades/response/simulated_trade.dart';
import 'package:commons_domain/domain/repository/trade_repository.dart';
import 'package:dependencies/dartz/dartz.dart';
import 'package:dependencies/shared_preferences/shared_preferences.dart';
import 'package:flutter/foundation.dart';

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
    var list = trades;
    list.add(trade);
    print('xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx');
    print(list);
    final encoded = jsonEncode(list.map((t) => t.toJson()).toList());
    print('=========================================');
    print('=========================================');
    print(encoded);
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
