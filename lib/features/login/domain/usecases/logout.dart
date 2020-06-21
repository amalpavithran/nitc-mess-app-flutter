import 'package:mess_management_flutter/core/errors/failures.dart';
import 'package:dartz/dartz.dart';
import 'package:mess_management_flutter/core/usecases/usecase.dart';
import 'package:mess_management_flutter/features/login/domain/repositories/auth_repository.dart';

class Logout implements UseCase<bool,NoParams>{
  final AuthRepository authRepository;

  Logout(this.authRepository);
  @override
  Future<Either<Failure, bool>> call(NoParams params) {
    return authRepository.logout();
  }
}