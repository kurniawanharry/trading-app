import 'package:dependencies/get_it/get_it.dart';
import 'package:dependencies/shared_preferences/shared_preferences.dart';

class SharedDependencies {
  Future<void> registerCore() async {
    await _initSharedPrefsInjections();
  }

  Future _initSharedPrefsInjections() async {
    sl.registerLazySingletonAsync<SharedPreferences>(() async {
      return await SharedPreferences.getInstance();
    });
    await sl.isReady<SharedPreferences>();
  }
}
