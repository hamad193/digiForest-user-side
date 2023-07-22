// ignore_for_file: library_private_types_in_public_api, depend_on_referenced_packages

import 'dart:convert';

import 'package:digi_forest/Constants/constants.dart';
import 'package:digi_forest/Custom%20Widgets/custom_elevated_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;


class LocationPickerPage extends StatefulWidget {
  const LocationPickerPage({super.key});

  @override
  _LocationPickerPageState createState() => _LocationPickerPageState();
}

class _LocationPickerPageState extends State<LocationPickerPage> {
  GoogleMapController? mapController;
  LatLng? markerLatLng;
  TextEditingController searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(
        title: const Text('Select Location'),
        centerTitle: true,
        backgroundColor: myGreenColor,
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.grey,
                    width: 1.0,
                  ),
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: TypeAheadField<String>(
                  textFieldConfiguration: TextFieldConfiguration(
                    style: authTextStyle,
                    controller: searchController,
                    decoration: const InputDecoration(
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.all(6.0),
                        labelText: 'Search City',
                        labelStyle: authTextStyle),
                  ),
                  suggestionsCallback: (pattern) async {
                    return await fetchCities(pattern);
                  },
                  itemBuilder: (context, suggestion) {
                    return ListTile(
                      title: Text(
                        suggestion,
                        style: authTextStyle,
                      ),
                    );
                  },
                  onSuggestionSelected: (suggestion) async {
                    List<Location> locations =
                    await locationFromAddress(suggestion);
                    if (locations.isNotEmpty) {
                      final latLng = LatLng(
                        locations.first.latitude,
                        locations.first.longitude,
                      );
                      setState(() {
                        markerLatLng = latLng;
                        moveCameraToLocation(latLng);
                      });
                    }
                  },
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.6,
                child: GoogleMap(
                  initialCameraPosition: const CameraPosition(
                    target: LatLng(34.9526, 72.3311),
                    zoom: 12.0,
                  ),
                  onMapCreated: (GoogleMapController controller) {
                    mapController = controller;
                  },
                  onTap: (LatLng latLng) {
                    setState(() {
                      markerLatLng = latLng;
                      moveCameraToLocation(latLng);
                    });
                  },
                  markers: markerLatLng != null
                      ? {
                    Marker(
                      markerId: const MarkerId('selectedLocationMarker'),
                      position: markerLatLng!,
                    ),
                  }
                      : {},
                ),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Expanded(
                    child: CElevatedButton(
                      bText: 'Select',
                      loading: false,
                      onPressed: () {
                        Navigator.of(context).pop(markerLatLng);
                      },
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: CElevatedButton(
                      bText: 'cancel',
                      loading: false,
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void moveCameraToLocation(LatLng latLng) {
    mapController?.animateCamera(
      CameraUpdate.newLatLngZoom(latLng, 12.0),
    );
  }

// Rest of the code...
}

Future<List<String>> fetchCities(String query) async {
  const apiKey =
      'AIzaSyC2rmv_2WJ3EPGXu58tm4O1thTDEn0YVak'; // Replace with your actual API key
  final url =
      'https://maps.googleapis.com/maps/api/place/autocomplete/json?input=$query&types=(cities)&components=country:pk&key=$apiKey';

  final response = await http.get(Uri.parse(url));
  if (response.statusCode == 200) {
    final data = json.decode(response.body);
    final predictions = data['predictions'] as List<dynamic>;
    final cityNames = predictions
        .map((prediction) => prediction['description'] as String)
        .toList();
    return cityNames;
  } else {
    throw Exception('Failed to fetch city suggestions');
  }
}


const TextStyle authTextStyle = TextStyle(
  fontSize: 16.0,
  fontWeight: FontWeight.normal,
  color: Colors.black54,
);