import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mess_management_flutter/core/errors/exceptions.dart';
import 'package:mess_management_flutter/core/errors/failures.dart';
import 'package:mess_management_flutter/features/dashboard/data/datasources/dues_local_datasource.dart';
import 'package:mess_management_flutter/features/dashboard/data/datasources/dues_remote_datasource.dart';
import 'package:mess_management_flutter/features/dashboard/data/models/dues_model.dart';
import 'package:mess_management_flutter/features/dashboard/data/repositories/dashboard_repository_impl.dart';
import 'package:mess_management_flutter/features/dashboard/domain/entities/dues.dart';
import 'package:mess_management_flutter/features/dashboard/domain/repositories/dash_board_repository.dart';
import 'package:mess_management_flutter/features/login/data/datasources/auth_local_datasource.dart';
import 'package:mockito/mockito.dart';

import '../../../../fixtures/fixture_reader.dart';

class MockDuesLocalDataSource extends Mock implements DuesLocalDataSource {}

class MockDuesRemoteDataSource extends Mock implements DuesRemoteDataSource {}

class MockAuthLocalDataSource extends Mock implements AuthLocalDataSource {}

void main() {
  MockDuesLocalDataSource mockDuesLocalDataSource;
  MockDuesRemoteDataSource mockDuesRemoteDataSource;
  MockAuthLocalDataSource mockAuthLocalDataSource;
  DashBoardRepository dashBoardRepository;
  setUp(() {
    mockDuesLocalDataSource = MockDuesLocalDataSource();
    mockDuesRemoteDataSource = MockDuesRemoteDataSource();
    mockAuthLocalDataSource = MockAuthLocalDataSource();
    dashBoardRepository = DashboardRepositoryImpl(
      duesLocalDataSource: mockDuesLocalDataSource,
      duesRemoteDataSource: mockDuesRemoteDataSource,
      authLocalDataSource: mockAuthLocalDataSource,
    );
  });
  group('getDues', () {
    test('should return Right(DuesPackage) on successfull call', () async {
      //arrange
      final tToken = "MySuperSecret";
      final tRawData = jsonDecode(fixture('dues_success.json'));
      when(mockAuthLocalDataSource.getToken())
          .thenAnswer((realInvocation) async => tToken);
      when(mockDuesRemoteDataSource.fetchRawDues(any))
          .thenAnswer((realInvocation) async => tRawData);
      when(mockDuesLocalDataSource.setDues(any))
          .thenAnswer((realInvocation) async => duesFromJsonList(tRawData));
      //act
      final result = await dashBoardRepository.getDues();
      //assert
      result.fold((l) => null, (r) => expect(r, duesFromJsonList(tRawData)));
      verify(mockAuthLocalDataSource.getToken());
      verify(mockDuesLocalDataSource.setDues(tRawData));
      verify(mockDuesRemoteDataSource.fetchRawDues(tToken));
    });
    test('should return Left(ServerFailure()) on ServerException', () async {
      //arrange
      final tToken = "MySuperSecret";
      when(mockAuthLocalDataSource.getToken())
          .thenAnswer((realInvocation) async => tToken);
      when(mockDuesRemoteDataSource.fetchRawDues(any)).thenThrow(ServerException());
      //act
      final result =await  dashBoardRepository.getDues();
      //assert
      result.fold((l) => expect(l,isA<ServerFailure>()), (r) => null);
    });
    test('should return Left(UnauthorizedFailure()) on UnauthorizedException', () async {
      //arrange
      final tToken = "MySuperSecret";
      when(mockAuthLocalDataSource.getToken())
          .thenAnswer((realInvocation) async => tToken);
      when(mockDuesRemoteDataSource.fetchRawDues(any)).thenThrow(UnauthorizedException());
      //act
      final result =await  dashBoardRepository.getDues();
      //assert
      result.fold((l) => expect(l,isA<UnauthorizedFailure>()), (r) => null);
    });
  });
}
