import 'package:flutter/material.dart';
import 'package:trash_hunter/login_page.dart';

Future<void>main() async{
  WidgetsFlutterBinding.ensureInitialized();


  runApp(const MyApp());

}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Your app name',
      debugShowCheckedModeBanner: false,
      home: LoginPage(),
    );
  }
}
