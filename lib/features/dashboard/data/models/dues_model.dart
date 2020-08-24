import 'package:flutter/foundation.dart';
import 'package:mess_management_flutter/features/dashboard/domain/entities/dues.dart';

class DuesModel extends Dues {
  DuesModel({
    @required price,
    @required title,
    @required description,
    @required date,
  }) : super(
          price: price,
          title: title,
          description: description,
          date: DateTime.fromMillisecondsSinceEpoch(date),
        );

  Map<String, dynamic> toJson(Dues dues) {
    return {
      'date': dues.date,
      'description': dues.description,
      'price': dues.price,
      'title': dues.title
    };
  }
}

List<Dues> duesFromJsonList(List<Map<String, dynamic>> json) {
  json.retainWhere((element) => element['description'] != 'Daily Charges');
  return json
      .map(
        (e) => DuesModel(
          price: e['price'],
          title: e['title'],
          description: e['description'],
          date: e['date'],
        ),
      )
      .toList();
}
