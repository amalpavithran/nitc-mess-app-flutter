import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mess_management_flutter/core/errors/exceptions.dart';
import 'package:mess_management_flutter/core/errors/failures.dart';
import 'package:mess_management_flutter/core/network/network_info.dart';
import 'package:mess_management_flutter/features/login/data/datasources/auth_local_datasource.dart';
import 'package:mess_management_flutter/features/login/data/datasources/auth_remote_datasource.dart';
import 'package:mess_management_flutter/features/login/data/models/user_model.dart';
import 'package:mess_management_flutter/features/login/data/repositories/auth_repository_impl.dart';
import 'package:mockito/mockito.dart';

import '../../../../fixtures/fixture_reader.dart';

class MockAuthRemoteDataSource extends Mock implements AuthRemoteDataSource {}

class MockAuthLocalDataSource extends Mock implements AuthLocalDataSource {}

class MockNetworkInfo extends Mock implements NetworkInfo {}

void main() {
  MockAuthRemoteDataSource remoteDataSource;
  MockAuthLocalDataSource localDataSource;
  MockNetworkInfo networkInfo;
  AuthRepositoryImpl repository;
  setUp(() {
    remoteDataSource = MockAuthRemoteDataSource();
    localDataSource = MockAuthLocalDataSource();
    networkInfo = MockNetworkInfo();
    repository = AuthRepositoryImpl(
      remoteDataSource: remoteDataSource,
      localDataSource: localDataSource,
      networkInfo: networkInfo,
    );
  });
  void withNetwork(bool val) {
    when(networkInfo.isConnected).thenAnswer((realInvocation) async => val);
  }

  group('changePassword', () {
    final tOldPassword = 'OldPassword';
    final tNewPassword = 'NewPassword';
    test('should return Right(null) on success', () async {
      //arrange
      when(remoteDataSource.changePassword(any, any))
          .thenAnswer((realInvocation) async => null);
      withNetwork(true);
      //act
      final result =
          await repository.changePassword(tOldPassword, tNewPassword);
      //assert
      verify(remoteDataSource.changePassword(tOldPassword, tNewPassword));
      expect(result, Right(null));
    });
    test('should return Left(ServerFailure) on ServerException', () async {
      //arrange
      when(remoteDataSource.changePassword(any, any))
          .thenThrow(ServerException());
      withNetwork(true);
      //act
      final result =
          await repository.changePassword(tOldPassword, tNewPassword);
      //assert
      verify(remoteDataSource.changePassword(tOldPassword, tNewPassword));
      expect(result, Left(ServerFailure()));
    });
    test('should return Left(UnexpectedFailure) on any other errors', () async {
      //arrange
      when(remoteDataSource.changePassword(any, any))
          .thenThrow(UnimplementedError());
      withNetwork(true);
      //act
      final result =
          await repository.changePassword(tOldPassword, tNewPassword);
      //assert
      verify(remoteDataSource.changePassword(tOldPassword, tNewPassword));
      expect(result, Left(UnexpectedFailure()));
    });
    test('should return Left(NoInternetConnection) on not having connection',
        () async {
      //arrange
      withNetwork(false);
      //act
      final result =
          await repository.changePassword(tOldPassword, tNewPassword);
      //assert
      verifyZeroInteractions(remoteDataSource);
      expect(result, Left(NoInternetConnection()));
    });
  });
  group('forgotPassword', () {
    final tEmail = 'test@gmail.com';
    test('should return Right(null) on success', () async {
      //arrange
      when(remoteDataSource.forgotPassword(any))
          .thenAnswer((realInvocation) async => null);
      withNetwork(true);
      //act
      final result = await repository.forgotPassword(tEmail);
      //assert
      verify(remoteDataSource.forgotPassword(tEmail));
      expect(result, Right(null));
    });
    test('should return Left(InvalidDataFailure) on invalid email', () async {
      //arrange
      final tEmail = 'asjnjkadnf';
      when(remoteDataSource.forgotPassword(any))
          .thenAnswer((realInvocation) async => null);
      withNetwork(true);
      //act
      final result = await repository.forgotPassword(tEmail);
      //assert
      verifyZeroInteractions(remoteDataSource);
      expect(result, Left(InvalidDataFailure()));
    });
    test('should return Left(ServerFailure) on ServerException', () async {
      //arrange
      when(remoteDataSource.forgotPassword(any)).thenThrow(ServerException());
      withNetwork(true);
      //act
      final result = await repository.forgotPassword(tEmail);
      //assert
      verify(remoteDataSource.forgotPassword(tEmail));
      expect(result, Left(ServerFailure()));
    });
    test('should return Left(UnexpectedFailure) on all other errors', () async {
      //arrange
      when(remoteDataSource.forgotPassword(any))
          .thenThrow(UnimplementedError());
      withNetwork(true);
      //act
      final result = await repository.forgotPassword(tEmail);
      //assert
      verify(remoteDataSource.forgotPassword(tEmail));
      expect(result, Left(UnexpectedFailure()));
    });
  });
  group('login', () {
    final tUsername = 'Amal';
    final tPassword = 'testPass';
    final tUser = UserModel.fromJson(jsonDecode(fixture('login_success.json')));
    test('should return Right(User) on success', () async {
      //arrange
      when(remoteDataSource.login(any, any))
          .thenAnswer((realInvocation) async => tUser);
      //act
      final result = await repository.login(tUsername, tPassword);
      //assert
      verify(remoteDataSource.login(tUsername, tPassword));
      expect(result, Right(tUser));
    });
    test('should return Left(ServerFailure) on ServerException', () async {
      //arrange
      when(remoteDataSource.login(any, any))
          .thenAnswer((realInvocation) async => tUser);
      //act
      final result = await repository.login(tUsername, tPassword);
      //assert
      verify(remoteDataSource.login(tUsername, tPassword));
      expect(result, Right(tUser));
    });
    test('should store userData to Cache', () async {
      //arrange
      when(remoteDataSource.login(any, any))
          .thenAnswer((realInvocation) async => tUser);
      when(localDataSource.setUser(user: anyNamed('user')))
          .thenAnswer((realInvocation) async => null);
      //act
      await repository.login(tUsername, tPassword);
      //assert
      verifyInOrder([
        remoteDataSource.login(tUsername, tPassword),
        localDataSource.setUser(user: tUser)
      ]);
    });
    test('should store token to cache', () async {
      //arrange
      when(remoteDataSource.login(any, any))
          .thenAnswer((realInvocation) async => tUser);
      when(localDataSource.setUser(user: anyNamed('user')))
          .thenAnswer((realInvocation) async => null);
      when(localDataSource.setToken(any))
          .thenAnswer((realInvocation) async => null);
      //act
      await repository.login(tUsername, tPassword);
      //assert
      verifyInOrder([
        remoteDataSource.login(tUsername, tPassword),
        localDataSource.setUser(user: tUser),
        localDataSource.setToken(tUser.token),
      ]);
    });
  });
  group('logout', () {
    final tToken = 'AnAmazingTokenOfAppreciation';
    test('should remove data from cache', () async {
      //arrange
      when(localDataSource.getToken())
          .thenAnswer((realInvocation) async => tToken);
      when(localDataSource.setUser(user: anyNamed('user')))
          .thenAnswer((realInvocation) async => null);
      when(localDataSource.clearToken())
          .thenAnswer((realInvocation) async => null);
      when(remoteDataSource.logout(any))
          .thenAnswer((realInvocation) async => null);
      when(networkInfo.isConnected).thenAnswer((realInvocation) async => true);
      //act
      final result = await repository.logout();
      //assert
      expect(result, Right(null));
      verifyInOrder([
        localDataSource.getToken(),
        remoteDataSource.logout(tToken),
        localDataSource.clearToken(),
        localDataSource.setUser(user: null),
      ]);
      verifyNoMoreInteractions(localDataSource);
      verifyNoMoreInteractions(remoteDataSource);
    });
  });
  group('resetPassword', () {
    final tToken = "MySuperAwesomeToken";
    final tNewPassword = "MyAmazingNewPassword";
    test('should return Right(null) on success', () async {
      //arrange
      when(remoteDataSource.resetPassword(any, any))
          .thenAnswer((realInvocation) async => null);
      withNetwork(true);
      //act
      final result = await repository.resetPassword(tToken, tNewPassword);
      //assert
      verify(remoteDataSource.resetPassword(tToken, tNewPassword));
      expect(result, Right(null));
    });
    test('should return Left(ServerFailure) on ServerException', () async {
      //arrange
      when(remoteDataSource.resetPassword(any, any))
          .thenThrow(ServerException());
      withNetwork(true);
      //act
      final result = await repository.resetPassword(tToken, tNewPassword);
      //assert
      verify(remoteDataSource.resetPassword(tToken, tNewPassword));
      expect(result, Left(ServerFailure()));
    });
    test('should return Left(UnexpectedFailure) on any other errors', () async {
      //arrange
      when(remoteDataSource.resetPassword(any, any))
          .thenThrow(UnimplementedError());
      withNetwork(true);
      //act
      final result = await repository.resetPassword(tToken, tNewPassword);
      //assert
      verify(remoteDataSource.resetPassword(tToken, tNewPassword));
      expect(result, Left(UnexpectedFailure()));
    });
    test('should return Left(NoInternetConnection) on not having connection',
        () async {
      //arrange
      withNetwork(false);
      //act
      final result = await repository.resetPassword(tToken, tNewPassword);
      //assert
      verifyZeroInteractions(remoteDataSource);
      expect(result, Left(NoInternetConnection()));
    });
  });
  group('silentLogin', (){
    final tToken = "MySuperToken";
    final tUser = UserModel.fromJson(jsonDecode(fixture('login_success.json')));
    test('should return Right(User) when already authenticated', () async {
      
      //arrange
      when(localDataSource.getToken()).thenAnswer((realInvocation) async => tToken);
      when(localDataSource.getUser()).thenAnswer((realInvocation) async => tUser);
      //act
      final result = await repository.silentLogin();
      //assert
      expect(result,Right(tUser));
      verifyInOrder([localDataSource.getToken(),localDataSource.getUser()]);
    });
    test('should return Left(Unauthorized) if token is null', () async {
      //arrange
      when(localDataSource.getToken()).thenAnswer((realInvocation) async => null);
      when(localDataSource.getUser()).thenAnswer((realInvocation) async => tUser);
      //act
      final result = await repository.silentLogin();
      //assert
      expect(result,Left(UnauthorizedFailure()));
    });
    test('should return Left(Unauthorized) if User is null', () async {
      //arrange
      when(localDataSource.getToken()).thenAnswer((realInvocation) async => tToken);
      when(localDataSource.getUser()).thenAnswer((realInvocation) async => null);
      //act
      final result = await repository.silentLogin();
      //assert
      expect(result,Left(UnauthorizedFailure()));
    });
  });
}
