import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:woofcare/config/colors.dart';
import 'package:woofcare/config/constants.dart';

import '/ui/pages/export.dart';

class MapPage extends StatefulWidget {
  const MapPage({super.key});

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  final locationController = Location();
  LatLng? currentPosition;

  List<Map<String, dynamic>> markers = [];
  BitmapDescriptor vetMarker = BitmapDescriptor.defaultMarker;
  BitmapDescriptor vetSelectMarker = BitmapDescriptor.defaultMarker;
  BitmapDescriptor ngoMarker = BitmapDescriptor.defaultMarker;
  BitmapDescriptor ngoSelectMarker = BitmapDescriptor.defaultMarker;
  BitmapDescriptor shelterMarker = BitmapDescriptor.defaultMarker;
  BitmapDescriptor shelterSelectMarker = BitmapDescriptor.defaultMarker;
  BitmapDescriptor dogMarker = BitmapDescriptor.defaultMarker;
  BitmapDescriptor dogSelectMarker = BitmapDescriptor.defaultMarker;
  BitmapDescriptor adoptMarker = BitmapDescriptor.defaultMarker;
  BitmapDescriptor adoptSelectMarker = BitmapDescriptor.defaultMarker;

  @override
  void initState() {
    super.initState();

    _updateMarkerIcons();
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      _fetchLocation(context);
      _fetchMarkers();
    });

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
                      for (var i = 0; i < markers.length; i++)
                        Marker(
                          markerId: MarkerId(markers[i]["id"]),
                          icon: markers[i]["icon"],
                          position: LatLng(
                            markers[i]["latitude"],
                            markers[i]["longitude"],
                          ),
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
      if (permissionGranted != PermissionStatus.granted) { // What if the permission status is grantedLimited?
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

  void _reportDogButtonPressed() {
    // Show the bottom sheet when the button is pressed
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return DraggableScrollableSheet(
          // Make the bottom sheet draggable
          initialChildSize: 0.75,
          minChildSize: 0.3,
          maxChildSize: 0.95,
          builder: (sheetContext, scrollController) {
            return Container(
              // Container to store the drag handle and the ReportingPage
              decoration: const BoxDecoration(
                color: WoofCareColors.secondaryBackground,
                borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
                border: Border(
                  top: BorderSide(color: WoofCareColors.borderOutline, width: 2.0),
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
                      color: WoofCareColors.primaryTextAndIcons,
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),

                  const Text(
                    'Dog Report',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w200,
                      color: WoofCareColors.primaryTextAndIcons,
                      decoration: TextDecoration.underline,
                    ),
                  ),

                  const SizedBox(height: 12),

                  Divider(color: Colors.black, height: 2.0),

                  // The ReportingPage (uses Expanded to take up the rest of the space)
                  Expanded(
                    child: SafeArea(
                      top: false,
                      left: false,
                      right: false,
                      child: SingleChildScrollView(
                        controller: scrollController,
                        padding: const EdgeInsets.only(
                          left: 20,
                          right: 20,
                          top: 20,
                          bottom: 30,
                        ),
                        child: ReportPage(scrollController: scrollController),
                      ),
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

  void _updateMarkerIcons() async {
    vetMarker = await BitmapDescriptor.asset(
      const ImageConfiguration(),
      'assets/images/map/vet.png',
    );
    vetSelectMarker = await BitmapDescriptor.asset(
      const ImageConfiguration(),
      'assets/images/map/vetSelect.png',
    );

    ngoMarker = await BitmapDescriptor.asset(
      const ImageConfiguration(),
      'assets/images/map/ngo.png',
    );
    ngoSelectMarker = await BitmapDescriptor.asset(
      const ImageConfiguration(),
      'assets/images/map/ngoSelect.png',
    );

    shelterMarker = await BitmapDescriptor.asset(
      const ImageConfiguration(),
      'assets/images/map/shelter.png',
    );
    shelterSelectMarker = await BitmapDescriptor.asset(
      const ImageConfiguration(),
      'assets/images/map/shelterSelect.png',
    );

    dogMarker = await BitmapDescriptor.asset(
      const ImageConfiguration(),
      'assets/images/map/dog.png',
    );
    dogSelectMarker = await BitmapDescriptor.asset(
      const ImageConfiguration(),
      'assets/images/map/dogSelect.png',
    );

    adoptMarker = await BitmapDescriptor.asset(
      const ImageConfiguration(),
      'assets/images/map/adopt.png',
    );
    adoptSelectMarker = await BitmapDescriptor.asset(
      const ImageConfiguration(),
      'assets/images/map/adoptSelect.png',
    );
  }

  void _fetchMarkers() async {
    for (QueryDocumentSnapshot doc
        in (await FIRESTORE.collection("locations").get()).docs) {
      final data = doc.data() as Map<String, dynamic>?;

      if (data != null &&
          data['latitude'] != null &&
          data['longitude'] != null) {
        Map<String, dynamic> marker = {
          'id': doc.id,
          'latitude': data['latitude'],
          'longitude': data['longitude'],
          'name': data['name'] ?? 'Unknown',
          'description': data['description'] ?? 'NA',
          'phone': data['phone'],
          'website': data['website'],
        };

        switch (data['type']) {
          case 'vet':
            marker['icon'] = vetMarker;
            break;
          case 'ngo':
            marker['icon'] = ngoMarker;
            break;
          case 'shelter':
            marker['icon'] = shelterMarker;
            break;
          case 'dog':
            marker['icon'] = dogMarker;
            break;
          case 'adopt':
            marker['icon'] = adoptMarker;
            break;
          default:
            marker['icon'] = dogMarker;
        }

        markers.add(marker);
      }
    }
  }

  Future<void> _fetchLocation(BuildContext context) async {
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
