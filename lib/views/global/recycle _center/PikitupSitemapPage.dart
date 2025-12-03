import 'package:binpack_residents/utils/buttton.dart';
import 'package:binpack_residents/views/global/recycle%20_center/widgets/sitemap_data.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class PikitupSitemapPage extends StatefulWidget {
  const PikitupSitemapPage({super.key});

  @override
  _PikitupSitemapPageState createState() => _PikitupSitemapPageState();
}

class _PikitupSitemapPageState extends State<PikitupSitemapPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final LatLng _initialCameraPosition =
      const LatLng(-26.2041, 28.0473); // Johannesburg
  List<Map<String, dynamic>> filteredRegions = sitemap;
  String selectedRegion = 'All';
  Map<String, dynamic>? selectedLocation;
  String searchQuery = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      endDrawer: _buildLocationDetailsDrawer(),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 300,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              background: _buildMap(),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(6.0),
              child: Column(
                children: [
                  SizedBox(
                    height: 100,
                    child: _buildQuickActionCards(),
                  ),
                  const SizedBox(height: 24),
                  _buildSearchAndTable(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActionCards() {
    return ListView(
      scrollDirection: Axis.horizontal,
      children: [
        _buildStatCard(
          'All',
          Icons.all_inclusive,
          sitemap.fold<int>(
              0, (sum, region) => sum + (region["locations"] as List).length),
          onTap: () => _filterByRegion('All'),
        ),
        ...sitemap.map((region) {
          String regionName = region["region"] as String;
          int locationCount = (region["locations"] as List).length;
          return _buildStatCard(
            regionName,
            Icons.location_on,
            locationCount,
            onTap: () => _filterByRegion(regionName),
          );
        }),
      ],
    );
  }

  Widget _buildStatCard(String title, IconData icon, int count,
      {VoidCallback? onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        elevation: 2,
        child: Container(
          width: 100,
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 24),
              const SizedBox(height: 4),
              Text(title,
                  style: const TextStyle(fontSize: 12),
                  overflow: TextOverflow.ellipsis),
              const SizedBox(height: 4),
              Text(count.toString(),
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.bold)),
            ],
          ),
        ),
      ),
    );
  }

  void _filterByRegion(String region) {
    setState(() {
      selectedRegion = region;
      filteredRegions = region == 'All'
          ? sitemap
          : sitemap.where((r) => r['region'] == region).toList();
    });
  }

  Widget _buildSearchAndTable() {
    List<Map<String, dynamic>> locations = filteredRegions.expand((region) {
      List<Map<String, dynamic>> locs =
          (region['locations'] as List<dynamic>).cast<Map<String, dynamic>>();
      for (var loc in locs) {
        loc['region'] = region['region'];
      }
      return locs;
    }).toList();

    // Apply search filter
    if (searchQuery.isNotEmpty) {
      locations = locations.where((location) {
        return location['name']
                .toLowerCase()
                .contains(searchQuery.toLowerCase()) ||
            location['city']
                .toLowerCase()
                .contains(searchQuery.toLowerCase()) ||
            location['region']
                .toLowerCase()
                .contains(searchQuery.toLowerCase());
      }).toList();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.all(8.0),
          child: Text('Locations Table',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: TextField(
            decoration: InputDecoration(
              hintText: 'Search by name, city, or region...',
              prefixIcon: const Icon(Icons.search),
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(8.0)),
            ),
            onChanged: (value) {
              setState(() {
                searchQuery = value;
              });
            },
          ),
        ),
        const SizedBox(height: 8),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: DataTable(
            columns: const [
              DataColumn(label: Text('Region')),
              DataColumn(label: Text('Location')),
              DataColumn(label: Text('Ward')),
              DataColumn(label: Text('City')),
              DataColumn(label: Text('Garden Site')),
              DataColumn(label: Text('Material Type')),
              DataColumn(label: Text('Contact')),
            ],
            rows: locations.map((location) {
              return DataRow(cells: [
                DataCell(Text(location["region"] ?? 'N/A')),
                DataCell(
                  InkWell(
                    onTap: () => _openLocationDetailsDrawer(location),
                    child: Text(location["name"] ?? 'N/A',
                        overflow: TextOverflow.ellipsis),
                  ),
                ),
                DataCell(Text(location["ward"] ?? 'N/A')),
                DataCell(Text(location["city"] ?? 'N/A')),
                DataCell(Text(location["gardenSite"] ?? 'N/A')),
                DataCell(Text(location["materialType"] ?? 'N/A')),
                DataCell(Text(location["contact"] ?? 'Not Available')),
              ]);
            }).toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildMap() {
    return GoogleMap(
      initialCameraPosition:
          CameraPosition(target: _initialCameraPosition, zoom: 10),
      markers: _createLocationMarkers(),
    );
  }

  Set<Marker> _createLocationMarkers() {
    return filteredRegions.expand((region) {
      return (region["locations"] as List<Map<String, dynamic>>)
          .where((location) => location["coordinates"] != null)
          .map<Marker>((location) {
        return Marker(
          markerId: MarkerId(location["name"] as String),
          position: location["coordinates"] as LatLng,
          infoWindow: InfoWindow(
            title: location["name"] as String,
            snippet: "Material: ${location["materialType"] ?? 'N/A'}",
            onTap: () => _openLocationDetailsDrawer(location),
          ),
        );
      }).toList();
    }).toSet();
  }

  Widget _buildLocationDetailsDrawer() {
    if (selectedLocation == null) {
      return const Drawer(child: Center(child: Text('No location selected')));
    }

    LatLng? coordinates = selectedLocation!["coordinates"] as LatLng?;
    String name = selectedLocation!["name"] ?? 'N/A';
    String ward = selectedLocation!["ward"] ?? 'N/A';
    String city = selectedLocation!["city"] ?? 'N/A';
    String gardenSite = selectedLocation!["gardenSite"] ?? 'N/A';
    String materialType = selectedLocation!["materialType"] ?? 'N/A';
    String contact = selectedLocation!["contact"] ?? 'Not Available';

    return Drawer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          DrawerHeader(
            decoration: const BoxDecoration(color: Colors.green),
            margin: EdgeInsets.zero,
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name,
                    style: const TextStyle(color: Colors.white, fontSize: 16),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1),
                const SizedBox(height: 8),
                Text('Ward: $ward',
                    style: const TextStyle(color: Colors.white, fontSize: 12)),
                Text('City: $city',
                    style: const TextStyle(color: Colors.white, fontSize: 12)),
                Text('Garden Site: $gardenSite',
                    style: const TextStyle(color: Colors.white, fontSize: 12)),
                Text('Material Type: $materialType',
                    style: const TextStyle(color: Colors.white, fontSize: 12)),
                Text('Contact: $contact',
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
                            markerId: const MarkerId("selectedLocation"),
                            position: coordinates)
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
                  style: elevatedButtonStyle,
                ),
                const SizedBox(height: 10),
                if (contact != 'Not Available')
                  ElevatedButton.icon(
                    onPressed: _launchCall,
                    icon: const Icon(Icons.call),
                    label: const Text("Call"),
                    style: elevatedButtonStyle,
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _openLocationDetailsDrawer(Map<String, dynamic> location) {
    setState(() {
      selectedLocation = location;
    });
    _scaffoldKey.currentState?.openEndDrawer();
  }

  Future<void> _launchDirections() async {
    if (selectedLocation == null || selectedLocation!["coordinates"] == null) {
      return;
    }
    LatLng coordinates = selectedLocation!["coordinates"] as LatLng;
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
    if (selectedLocation == null || selectedLocation!["contact"] == null) {
      return;
    }
    final contact = selectedLocation!["contact"];
    final url = 'tel:$contact';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Could not launch phone app')));
    }
  }
}
