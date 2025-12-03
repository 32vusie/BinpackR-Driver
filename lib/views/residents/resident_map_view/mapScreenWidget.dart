import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapWidget extends StatefulWidget {
  final GeoPoint location; // Change from String to GeoPoint
  final String driverID;

  const MapWidget({super.key, required this.location, required this.driverID});

  @override
  _MapWidgetState createState() => _MapWidgetState();
}

class _MapWidgetState extends State<MapWidget> {
  GoogleMapController? mapController;
  LatLng? requestLocation;
  Set<Marker> markers = {};
  Set<Polyline> polylines = {};

  @override
  void initState() {
    super.initState();
    // Initialize requestLocation with the GeoPoint provided
    requestLocation = LatLng(widget.location.latitude, widget.location.longitude);
    _setMarkers();
  }

  void _setMarkers() {
    markers.clear();
    
    if (requestLocation != null) {
      markers.add(Marker(
        markerId: const MarkerId('request'),
        position: requestLocation!,
        infoWindow: const InfoWindow(title: 'Request Location'),
      ));
    }

    setState(() {}); // Rebuild the widget to update the markers
  }

  @override
  void dispose() {
    mapController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: requestLocation == null
          ? const Center(child: CircularProgressIndicator())
          : GoogleMap(
              onMapCreated: (controller) {
                mapController = controller;
                // Move the camera to the request location
                mapController?.animateCamera(
                  CameraUpdate.newLatLngZoom(requestLocation!, 15.0),
                );
              },
              initialCameraPosition: CameraPosition(
                target: requestLocation!,
                zoom: 15.0,
              ),
              markers: markers,
              myLocationEnabled: false, // Disable myLocation button
            ),
    );
  }
}
