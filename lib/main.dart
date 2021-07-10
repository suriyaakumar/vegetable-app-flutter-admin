import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:admin/panel.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Admin',
      home: Panel(),
      theme: ThemeData(
          primaryColor: Colors.deepPurple,
          accentColor: Colors.deepPurpleAccent,
          appBarTheme: AppBarTheme(centerTitle: true),
          snackBarTheme: SnackBarThemeData(
              backgroundColor: Colors.deepPurpleAccent,
              contentTextStyle: TextStyle(color: Colors.white))),
    );
  }
}
