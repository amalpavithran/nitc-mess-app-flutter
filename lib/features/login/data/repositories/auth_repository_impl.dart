import 'package:flutter/foundation.dart';
import 'package:mess_management_flutter/core/errors/exceptions.dart';
import 'package:mess_management_flutter/core/network/network_info.dart';
import 'package:mess_management_flutter/features/login/data/datasources/auth_local_datasource.dart';
import 'package:mess_management_flutter/features/login/data/datasources/auth_remote_datasource.dart';
import 'package:mess_management_flutter/features/login/domain/entities/user.dart';
import 'package:mess_management_flutter/core/errors/failures.dart';
import 'package:dartz/dartz.dart';
import 'package:mess_management_flutter/features/login/domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;
  final AuthLocalDataSource localDataSource;
  final NetworkInfo networkInfo;

  AuthRepositoryImpl({
    @required this.remoteDataSource,
    @required this.localDataSource,
    @required this.networkInfo,
  });

  @override
  Future<Either<Failure, void>> changePassword(
      String oldPassword, String newPassword) async {
    try {
      if(!await networkInfo.isConnected){
        return Left(NoInternetConnection());
      }
      await remoteDataSource.changePassword(oldPassword, newPassword);
      return Right(null);
    } on ServerException {
      return Left(ServerFailure());
    } catch (e) {
      return Left(UnexpectedFailure());
    }
  }

  @override
  Future<Either<Failure, void>> forgotPassword(String email) {
    // TODO: implement forgotPassword
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, User>> login(String username, String password) {
    // TODO: implement login
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, void>> logout() {
    // TODO: implement logout
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, void>> resetPassword(
      String token, String newPassword) {
    // TODO: implement resetPassword
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, User>> silentLogin() {
    // TODO: implement silentLogin
    throw UnimplementedError();
  }
}
