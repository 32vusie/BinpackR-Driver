import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class BinPage extends StatefulWidget {
  const BinPage({super.key});

  @override
  _BinPageState createState() => _BinPageState();
}

class _BinPageState extends State<BinPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  // Sample data for the DataTable
  final List<Map<String, String>> binData = [
    {
      'id': '1',
      'location': 'Location A',
      'status': 'Active',
      'capacity': '100L',
      'fullness': '75%',
      'recycleType': 'Plastic',
    },
    {
      'id': '2',
      'location': 'Location B',
      'status': 'Active',
      'capacity': '120L',
      'fullness': '50%',
      'recycleType': 'Glass',
    },
    {
      'id': '3',
      'location': 'Location C',
      'status': 'Offline',
      'capacity': '80L',
      'fullness': '0%',
      'recycleType': 'None',
    },
    // Add more sample data as needed
  ];

  // Variables to hold selected bin details
  String selectedBinId = 'N/A';
  String selectedBinLocation = 'N/A';
  String selectedBinStatus = 'N/A';
  String selectedBinCapacity = 'N/A';
  String selectedBinFullness = 'N/A';
  String selectedBinRecycleType = 'N/A';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: const Text('Bins Overview',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
        // actions: [
        //   IconButton(
        //     icon: const Icon(Icons.menu),
        //     onPressed: () {
        //       _scaffoldKey.currentState?.openEndDrawer();
        //     },
        //   ),
        // ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ResponsiveLayout(
          desktop: Row(
            children: [
              Expanded(
                flex: 2,
                child: SizedBox(
                  height: double.infinity, // Fill available height
                  child: _buildStatsAndTable(),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                flex: 3,
                child: SizedBox(
                  height: double.infinity, // Fill available height
                  child: _buildMap(),
                ),
              ),
            ],
          ),
          mobile: Column(
            children: [
              Expanded(
                child: _buildMap(),
              ),
              const SizedBox(height: 16),
              SizedBox(
                height: 300, // Fixed height for stats and table
                child: _buildStatsAndTable(),
              ),
            ],
          ),
        ),
      ),
      // Drawer for displaying bin details
      endDrawer: _buildBinDetailsDrawer(),
    );
  }

  Widget _buildStatsAndTable() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Scrollable Container for Stats Cards
        SizedBox(
          height: 150, // Fixed height for scrollable stats cards
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _buildStatCard('All Bins', Icons.assignment, '120'),
                const SizedBox(width: 16),
                _buildStatCard('Active Bins', Icons.check_circle, '100'),
                const SizedBox(width: 16),
                _buildStatCard('Offline Bins', Icons.visibility_off, '15'),
                const SizedBox(width: 16),
                _buildStatCard('Out of Service', Icons.error, '5'),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        const Text(
          'Bins Table',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Expanded(
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                columns: const [
                  DataColumn(label: Text('ID')),
                  DataColumn(label: Text('Location')),
                  DataColumn(label: Text('Status')),
                  DataColumn(label: Text('Capacity')),
                  DataColumn(label: Text('Fullness')),
                  DataColumn(label: Text('Recycle Type')),
                ],
                rows: binData.map((bin) {
                  return DataRow(cells: [
                    DataCell(Text(bin['id']!)),
                    DataCell(
                      InkWell(
                        onTap: () {
                          // Open the drawer and pass the bin details
                          _openBinDetailsDrawer(bin);
                        },
                        child: Text(bin['location']!),
                      ),
                    ),
                    DataCell(Text(bin['status']!)),
                    DataCell(Text(bin['capacity']!)),
                    DataCell(Text(bin['fullness']!)),
                    DataCell(Text(bin['recycleType']!)),
                  ]);
                }).toList(),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildStatCard(String title, IconData icon, String value) {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 40),
            const SizedBox(height: 8),
            Text(title, style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 4),
            Text(value, style: const TextStyle(fontSize: 24)),
          ],
        ),
      ),
    );
  }

  Widget _buildMap() {
    return SizedBox(
      height: double.infinity,
      child: GoogleMap(
        onMapCreated: (GoogleMapController controller) {
          // Initialize your map here
        },
        initialCameraPosition: const CameraPosition(
          target: LatLng(0.0, 0.0),
          zoom: 2,
        ),
      ),
    );
  }

  Widget _buildBinDetailsDrawer() {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          const DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.blue,
            ),
            child: Text(
              'Bin Details',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
              ),
            ),
          ),
          ListTile(
            title: Text('ID: $selectedBinId'),
          ),
          ListTile(
            title: Text('Location: $selectedBinLocation'),
          ),
          ListTile(
            title: Text('Status: $selectedBinStatus'),
          ),
          ListTile(
            title: Text('Capacity: $selectedBinCapacity'),
          ),
          ListTile(
            title: Text('Fullness: $selectedBinFullness'),
          ),
          ListTile(
            title: Text('Recycle Type: $selectedBinRecycleType'),
          ),
        ],
      ),
    );
  }

  void _openBinDetailsDrawer(Map<String, String> bin) {
    // Set the details of the selected bin in your state
    selectedBinId = bin['id']!;
    selectedBinLocation = bin['location']!;
    selectedBinStatus = bin['status']!;
    selectedBinCapacity = bin['capacity']!;
    selectedBinFullness = bin['fullness']!;
    selectedBinRecycleType = bin['recycleType']!;

    // Update the UI by calling setState
    setState(() {});

    // Open the drawer
    _scaffoldKey.currentState?.openEndDrawer();
  }
}

class ResponsiveLayout extends StatelessWidget {
  final Widget desktop;
  final Widget mobile;

  const ResponsiveLayout({super.key, required this.desktop, required this.mobile});

  @override
  Widget build(BuildContext context) {
    // Use MediaQuery to determine if the device is mobile or desktop
    if (MediaQuery.of(context).size.width < 600) {
      return mobile; // Mobile layout
    }
    return desktop; // Desktop layout
  }
}
