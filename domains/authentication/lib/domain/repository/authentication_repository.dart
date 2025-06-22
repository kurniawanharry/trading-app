import 'package:common/error/failure_response.dart';
import 'package:dependencies/dartz/dartz.dart';

abstract class AuthenticationRepository {
  const AuthenticationRepository();

  Future<Either<FailureResponse, String>> getToken();

  Future<Either<FailureResponse, bool>> cacheToken({required String token});
}
