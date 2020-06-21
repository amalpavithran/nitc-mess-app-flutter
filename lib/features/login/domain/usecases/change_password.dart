import 'package:flutter/foundation.dart';
import 'package:mess_management_flutter/core/errors/failures.dart';
import 'package:dartz/dartz.dart';
import 'package:mess_management_flutter/core/usecases/usecase.dart';
import 'package:mess_management_flutter/features/login/domain/repositories/auth_repository.dart';

class ChangePassword implements UseCase<bool, Params> {
  final AuthRepository authRepository;

  ChangePassword(this.authRepository);
  @override
  Future<Either<Failure, bool>> call(Params params) {
    return authRepository.changePassword(params.oldPassword, params.newPassword);
  }
}

class Params {
  final String oldPassword;
  final String newPassword;

  Params({
    @required this.oldPassword,
    @required this.newPassword,
  });
}
