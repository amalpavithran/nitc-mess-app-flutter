import 'package:dartz/dartz.dart';
import 'package:mess_management_flutter/core/errors/failures.dart';
import 'package:mess_management_flutter/features/login/domain/entities/user.dart';

abstract class AuthRepository {
  Future<Either<Failure, User>> login(String username, String password);
  Future<Either<Failure, void>> logout();
  Future<Either<Failure, User>> silentLogin();
  Future<Either<Failure, void>> forgotPassword(String email);
  Future<Either<Failure, void>> resetPassword(String token, String newPassword);
  Future<Either<Failure, void>> changePassword(
    String oldPassword,
    String newPassword,
  );
}
