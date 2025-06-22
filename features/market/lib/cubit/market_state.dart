part of 'market_cubit.dart';

class MarketState extends Equatable {
  final ViewData<Map<String, CoinTicker>> marketState;
  final ViewData<List<CoinGeckoCoin>> geckoState;

  const MarketState({required this.marketState, required this.geckoState});

  MarketState copyWith({
    ViewData<Map<String, CoinTicker>>? marketState,
    ViewData<List<CoinGeckoCoin>>? geckoState,
  }) {
    return MarketState(
        marketState: marketState ?? this.marketState, geckoState: geckoState ?? this.geckoState);
  }

  @override
  List<Object?> get props => [marketState, geckoState];
}
