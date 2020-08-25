import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:mess_management_flutter/core/errors/exceptions.dart';
import 'package:mess_management_flutter/features/dashboard/data/models/dues_model.dart';
import 'package:mess_management_flutter/features/dashboard/data/models/totals_model.dart';
import 'package:mess_management_flutter/features/dashboard/domain/entities/dues.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class DuesLocalDataSource {
  ///Sets totals in Shared Preferences from json
  ///
  ///throws [Null Exception] if json is null
  Future<TotalsModel> setTotals(List<dynamic> json);

  ///Sets Dues in Shared Preferences from json
  ///
  ///Throws [Null Exception] if json is null
  Future<List<DuesModel>> setDues(List<dynamic> json);

  ///Gets Totals from Shared Preferences
  ///
  ///throws [Null Exception] if no data found
  Future<TotalsModel> getTotals();

  ///Gets Dues from Shared Preferences
  ///
  ///throws [Null Exception] if no data found
  Future<List<DuesModel>> getDues();
}

class DuesLocalDataSourceImpl implements DuesLocalDataSource {
  final SharedPreferences sharedPreferences;

  DuesLocalDataSourceImpl({@required this.sharedPreferences});
  @override
  Future<List<DuesModel>> getDues() {
    // TODO: implement getDues
    throw UnimplementedError();
  }

  @override
  Future<TotalsModel> getTotals() {
    // TODO: implement getTotals
    throw UnimplementedError();
  }

  @override
  Future<List<DuesModel>> setDues(json) async{
    if(json == null){
      throw NullException();
    }
    List<Dues> dues = duesFromJsonList(json);
    await sharedPreferences.setString('dues', duesToJsonList(dues));
    return dues;
  }

  @override
  Future<TotalsModel> setTotals(json) async{
    if(json==null){
      throw NullException();
    }
    final totals = TotalsModel.fromJson(json);
    await sharedPreferences.setString('totals', jsonEncode(totals.toJson()));
    return totals;
  }
}
