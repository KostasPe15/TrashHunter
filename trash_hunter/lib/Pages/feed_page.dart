import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:trash_hunter/Constants/TextsStyles/heading_texts.dart';

class FeedPage extends StatefulWidget {
  const FeedPage({super.key});

  @override
  State<FeedPage> createState() => _FeedPageState();
}

class _FeedPageState extends State<FeedPage> {
  late GoogleMapController _mapController;

  final LatLng _initialPosition =
      const LatLng(40.6401, 22.9444); // Thessaloniki

  final TextEditingController _searchController = TextEditingController();


 Future<void> _searchAndNavigate() async {
    final query = _searchController.text;
    if (query.isEmpty) return;

    try {
      List<Location> locations = await locationFromAddress(query);
      if (locations.isNotEmpty) {
        final location = locations.first;
        _mapController.animateCamera(CameraUpdate.newLatLngZoom(
          LatLng(location.latitude, location.longitude),
          15,
        ));
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Location not found: $query"),
      ));
    }
  }
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
           Positioned(
            top: 2,
            left: 15,
            right: 15,
            child: Material(
              elevation: 5,
              borderRadius: BorderRadius.circular(8),
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: "Search location...",
                  prefixIcon: Icon(Icons.search),
                  suffixIcon: IconButton(
                    icon: Icon(Icons.send),
                    onPressed: _searchAndNavigate,
                  ),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(horizontal: 15, vertical: 12),
                ),
                onSubmitted: (_) => _searchAndNavigate(),
              ),
            ),
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
        _searchController.dispose();

    super.dispose();
  }
}
