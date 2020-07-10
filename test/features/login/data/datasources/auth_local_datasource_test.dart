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
}