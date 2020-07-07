import 'package:flutter_test/flutter_test.dart';
import 'package:mess_management_flutter/features/login/data/datasources/auth_remote_datasource.dart';
import 'package:mockito/mockito.dart';
import 'package:http/http.dart' as http;

class MockHttpClient extends Mock implements http.Client {}

void main() {
  MockHttpClient mockHttpClient;
  AuthRemoteDataSourceImpl authRemoteDataSourceImpl;
  setUp(() {
    mockHttpClient = MockHttpClient();
    authRemoteDataSourceImpl = AuthRemoteDataSourceImpl(client: mockHttpClient);
  });
  setupMockHttpClientSuccess200() {
    when(mockHttpClient.post(any, headers: anyNamed('headers')));
  }

  group('login', () {
    final tUsername = 'Amal1234';
    final tPassword = 'MyVeryStrongSecret';
    test(
        'should perform POST request on URL api/login as the endpoint with application/json header',
        () async {
      //arrange
      setupMockHttpClientSuccess200();
      //act
      final result = await authRemoteDataSourceImpl.login(tUsername, tPassword);
      //assert
      verify(mockHttpClient.post(
        'http://$BASEURL/api/login',
        headers: {
          'Content-Type': 'application/json',
        },
      ));
    });
  });
}
