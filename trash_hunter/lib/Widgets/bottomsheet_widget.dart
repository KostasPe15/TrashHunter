import 'package:flutter/material.dart';

class BottomsheetWidget extends StatefulWidget {
  const BottomsheetWidget({super.key});

  @override
  State<BottomsheetWidget> createState() => _BottomsheetWidgetState();
}

class _BottomsheetWidgetState extends State<BottomsheetWidget> {
  final DraggableScrollableController _draggableController =
      DraggableScrollableController();

  final double _minChildSize = 0.10;
  final double _maxChildSize = 0.85;

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      controller: _draggableController,
      initialChildSize: 0.10,
      minChildSize: 0.10,
      maxChildSize: 0.85,
      builder: (context, scrollController) {
        return SafeArea(
          top: false,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
            ),
            child: Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 30),
                  child: ListView(
                    controller: scrollController,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          children: [
                            Text("Test 1"),
                            SizedBox(height: 300),
                            Text("Test 2"),
                            SizedBox(height: 300),
                            Text("Test 3"),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  child: GestureDetector(
                    behavior: HitTestBehavior.translucent,
                    onVerticalDragUpdate: (details) {
                      // Forward the drag to the DraggableScrollableController
                      final newSize = (_draggableController.size -
                              details.primaryDelta! /
                                  MediaQuery.of(context).size.height)
                          .clamp(_minChildSize, _maxChildSize);

                      _draggableController.jumpTo(newSize);
                    },
                    child: Container(
                      height: 30, // Make the whole top 30px area draggable
                      alignment: Alignment.center,
                      child: Container(
                        width: 40,
                        height: 5,
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _draggableController.dispose();
    super.dispose();
  }
}
