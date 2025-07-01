part of 'trade_form_cubit.dart';

class TradeFormState extends Equatable {
  final bool isBuy;
  final double? price;
  final double? amount;
  final double? total;

  const TradeFormState({
    required this.isBuy,
    this.price,
    this.amount,
    this.total,
  });

  TradeFormState copyWith({
    bool? isBuy,
    double? price,
    double? amount,
    double? total,
  }) {
    return TradeFormState(
      isBuy: isBuy ?? this.isBuy,
      price: price ?? this.price,
      amount: amount ?? this.amount,
      total: total ?? this.total,
    );
  }

  @override
  List<Object?> get props => [isBuy, price, amount, total];
}
