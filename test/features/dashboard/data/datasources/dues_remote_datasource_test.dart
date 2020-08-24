import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:mess_management_flutter/features/dashboard/data/datasources/dues_remote_datasource.dart';
import 'package:mess_management_flutter/features/login/data/datasources/auth_remote_datasource.dart';
import 'package:mockito/mockito.dart';
import 'package:http/http.dart' as http;

import '../../../../fixtures/fixture_reader.dart';

class MockHttpClient extends Mock implements http.Client {}

void main() {
  MockHttpClient mockClient;
  DuesRemoteDataSource duesRemoteDataSource;
  setUp(() {
    mockClient = MockHttpClient();
    duesRemoteDataSource = DuesRemoteDataSouceImpl(client: mockClient);
  });

  group('fetchRawDues', () {
    test('should return jsonDecoded data on successful call', () async {
      //arrange
      final tToken = 'SuperSecret';
      final response = fixture('dues_success.json');
      when(mockClient.get(any, headers: anyNamed('headers'))).thenAnswer(
        (realInvocation) async => http.Response(
          response,
          200,
        ),
      );
      //act
      final result = await duesRemoteDataSource.fetchRawDues(tToken);
      //assert
      verify(mockClient.get(
        BASEURL + '/api/users/dues',
        headers: {
          'Authorization': 'Bearer ' + tToken,
          'Content-Type': 'application/json',
        },
      ));
      expect(result, jsonDecode(response));
    });
  });
}
