import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

import '/ui/pages/export.dart';

class MapPage extends StatefulWidget {
  const MapPage({super.key});

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  final locationController = Location();
  LatLng? currentPosition;

  void _reportDogButtonPressed() {
    // Show the bottom sheet when the button is pressed
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return DraggableScrollableSheet(
          // Make the bottom sheet draggable
          initialChildSize: 0.77,
          minChildSize: 0.3,
          maxChildSize: 0.9,
          builder: (sheetContext, scrollController) {
            return Container(
              // Container to store the drag handle and the ReportingPage
              decoration: const BoxDecoration(
                color: Color(0xFFF7FFF7),
                borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
                border: Border(
                  top: BorderSide(color: Color(0xFFA66E38), width: 2.0),
                ),
              ),

              // Children of the container => drag handle and the ReportingPage
              child: Column(
                children: [
                  // Drag handle (necessary since modal bottom sheet's handle doesn't align with the current setup)
                  Container(
                    margin: const EdgeInsets.only(top: 20, bottom: 16),
                    width: 40,
                    height: 5,
                    decoration: BoxDecoration(
                      color: const Color(0xFF3F2917),
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),

                  const Text(
                    'Dog Report',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w200,
                      color: Color(0xFF3F2917),
                      decoration: TextDecoration.underline,
                      decorationColor: Color(0xFF3F2917),
                    ),
                  ),

                  const SizedBox(height: 8),

                  // The ReportingPage (uses Expanded to take up the rest of the space)
                  Expanded(
                    child: SingleChildScrollView(
                      controller: scrollController,
                      child: ReportPage(scrollController: scrollController),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback(
      (_) async => await fetchLocationUpdates(context),
    );

    return SafeArea(
      child: Scaffold(
        body: SafeArea(
          child:
              currentPosition == null
                  ? const Center(child: CircularProgressIndicator())
                  : GoogleMap(
                    myLocationButtonEnabled: true,
                    myLocationEnabled: true,
                    mapType: MapType.normal,
                    initialCameraPosition: CameraPosition(
                      target: currentPosition!,
                      zoom: 13,
                    ),
                    markers: {
                      Marker(
                        markerId: const MarkerId('currentLocation'),
                        icon: BitmapDescriptor.defaultMarkerWithHue(
                          BitmapDescriptor.hueAzure,
                        ),
                        position: currentPosition!,
                      ),
                    },
                  ),
        ),

        // Floating action button to report a dog
        floatingActionButtonLocation: FloatingActionButtonLocation.startTop,
        floatingActionButton: Padding(
          padding: const EdgeInsets.only(top: 8),
          child: FloatingActionButton.large(
            onPressed: () {
              _reportDogButtonPressed();
            },
            backgroundColor: Colors.transparent,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(90),
            ),
            focusElevation: 0,
            highlightElevation: 0,
            child: Image.asset(
              'assets/images/homePageButtons/ReportBtn.png',
              fit: BoxFit.cover,
            ),
          ),
        ),
      ),
    );
  }

  Future<void> fetchLocationUpdates(BuildContext context) async {
    bool serviceEnabled;
    PermissionStatus permissionGranted;

    serviceEnabled = await locationController.serviceEnabled();
    if (serviceEnabled) {
      serviceEnabled = await locationController.requestService();
    } else {
      return;
    }

    permissionGranted = await locationController.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await locationController.requestPermission();
      if (permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    locationController.onLocationChanged.listen((currentLocation) {
      if (currentLocation.latitude != null &&
          currentLocation.longitude != null &&
          context.mounted) {
        setState(() {
          currentPosition = LatLng(
            currentLocation.latitude!,
            currentLocation.longitude!,
          );
        });
      }
    });
  }
}
