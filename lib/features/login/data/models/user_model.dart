import 'package:flutter/foundation.dart';
import 'package:mess_management_flutter/features/login/domain/entities/user.dart';

class UserModel extends User {
  final String token;

  UserModel({
    @required this.token,
    @required String name,
    @required String email,
    @required String rollNumber,
    @required String mess,
    @required String hostelName,
    @required String roomNumber,
  }) : super(
          name: name,
          email: email,
          rollNumber: rollNumber,
          mess: mess,
          hostelName: hostelName,
          roomNumber: roomNumber,
        );
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
        name: json['name'],
        email: json['email'],
        rollNumber: json['rollNumber'],
        mess: json['mess'],
        hostelName: json['hostelName'],
        roomNumber: json['roomNumber'],
        token: json['token']);
  }
  Map<String, String> toJson() {
    return {
      'name': name,
      'email': email,
      'rollNumber': rollNumber,
      'mess': mess,
      'hostelName': hostelName,
      'roomNumber': roomNumber
    };
  }
}
