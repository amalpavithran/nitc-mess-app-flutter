import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import '../../../../core/errors/exceptions.dart';
import '../../../login/data/datasources/auth_remote_datasource.dart';

abstract class DuesRemoteDataSource {
  /// GET {BASEURL}/api/users/dues/
  /// Gets current dues from remote repository
  /// throws [Unauthorized] error on invalid token
  /// throws [ServerException] on all other errors
  Future<List<dynamic>> fetchRawDues(String token);
}

class DuesRemoteDataSouceImpl implements DuesRemoteDataSource {
  final http.Client client; 
  DuesRemoteDataSouceImpl({@required this.client});
  @override
  Future<List<dynamic>> fetchRawDues(String token) async {
    final response = await client.get(
      BASEURL + '/api/users/dues',
      headers: {
        'Authorization': 'Bearer ' + token,
        'Content-Type': 'application/json',
      },
    );
    if (response.statusCode == 200) {
      List<dynamic> dues = jsonDecode(response.body);
      return dues;
    }else if(response.statusCode==401){
      throw UnauthorizedException();
    }else{
      throw ServerException();
    }
  }
}