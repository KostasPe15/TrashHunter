import 'package:flutter/material.dart';
import 'package:trash_hunter/login_page.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Your app name',
      debugShowCheckedModeBanner: false,
      home: LoginPage(),
    );
  }
}
