import 'package:flutter/material.dart';
import 'package:trash_hunter/Widgets/bottomsheet_widget.dart';
import 'package:trash_hunter/Widgets/map_widget.dart';

class FeedPage extends StatefulWidget {
  const FeedPage({super.key});

  @override
  State<FeedPage> createState() => _FeedPageState();
}

class _FeedPageState extends State<FeedPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [MapWidget(), BottomsheetWidget()],
      ),
    );
  }
}
