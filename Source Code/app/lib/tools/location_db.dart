import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';

class LocationsDB {
  List<String> photos = [];

  static Future<void> update() async {
    final String response = await rootBundle.loadString('assets/org_data.json');
    final data = await json.decode(response);

    upload(data);
  }

  static void upload(List orgs) async {
    final firestore = FirebaseFirestore.instance;
    final collectionRef = firestore.collection("locations");

    for (int row = 0; row < (orgs.length); row++) {
      List<String> photos = [];
      await collectionRef.add({
        "name": orgs[row]["Organization"].toLowerCase(),
        "type": orgs[row]["Type of Organization"].toLowerCase(),
        "website": orgs[row]["Website"],
        "phone": orgs[row]["Phone Number"],
        "latitude": orgs[row]["Latitude"],
        "longitude": orgs[row]["Longitude"],
        "description": orgs[row]["Description"].toLowerCase(),
        "photos": photos,
      });
    }
  }
}
