import 'package:authentication/domain/repository/authentication_repository.dart';
import 'package:common/error/failure_response.dart';
import 'package:common/use_case/use_case.dart';
import 'package:dartz/dartz.dart';

class CacheTokenUseCase extends UseCase<bool, String> {
  final AuthenticationRepository authenticationRepository;

  CacheTokenUseCase({required this.authenticationRepository});

  @override
  Future<Either<FailureResponse, bool>> call(String params) async {
    return await authenticationRepository.cacheToken(token: params);
  }
}
