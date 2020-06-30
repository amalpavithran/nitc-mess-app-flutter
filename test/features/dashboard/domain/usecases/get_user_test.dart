import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mess_management_flutter/core/usecases/usecase.dart';
import 'package:mess_management_flutter/features/dashboard/domain/repositories/dash_board_repository.dart';
import 'package:mess_management_flutter/features/dashboard/domain/usecases/get_user.dart';
import 'package:mess_management_flutter/features/login/domain/entities/user.dart';
import 'package:mockito/mockito.dart';

class MockDashboardRepository extends Mock implements DashBoardRepository{}

void main(){
  MockDashboardRepository mockDashboardRepository;
  GetUser getUser;
  setUp((){
    mockDashboardRepository = MockDashboardRepository();
    getUser = GetUser(mockDashboardRepository);
  });

  test('GetUser should return [User] on call', () async {
    //arrange
    final tUser = User(name: 'Amal', email: 'amalpavithranmp@gmail.com', rollNumber: 'B180913EC', mess: 'F', hostelName: 'MBH', roomNumber: '480');
    when(mockDashboardRepository.getUser()).thenAnswer((realInvocation) async => Right(tUser));
    //act
    final result = await getUser(NoParams());
    //assert
    verify(mockDashboardRepository.getUser());
    expect(result,Right(tUser));
  });
}