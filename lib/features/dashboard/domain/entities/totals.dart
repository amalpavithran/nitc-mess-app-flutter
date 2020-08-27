import 'package:flutter/foundation.dart';

class Totals {
  final totalDailyCharge;
  final totalDaysDined;
  final totalExtra;
  final totalItems;

  Totals({
    @required this.totalDailyCharge,
    @required this.totalDaysDined,
    @required this.totalExtra,
    @required this.totalItems,
  });
}