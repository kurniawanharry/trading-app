import 'package:common/navigation/navigation_helper.dart';
import 'package:common/navigation/router/auth_router.dart';
import 'package:common/navigation/router/splash_routes.dart';
import 'package:dependencies/get_it/get_it.dart';

class CommonDependencies {
  CommonDependencies() {
    _navigation();
    _routers();
  }

  void _navigation() => sl.registerLazySingleton<NavigationHelper>(() => NavigationHelperImpl());

  void _routers() {
    sl.registerLazySingleton<SplashRouter>(
      () => SplashRouterImpl(
        sl(),
      ),
    );
    sl.registerLazySingleton<AuthRouter>(
      () => AuthRouterImpl(
        navigationHelper: sl(),
      ),
    );
  }
}
