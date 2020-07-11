import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:mess_management_flutter/core/errors/exceptions.dart';

abstract class AuthLocalDataSource {
  ///Gets authentication token from Secure Storage
  ///
  ///throws [NullException] if string not present
  Future<String> getToken();

  ///Clears any authentication token from Secure Storage
  Future<void> clearToken();

  ///Sets an authentication token to Secure Storage
  Future<void> setToken(String token);
}

class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  final FlutterSecureStorage storage;

  AuthLocalDataSourceImpl(this.storage);
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
}
