import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mess_management_flutter/features/login/domain/repositories/auth_repository.dart';
import 'package:mess_management_flutter/features/login/domain/usecases/reset_password.dart';
import 'package:mockito/mockito.dart';

class MockAuthRepository extends Mock implements AuthRepository{}

void main(){
  MockAuthRepository mockAuthRepository;
  ResetPassword resetPassword;
  
  setUp((){
    mockAuthRepository = MockAuthRepository();
    resetPassword = ResetPassword(mockAuthRepository);
  });
  test('ResetPassword should return true from repository', () async {
    final tToken = 'testtoken';
    final tNewPassword = 'NewAwesomePassword';
    //arrange
    when(mockAuthRepository.resetPassword(tToken, tNewPassword)).thenAnswer((realInvocation) async => Right(true));
    //act
    final result = await resetPassword(Params(token: tToken,newPassword: tNewPassword)); 
    //assert
    verify(mockAuthRepository.resetPassword(tToken, tNewPassword));
    expect(result,Right(true));
  });
}