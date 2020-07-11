import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

class User extends Equatable {
  final String name;
  final String email;
  final String rollNumber;
  final String mess;
  final String hostelName;
  final String roomNumber;

  User({
    @required this.name,
    @required this.email,
    @required this.rollNumber,
    @required this.mess,
    @required this.hostelName,
    @required this.roomNumber,
  });

  @override
  List<Object> get props => [
        name,
        email,
        rollNumber,
        mess,
        hostelName,
        roomNumber,
      ];
}