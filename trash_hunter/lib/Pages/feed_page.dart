import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
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
  final ScrollController _scrollController = ScrollController();
  final DraggableScrollableController _draggableController =
      DraggableScrollableController();

  void _onSearchChanged(String query) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();

    _debounce = Timer(const Duration(milliseconds: 500), () async {
      if (query.isEmpty) {
        setState(() => _suggestions = []);
        return;
      }

      setState(() => _isFetching = true);

      try {
        final results = await getSuggestions(query);
        setState(() {
          _suggestions = results;
          _isFetching = false;
        });
      } catch (e) {
        setState(() {
          _suggestions = [];
          _isFetching = false;
        });
      }
    });
  }

  final LatLng _initialPosition =
      const LatLng(40.6401, 22.9444); // Thessaloniki

  final TextEditingController _searchController = TextEditingController();
  Future<List<Map<String, dynamic>>> getSuggestions(String query) async {
    final url = Uri.parse(
        'https://nominatim.openstreetmap.org/search?q=$query&format=json&addressdetails=1');

    final response = await http.get(url, headers: {
      'User-Agent':
          'TrashHunterApp/1.0 (your_email@example.com)' // Nominatim requires this
    });

    if (response.statusCode == 200) {
      final List data = json.decode(response.body);
      return data
          .map((e) => {
                'name': e['display_name'],
                'lat': double.parse(e['lat']),
                'lon': double.parse(e['lon']),
              })
          .toList();
    } else {
      throw Exception("Failed to fetch suggestions");
    }
  }

  Future<void> _searchAndNavigate() async {
    final query = _searchController.text;
    if (query.isEmpty) return;

    try {
      final suggestions = await getSuggestions(query);

      if (suggestions.isNotEmpty) {
        final first = suggestions.first;
        _mapController.animateCamera(CameraUpdate.newLatLngZoom(
          LatLng(first['lat'], first['lon']),
          15,
        ));
        FocusScope.of(context).unfocus();
        setState(() => _suggestions = []);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("No results found for: $query"),
        ));
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Error: $e"),
      ));
    }
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
                    initialCameraPosition: CameraPosition(
                      target: _initialPosition,
                      zoom: 12,
                    ),
                    onMapCreated: (GoogleMapController controller) {
                      _mapController = controller;
                    },
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
                        onChanged: _onSearchChanged,
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
                        top: 10,
                        left: 0,
                        right: 0,
                        child: GestureDetector(
                          onTap: () {
                            final size = _draggableController.size;
                            final targetSize = size < 0.5 ? 0.85 : 0.15;
                            _draggableController.animateTo(
                              targetSize,
                              duration: Duration(milliseconds: 300),
                              curve: Curves.easeInOut,
                            );
                          },
                          child: Center(
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
