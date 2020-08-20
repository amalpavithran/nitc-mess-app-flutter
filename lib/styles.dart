import 'package:flutter/material.dart';

TextStyle title = TextStyle(
  fontSize: 20,
  fontWeight: FontWeight.w300,
);
TextStyle appbarTitle = TextStyle(
  fontSize: 20,
  fontWeight: FontWeight.bold,
);
TextStyle h2 = TextStyle(
  fontSize: 15,
  fontWeight: FontWeight.bold
);

TextStyle secondary = TextStyle(
  color: Colors.grey,
  fontWeight: FontWeight.w400
);

TextStyle primary = TextStyle(
  fontWeight: FontWeight.normal,
);

TextStyle boldWhite = TextStyle(
  color: Colors.white,
);

TextStyle banner = TextStyle(
  fontSize: 40,
  fontWeight: FontWeight.w100
);

const primaryColor = Color(0xff4fe4cb);

final theme  = ThemeData(
  brightness: Brightness.light,
  primaryColor: primaryColor,
  accentColor: Colors.black,
  textTheme: TextTheme(

  ),
  appBarTheme: AppBarTheme(
    brightness: Brightness.dark,
    iconTheme: IconThemeData(
      color: Colors.white
    ),
    color: Colors.teal,
    textTheme: TextTheme(
      headline6: TextStyle(
        color: Colors.white
      )
    )
  )
);