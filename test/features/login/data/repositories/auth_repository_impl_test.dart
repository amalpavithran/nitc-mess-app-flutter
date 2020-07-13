import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mess_management_flutter/core/errors/exceptions.dart';
import 'package:mess_management_flutter/core/errors/failures.dart';
import 'package:mess_management_flutter/core/network/network_info.dart';
import 'package:mess_management_flutter/features/login/data/datasources/auth_local_datasource.dart';
import 'package:mess_management_flutter/features/login/data/datasources/auth_remote_datasource.dart';
import 'package:mess_management_flutter/features/login/data/repositories/auth_repository_impl.dart';
import 'package:mockito/mockito.dart';

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
  group('changePassword', (){
    final tOldPassword = 'OldPassword';
    final tNewPassword = 'NewPassword';
    void withNetwork(bool val){
      when(networkInfo.isConnected).thenAnswer((realInvocation) async => val);
    }
    test('should return Right(null) on success', () async {
      //arrange
      when(remoteDataSource.changePassword(any, any)).thenAnswer((realInvocation) async => null);
      withNetwork(true);
      //act
      final result = await repository.changePassword(tOldPassword, tNewPassword);
      //assert
      verify(remoteDataSource.changePassword(tOldPassword, tNewPassword));
      expect(result, Right(null));
    });
    test('should return Left(ServerFailure) on ServerException', () async {
      //arrange
      when(remoteDataSource.changePassword(any, any)).thenThrow(ServerException());
      withNetwork(true);
      //act
      final result = await repository.changePassword(tOldPassword, tNewPassword);
      //assert
      verify(remoteDataSource.changePassword(tOldPassword, tNewPassword));
      expect(result,Left(ServerFailure()));
    });
    test('should return Left(UnexpectedFailure) on any other errors', () async {
      //arrange
      when(remoteDataSource.changePassword(any, any)).thenThrow(UnimplementedError());
      withNetwork(true);
      //act
      final result = await repository.changePassword(tOldPassword, tNewPassword);
      //assert
      verify(remoteDataSource.changePassword(tOldPassword, tNewPassword));
      expect(result,Left(UnexpectedFailure()));
    });
    test('should return Left(NoInternetConnection) on not having connection', () async {
      //arrange
      withNetwork(false);
      //act
      final result = await repository.changePassword(tOldPassword, tNewPassword);
      //assert
      verifyZeroInteractions(remoteDataSource);
      expect(result,Left(NoInternetConnection()));
    });
  });
}
