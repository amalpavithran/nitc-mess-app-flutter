import 'package:flutter/material.dart';
import 'package:mess_management_flutter/dashboard.dart';
import 'package:mess_management_flutter/login.dart';

void main() async {
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
    home: Login(),
    routes: {
      '/login':(context)=>Login(),
      '/dashboard':(context)=>Dashboard()
    },
    ));
}