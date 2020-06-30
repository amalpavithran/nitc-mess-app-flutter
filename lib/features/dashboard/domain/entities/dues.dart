import 'package:flutter/foundation.dart';

class Dues {
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
}
