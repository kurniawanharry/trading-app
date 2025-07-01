part of 'porto_cubit.dart';

class PortoState extends Equatable {
  final ViewData<List<PortfolioItem>> marketState;
  final double totalPortfolioValue;

  const PortoState({
    required this.marketState,
    this.totalPortfolioValue = 0,
  });

  PortoState copyWith({
    ViewData<List<PortfolioItem>>? marketState,
    double? totalPortfolioValue,
  }) {
    return PortoState(
      totalPortfolioValue: totalPortfolioValue ?? this.totalPortfolioValue,
      marketState: marketState ?? this.marketState,
    );
  }

  @override
  List<Object?> get props => [marketState];
}
