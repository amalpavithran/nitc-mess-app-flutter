import 'dart:convert';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mess_management_flutter/core/errors/failures.dart';
import 'package:mess_management_flutter/features/login/domain/entities/user.dart';
import 'package:mess_management_flutter/features/login/domain/usecases/login.dart';
import 'package:mess_management_flutter/features/login/domain/usecases/silent_login.dart';
import 'package:mess_management_flutter/features/login/presentation/cubit/login_cubit.dart';
import 'package:mockito/mockito.dart';

import '../../../../fixtures/fixture_reader.dart';

class MockLogin extends Mock implements Login {}

class MockSilentLogin extends Mock implements SilentLogin {}

void main() {
  MockLogin mockLogin;
  MockSilentLogin mockSilentLogin;
  LoginCubit loginCubit;
  setUp(() {
    mockLogin = MockLogin();
    mockSilentLogin = MockSilentLogin();
    loginCubit = LoginCubit(
      loginUsecase: mockLogin,
      silentLoginUsecase: mockSilentLogin,
    );
  });
  group('Login', () {
    test('Initial State should be LoginInitial', () async {
      expect(loginCubit.state, equals(LoginInitial()));
    });

    test('should emit [LoginLoading, LoginSuccess] on successful login',
        () async {
      //arrange
      final tUsername = 'Amal';
      final tPassword = 'SuperSecret';
      final tUser = User.fromJson(jsonDecode(fixture('login_success.json')));
      when(mockLogin.call(any)).thenAnswer(
        (realInvocation) async => Right(tUser),
      );
      //assert
      final expected = [
        LoginLoading(),
        LoginSuccess(tUser),
      ];
      expectLater(loginCubit, emitsInOrder(expected));
      //act
      loginCubit.login(tUsername, tPassword);
    });

    test('should emit [LoginLoading, LoginFailure] on failed login', () async {
      //arrange
      final tUsername = 'Amal';
      final tPassword = 'SuperSecret';
      when(mockLogin.call(any)).thenAnswer(
        (realInvocation) async => Left(ServerFailure()),
      );
      //assert
      final expected = [
        LoginLoading(),
        LoginFailure(SERVER_FAILURE_MESSAGE),
      ];
      expectLater(loginCubit, emitsInOrder(expected));
      //act
      loginCubit.login(tUsername, tPassword);
    });
  });
  group('SilentLogin', () {
    final tUser = User.fromJson(jsonDecode(fixture('login_success.json')));
    test('should emit [SilentLoginSuccess] on success', () async {
      //arrange
      when(mockSilentLogin(any))
          .thenAnswer((realInvocation) async => Right(tUser));
      //assert
      final expected = [SilentLoginSuccess()];
      expectLater(loginCubit, emitsInOrder(expected));
      //act
      loginCubit.silentLogin();
    });
  });
}
