import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

class Dues extends Equatable{
  final String title;
  final String description;
  final DateTime date;
  final double price;

  Dues({
    @required this.title,
    @required this.description,
    @required this.date,
    @required this.price,
  });

  @override
  List<Object> get props => [];
}
