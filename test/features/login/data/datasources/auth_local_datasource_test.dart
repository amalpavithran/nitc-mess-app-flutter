import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mess_management_flutter/core/errors/exceptions.dart';
import 'package:mess_management_flutter/features/login/data/datasources/auth_local_datasource.dart';
import 'package:mockito/mockito.dart';

class MockSecureStorage extends Mock implements FlutterSecureStorage {}

void main(){
  MockSecureStorage mockSecureStorage;
  AuthLocalDataSourceImpl authLocalDataSourceImpl;
  setUp((){
    mockSecureStorage = MockSecureStorage();
    authLocalDataSourceImpl = AuthLocalDataSourceImpl(mockSecureStorage);
  });
  group('getToken', (){
    final tToken = "MyAmazingHashedToken";
    test('should return String on success', () async {
      //arrange
      when(mockSecureStorage.read(key:anyNamed('key'))).thenAnswer((realInvocation) async => tToken);
      //act
      final result = await authLocalDataSourceImpl.getToken();
      //assert
      verify(mockSecureStorage.read(key: 'token'));
      expect(result,tToken);
    });
    test('should return [NoTokenException] on null', () async {
      //arrange
      when(mockSecureStorage.read(key:anyNamed('key'))).thenAnswer((realInvocation) async => null);
      //act
      final call = authLocalDataSourceImpl.getToken;
      //assert
      expect(()=>call(),throwsA(isA<NoTokenException>()));
    });
  });
  test('clearToken should return normally on successful call', () async {
    //arrange
    when(mockSecureStorage.delete(key: anyNamed('key'))).thenAnswer((realInvocation) async => null);
    //act
    final call = authLocalDataSourceImpl.clearToken;
    //assert
    expect(()=>call(),returnsNormally);
    verify(mockSecureStorage.delete(key: 'token'));
  });
  test('setToken should return normally on successful call', () async {
    final tToken = 'MyVerySecureHashedJWTToken';
    //arrange
    when(mockSecureStorage.write(key: anyNamed('key'),value: anyNamed('value'))).thenAnswer((realInvocation) async => null);
    //act
    final call = authLocalDataSourceImpl.setToken;
    //assert
    expect(()=>call(tToken),returnsNormally);
    verify(mockSecureStorage.write(key: 'token',value: tToken));
  });
}