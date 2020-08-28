import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:mess_management_flutter/features/dashboard/domain/entities/dues.dart';

class DuesModel extends Dues {
  DuesModel({
    @required double price,
    @required String title,
    @required String description,
    @required DateTime date,
  }) : super(
          price: price,
          title: title,
          description: description,
          date: date,
        );

  factory DuesModel.fromJson(Map<String, dynamic> json) {
    return DuesModel(
      price: json['price'].toDouble(),
      title: json['title'],
      description: json['description'],
      date: DateTime.fromMillisecondsSinceEpoch(json['date']),
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'date': this.date.millisecondsSinceEpoch,
      'description': this.description,
      'price': this.price,
      'title': this.title
    };
  }
}

List<Dues> duesFromJsonList(List<dynamic> json) {
  json.retainWhere((element) => element['description'] != 'Daily Charges');
  return json.map((e) => DuesModel.fromJson(e)).toList();
}

String duesToJsonList(List<DuesModel> dues) {
  return jsonEncode(dues.map((e) => e.toJson()).toList());
}
