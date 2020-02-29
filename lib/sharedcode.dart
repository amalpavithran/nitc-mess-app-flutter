import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:io';
class PreventAppExit extends StatefulWidget {
  final GlobalKey<ScaffoldState> childkey;
  final Scaffold child;
  PreventAppExit({this.childkey, this.child});
  @override
  _PreventAppExitState createState() =>
      _PreventAppExitState(this.childkey, this.child);
}

class _PreventAppExitState extends State<PreventAppExit> {
  final Scaffold child;
  final GlobalKey<ScaffoldState> childkey;
  _PreventAppExitState(this.childkey, this.child);

  DateTime _recentTry;

  Future<bool> _onBackButtonPress() {
    DateTime currentTime = DateTime.now();
    if (currentTime.difference(_recentTry) > Duration(seconds: 2)) {
      _recentTry = currentTime;
      childkey.currentState.showSnackBar(SnackBar(
        content: Text('Press back again to exit'),
        duration: Duration(seconds: 2),
      ));
      return Future.value(false);
    }
    exit(0);
    return Future.value(true);
  }

  @override
  Widget build(BuildContext context) {
    _recentTry = DateTime.now();
    return WillPopScope(onWillPop: _onBackButtonPress, child: this.child);
  }
}