import 'package:flutter/foundation.dart';
import 'package:mess_management_flutter/core/errors/failures.dart';
import 'package:dartz/dartz.dart';
import 'package:mess_management_flutter/core/usecases/usecase.dart';
import 'package:mess_management_flutter/features/login/domain/repositories/auth_repository.dart';

class ForgotPassword implements UseCase<void, Params> {
  final AuthRepository authRepository;

  ForgotPassword(this.authRepository);
  @override
  Future<Either<Failure, void>> call(Params params) {
    return authRepository.forgotPassword(params.email);
  }
}

class Params {
  final String email;

  Params({@required this.email});
}
