import 'package:authentication/data/datasource/local/authentication_local_data_source.dart';
import 'package:authentication/domain/repository/authentication_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:common/error/failure_response.dart';

class AuthenticationRepositoryImpl implements AuthenticationRepository {
  final AuthenticationLocalDataSource authenticationLocalDataSource;

  AuthenticationRepositoryImpl({required this.authenticationLocalDataSource});

  @override
  Future<Either<FailureResponse, bool>> cacheToken({
    required String token,
  }) async {
    try {
      await authenticationLocalDataSource.cacheToken(token: token);
      return const Right(true);
    } on Exception catch (error) {
      return Left(FailureResponse(errorMessage: error.toString()));
    }
  }

  @override
  Future<Either<FailureResponse, String>> getToken() async {
    try {
      final response = await authenticationLocalDataSource.getToken();
      return Right(response);
    } on Exception catch (error) {
      return Left(FailureResponse(errorMessage: error.toString()));
    }
  }
}
