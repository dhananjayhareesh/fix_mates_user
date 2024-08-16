import 'package:flutter/material.dart';
import 'package:open_street_map_search_and_pick/open_street_map_search_and_pick.dart';

class MapScreen extends StatelessWidget {
  const MapScreen({super.key, required this.locationController});
  final TextEditingController locationController;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Select Your Location'),
      ),
      body: OpenStreetMapSearchAndPick(
        buttonWidth: 130,
        zoomInIcon: Icons.zoom_in_sharp,
        zoomOutIcon: Icons.zoom_out,
        locationPinIconColor: Colors.blueGrey,
        locationPinTextStyle: const TextStyle(
            color: Colors.blueGrey, fontSize: 14, fontWeight: FontWeight.bold),
        buttonColor: Colors.blue,
        buttonText: 'Pick Location',
        buttonTextStyle: const TextStyle(
            color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold),
        onPicked: (pickedData) {
          final data = {
            'lat': pickedData.latLong.latitude,
            'long': pickedData.latLong.longitude,
          };
          locationController.text = pickedData.address['state_district'] ?? '';
          Navigator.pop(context, data); // Return the location data
        },
      ),
    );
  }
}
