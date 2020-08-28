import 'package:mess_management_flutter/core/errors/failures.dart';
import 'package:dartz/dartz.dart';
import 'package:mess_management_flutter/core/usecases/usecase.dart';
import 'package:mess_management_flutter/features/dashboard/domain/entities/quick_glance.dart';
import 'package:mess_management_flutter/features/dashboard/domain/repositories/dash_board_repository.dart';

class GetQuickGlance extends UseCase<QuickGlance, NoParams> {
  final DashBoardRepository repository;

  GetQuickGlance(this.repository);
  @override
  Future<Either<Failure, QuickGlance>> call(NoParams params) {
    return repository.getQuickGlance();
  }
}
