part of 'main_cubit.dart';

class MainState extends Equatable {
  final ViewData mainState;
  final int selectedTabIndex;
  final DateTime? currentBackPressTime;

  const MainState({
    required this.mainState,
    this.selectedTabIndex = 0,
    this.currentBackPressTime,
  });

  MainState copyWith({
    ViewData? mainState,
    int? selectedTabIndex,
    DateTime? currentBackPressTime,
  }) {
    return MainState(
      mainState: mainState ?? this.mainState,
      selectedTabIndex: selectedTabIndex ?? this.selectedTabIndex,
      currentBackPressTime: currentBackPressTime ?? this.currentBackPressTime,
    );
  }

  @override
  List<Object?> get props => [
        mainState,
        selectedTabIndex,
        currentBackPressTime,
      ];
}
