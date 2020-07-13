import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mess_management_flutter/features/login/domain/repositories/auth_repository.dart';
import 'package:mess_management_flutter/features/login/domain/usecases/forgot_password.dart';
import 'package:mockito/mockito.dart';

class MockAuthRepository extends Mock implements AuthRepository{}

void main(){
  MockAuthRepository mockAuthRepository;
  ForgotPassword forgotPassword;
  setUp((){
    mockAuthRepository = MockAuthRepository();
    forgotPassword = ForgotPassword(mockAuthRepository);
  });
  test('ForgotPassword should return Right(null) from repository', () async {
    final tEmail = 'test@email.com';
    //arrange
    when(mockAuthRepository.forgotPassword(tEmail)).thenAnswer((_) async => Right(null));
    //act
    final result = await forgotPassword(Params(email: tEmail));
    //assert
    verify(mockAuthRepository.forgotPassword(tEmail));
    expect(result,Right(null));
  });
}