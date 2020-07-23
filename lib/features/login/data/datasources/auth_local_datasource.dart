import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:mess_management_flutter/core/errors/exceptions.dart';
import 'package:mess_management_flutter/features/login/data/models/user_model.dart';
import 'package:mess_management_flutter/features/login/domain/entities/user.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class AuthLocalDataSource {
  ///Gets authentication token from Secure Storage
  ///
  ///throws [NullException] if string not present
  Future<String> getToken();

  ///Clears any authentication token from Secure Storage
  Future<void> clearToken();

  ///Sets an authentication token to Secure Storage
  Future<void> setToken(String token);

  ///Stores [User] to Cache
  ///Clears User Data
  ///
  Future<void> setUser({@required UserModel user});

  ///Gets Cached [User] from local storage
  ///Returns [null] if not found
  ///
  Future<User> getUser();
}

class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  final FlutterSecureStorage storage;
  final SharedPreferences sharedPreferences;

  AuthLocalDataSourceImpl(this.storage, this.sharedPreferences);
  @override
  Future<String> getToken() async {
    final result = await storage.read(key: 'token');
    if (result == null) {
      throw NoTokenException();
    }
    return result;
  }

  @override
  Future<void> clearToken() async {
    await storage.delete(key: 'token');
    return null;
  }

  @override
  Future<void> setToken(String token) async {
    await storage.write(key: 'token', value: token);
    return null;
  }

  @override
  Future<void> setUser({UserModel user}) async {
    await sharedPreferences.setString('user', jsonEncode(user.toJson()));
    return null;
  }

  @override
  Future<User> getUser() async {
    return User.fromJson(jsonDecode(sharedPreferences.getString('user')));
  }
}
