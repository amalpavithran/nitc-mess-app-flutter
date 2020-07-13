import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mess_management_flutter/core/errors/failures.dart';
import 'package:mess_management_flutter/core/usecases/usecase.dart';
import 'package:mess_management_flutter/features/login/domain/entities/user.dart';
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
    test('should return User if user already logged in', () async {
      final tUser = User(name: 'Amal', email: 'amalpavithranmp@gmail.com', rollNumber: 'B180913EC', mess: 'F', hostelName: 'MBH', roomNumber: '480');
      //arrange
      when(mockAuthRepository.silentLogin())
          .thenAnswer((_) async => Right(tUser));
      //act
      final result = await usecase(NoParams());
      //assert
      verify(mockAuthRepository.silentLogin());
      expect(result, Right(tUser));
    });
    test('should return ServerFailure if user not logged in', () async {
      //arrange
      when(mockAuthRepository.silentLogin())
          .thenAnswer((_) async => Left(ServerFailure()));
      //act
      final result = await usecase(NoParams());
      //assert
      verify(mockAuthRepository.silentLogin());
      expect(result, Left(ServerFailure()));
    });
  });
}
