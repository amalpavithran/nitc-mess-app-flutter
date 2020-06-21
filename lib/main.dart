import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'dashboard.dart';
import 'login.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final _storage = new FlutterSecureStorage();
  final _token  = await _storage.read(key: 'token');
  Widget defaultHome = Login();
  if(_token!=null){
    defaultHome = Dashboard();
  }
  runApp(MaterialApp(
    theme: ThemeData(
      primaryColor: Colors.black,
      secondaryHeaderColor: Colors.black,
      accentColor: Colors.black,
      primaryTextTheme: TextTheme(
        title: TextStyle(
          color: Colors.black
        )
      ),
      inputDecorationTheme: InputDecorationTheme(
        labelStyle: TextStyle(color: Colors.black),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.black)
        )
      ),
      fontFamily: ''
    ),
    title:'NITC MESS',
    home: defaultHome,
    routes: {
      '/login':(context)=>Login(),
      '/dashboard':(context)=>Dashboard()
    },
    ));
}