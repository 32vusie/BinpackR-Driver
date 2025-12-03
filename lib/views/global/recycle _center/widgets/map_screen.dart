import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapScreen extends StatelessWidget {
  final LatLng coordinates;

  const MapScreen({super.key, required this.coordinates});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Location on Map"),
        backgroundColor: Colors.green[800],
      ),
      body: GoogleMap(
        initialCameraPosition: CameraPosition(
          target: coordinates,
          zoom: 14.0,
        ),
        markers: {
          Marker(
            markerId: const MarkerId("selectedLocation"),
            position: coordinates,
          ),
        },
      ),
    );
  }
}
