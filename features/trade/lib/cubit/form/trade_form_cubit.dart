import 'package:commons_domain/data/models/trades/response/simulated_trade.dart';
import 'package:dependencies/bloc/bloc.dart';
import 'package:dependencies/equatable/equatable.dart';

part 'trade_form_state.dart';

class TradeFormCubit extends Cubit<TradeFormState> {
  TradeFormCubit()
      : super(
          TradeFormState(isBuy: true),
        );

  void toggleBuySell(bool isBuy) {
    emit(state.copyWith(isBuy: isBuy));
  }

  void updatePrice(double price) {
    final amount = state.amount;
    final total = amount != null ? price * amount : null;
    emit(state.copyWith(price: price, total: total));
  }

  void updateAmount(double amount) {
    final price = state.price;
    final total = price != null ? price * amount : null;
    emit(state.copyWith(amount: amount, total: total));
  }

  void increaseAmount({double step = 1.0}) {
    final newAmount = (state.amount ?? 0) + step;
    emit(state.copyWith(amount: newAmount));
  }

  void increasePrice({double step = 1.0}) {
    double newPrice = (state.price ?? 0) + step;
    emit(state.copyWith(price: newPrice));
  }

  void decreasePrice({double step = 1.0}) {
    double newPrice = ((state.price ?? 0) - step).clamp(0, double.infinity);
    emit(state.copyWith(price: newPrice));
  }

  void decreaseAmount({double step = 1.0}) {
    double newAmount = ((state.amount ?? 0) - step).clamp(0, double.infinity);
    emit(state.copyWith(amount: newAmount));
  }

  void updateTotal(double total) {
    final price = state.price;
    final amount = price != null && price > 0 ? total / price : null;
    emit(state.copyWith(total: total, amount: amount));
  }

  /// Returns a SimulatedTrade ready to be saved, or null if inputs are incomplete
  SimulatedTrade? buildTrade(String symbol) {
    final price = state.price;
    final amount = state.amount;
    final total = state.total;

    if (price == null || amount == null || total == null) return null;

    return SimulatedTrade(
      symbol: symbol,
      price: price,
      quantity: amount,
      total: total,
      isBuy: state.isBuy,
      timestamp: DateTime.now(),
    );
  }

  void reset() {
    emit(
      TradeFormState(
        isBuy: state.isBuy,
        amount: 0,
        total: 0,
      ),
    );
  }
}
