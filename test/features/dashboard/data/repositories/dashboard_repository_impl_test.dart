import 'package:flutter_test/flutter_test.dart';
import 'package:mess_management_flutter/features/dashboard/data/datasources/dues_local_datasource.dart';
import 'package:mess_management_flutter/features/dashboard/data/datasources/dues_remote_datasource.dart';
import 'package:mess_management_flutter/features/dashboard/data/repositories/dashboard_repository_impl.dart';
import 'package:mess_management_flutter/features/dashboard/domain/repositories/dash_board_repository.dart';
import 'package:mess_management_flutter/features/login/data/datasources/auth_local_datasource.dart';
import 'package:mockito/mockito.dart';

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
  
}
