import 'package:flutter/material.dart';
import 'package:mess_management_flutter/strings.dart';
import 'package:mess_management_flutter/features/login/presentation/pages/login_page.dart';
import 'package:mess_management_flutter/injection_container.dart' as di;
import 'package:mess_management_flutter/styles.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await di.init();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: TITLE,
      theme: theme,
      home: LoginPage(),
    );
  }
}
