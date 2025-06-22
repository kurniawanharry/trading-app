import 'package:common/constants/app_constants.dart';
import 'package:common/error/exception.dart';
import 'package:dependencies/shared_preferences/shared_preferences.dart';

abstract class AuthenticationLocalDataSource {
  const AuthenticationLocalDataSource();
  Future<bool> cacheToken({required String token});
  Future<String> getToken();
}

class AuthenticationLocalDataSourceImpl
    implements AuthenticationLocalDataSource {
  final SharedPreferences sharedPreferences;

  const AuthenticationLocalDataSourceImpl({required this.sharedPreferences});

  @override
  Future<bool> cacheToken({required String token}) async {
    return sharedPreferences.setString(AppConstants.cachedKey.tokenKey, token);
  }

  @override
  Future<String> getToken() async {
    try {
      return sharedPreferences.getString(AppConstants.cachedKey.tokenKey) ?? "";
    } catch (_) {
      throw DatabaseException(AppConstants.errorMessage.failedGetToken);
    }
  }
}
