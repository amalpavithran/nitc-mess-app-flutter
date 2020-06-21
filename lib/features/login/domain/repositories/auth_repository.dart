import 'package:dartz/dartz.dart';
import 'package:mess_management_flutter/core/errors/failures.dart';
import 'package:mess_management_flutter/features/login/domain/entities/user.dart';

abstract class AuthRepository {
  Future<Either<Failure, User>> login(String username, String password);
  Future<Either<Failure, bool>> logout();
  Future<Either<Failure, dynamic>> silentLogin();
  Future<Either<Failure, bool>> forgotPassword(String email);
  Future<Either<Failure, bool>> resetPassword(String token, String newPassword);
  Future<Either<Failure, bool>> changePassword(
    String oldPassword,
    String newPassword,
  );
}
