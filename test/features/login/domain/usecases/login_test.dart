import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mess_management_flutter/features/login/domain/entities/user.dart';
import 'package:mess_management_flutter/features/login/domain/repositories/auth_repository.dart';
import 'package:mess_management_flutter/features/login/domain/usecases/login.dart';
import 'package:mockito/mockito.dart';

class MockAuthRepository extends Mock implements AuthRepository {}

void main() {
  MockAuthRepository mockAuthRepository;
  Login usecase;

  setUp(() {
    mockAuthRepository = MockAuthRepository();
    usecase = Login(mockAuthRepository);
  });

  test('Login should return user from repository', () async {
    //arrange
    final tUsername = 'amal';
    final tPassword = 'password';
    final tUser = User(
      name: 'Amal',
      email: 'test@email.com',
      rollNumber: '123456',
      mess: 'f',
      hostelName: 'PG-1',
      roomNumber: '345',
    );
    when(mockAuthRepository.login(tUsername, tPassword))
        .thenAnswer((_) async => Right(tUser));
    //act
    final result = await usecase(Params(username: tUsername,password: tPassword));
    //assert
    expect(result, Right(tUser));
  });
}
