import 'package:flutter/foundation.dart';

class TotalsModel {
  final totalDailyCharge;
  final totalDaysDined;
  final totalExtra;
  final totalItems;

  TotalsModel({
    @required this.totalDailyCharge,
    @required this.totalDaysDined,
    @required this.totalExtra,
    @required this.totalItems,
  });

  factory TotalsModel.fromJson(Map<String, dynamic> json) {
    return TotalsModel(
      totalDailyCharge: json['totalDailyCharge'],
      totalDaysDined: json['totalDaysDined'],
      totalExtra: json['totalExtra'],
      totalItems: json['totalItems'],
    );
  }

  factory TotalsModel.fromJsonDuesList(List<dynamic> json) {
    double totalDailyCharge = 0;
    double totalDaysDined = 0;
    double totalExtra = 0;
    int totalItems = json.length;

    json.forEach((element) {
      if (element['description'] == 'Daily Charges') {
        totalDaysDined++;
        totalDailyCharge += element['price'];
      } else {
        totalExtra += element['price'];
      }
    });
    return TotalsModel(
      totalDailyCharge: totalDailyCharge,
      totalDaysDined: totalDaysDined,
      totalExtra: totalExtra,
      totalItems: totalItems,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'totalDailyCharge': this.totalDailyCharge,
      'totalDaysDined': this.totalDaysDined,
      'totalExtra': this.totalExtra,
      'totalItems': this.totalItems,
    };
  }
}
