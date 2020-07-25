import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mess_management_flutter/core/errors/exceptions.dart';
import 'package:mess_management_flutter/features/login/data/datasources/auth_local_datasource.dart';
import 'package:mess_management_flutter/features/login/data/models/user_model.dart';
import 'package:mess_management_flutter/features/login/domain/entities/user.dart';
import 'package:mockito/mockito.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../fixtures/fixture_reader.dart';

class MockSecureStorage extends Mock implements FlutterSecureStorage {}

class MockSharedPreferences extends Mock implements SharedPreferences {}

void main() {
  MockSecureStorage mockSecureStorage;
  AuthLocalDataSource authLocalDataSourceImpl;
  MockSharedPreferences mockSharedPreferences;
  setUp(() {
    mockSecureStorage = MockSecureStorage();
    mockSharedPreferences = MockSharedPreferences();
    authLocalDataSourceImpl =
        AuthLocalDataSourceImpl(mockSecureStorage, mockSharedPreferences);
  });
  group('getToken', () {
    final tToken = "MyAmazingHashedToken";
    test('should return String on success', () async {
      //arrange
      when(mockSecureStorage.read(key: anyNamed('key')))
          .thenAnswer((realInvocation) async => tToken);
      //act
      final result = await authLocalDataSourceImpl.getToken();
      //assert
      verify(mockSecureStorage.read(key: 'token'));
      expect(result, tToken);
    });
    test('should return [NoTokenException] on null', () async {
      //arrange
      when(mockSecureStorage.read(key: anyNamed('key')))
          .thenAnswer((realInvocation) async => null);
      //act
      final call = authLocalDataSourceImpl.getToken;
      //assert
      expect(() => call(), throwsA(isA<NoTokenException>()));
    });
  });
  test('clearToken should return normally on successful call', () async {
    //arrange
    when(mockSecureStorage.delete(key: anyNamed('key')))
        .thenAnswer((realInvocation) async => null);
    //act
    final call = authLocalDataSourceImpl.clearToken;
    //assert
    expect(() => call(), returnsNormally);
    verify(mockSecureStorage.delete(key: 'token'));
  });
  test('setToken should return normally on successful call', () async {
    final tToken = 'MyVerySecureHashedJWTToken';
    //arrange
    when(mockSecureStorage.write(
            key: anyNamed('key'), value: anyNamed('value')))
        .thenAnswer((realInvocation) async => null);
    //act
    final call = authLocalDataSourceImpl.setToken;
    //assert
    expect(() => call(tToken), returnsNormally);
    verify(mockSecureStorage.write(key: 'token', value: tToken));
  });
  test('setUser should return void on success', () async {
    final tUserModel =
        UserModel.fromJson(jsonDecode(fixture('login_success.json')));
    //arrange
    when(mockSharedPreferences.setString(any, any))
        .thenAnswer((realInvocation) async => true);
    //act
    final call = authLocalDataSourceImpl.setUser;
    //assert
    expect(() => call(user: tUserModel), returnsNormally);
    verify(mockSharedPreferences.setString(
        'user', jsonEncode(tUserModel.toJson())));
  });
  test('getUser should return User from Cache', () async {
    final tUser = User.fromJson(jsonDecode(fixture('login_success.json')));
    //arrange
    when(mockSharedPreferences.getString(any))
        .thenReturn(fixture('login_success.json'));
    //act
    final result = await authLocalDataSourceImpl.getUser();
    //assert
    expect(result, tUser);
    verify(mockSharedPreferences.getString('user'));
  });
  test('setUser should remove User from cache on receiving null as argument', () async {
    //arrange
    when(mockSharedPreferences.remove(any)).thenAnswer((realInvocation) async => true);
    //act
    final call = authLocalDataSourceImpl.setUser;
    //assert
    expect(()=>call(user: null),returnsNormally);
    verify(mockSharedPreferences.remove('user'));
    verifyNoMoreInteractions(mockSharedPreferences);
  });
}
