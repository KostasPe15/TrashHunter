import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:trash_hunter/Constants/TextsStyles/heading_texts.dart';
import 'package:http/http.dart' as http;

class FeedPage extends StatefulWidget {
  const FeedPage({super.key});

  @override
  State<FeedPage> createState() => _FeedPageState();
}

class _FeedPageState extends State<FeedPage> {
  late GoogleMapController _mapController;
  List<Map<String, dynamic>> _suggestions = [];
  bool _isFetching = false;
  Timer? _debounce;
  Set<Marker> markers = {};
  final ScrollController _scrollController = ScrollController();
  final DraggableScrollableController _draggableController =
      DraggableScrollableController();

  final double _minChildSize = 0.10;
  final double _maxChildSize = 0.85;

  final LatLng _initialPosition =
      const LatLng(40.6401, 22.9444); // Thessaloniki

  final TextEditingController _searchController = TextEditingController();

  Future<void> _searchAndNavigate() async {
    final query = _searchController.text.trim();
    if (query.isEmpty) return;

    setState(() => _isFetching = true);

    try {
      final url = Uri.parse(
          'https://nominatim.openstreetmap.org/search?q=$query&format=json&limit=1');

      final response =
          await http.get(url, headers: {'User-Agent': 'TrashHunterApp/1.0'});

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);

        if (data.isNotEmpty) {
          final result = data[0];
          final lat = double.parse(result['lat']);
          final lon = double.parse(result['lon']);

          _mapController.animateCamera(
            CameraUpdate.newLatLngZoom(LatLng(lat, lon), 14),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Location not found.')),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error contacting location service.')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Search failed: $e')),
      );
    } finally {
      setState(() => _isFetching = false);
    }
  }

  void _onMapCreated(GoogleMapController controller) {
    _mapController = controller;
    setState(() {
      markers.add(Marker(
        markerId: MarkerId('marker1'),
        position: LatLng(40.614281, 22.966344),
        infoWindow: InfoWindow(title: 'Toumba'),
      ));
      markers.add(Marker(
        markerId: MarkerId('marker2'),
        position: LatLng(40.6401, 22.9444),
        infoWindow: InfoWindow(title: 'Thessaloniki'),
      ));
    });
  }

  @override
  void initState() {
    super.initState();
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
          GestureDetector(
            behavior: HitTestBehavior.translucent,
            onTap: () {
              _draggableController.animateTo(
                0.15,
                duration: Duration(milliseconds: 300),
                curve: Curves.easeOut,
              );
              FocusScope.of(context).unfocus(); // Optional: close keyboard
              setState(() => _suggestions = []); // Optional: clear suggestions
            },
            child: Container(
              color: Colors.transparent,
              child: Stack(
                children: [
                  GoogleMap(
                    padding:
                        EdgeInsets.only(bottom: 70), // Move controls higher

                    initialCameraPosition: CameraPosition(
                      target: _initialPosition,
                      zoom: 12,
                    ),
                    onMapCreated: _onMapCreated,
                    markers: markers,
                    zoomControlsEnabled: true,
                    onTap: (_) {
                      _draggableController.animateTo(
                        0.10,
                        duration: Duration(milliseconds: 300),
                        curve: Curves.easeOut,
                      );
                      FocusScope.of(context).unfocus();
                      setState(() => _suggestions = []);
                    },
                    onCameraMoveStarted: () {
                      _draggableController.animateTo(
                        0.10,
                        duration: Duration(milliseconds: 300),
                        curve: Curves.easeOut,
                      );
                      FocusScope.of(context).unfocus();
                      setState(() => _suggestions = []);
                    },
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
                          suffixIcon: _isFetching
                              ? Padding(
                                  padding: const EdgeInsets.all(12.0),
                                  child: SizedBox(
                                    width: 16,
                                    height: 16,
                                    child: CircularProgressIndicator(
                                        strokeWidth: 2),
                                  ),
                                )
                              : IconButton(
                                  icon: Icon(Icons.send),
                                  onPressed: _searchAndNavigate,
                                ),
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(
                              horizontal: 15, vertical: 12),
                        ),
                      ),
                    ),
                  ),
                  if (_suggestions.isNotEmpty)
                    Positioned(
                      top: 60,
                      left: 15,
                      right: 15,
                      child: Material(
                        elevation: 4,
                        borderRadius: BorderRadius.circular(8),
                        child: SizedBox(
                          height: 300,
                          child: Scrollbar(
                            controller: _scrollController,
                            thumbVisibility: true,
                            child: ListView.builder(
                              controller: _scrollController,
                              itemCount: _suggestions.length,
                              itemBuilder: (context, index) {
                                final suggestion = _suggestions[index];
                                return ListTile(
                                  title: Text(suggestion['name']),
                                  onTap: () {
                                    _mapController.animateCamera(
                                      CameraUpdate.newLatLngZoom(
                                        LatLng(suggestion['lat'],
                                            suggestion['lon']),
                                        15,
                                      ),
                                    );
                                    FocusScope.of(context).unfocus();
                                    setState(() => _suggestions = []);
                                  },
                                );
                              },
                            ),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
          DraggableScrollableSheet(
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
                    borderRadius:
                        BorderRadius.vertical(top: Radius.circular(16)),
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
                            height:
                                30, // Make the whole top 30px area draggable
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
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _mapController.dispose();
    _searchController.dispose();
    _debounce?.cancel();
    _scrollController.dispose();

    super.dispose();
  }
}
