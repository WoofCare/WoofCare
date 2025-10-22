import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:url_launcher/url_launcher.dart';
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
  bool markerSelected = false;

  BitmapDescriptor currentMarker = BitmapDescriptor.defaultMarker;

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

  Future<void> _showMarkerBottomSheet(Map<String, dynamic> markerData) async {
    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return DraggableScrollableSheet(
          initialChildSize: 0.28,
          minChildSize: 0.15,
          maxChildSize: 0.75,
          builder: (sheetContext, scrollController) {
            return Container(
              decoration: const BoxDecoration(
                color: WoofCareColors.secondaryBackground,
                borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
                border: Border(
                  top: BorderSide(
                    color: WoofCareColors.borderOutline,
                    width: 2.0,
                  ),
                ),
              ),
              child: SingleChildScrollView(
                controller: scrollController,
                child: Padding(
                  padding: const EdgeInsets.only(
                    left: 20,
                    right: 20,
                    top: 12,
                    bottom: 24,
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Drag handle
                      Center(
                        child: Container(
                          margin: const EdgeInsets.only(top: 8, bottom: 12),
                          width: 40,
                          height: 5,
                          decoration: BoxDecoration(
                            color: WoofCareColors.primaryTextAndIcons,
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),

                      // Title row with image, name and rating/state
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Placeholder image (replace with network/image if available)
                          Container(
                            width: 90,
                            height: 90,
                            decoration: BoxDecoration(
                              color: Colors.grey[300],
                              borderRadius: BorderRadius.circular(12),
                              image: const DecorationImage(
                                image: AssetImage(
                                  'assets/images/placeholders/placeholder.jpeg',
                                ),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),

                          const SizedBox(width: 12),

                          // Name and metadata
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  ((markerData['name'] ?? "Unknown") as String)
                                      .capitalize!,
                                  style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w600,
                                    color: WoofCareColors.primaryTextAndIcons,
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Row(
                                  children: const [
                                    Icon(
                                      Icons.star,
                                      size: 16,
                                      color: Colors.amber,
                                    ),
                                    SizedBox(width: 6),
                                    Text('4.3', style: TextStyle(fontSize: 14)),
                                    SizedBox(width: 8),
                                    Text(
                                      '(59)',
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.grey,
                                      ),
                                    ),
                                    SizedBox(width: 8),
                                    Text(
                                      '• 2 min',
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 12),

                      // Action buttons row
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: ElevatedButton.icon(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFFA66E38),
                                foregroundColor: const Color(0xFFCAB096),
                                textStyle: const TextStyle(fontSize: 10),
                                padding: const EdgeInsets.symmetric(
                                  vertical: 12,
                                  horizontal: 4,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              onPressed: () async {
                                Navigator.of(context).pop();

                                final maps = Uri.parse(
                                  "https://www.google.com/maps?q=${markerData['latitude']},${markerData['longitude']}",
                                );

                                if (await canLaunchUrl(maps)) {
                                  await launchUrl(
                                    maps,
                                    mode: LaunchMode.externalApplication,
                                  );
                                }
                              },
                              icon: const Icon(Icons.directions),
                              label: const Text('Directions'),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: ElevatedButton.icon(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFFA66E38),
                                foregroundColor: const Color(0xFFCAB096),
                                textStyle: const TextStyle(fontSize: 12),
                                padding: const EdgeInsets.symmetric(
                                  vertical: 12,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              onPressed: () async {
                                final phone = markerData['phone'];

                                if (phone != null &&
                                    phone.toString().isNotEmpty) {
                                  final uri = Uri(
                                    scheme: 'tel',
                                    path: phone.toString(),
                                  );

                                  try {
                                    if (await canLaunchUrl(uri)) {
                                      await launchUrl(uri);
                                    }
                                  } catch (e) {
                                    // ignore for now
                                  }
                                }
                              },
                              icon: const Icon(Icons.call),
                              label: const Text('Call'),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: ElevatedButton.icon(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFFA66E38),
                                foregroundColor: const Color(0xFFCAB096),
                                textStyle: const TextStyle(fontSize: 12),
                                padding: const EdgeInsets.symmetric(
                                  vertical: 12,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              onPressed: () async {
                                final website = markerData['website'];
                                if (website != null &&
                                    website.toString().isNotEmpty) {
                                  var uri = Uri.parse(website.toString());

                                  if (!uri.hasScheme) {
                                    uri = Uri.parse(
                                      'https://${website.toString()}',
                                    );
                                  }
                                  try {
                                    if (await canLaunchUrl(uri)) {
                                      await launchUrl(
                                        uri,
                                        mode: LaunchMode.externalApplication,
                                      );
                                    }
                                  } catch (e) {
                                    // ignore
                                  }
                                }
                              },
                              icon: const Icon(Icons.public),
                              label: const Text('Website'),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: ElevatedButton.icon(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFFA66E38),
                                foregroundColor: const Color(0xFFCAB096),
                                textStyle: const TextStyle(fontSize: 12),
                                padding: const EdgeInsets.symmetric(
                                  vertical: 12,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              onPressed: () {
                                // Share action
                              },
                              icon: const Icon(Icons.share),
                              label: const Text('Share'),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 12),

                      const Divider(color: Colors.black, height: 2.0),

                      const SizedBox(height: 12),

                      // About / Description
                      const Text(
                        'About',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        markerData['description'] ??
                            'No description available.',
                      ),

                      const SizedBox(height: 18),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
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
                    mapType: MapType.hybrid,
                    initialCameraPosition: CameraPosition(
                      target: currentPosition!,
                      zoom: 13,
                    ),
                    markers: {
                      Marker(
                        markerId: MarkerId("currentPos"),
                        icon: currentMarker,
                        position: currentPosition!,
                      ),
                      for (var i = 0; i < markers.length; i++)
                        Marker(
                          markerId: MarkerId(markers[i]["id"]),
                          // icon:
                          //     markerSelected
                          //         ? markers[i]["selectIcon"]
                          //         : markers[i]["icon"],
                          icon: markers[i]["icon"],
                          position: LatLng(
                            markers[i]["latitude"],
                            markers[i]["longitude"],
                          ),
                          onTap: () {
                            // Show a bottom sheet when this marker is tapped and update selection
                            _handleMarkerTap(i);
                          },
                        ),
                    },
                  ),
        ),

        // Floating action button to report a dog
        floatingActionButtonLocation: FloatingActionButtonLocation.startTop,
        floatingActionButton: Padding(
          padding: const EdgeInsets.only(top: 12),
          child: FloatingActionButton.large(
            onPressed: () {
              _reportDogButtonPressed();
            },
            shape: RoundedRectangleBorder(
              side: BorderSide(
                color: WoofCareColors.borderOutline.withValues(alpha: 0.5),
              ),
              borderRadius: BorderRadiusGeometry.circular(90),
            ),
            backgroundColor: WoofCareColors.secondaryBackground.withValues(
              alpha: 0.9,
            ),
            child: FaIcon(FontAwesomeIcons.bullhorn),
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
        // What if the permission status is grantedLimited?
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
                  top: BorderSide(
                    color: WoofCareColors.borderOutline,
                    width: 2.0,
                  ),
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
    currentMarker = await BitmapDescriptor.asset(
      const ImageConfiguration(),
      'assets/images/map/current.png',
    );

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
            marker['selectIcon'] = vetSelectMarker;
            break;
          case 'ngo':
            marker['icon'] = ngoMarker;
            marker['selectIcon'] = ngoSelectMarker;
            break;
          case 'shelter':
            marker['icon'] = shelterMarker;
            marker['selectIcon'] = shelterSelectMarker;
            break;
          case 'dog':
            marker['icon'] = dogMarker;
            marker['selectIcon'] = dogSelectMarker;
            break;
          case 'adopt':
            marker['icon'] = adoptMarker;
            marker['selectIcon'] = adoptSelectMarker;
            break;
          default:
            marker['icon'] = dogMarker;
        }

        markers.add(marker);
      }
    }
  }

  Future<void> _handleMarkerTap(int index) async {
    setState(() {
      markerSelected = true;
    });

    await _showMarkerBottomSheet(markers[index]);

    if (mounted) {
      setState(() {
        markerSelected = false;
      });
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
