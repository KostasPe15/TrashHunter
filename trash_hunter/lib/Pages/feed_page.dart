import 'package:flutter/material.dart';
import 'package:trash_hunter/Constants/TextsStyles/heading_texts.dart';
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
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.white,
        scrolledUnderElevation: 0,
        title: const HeadingTexts(
          text: 'Αρχική',
          type: HeadingType.h4,
          color: Color(0xFF1F2024),
        ),
      ),
      backgroundColor: Colors.white,
      body: Stack(
        children: [MapWidget(), BottomsheetWidget()],
      ),
    );
  }
}
