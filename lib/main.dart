
import 'package:flutter/material.dart';
import 'package:meerabelle/login.dart';
import 'firebase_options.dart';
import 'login.dart';

import 'package:firebase_core/firebase_core.dart';

void main() async{
      WidgetsFlutterBinding.ensureInitialized();
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );
      runApp( MyApp());
}
/// This is the main application widget.
class MyApp extends StatelessWidget {
  MyApp({Key? key}) : super(key: key);

  static const String _title = 'Flutter Code Sample';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: _title,
      theme: ThemeData(scaffoldBackgroundColor: Colors.blue),
      home:  LoginScreen(),
    );
  }
}
