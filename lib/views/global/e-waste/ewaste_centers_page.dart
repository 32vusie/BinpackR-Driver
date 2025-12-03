// ewaste_centers_page.dart

import 'package:binpack_residents/utils/buttton.dart';
import 'package:binpack_residents/utils/theme.dart';
import 'package:binpack_residents/views/global/e-waste/widgets/ewaste_centers_data.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class EWasteCentersPage extends StatefulWidget {
  const EWasteCentersPage({super.key});

  @override
  _EWasteCentersPageState createState() => _EWasteCentersPageState();
}

class _EWasteCentersPageState extends State<EWasteCentersPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final LatLng _initialCameraPosition =
      const LatLng(-30.5595, 22.9375); // Center of South Africa
  Map<String, dynamic>? selectedCenter;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      endDrawer: _buildCenterDetailsDrawer(),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 250,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              background: _buildMap(),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: _buildCentersList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMap() {
    return GoogleMap(
      initialCameraPosition:
          CameraPosition(target: _initialCameraPosition, zoom: 5),
      markers: _createCenterMarkers(),
    );
  }

  Set<Marker> _createCenterMarkers() {
    return ewasteCenters.map((center) {
      LatLng coordinates = center["coordinates"] as LatLng;
      return Marker(
        markerId: MarkerId(center["name"] as String),
        position: coordinates,
        infoWindow: InfoWindow(
          title: center["name"] as String,
          snippet: center["address"] as String,
          onTap: () => _openCenterDetailsDrawer(center),
        ),
      );
    }).toSet();
  }

  Widget _buildCentersList() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'E-Waste Recycle and Collection Centers',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.normal),
        ),
        const SizedBox(height: 8),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: ewasteCenters.length,
          itemBuilder: (context, index) {
            final center = ewasteCenters[index];
            return Card(
              child: ListTile(
                title: Text(center["name"] ?? 'N/A'),
                subtitle: Text(center["address"] ?? 'N/A'),
                onTap: () => _openCenterDetailsDrawer(center),
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildCenterDetailsDrawer() {
    if (selectedCenter == null) {
      return const Drawer(child: Center(child: Text('No center selected')));
    }

    LatLng? coordinates = selectedCenter!["coordinates"] as LatLng?;
    String name = selectedCenter!["name"] ?? 'N/A';
    String address = selectedCenter!["address"] ?? 'N/A';
    String region = selectedCenter!["region"] ?? 'N/A';
    String city = selectedCenter!["city"] ?? 'N/A';
    List<String> wasteTypes =
        (selectedCenter!["wasteTypes"] as List<dynamic>).cast<String>();
    String contact = selectedCenter!["contact"] ?? 'Not Available';
    String website = selectedCenter!["website"] ?? 'N/A';

    return Drawer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          DrawerHeader(
            decoration: const BoxDecoration(color: primaryColor),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name,
                    style: const TextStyle(color: Colors.white, fontSize: 14)),
                const SizedBox(height: 2),
                Text('Address: $address',
                    style: const TextStyle(color: Colors.white, fontSize: 12)),
                Text('Region: $region',
                    style: const TextStyle(color: Colors.white, fontSize: 12)),
                Text('City: $city',
                    style: const TextStyle(color: Colors.white, fontSize: 12)),
                Text('Waste Types: ${wasteTypes.join(', ')}',
                    style: const TextStyle(color: Colors.white, fontSize: 12)),
              ],
            ),
          ),
          Expanded(
            child: coordinates != null
                ? Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: GoogleMap(
                      initialCameraPosition:
                          CameraPosition(target: coordinates, zoom: 14.0),
                      markers: {
                        Marker(
                          markerId: const MarkerId("selectedCenter"),
                          position: coordinates,
                        )
                      },
                    ),
                  )
                : const Center(child: Text('No coordinates available')),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                ElevatedButton.icon(
                  onPressed: _launchDirections,
                  icon: const Icon(Icons.directions),
                  label: const Text("Get Directions"),
                  style: elevatedButtonStyle, // Apply custom style
                ),
                const SizedBox(height: 10),
                if (contact != 'Not Available')
                  ElevatedButton.icon(
                    onPressed: _launchCall,
                    icon: const Icon(Icons.call),
                    label: const Text("Call"),
                    style: elevatedButtonStyle, // Apply custom style
                  ),
                const SizedBox(height: 10),
                ElevatedButton.icon(
                  onPressed: _launchWebsite,
                  icon: const Icon(Icons.web),
                  label: const Text("Visit Website"),
                  style: elevatedButtonStyle, // Apply custom style
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  void _openCenterDetailsDrawer(Map<String, dynamic> center) {
    setState(() {
      selectedCenter = center;
    });
    _scaffoldKey.currentState?.openEndDrawer();
  }

  Future<void> _launchDirections() async {
    if (selectedCenter == null || selectedCenter!["coordinates"] == null) {
      return;
    }
    LatLng coordinates = selectedCenter!["coordinates"] as LatLng;
    final url =
        'https://www.google.com/maps/dir/?api=1&destination=${coordinates.latitude},${coordinates.longitude}';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Could not launch Google Maps')));
    }
  }

  Future<void> _launchCall() async {
    if (selectedCenter == null || selectedCenter!["contact"] == null) return;
    final contact = selectedCenter!["contact"];
    final url = 'tel:$contact';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Could not launch phone app')));
    }
  }

  Future<void> _launchWebsite() async {
    if (selectedCenter == null || selectedCenter!["website"] == null) return;
    final website = selectedCenter!["website"];
    if (await canLaunch(website)) {
      await launch(website);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Could not launch website')));
    }
  }
}
