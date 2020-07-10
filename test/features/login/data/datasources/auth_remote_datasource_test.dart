import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:mess_management_flutter/core/errors/exceptions.dart';
import 'package:mess_management_flutter/features/login/data/datasources/auth_remote_datasource.dart';
import 'package:mess_management_flutter/features/login/data/models/user_model.dart';
import 'package:mockito/mockito.dart';
import 'package:http/http.dart' as http;

import '../../../../fixtures/fixture_reader.dart';

class MockHttpClient extends Mock implements http.Client {}

void main() {
  MockHttpClient mockHttpClient;
  AuthRemoteDataSourceImpl authRemoteDataSourceImpl;
  setUp(() {
    mockHttpClient = MockHttpClient();
    authRemoteDataSourceImpl = AuthRemoteDataSourceImpl(client: mockHttpClient);
  });
  setupMockHttpClientSuccess200() {
    when(mockHttpClient.post(any,
            headers: anyNamed('headers'), body: anyNamed('body')))
        .thenAnswer((realInvocation) async => http.Response('success', 200));
  }

  setupMockHttpClientServerError500() {
    when(mockHttpClient.post(any,
            headers: anyNamed('headers'), body: anyNamed('body')))
        .thenAnswer((realInvocation) async =>
            http.Response('Something went wrong', 500));
  }

  setupMockHttpClientUnauthorized401() {
    when(mockHttpClient.post(any,
            headers: anyNamed('headers'), body: anyNamed('body')))
        .thenAnswer((realInvocation) async =>
            http.Response("Invalid Credentials", 401));
  }

  group('login', () {
    final tUsername = 'Amal1234';
    final tPassword = 'MyVeryStrongSecret';
    setupMockHttpClientServerLogin200() {
      when(mockHttpClient.post(any,
              headers: anyNamed('headers'), body: anyNamed('body')))
          .thenAnswer((realInvocation) async =>
              http.Response(fixture('login_success.json'), 200));
    }

    test(
        'should perform POST request on URL api/auth/login as the endpoint with application/json header',
        () async {
      //arrange
      setupMockHttpClientServerLogin200();
      //act
      authRemoteDataSourceImpl.login(tUsername, tPassword);
      //assert
      verify(mockHttpClient.post('$BASEURL/api/auth/login', headers: {
        'Content-Type': 'application/json',
      }, body: {
        'username': tUsername,
        'password': tPassword,
      }));
    });
    test('should return [UserModel] on status code 200', () async {
      //arrange
      setupMockHttpClientServerLogin200();
      //act
      final result = await authRemoteDataSourceImpl.login(tUsername, tPassword);
      //assert
      expect(result,
          UserModel.fromJson(jsonDecode(fixture('login_success.json'))));
    });
    test('should throw [InvalidCredentialsException] on status code 401',
        () async {
      //arrange
      setupMockHttpClientUnauthorized401();
      //act
      final call = authRemoteDataSourceImpl.login;
      //assert
      expect(() => call(tUsername, tPassword),
          throwsA(isA<InvalidCredentialsException>()));
    });
    test('should return [ServerException] on all other errors', () async {
      //arrange
      setupMockHttpClientServerError500();
      //act
      final call = authRemoteDataSourceImpl.login;
      //assert
      expect(() => call(tUsername, tPassword), throwsA(isA<ServerException>()));
    });
  });
  group('changePassword', () {
    final tOldPassword = "AStrongPassword";
    final tNewPassword = "AVeryStrongPassword";
    test('should POST to api/auth/change with header application/json',
        () async {
      //arrange
      setupMockHttpClientSuccess200();
      //act
      await authRemoteDataSourceImpl.changePassword(tOldPassword, tNewPassword);
      //assert
      verify(mockHttpClient.post('$BASEURL/api/auth/change', headers: {
        'Content-Type': 'application/json',
      }, body: {
        'oldPassword': tOldPassword,
        'newPassword': tNewPassword,
      }));
    });
    test('should return void on success', () async {
      //arrange
      setupMockHttpClientSuccess200();
      //act
      final call = authRemoteDataSourceImpl.changePassword;
      //assert
      expect(() => call(tOldPassword, tNewPassword), returnsNormally);
    });
    test('should throw ServerException on other status codes', () async {
      //arrange
      setupMockHttpClientServerError500();
      //act
      final call = authRemoteDataSourceImpl.changePassword;
      //assert
      expect(() => call(tOldPassword, tNewPassword),
          throwsA(isA<ServerException>()));
    });
  });
  group('forgotPassword', () {
    final tEmail = 'amalpaviithranmp@gmail.com';
    test('should POST to api/auth/forgot with headers application/json',
        () async {
      //arrange
      setupMockHttpClientSuccess200();
      //act
      await authRemoteDataSourceImpl.forgotPassword(tEmail);
      //assert
      verify(mockHttpClient.post('$BASEURL/api/auth/forgot',
          headers: {'Content-Type': 'application/json'},
          body: {'email': tEmail}));
    });
    test('should return void on success', () async {
      //arrange
      setupMockHttpClientSuccess200();
      //act
      final call = authRemoteDataSourceImpl.forgotPassword;
      //assert
      expect(() => call(tEmail), returnsNormally);
    });
    test('should return [ServerException] for all other errors', () async {
      //arrange
      setupMockHttpClientServerError500();
      //act
      final call = authRemoteDataSourceImpl.forgotPassword;
      //assert
      expect(() => call(tEmail), throwsA(isA<ServerException>()));
    });
  });
  group('logout', () {
    final tToken = "AVeryHashedJWTToken";
    test('should return void on successful call', () async {
      //arrange
      when(mockHttpClient.post(any, headers: anyNamed('headers')))
          .thenAnswer((realInvocation) async => http.Response('success', 200));
      //act
      final call = authRemoteDataSourceImpl.logout;
      //assert
      expect(() => call(tToken), returnsNormally);
      verify(mockHttpClient.post(
        '$BASEURL/api/auth/logout',
        headers: {
          'Authorization': 'Bearer ' + tToken,
          'Content-Type': 'application/json',
        },
      ));
    });
    test('should throw [ServerException] on all other errors', () async {
      //arrange
      when(mockHttpClient.post(any, headers: anyNamed('headers')))
          .thenAnswer((realInvocation) async => http.Response('failure', 500));
      //act
      final call = authRemoteDataSourceImpl.logout;
      //assert
      expect(() => call(tToken), throwsA(isA<ServerException>()));
    });
  });
  group('resetPassword', () {
    final tToken = "AVeryHashedJWTToken";
    final tNewPassword = "AVeryVeryStrongNewPassword";
    test('should return void on successful call', () async {
      //arrange
      setupMockHttpClientSuccess200();
      //act
      final call = authRemoteDataSourceImpl.resetPassword;
      //assert
      expect(() => call(tToken, tNewPassword), returnsNormally);
      verify(mockHttpClient.post(
        '$BASEURL/api/auth/reset',
        headers: {'Content-Type': 'application/json'},
        body: {'token': tToken, 'newPassword': tNewPassword},
      ));
    });
    test('should return void on successful call', () async {
      //arrange
      setupMockHttpClientServerError500();
      //act
      final call = authRemoteDataSourceImpl.resetPassword;
      //assert
      expect(() => call(tToken, tNewPassword),throwsA(isA<ServerException>()));
    });
  });
}
