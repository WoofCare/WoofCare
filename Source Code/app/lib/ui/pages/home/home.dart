import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:custom_floating_action_button_location/custom_floating_action_button_location.dart';
import 'package:woofcare/ui/pages/export.dart';


class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final locationController = Location();
  LatLng? currentPosition;

  void _reportDogButtonPressed() {
    showModalBottomSheet(
      isScrollControlled: true,
      useSafeArea: true,
      context: context, 

      builder: (ctx) => const ReportingPage()
    );
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance
        .addPostFrameCallback((_) async => await fetchLocationUpdates());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        elevation: 0,
        actions: [
          IconButton(
            onPressed: () => Navigator.pushNamed(context, "/profile"),
            icon: Image.asset(
              "assets/images/homePageButtons/ProfileButton.png",
              width: 40,
              height: 40,
            )
          )
        ],
      ),
      body: SafeArea(
        child: currentPosition == null
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
                        BitmapDescriptor.hueAzure),
                    position: currentPosition!,
                  ),
                },
              ),
      ),
      
      // Floating action button to report a dog
      // TODO: Currently the CustomFloatingActionButtonLocation causes the button to flicker
      floatingActionButtonLocation: CustomFloatingActionButtonLocation(xOffset: 10, yOffset: 775),
      floatingActionButton: SizedBox (
        height: 80,
        width: 80,
        child: FittedBox (
          child: FloatingActionButton(
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
      )
    );
  }

  Future<void> fetchLocationUpdates() async {
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
          currentLocation.longitude != null) {
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
