import 'package:dartz/dartz.dart';
import 'package:mess_management_flutter/core/errors/failures.dart';
import 'package:mess_management_flutter/core/usecases/usecase.dart';
import 'package:mess_management_flutter/features/login/domain/repositories/auth_repository.dart';

class SilentLogin extends UseCase<dynamic,NoParams>{
  final AuthRepository authRepository;

  SilentLogin(this.authRepository);
  @override
  Future<Either<Failure,dynamic>> call(NoParams params) {
    return authRepository.silentLogin(); 
  }
}