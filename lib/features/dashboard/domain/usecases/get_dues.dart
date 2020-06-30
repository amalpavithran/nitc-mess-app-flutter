import 'package:mess_management_flutter/core/errors/failures.dart';
import 'package:dartz/dartz.dart';
import 'package:mess_management_flutter/core/usecases/usecase.dart';
import 'package:mess_management_flutter/features/dashboard/domain/entities/dues.dart';
import 'package:mess_management_flutter/features/dashboard/domain/repositories/dash_board_repository.dart';

class GetDues implements UseCase<List<Dues>,NoParams>{
  final DashBoardRepository repository;

  GetDues(this.repository);
  @override
  Future<Either<Failure, List<Dues>>> call(NoParams params) {
    return repository.getDues();
  }
}