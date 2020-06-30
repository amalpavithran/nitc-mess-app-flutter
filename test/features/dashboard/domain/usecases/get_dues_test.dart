import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mess_management_flutter/core/usecases/usecase.dart';
import 'package:mess_management_flutter/features/dashboard/domain/entities/dues.dart';
import 'package:mess_management_flutter/features/dashboard/domain/repositories/dash_board_repository.dart';
import 'package:mess_management_flutter/features/dashboard/domain/usecases/get_dues.dart';
import 'package:mockito/mockito.dart';

class MockDashBoardRepository extends Mock implements DashBoardRepository{}

void main(){
  MockDashBoardRepository mockDashBoardRepository;
  GetDues usecase;
  setUp((){
    mockDashBoardRepository = MockDashBoardRepository();
    usecase = GetDues(mockDashBoardRepository);
  });

  test('GetDues should return [List<Dues>] on call', () async {
    final tDues = [Dues(title: 'test', description: 'test', date: DateTime.now(), price: 15.0)];
    //arrange
    when(mockDashBoardRepository.getDues()).thenAnswer((realInvocation) async => Right(tDues));
    //act
    final result = await usecase(NoParams());
    //assert
    expect(result, Right(tDues));
  });
}