import 'package:mess_management_flutter/core/errors/failures.dart';
import 'package:dartz/dartz.dart';
import 'package:mess_management_flutter/core/usecases/usecase.dart';
import 'package:mess_management_flutter/features/dashboard/domain/repositories/dash_board_repository.dart';
import 'package:mess_management_flutter/features/login/domain/entities/user.dart';

class GetUser extends UseCase<User,NoParams>{
  final DashBoardRepository repository;

  GetUser(this.repository);
  @override
  Future<Either<Failure, User>> call(NoParams params) {
    return repository.getUser();
  }
  
}