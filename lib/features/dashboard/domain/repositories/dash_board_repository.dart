import 'package:dartz/dartz.dart';
import 'package:mess_management_flutter/core/errors/failures.dart';
import 'package:mess_management_flutter/features/dashboard/domain/entities/dues.dart';
import 'package:mess_management_flutter/features/login/domain/entities/user.dart';

abstract class DashBoardRepository {
  Future<Either<Failure,List<Dues>>> getDues();
  Future<Either<Failure,User>> getUser();
}