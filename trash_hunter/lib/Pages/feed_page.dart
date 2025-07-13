import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class FeedPage extends StatefulWidget {
  const FeedPage({super.key});

  @override
  State<FeedPage> createState() => _FeedPageState();
}

class _FeedPageState extends State<FeedPage> {
  late GoogleMapController _mapController;

  final LatLng _initialPosition =
      const LatLng(40.6401, 22.9444); // Thessaloniki

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          GoogleMap(
            initialCameraPosition: CameraPosition(
              target: _initialPosition,
              zoom: 12,
            ),
            onMapCreated: (GoogleMapController controller) {
              _mapController = controller;
            },
            zoomControlsEnabled: true,
          ),
          DraggableScrollableSheet(
              initialChildSize: 0.2,
              minChildSize: 0.2,
              maxChildSize: 0.6,
              builder: (context, scrollController) {
                return SingleChildScrollView(
                    controller: scrollController,
                    child: Container(
                      color: Colors.white70,
                      child: Column(
                        children: [
                          Text("Test 1"),
                          SizedBox(height: 300),
                          Text("Test 2"),
                          SizedBox(height: 300),
                          Text("Test 3")
                        ],
                      ),
                    ));
              })
        ],
      ),
    );
  }

  @override
  void dispose() {
    _mapController.dispose();
    super.dispose();
  }
}
