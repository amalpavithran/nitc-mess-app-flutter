import 'package:flutter/foundation.dart';
import 'package:mess_management_flutter/core/errors/exceptions.dart';
import 'package:mess_management_flutter/core/network/network_info.dart';
import 'package:mess_management_flutter/features/login/data/datasources/auth_local_datasource.dart';
import 'package:mess_management_flutter/features/login/data/datasources/auth_remote_datasource.dart';
import 'package:mess_management_flutter/features/login/data/models/user_model.dart';
import 'package:mess_management_flutter/features/login/domain/entities/user.dart';
import 'package:mess_management_flutter/core/errors/failures.dart';
import 'package:dartz/dartz.dart';
import 'package:mess_management_flutter/features/login/domain/repositories/auth_repository.dart';
import 'package:validators/validators.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;
  final AuthLocalDataSource localDataSource;
  final NetworkInfo networkInfo;
  Future<Either<Failure, void>> _exceptionHandler(
      Future<Either<Failure, void>> body()) async {
    try {
      return await body();
    } on ServerException {
      return Left(ServerFailure());
    } catch (e) {
      return Left(UnexpectedFailure());
    }
  }

  AuthRepositoryImpl({
    @required this.remoteDataSource,
    @required this.localDataSource,
    @required this.networkInfo,
  });

  @override
  Future<Either<Failure, void>> changePassword(
      String oldPassword, String newPassword) async {
    return _exceptionHandler(() async {
      if (!await networkInfo.isConnected) {
        return Left(NoInternetConnection());
      }
      await remoteDataSource.changePassword(oldPassword, newPassword);
      return Right(null);
    });
  }

  @override
  Future<Either<Failure, void>> forgotPassword(String email) async {
    return _exceptionHandler(() async {
      if (!await networkInfo.isConnected) {
        return Left(NoInternetConnection());
      } else if (!isEmail(email)) {
        return Left(InvalidDataFailure());
      }
      await remoteDataSource.forgotPassword(email);
      return Right(null);
    });
  }

  @override
  Future<Either<Failure, User>> login(String username, String password) async {
    try {
      final user = await remoteDataSource.login(username, password);
      await localDataSource.setUser(user: user);
      await localDataSource.setToken(user.token);
      return Right(user);
    } on ServerException {
      return Left(ServerFailure());
    } catch (e) {
      return Left(UnexpectedFailure());
    }
  }

  @override
  Future<Either<Failure, void>> logout() async {
    try {
      final token = await localDataSource.getToken();
      await remoteDataSource.logout(token);
      await localDataSource.clearToken();
      await localDataSource.setUser(user: null);
      return Right(null);
    } catch (e) {
      return Left(UnexpectedFailure());
    }
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
