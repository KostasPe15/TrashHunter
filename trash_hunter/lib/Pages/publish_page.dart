import 'package:flutter/material.dart';

class PublishPage extends StatefulWidget {
  const PublishPage({super.key});

  @override
  State<PublishPage> createState() => _PublishPageState();
}

class _PublishPageState extends State<PublishPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(child: Text("Publish Page")),
    );
  }
}
