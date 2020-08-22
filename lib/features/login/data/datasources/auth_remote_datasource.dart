import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:mess_management_flutter/core/errors/exceptions.dart';
import 'package:mess_management_flutter/features/login/data/models/user_model.dart';
import 'package:http/http.dart' as http;

const BASEURL = 'https://nitc-mess.herokuapp.com';

abstract class AuthRemoteDataSource {
  ///POST {BASEURL}/api/auth/login with [username] & [password]
  ///Returns [UserModel]
  ///Throws [InvalidCredentialsExceptions] on receving 400 Unauthorized
  ///Throws [ServerException] for all other error codes
  Future<UserModel> login(String username, String password);

  ///POST {BASEURL}/api/auth/logout with [token]
  ///
  ///Throws [ServerException] for all error codes
  Future<void> logout(String token);

  ///POST {BASEURL}/api/auth/forgot with [email]
  ///
  ///Throws [NoMatchFoundException] on finding no matches
  ///Throws [ServerException] for all other error codes
  Future<void> forgotPassword(String email);

  ///POST {BASEURL}/api/auth/reset
  ///
  ///Throws [TokenException] on receving invalid token
  ///Throws [SamePasswordException] on receving new password as the old password
  ///Throws [ServerException] for all other error codes
  Future<void> resetPassword(String token, String newPassword);

  ///POST {BASEURL}/api/auth/change
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
      '$BASEURL/api/auth/change',
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'oldPassword': oldPassword,
        'newPassword': newPassword,
      }),
    );
    if (response.statusCode != 200) {
      throw ServerException();
    } else {
      return null;
    }
  }

  @override
  Future<void> forgotPassword(String email) async {
    final response = await client.post(
      '$BASEURL/api/auth/forgot',
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'email': email}),
    );
    if (response.statusCode != 200) {
      throw ServerException();
    } else {
      return null;
    }
  }

  @override
  Future<UserModel> login(String username, String password) async {
    final response = await client.post('$BASEURL/api/auth/login',
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'username': username,
          'password': password,
        }));
    print(response.statusCode);
    if (response.statusCode == 200) {
      return UserModel.fromJson(jsonDecode(response.body));
    } else if (response.statusCode == 401) {
      throw InvalidCredentialsException();
    } else {
      throw ServerException();
    }
  }

  @override
  Future<void> logout(String token) async {
    final response = await client.post(
      '$BASEURL/api/auth/logout',
      headers: {
        'Authorization': 'Bearer ' + token,
        'Content-Type': 'application/json',
      },
    );
    if (response.statusCode != 200) {
      throw ServerException();
    } else {
      return null;
    }
  }

  @override
  Future<void> resetPassword(String token, String newPassword) async {
    final response = await client.post('$BASEURL/api/auth/reset',
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'token': token, 'newPassword': newPassword}));
    if (response.statusCode != 200) {
      throw ServerException();
    }
  }
}
