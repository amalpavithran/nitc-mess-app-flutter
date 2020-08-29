import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';
import 'package:mess_management_flutter/core/errors/exceptions.dart';
import 'package:mess_management_flutter/core/errors/failures.dart';
import 'package:mess_management_flutter/features/dashboard/data/datasources/dues_local_datasource.dart';
import 'package:mess_management_flutter/features/dashboard/data/datasources/dues_remote_datasource.dart';
import 'package:mess_management_flutter/features/dashboard/domain/entities/dues.dart';
import 'package:mess_management_flutter/features/dashboard/domain/entities/quick_glance.dart';
import 'package:mess_management_flutter/features/dashboard/domain/repositories/dash_board_repository.dart';
import 'package:mess_management_flutter/features/login/data/datasources/auth_local_datasource.dart';

class DashboardRepositoryImpl implements DashBoardRepository {
  final DuesLocalDataSource duesLocalDataSource;
  final DuesRemoteDataSource duesRemoteDataSource;
  final AuthLocalDataSource authLocalDataSource;

  DashboardRepositoryImpl({
    @required this.duesLocalDataSource,
    @required this.duesRemoteDataSource,
    @required this.authLocalDataSource,
  });

  @override
  Future<Either<Failure, List<Dues>>> getDues() async {
    try {
      final token = await authLocalDataSource.getToken();
      final json = await duesRemoteDataSource.fetchRawDues(token);
      final result = await duesLocalDataSource.setDues(json);
      return Right(result);
    } on ServerException {
      return Left(ServerFailure());
    } on UnauthorizedException {
      return Left(UnauthorizedFailure());
    } on NullException {
      return Left(UnauthorizedFailure());
    } catch (e) {
      print(e);
      return Left(UnexpectedFailure());
    }
  }

  @override
  Future<Either<Failure, QuickGlance>> getQuickGlance() {
    // TODO: implement getQuickGlance
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, List<Dues>>> getDuesLocal() {
    // TODO: implement getDuesLocal
    throw UnimplementedError();
  }
}
