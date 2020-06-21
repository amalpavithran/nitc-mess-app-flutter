import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mess_management_flutter/features/login/domain/repositories/auth_repository.dart';
import 'package:mess_management_flutter/features/login/domain/usecases/change_password.dart';
import 'package:mockito/mockito.dart';

class MockAuthRepository extends Mock implements AuthRepository {}

void main() {
  MockAuthRepository mockAuthRepository;
  ChangePassword changePassword;
  setUp(() {
    mockAuthRepository = MockAuthRepository();
    changePassword = ChangePassword(mockAuthRepository);
  });
  test('ChangePassword should return true from repository', () async {
    final tOldPassword = 'hello123';
    final tNewPassword = 'hello456';
    //arrange
    when(mockAuthRepository.changePassword(any, any))
        .thenAnswer((realInvocation) async => Right(true));
    //act
    final result = await changePassword(
        Params(oldPassword: tOldPassword, newPassword: tNewPassword));
    //assert
    verify(mockAuthRepository.changePassword(tOldPassword, tNewPassword));
    expect(result, Right(true));
  });
}
