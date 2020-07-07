import 'package:flutter/foundation.dart';
import 'package:mess_management_flutter/features/login/data/models/user_model.dart';
import 'package:http/http.dart' as http;

const BASEURL = 'https://nitc-mess.herokuapp.com';

abstract class AuthRemoteDataSource {
  ///POST http://{BASEURL}/api/login with [username] & [password]
  ///Returns [UserModel]
  ///Throws [InvalidCredentialsExceptions] on receving 400 Unauthorized
  ///Throws [ServerException] for all other error codes
  Future<UserModel> login(String username, String password);

  ///POST http://{BASEURL}/api/logout with [token]
  ///
  ///Throws [ServerException] for all error codes
  Future<void> logout();

  ///POST http://{BASEURL}/api/forgot with [email]
  ///
  ///Throws [NoMatchFoundException] on finding no matches
  ///Throws [ServerException] for all other error codes
  Future<void> forgotPassword(String email);

  ///POST http://{BASEURL}/api/reset
  ///
  ///Throws [TokenException] on receving invalid token
  ///Throws [SamePasswordException] on receving new password as the old password
  ///Throws [ServerException] for all other error codes
  Future<void> resetPassword(String token, String newPassword);

  ///POST http://{BASEURL}/api/change
  ///Throws [InvalidCredentialsException] on receving 400 unauthorized
  ///Throws [ServerException] for all other error codes
  Future<void> changePassword(String oldPassword, String newPassword);
}

class AuthRemoteDataSourceImpl extends AuthRemoteDataSource {
  final http.Client client;

  AuthRemoteDataSourceImpl({@required this.client});
  @override
  Future<void> changePassword(String oldPassword, String newPassword) {
    // TODO: implement changePassword
    throw UnimplementedError();
  }

  @override
  Future<void> forgotPassword(String email) {
    // TODO: implement forgotPassword
    throw UnimplementedError();
  }

  @override
  Future<UserModel> login(String username, String password) {
    client.post(
      'http://$BASEURL/api/login',
      headers: {
        'Content-Type': 'application/json',
      },
    );
  }

  @override
  Future<void> logout() {
    // TODO: implement logout
    throw UnimplementedError();
  }

  @override
  Future<void> resetPassword(String token, String newPassword) {
    // TODO: implement resetPassword
    throw UnimplementedError();
  }
}
