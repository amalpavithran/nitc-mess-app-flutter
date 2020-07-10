import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:mess_management_flutter/core/errors/exceptions.dart';

abstract class AuthLocalDataSource {
  ///Gets authentication token from Secure Storage
  ///
  ///throws [NullException] if string not present
  Future<String> getToken();
}

class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  final FlutterSecureStorage storage;

  AuthLocalDataSourceImpl(this.storage);
  @override
  Future<String> getToken() async {
    final result =  await storage.read(key: 'token');
    if(result==null){
      throw NoTokenException();
    }
    return result;
  }
}
