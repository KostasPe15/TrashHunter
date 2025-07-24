import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapWidget extends StatefulWidget {
  const MapWidget({super.key});

  @override
  State<MapWidget> createState() => _MapWidgetState();
}

class _MapWidgetState extends State<MapWidget> {
  late GoogleMapController _mapController;
  Set<Marker> markers = {};
  final DraggableScrollableController _draggableController =
      DraggableScrollableController();

  final LatLng _initialPosition =
      const LatLng(40.6401, 22.9444); // Thessaloniki

  void _onMapCreated(GoogleMapController controller) {
    _mapController = controller;
    setState(() {
      markers.add(Marker(
        markerId: MarkerId('marker1'),
        position: LatLng(40.635658899999996, 22.9389212),
        infoWindow: InfoWindow(title: 'Goum'),
      ));
      markers.add(Marker(
        markerId: MarkerId('marker2'),
        position: LatLng(40.6401, 22.9444),
        infoWindow: InfoWindow(title: 'Thessaloniki'),
      ));
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        _draggableController.animateTo(
          0.15,
          duration: Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
        FocusScope.of(context).unfocus(); // Optional: close keyboard
      },
      child: Container(
        color: Colors.transparent,
        child: Stack(
          children: [
            GoogleMap(
              mapType: MapType.hybrid,
              initialCameraPosition: CameraPosition(
                target: _initialPosition,
                zoom: 12,
              ),
              onMapCreated: _onMapCreated,
              markers: markers,
              zoomControlsEnabled: false,
              onTap: (_) {
                _draggableController.animateTo(
                  0.10,
                  duration: Duration(milliseconds: 300),
                  curve: Curves.easeOut,
                );
                FocusScope.of(context).unfocus();
              },
              onCameraMoveStarted: () {
                _draggableController.animateTo(
                  0.10,
                  duration: Duration(milliseconds: 300),
                  curve: Curves.easeOut,
                );
                FocusScope.of(context).unfocus();
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _mapController.dispose();
    _draggableController.dispose();
    super.dispose();
  }
}
