import 'package:flutter/material.dart';
import 'package:trash_hunter/Pages/login_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Trash Hunter',
      debugShowCheckedModeBanner: false,
      home: LoginPage(),
    );
  }
}
