import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mess_management_flutter/core/errors/failures.dart';
import 'package:mess_management_flutter/core/usecases/usecase.dart';
import 'package:mess_management_flutter/features/dashboard/data/models/totals_model.dart';
import 'package:mess_management_flutter/features/dashboard/domain/entities/quick_glance.dart';
import 'package:mess_management_flutter/features/dashboard/domain/entities/totals.dart';
import 'package:mess_management_flutter/features/dashboard/domain/repositories/dash_board_repository.dart';
import 'package:mess_management_flutter/features/dashboard/domain/usecases/get_quick_glance.dart';
import 'package:mess_management_flutter/features/login/data/models/user_model.dart';
import 'package:mess_management_flutter/features/login/domain/entities/user.dart';
import 'package:mockito/mockito.dart';

import '../../../../fixtures/fixture_reader.dart';

class MockDashBoardRepository extends Mock implements DashBoardRepository{}

void main(){
  MockDashBoardRepository mockDashBoardRepository;
  GetQuickGlance usecase;

  setUp((){
    mockDashBoardRepository = MockDashBoardRepository();
    usecase = GetQuickGlance(mockDashBoardRepository);
  });

  test('GetQuickGlance should return [QuickGlance] on call', () async {
    //arrange
    final User tUser = UserModel.fromJson(jsonDecode(fixture('login_success.json')));
    final Totals tTotals = TotalsModel.fromJson(jsonDecode(fixture('totals_success.json')));
    when(mockDashBoardRepository.getQuickGlance()).thenAnswer((realInvocation) async => Right(QuickGlance(tUser,tTotals)));
    //act
    final result  = await usecase(NoParams());
    //assert
    expect(result, Right<Failure,QuickGlance>(QuickGlance(tUser, tTotals)));
  });
}