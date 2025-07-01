import 'package:dependencies/bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:main/cubit/main_cubit.dart';
import 'package:market/ui/market_screen.dart';
import 'package:portofolio/ui/portofolio_screen.dart';
import 'package:trade/ui/trade_screen.dart';

class MainScreen extends StatelessWidget {
  MainScreen({super.key});

  final PageStorageBucket bucket = PageStorageBucket();

  final pages = [
    // HomeScreen(key: const PageStorageKey("home")),
    const MarketScreen(key: PageStorageKey("market")),
    const TradeScreen(key: PageStorageKey("trade")),
    const PortofolioScreen(key: PageStorageKey("portofolio")),
  ];

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<MainCubit, MainState>(
          listener: (context, state) {},
        ),
      ],
      child: BlocBuilder<MainCubit, MainState>(
        builder: (context, state) {
          return Scaffold(
            body: PageStorage(
              bucket: bucket,
              child: pages[state.selectedTabIndex],
            ),
            bottomNavigationBar: BottomNavigationBar(
              currentIndex: state.selectedTabIndex,
              type: BottomNavigationBarType.fixed,
              onTap: (index) => context.read<MainCubit>().onSelectedTab(index),
              items: [
                // BottomNavigationBarItem(
                //   icon: Icon(Icons.home_outlined),
                //   activeIcon: Icon(Icons.home),
                //   label: 'Home',
                // ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.area_chart_outlined),
                  activeIcon: Icon(Icons.area_chart),
                  label: 'Markets',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.currency_exchange_rounded),
                  activeIcon: Icon(Icons.currency_exchange_outlined),
                  label: 'Trade',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.text_snippet_outlined),
                  activeIcon: Icon(Icons.text_snippet),
                  label: 'Portfolio',
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
