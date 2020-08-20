import 'package:dartz/dartz.dart';
import 'package:mess_management_flutter/core/errors/failures.dart';
import 'package:mess_management_flutter/core/usecases/usecase.dart';
import 'package:mess_management_flutter/features/login/domain/entities/user.dart';
import 'package:mess_management_flutter/features/login/domain/repositories/auth_repository.dart';

class SilentLogin extends UseCase<User,NoParams>{
  final AuthRepository authRepository;

  SilentLogin(this.authRepository);
  @override
  Future<Either<Failure,User>> call(NoParams params) {
    return authRepository.silentLogin(); 
  }
}