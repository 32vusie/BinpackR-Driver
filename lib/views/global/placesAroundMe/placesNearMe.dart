import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

class PlacesWidget extends StatefulWidget {
  const PlacesWidget({super.key});

  @override
  _PlacesWidgetState createState() => _PlacesWidgetState();
}

class _PlacesWidgetState extends State<PlacesWidget> {
  GoogleMapController? _mapController;
  Position? _currentPosition;
  final Set<Marker> _markers = {};
  final String _apiKey = 'AIzaSyCYEH7nCxKcnFBwk_CNbg_NYW8L7wjaHhY'; // Replace with your API key
  bool _isFullScreen = false;
  String _selectedCategory = 'point_of_interest';
  String _keyword = '';
  double _radius = 5000; // Default radius in meters
  bool _useMiles = false;
  final List<String> _categories = [
    'restaurant', 'cafe', 'hospital', 'atm', 'mosque', 'church', 'park',
    'school', 'shopping_mall', 'gym', 'pharmacy', 'museum', 'library',
    'bank', 'post_office', 'gas_station', 'car_wash', 'bus_station',
    'train_station', 'airport', 'hotel', 'movie_theater', 'zoo',
    'tourist_attraction', 'hospital', 'supermarket', 'bakery', 'bar',
    'night_club', 'parking', 'jewelry_store', 'clothing_store'
  ];

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  Future<void> _getCurrentLocation() async {
    try {
      Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
      setState(() {
        _currentPosition = position;
      });
      await _fetchNearbyPlaces(position);
    } catch (e) {
      print('Error getting location: $e');
    }
  }

  Future<void> _fetchNearbyPlaces(Position position) async {
    final url = Uri.parse(
      'https://maps.googleapis.com/maps/api/place/nearbysearch/json'
      '?location=${position.latitude},${position.longitude}'
      '&radius=$_radius'
      '&type=$_selectedCategory'
      '&keyword=$_keyword'
      '&key=$_apiKey',
    );

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data['status'] == 'OK') {
        setState(() {
          _markers.clear();
          for (var result in data['results']) {
            _markers.add(Marker(
              markerId: MarkerId(result['place_id']),
              position: LatLng(
                result['geometry']['location']['lat'],
                result['geometry']['location']['lng'],
              ),
              infoWindow: InfoWindow(
                title: result['name'],
                snippet: result['vicinity'],
                onTap: () {
                  _showPlaceDetails(result);
                },
              ),
            ));
          }
        });

        if (_mapController != null && _currentPosition != null) {
          _mapController?.animateCamera(
            CameraUpdate.newLatLngZoom(
              LatLng(_currentPosition!.latitude, _currentPosition!.longitude),
              15.0,
            ),
          );
        }
      } else {
        print('Error fetching places: ${data['status']}');
      }
    } else {
      print('Failed to load places: ${response.statusCode}');
    }
  }

  void _showPlaceDetails(Map<String, dynamic> place) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(place['name']),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (place['photos'] != null)
                Image.network(
                  'https://maps.googleapis.com/maps/api/place/photo?maxwidth=400&photoreference=${place['photos'][0]['photo_reference']}&key=$_apiKey',
                ),
              Text('Address: ${place['vicinity']}'),
              if (place['opening_hours'] != null)
                Text('Open Now: ${place['opening_hours']['open_now'] ? 'Yes' : 'No'}'),
              if (place['website'] != null)
                TextButton(
                  onPressed: () async {
                    final url = place['website'];
                    if (await canLaunch(url)) {
                      await launch(url);
                    } else {
                      throw 'Could not launch $url';
                    }
                  },
                  child: const Text('Visit Website'),
                ),
              Text('Rating: ${place['rating'] ?? 'N/A'}'),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    _mapController?.dispose();
    super.dispose();
  }

  void _toggleFullScreen() {
    setState(() {
      _isFullScreen = !_isFullScreen;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Nearby Places'),
        actions: [
          IconButton(
            icon: Icon(_isFullScreen ? Icons.arrow_back : Icons.fullscreen),
            onPressed: _toggleFullScreen,
          ),
        ],
      ),
      body: _currentPosition == null
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                if (!_isFullScreen)
                  Container(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        DropdownButton<String>(
                          value: _selectedCategory,
                          items: _categories.map((String category) {
                            return DropdownMenuItem<String>(
                              value: category,
                              child: Text(category),
                            );
                          }).toList(),
                          onChanged: (String? newValue) {
                            setState(() {
                              _selectedCategory = newValue!;
                              _getCurrentLocation(); // Refresh places with new category
                            });
                          },
                        ),
                        TextField(
                          decoration: const InputDecoration(
                            labelText: 'Keyword',
                            border: OutlineInputBorder(),
                          ),
                          onChanged: (value) {
                            setState(() {
                              _keyword = value;
                            });
                            _getCurrentLocation(); // Refresh places with new keyword
                          },
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Slider(
                                value: _radius,
                                min: 1000,
                                max: 10000,
                                divisions: 9,
                                label: 'Radius ${(_radius / 1000).toStringAsFixed(1)} km',
                                onChanged: (value) {
                                  setState(() {
                                    _radius = value;
                                  });
                                  _getCurrentLocation(); // Refresh places with new radius
                                },
                              ),
                            ),
                            Text('${(_radius / 1000).toStringAsFixed(1)} km'),
                          ],
                        ),
                        SwitchListTile(
                          title: const Text('Use Miles'),
                          value: _useMiles,
                          onChanged: (value) {
                            setState(() {
                              _useMiles = value;
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                Expanded(
                  child: GoogleMap(
                    onMapCreated: (controller) {
                      _mapController = controller;
                    },
                    initialCameraPosition: CameraPosition(
                      target: LatLng(_currentPosition!.latitude, _currentPosition!.longitude),
                      zoom: 15.0,
                    ),
                    markers: _markers,
                    myLocationEnabled: true,
                    onCameraMove: (position) {
                      // Optionally handle camera movement
                    },
                  ),
                ),
              ],
            ),
      floatingActionButton: _isFullScreen
          ? FloatingActionButton(
              onPressed: _toggleFullScreen,
              backgroundColor: Colors.red,
              child: const Icon(Icons.arrow_back),
            )
          : null,
    );
  }
}
