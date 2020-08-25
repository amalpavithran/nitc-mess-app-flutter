import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart';
import 'package:mess_management_flutter/core/errors/exceptions.dart';
import 'package:mess_management_flutter/features/dashboard/data/datasources/dues_local_datasource.dart';
import 'package:mess_management_flutter/features/dashboard/data/models/dues_model.dart';
import 'package:mess_management_flutter/features/dashboard/data/models/totals_model.dart';
import 'package:mockito/mockito.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../fixtures/fixture_reader.dart';

class MockSharedPreferences extends Mock implements SharedPreferences {}

void main() {
  MockSharedPreferences mockSharedPreferences;
  DuesLocalDataSource duesLocalDataSource;
  setUp(() {
    mockSharedPreferences = MockSharedPreferences();
    duesLocalDataSource =
        DuesLocalDataSourceImpl(sharedPreferences: mockSharedPreferences);
  });
  group('setTotals', () {
    test('should return TotalsModel on successful call', () async {
      //arrange
      List<dynamic> tData = jsonDecode(fixture('dues_success.json'));
      print(tData);
      final tTotals = TotalsModel.fromJsonDuesList(tData).toJson();
      when(mockSharedPreferences.setString(any, any))
          .thenAnswer((realInvocation) async => true);
      //act
      final result = await duesLocalDataSource.setTotals(tData);
      //assert
      verify(mockSharedPreferences.setString('totals', jsonEncode(tTotals)));
      expect(result, isA<TotalsModel>());
      expect(result.totalDailyCharge, 160);
      expect(result.totalDaysDined, 2);
      expect(result.totalExtra, 20);
      expect(result.totalItems, 3);
    });
    test('should throw [Null Exception] when json is null', () async {
      //arrange
      //act
      final call = duesLocalDataSource.setTotals;
      //assert
      verifyZeroInteractions(mockSharedPreferences);
      expect(() => call(null), throwsA(isA<NullException>()));
    });
  });
  group('setDues', () {
    test('should return List<DuesModel> on successful call', () async {
      //arrange
      final tData = jsonDecode(fixture('dues_success.json'));
      when(mockSharedPreferences.setString(any, any))
          .thenAnswer((realInvocation) async => true);
      //act
      final result = await duesLocalDataSource.setDues(tData);
      //assert
      verify(mockSharedPreferences.setString(
          'dues', duesToJsonList(duesFromJsonList(tData))));
      expect(result, isA<List<DuesModel>>());
    });
    test('should throw [NullException] on json being null', () async {
      //arrange
      //act
      final call = duesLocalDataSource.setDues;
      //assert
      verifyZeroInteractions(mockSharedPreferences);
      expect(() => call(null), throwsA(isA<NullException>()));
    });
  });
  test('getTotals should return [TotalsModel] on successful call', () async {
    //arrange
    final tData = fixture('totals_success.json');
    final tMapData = jsonDecode(tData);
    when(mockSharedPreferences.getString(any)).thenReturn(tData);
    //act
    final result = await duesLocalDataSource.getTotals();
    //assert
    verify(mockSharedPreferences.getString('totals'));
    expect(result, isA<TotalsModel>());
    expect(result.totalDailyCharge, tMapData['totalDailyCharge']);
    expect(result.totalDaysDined, tMapData['totalDaysDined']);
    expect(result.totalExtra, tMapData['totalExtra']);
    expect(result.totalItems, tMapData['totalItems']);
  });
  test('getDues', () async {
    //arrange
    final tData = fixture('dues_success.json');
    when(mockSharedPreferences.getString(any)).thenReturn(tData);
    //act
    final result =await duesLocalDataSource.getDues();
    //assert
    verify(mockSharedPreferences.getString('dues'));
    expect(result, isA<List<DuesModel>>());
    
  });
}
