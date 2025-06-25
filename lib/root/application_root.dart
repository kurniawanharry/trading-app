import 'package:common/constants/application_configs.dart';
import 'package:common/navigation/navigation_helper.dart';
import 'package:dependencies/bloc/bloc.dart';
import 'package:dependencies/flutter_screenutil/flutter_screenutil.dart';
import 'package:dependencies/get_it/get_it.dart';
import 'package:flutter/material.dart';
import 'package:home/ui/ui.dart';
import 'package:main/cubit/main_cubit.dart';
import 'package:main/ui/main_screen.dart';
import 'package:market/cubit/market_cubit.dart';
import 'package:onboarding/bloc/splash_bloc/splash_bloc.dart';
import 'package:onboarding/ui/splash_screen.dart';
import 'package:portofolio/cubit/porto_cubit.dart';
import 'package:resources/theme.dart';
import 'package:common/navigation/router/routes.dart';
// ignore: depend_on_referenced_packages
import 'package:flutter_localizations/flutter_localizations.dart';

part 'application_rooting_extensions.dart';

class ApplicationRoot extends StatelessWidget {
  const ApplicationRoot({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(360, 690),
      builder: (_, __) => MaterialApp(
        title: Config.appFlavor.name,
        // debugShowCheckedModeBanner: Config.isDebug,
        debugShowCheckedModeBanner: false,
        theme: appTheme,
        darkTheme: appTheme,
        themeMode: ThemeMode.dark,
        localizationsDelegates: const [
          // AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate
        ],
        supportedLocales: const [Locale('en', '')],
        home: MultiBlocProvider(
          providers: [
            BlocProvider(create: (_) => SplashCubit()..initSplash()),
          ],
          child: SplashScreen(),
        ),
        navigatorKey: NavigationHelperImpl.navigatorKey,
        onGenerateRoute: (settings) {
          final arguments = settings.arguments;
          switch (settings.name) {
            case AppRoutes.splash:
              return MaterialPageRoute(
                builder: (_) => SplashScreen(),
              );
            case AppRoutes.home:
              return MaterialPageRoute(
                builder: (_) => HomeScreen(),
              );
            case AppRoutes.main:
              return _routeFadeAnimation(
                MultiBlocProvider(
                  providers: [
                    BlocProvider(create: (context) => MainCubit()),
                    BlocProvider(
                      create: (context) => MarketCubit(
                          streamMarketUsecase: sl(),
                          streamMarketMultipleUsecase: sl(),
                          geckoUsecase: sl())
                        // ..streamMarket('bnbusdt')
                        ..fetchGeckoCoin(
                          ['bitcoin', 'ethereum', 'dogecoin', 'cardano', 'solana', 'tron'],
                        )
                        ..streamMultiple(
                          [
                            'btcusdt@ticker',
                            'ethusdt@ticker',
                            'dogeusdt@ticker',
                            'adausdt@ticker',
                            'solusdt@ticker',
                            'trxusdt@ticker'
                          ],
                        ),
                    ),
                    BlocProvider(create: (context) => PortoCubit()),
                  ],
                  child: MainScreen(),
                ),
              );

            default:
              return MaterialPageRoute(
                builder: (_) => SplashScreen(),
              );
          }
        },
      ),
    );
  }
}

PageRouteBuilder _routeFadeAnimation(Widget page) {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) => page,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      return FadeTransition(
        opacity: animation,
        child: child,
      );
    },
    transitionDuration: const Duration(milliseconds: 500),
  );
}
