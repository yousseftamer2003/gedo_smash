import 'package:flutter/material.dart';
import 'package:food2go_app/constants/colors.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geocoding/geocoding.dart'; // Import the geocoding package

class FullScreenMapScreen extends StatefulWidget {
  const FullScreenMapScreen({super.key, required this.initialPosition, required this.prevmapController,  this.selectedAddress});
  final CameraPosition initialPosition;
  final GoogleMapController prevmapController;
  final String? selectedAddress;
  

  @override
  State<FullScreenMapScreen> createState() => _FullScreenMapScreenState();
}

class _FullScreenMapScreenState extends State<FullScreenMapScreen> {
  final Set<Marker> _markers = {};
  LatLng? _selectedPosition; // Store the selected position
  GoogleMapController? mapController;

  // Reverse geocode the position to a readable address
  Future<String> _getFormattedAddress(LatLng position) async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(position.latitude, position.longitude);
      
      Placemark place = placemarks[0];
      return '${place.street}, ${place.locality}, ${place.country}';
    } catch (e) {
      // Handle any errors
      return 'Address not available';
    }
  }

  void _onMapTap(LatLng position) {
    setState(() {
      _selectedPosition = position;
      _markers.clear(); // Clear any existing markers
      _markers.add(Marker(
        markerId: MarkerId(position.toString()),
        position: position,
        infoWindow: const InfoWindow(title: ''),
      ));
    });
  }

  void _returnSelectedAddress() async {
    if (_selectedPosition != null) {
      // Get the formatted address using reverse geocoding
      String selectedAddress = await _getFormattedAddress(_selectedPosition!);
      
      // Pop the screen and return the selected address to the previous screen
      // ignore: use_build_context_synchronously
      Navigator.pop(context, selectedAddress);
    } else {
      // Show a message if no location was selected
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a location on the map.')),
      );
    }
  }

  @override
  void initState() {
    mapController = widget.prevmapController;
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Full-Screen Map'),
      ),
      body: Column(
        children: [
          Expanded(
            child: GoogleMap(
              onMapCreated: (controller) {
                mapController = controller;
              },
              initialCameraPosition: widget.initialPosition,
              myLocationEnabled: true,
              myLocationButtonEnabled: false,
              markers: _markers,
              onTap: _onMapTap,
              zoomGesturesEnabled: true,
              scrollGesturesEnabled: true,
              tiltGesturesEnabled: true,
              rotateGesturesEnabled: true,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: _returnSelectedAddress,
              style: ElevatedButton.styleFrom(
                backgroundColor: maincolor,
                foregroundColor: Colors.white,
              ),
              child: const Text('Select Address'),
            ),
          ),
        ],
      ),
    );
  }
}
