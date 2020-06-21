import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mess_management_flutter/core/usecases/usecase.dart';
import 'package:mess_management_flutter/features/login/domain/repositories/auth_repository.dart';
import 'package:mess_management_flutter/features/login/domain/usecases/silent_login.dart';
import 'package:mockito/mockito.dart';

class MockAuthRepository extends Mock implements AuthRepository {}

void main() {
  MockAuthRepository mockAuthRepository;
  SilentLogin usecase;
  group('SilentLogin', () {
    setUp(() {
      mockAuthRepository = MockAuthRepository();
      usecase = SilentLogin(mockAuthRepository);
    });
    test('should return [String] token if user already logged in', () async {
      final tToken = 'testtokenstring';
      //arrange
      when(mockAuthRepository.silentLogin())
          .thenAnswer((_) async => Right(tToken));
      //act
      final result = await usecase(NoParams());
      //assert
      verify(mockAuthRepository.silentLogin());
      expect(result, Right(tToken));
    });
    test('should return false if user not logged in', () async {
      //arrange
      when(mockAuthRepository.silentLogin())
          .thenAnswer((_) async => Right(false));
      //act
      final result = await usecase(NoParams());
      //assert
      verify(mockAuthRepository.silentLogin());
      expect(result, Right(false));
    });
  });
}
