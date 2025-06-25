part of 'trade_cubit.dart';

class TradeState extends Equatable {
  final ViewData<String> tradeState;
  const TradeState({required this.tradeState});

  TradeState copyWith({
    ViewData<String>? tradeState,
  }) {
    return TradeState(
      tradeState: tradeState ?? this.tradeState,
    );
  }

  @override
  List<Object?> get props => [tradeState];
}
