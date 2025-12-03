import 'dart:convert';
import 'package:binpack_residents/utils/InputDecoration.dart';
import 'package:binpack_residents/utils/theme.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class LocationSearchField extends StatefulWidget {
  final Function(String, String, String, String, String) onLocationSelected;

  const LocationSearchField({super.key, required this.onLocationSelected});

  @override
  _LocationSearchFieldState createState() => _LocationSearchFieldState();
}

class _LocationSearchFieldState extends State<LocationSearchField> {
  final TextEditingController _locationController = TextEditingController();
  final String _apiKey = 'AIzaSyCYEH7nCxKcnFBwk_CNbg_NYW8L7wjaHhY';
  List<dynamic> _placeSuggestions = [];

  Future<void> _getPlaceSuggestions(String input) async {
    final String requestUrl =
        'https://maps.googleapis.com/maps/api/place/autocomplete/json?input=$input&key=$_apiKey&components=country:za';

    final response = await http.get(Uri.parse(requestUrl));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      setState(() {
        _placeSuggestions = data['predictions'];
      });
    } else {
      throw Exception('Failed to load predictions');
    }
  }

  Future<void> _getPlaceDetails(String placeId) async {
    final String requestUrl =
        'https://maps.googleapis.com/maps/api/place/details/json?place_id=$placeId&key=$_apiKey';

    final response = await http.get(Uri.parse(requestUrl));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final result = data['result'];
      final addressComponents = result['address_components'];

      final streetAddress = addressComponents.firstWhere(
        (component) => (component['types'] as List).contains('street_address'),
        orElse: () => {'long_name': ''},
      )['long_name'];

      final suburb = addressComponents.firstWhere(
        (component) =>
            (component['types'] as List).contains('sublocality_level_1'),
        orElse: () => {'long_name': ''},
      )['long_name'];

      final city = addressComponents.firstWhere(
        (component) => (component['types'] as List).contains('locality'),
        orElse: () => {'long_name': ''},
      )['long_name'];

      final province = addressComponents.firstWhere(
        (component) => (component['types'] as List)
            .contains('administrative_area_level_1'),
        orElse: () => {'long_name': ''},
      )['long_name'];

      final postalCode = addressComponents.firstWhere(
        (component) => (component['types'] as List).contains('postal_code'),
        orElse: () => {'long_name': ''},
      )['long_name'];

      widget.onLocationSelected(
        streetAddress,
        suburb,
        city,
        province,
        postalCode,
      );
    } else {
      throw Exception('Failed to load place details');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextFormField(
          controller: _locationController,
          decoration: inputDecorationStyle.copyWith(
            labelText: 'Location',
            prefixIcon: const Icon(Icons.location_on),
            filled: true,
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(
                color: primaryColor,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(
                color: primaryColor,
              ),
            ),
          ),
          onChanged: (value) {
            if (value.isNotEmpty) {
              _getPlaceSuggestions(value);
            } else {
              setState(() {
                _placeSuggestions = [];
              });
            }
          },
        ),
        if (_placeSuggestions.isNotEmpty)
          SizedBox(
            height: 200,
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: _placeSuggestions.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(_placeSuggestions[index]['description']),
                  onTap: () async {
                    final placeId = _placeSuggestions[index]['place_id'];
                    await _getPlaceDetails(placeId);
                    setState(() {
                      _locationController.text =
                          _placeSuggestions[index]['description'];
                      _placeSuggestions = [];
                    });
                  },
                );
              },
            ),
          ),
      ],
    );
  }
}
