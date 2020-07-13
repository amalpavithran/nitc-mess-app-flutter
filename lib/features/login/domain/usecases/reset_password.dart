import 'package:mess_management_flutter/core/errors/failures.dart';
import 'package:dartz/dartz.dart';
import 'package:mess_management_flutter/core/usecases/usecase.dart';
import 'package:mess_management_flutter/features/login/domain/repositories/auth_repository.dart';

class ResetPassword implements UseCase<void, Params> {
  final AuthRepository authRepository;

  ResetPassword(this.authRepository);

  @override
  Future<Either<Failure, void>> call(Params params) {
    return authRepository.resetPassword(params.token, params.newPassword);
  }
}

class Params {
  final String token;
  final String newPassword;

  Params({this.token, this.newPassword});
}
