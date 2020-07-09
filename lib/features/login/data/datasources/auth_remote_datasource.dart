import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:mess_management_flutter/core/errors/exceptions.dart';
import 'package:mess_management_flutter/features/login/data/models/user_model.dart';
import 'package:http/http.dart' as http;

const BASEURL = 'https://nitc-mess.herokuapp.com';

abstract class AuthRemoteDataSource {
  ///POST http://{BASEURL}/api/auth/login with [username] & [password]
  ///Returns [UserModel]
  ///Throws [InvalidCredentialsExceptions] on receving 400 Unauthorized
  ///Throws [ServerException] for all other error codes
  Future<UserModel> login(String username, String password);

  ///POST http://{BASEURL}/api/auth/logout with [token]
  ///
  ///Throws [ServerException] for all error codes
  Future<void> logout();

  ///POST http://{BASEURL}/api/auth/forgot with [email]
  ///
  ///Throws [NoMatchFoundException] on finding no matches
  ///Throws [ServerException] for all other error codes
  Future<void> forgotPassword(String email);

  ///POST http://{BASEURL}/api/auth/reset
  ///
  ///Throws [TokenException] on receving invalid token
  ///Throws [SamePasswordException] on receving new password as the old password
  ///Throws [ServerException] for all other error codes
  Future<void> resetPassword(String token, String newPassword);

  ///POST http://{BASEURL}/api/auth/change
  ///Throws [InvalidCredentialsException] on receving 400 unauthorized
  ///Throws [ServerException] for all other error codes
  Future<void> changePassword(String oldPassword, String newPassword);
}

class AuthRemoteDataSourceImpl extends AuthRemoteDataSource {
  final http.Client client;

  AuthRemoteDataSourceImpl({@required this.client});
  @override
  Future<void> changePassword(String oldPassword, String newPassword) async {
    final response = await client.post(
      'http://$BASEURL/api/auth/change',
      headers: {
        'Content-Type': 'application/json',
      },
      body: {
        'oldPassword': oldPassword,
        'newPassword': newPassword,
      },
    );
    if (response.statusCode != 200) {
      throw ServerException();
    } else {
      return null;
    }
  }

  @override
  Future<void> forgotPassword(String email) {
    // TODO: implement forgotPassword
    throw UnimplementedError();
  }

  @override
  Future<UserModel> login(String username, String password) async {
    final response =
        await client.post('http://$BASEURL/api/auth/login', headers: {
      'Content-Type': 'application/json',
    }, body: {
      'username': username,
      'password': password,
    });
    print(response);
    if (response.statusCode == 200) {
      return UserModel.fromJson(jsonDecode(response.body));
    } else if (response.statusCode == 401) {
      throw InvalidCredentialsException();
    } else {
      throw ServerException();
    }
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
