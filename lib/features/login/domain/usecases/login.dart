import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/user.dart';
import '../repositories/auth_repository.dart';

class Login implements UseCase<User, Params> {
  final AuthRepository authRepository;

  Login(this.authRepository);
  @override
  Future<Either<Failure, User>> call(Params params) {
    return authRepository.login(params.username, params.password);
  }
}

class Params {
  final String username;
  final String password;

  Params({
    @required this.username,
    @required this.password,
  });
}
