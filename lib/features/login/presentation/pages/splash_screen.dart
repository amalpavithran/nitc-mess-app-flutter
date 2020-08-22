import 'package:flutter/material.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Image.asset(
          'assets/splash2.png',
          height: 800,
          fit: BoxFit.cover,
        ),
        Container(
          alignment: Alignment.bottomCenter - Alignment(0, 0.35),
          child: CircularProgressIndicator(),
        )
      ],
    );
  }
}
