import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:trash_hunter/Pages/publish_page.dart';
import '../Constants/Buttons/primary_button.dart';

class AddressPage extends StatefulWidget {
  @override
  _AddressPageState createState() => _AddressPageState();
}

class _AddressPageState extends State<AddressPage> {
  GoogleMapController? _mapController;
  LatLng? _center;
  String _address = 'Loading...';
  TextEditingController _searchController = TextEditingController();
  FocusNode _searchFocus = FocusNode();
  LatLng? _lastGeocoded;

  @override
  void initState() {
    super.initState();
    _determinePosition();
  }

  Future<void> _determinePosition() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      setState(() {
        _address = "Location services are disabled.";
      });
      return;
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        setState(() {
          _address = "Location permission denied.";
        });
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      setState(() {
        _address = "Location permissions are permanently denied.";
      });
      return;
    }

    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
    setState(() {
      _center = LatLng(position.latitude, position.longitude);
    });
  }

  void _onCameraMove(CameraPosition position) {
    setState(() {
      _center = position.target;
    });
  }

  Future<void> _onCameraIdle() async {
    if (_center != null && _center != _lastGeocoded) {
      _lastGeocoded = _center;
      try {
        List<Placemark> placemarks = await placemarkFromCoordinates(
          _center!.latitude,
          _center!.longitude,
        );
        if (placemarks.isNotEmpty) {
          final place = placemarks.first;
          setState(() {
            _address =
                '${place.street}, ${place.locality}, ${place.postalCode}';
          });
        }
      } catch (e) {
        setState(() {
          _address = "Unable to fetch address.";
        });
      }
    }
  }

  Future<void> _searchAddress(String query) async {
    try {
      List<Location> locations = await locationFromAddress(query);
      if (locations.isNotEmpty) {
        final location = locations.first;
        final newLatLng = LatLng(location.latitude, location.longitude);

        _mapController?.animateCamera(
          CameraUpdate.newLatLngZoom(newLatLng, 17),
        );

        setState(() {
          _center = newLatLng;
          _address = "Searching...";
        });

        List<Placemark> placemarks = await placemarkFromCoordinates(
          location.latitude,
          location.longitude,
        );

        if (placemarks.isNotEmpty) {
          final place = placemarks.first;
          setState(() {
            _address =
                '${place.street}, ${place.locality}, ${place.postalCode}';
          });
        }
      } else {
        _showSnackBar("No location found for: $query");
      }
    } catch (e) {
      _showSnackBar("Search error: ${e.toString()}");
    }
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("New Post"),
      ),
      body: _center == null
          ? Center(child: CircularProgressIndicator())
          : Stack(
              children: [
                GoogleMap(
                  mapType: MapType.hybrid,
                  initialCameraPosition: CameraPosition(
                    target: _center!,
                    zoom: 17,
                  ),
                  onMapCreated: (controller) => _mapController = controller,
                  onCameraMove: _onCameraMove,
                  onCameraIdle: _onCameraIdle,
                  myLocationEnabled: true,
                  myLocationButtonEnabled: false,
                ),
                Center(
                  child:
                      Icon(Icons.location_on, size: 40, color: Colors.orange),
                ),
                Positioned(
                  top: 10,
                  left: 20,
                  right: 20,
                  child: Column(
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        decoration: BoxDecoration(
                          color: Colors.grey,
                          borderRadius: BorderRadius.circular(8),
                          boxShadow: [
                            BoxShadow(color: Colors.black26, blurRadius: 4),
                          ],
                        ),
                        child: TextField(
                          controller: _searchController,
                          focusNode: _searchFocus,
                          onSubmitted: (value) {
                            _searchFocus.unfocus();
                            _searchAddress(value);
                          },
                          decoration: InputDecoration(
                            hintText: "Search address",
                            border: InputBorder.none,
                            icon: Icon(Icons.search, color: Colors.white),
                            suffixIcon: IconButton(
                              icon: Icon(Icons.clear, color: Colors.white),
                              onPressed: () {
                                _searchController.clear();
                              },
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Container(
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.black87,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          _address,
                          style: TextStyle(color: Colors.white),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  ),
                ),
                Positioned(
                  bottom: 40,
                  left: 20,
                  right: 20,
                  child: PrimaryButton(
                    text: 'Continue',
                    height: 50,
                    width: 120,
                    onPressed: () async {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) {
                            return PublishPage(_address);
                          },
                        ),
                      );
                    },
                  ),
                )
              ],
            ),
    );
  }
}
