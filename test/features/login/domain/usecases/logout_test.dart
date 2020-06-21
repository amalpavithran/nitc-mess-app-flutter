import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mess_management_flutter/core/usecases/usecase.dart';
import 'package:mess_management_flutter/features/login/domain/repositories/auth_repository.dart';
import 'package:mess_management_flutter/features/login/domain/usecases/logout.dart';
import 'package:mockito/mockito.dart';

class MockAuthRepository extends Mock implements AuthRepository{}

void main(){
  MockAuthRepository mockAuthRepository;
  Logout usecase;

  setUp((){
    mockAuthRepository = MockAuthRepository();
    usecase = Logout(mockAuthRepository);
  });
  test('Logout should return true from repository', () async {
    //arrange
    when(mockAuthRepository.logout()).thenAnswer((_) async => Right(true));
    //act
    final result = await usecase(NoParams());
    //assert
    verify(mockAuthRepository.logout());
    expect(result,Right(true));
  });
}