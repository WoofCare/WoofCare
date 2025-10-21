import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';


class Addtofirebase {
  List _orgs = [];
  List<String> photos = [];
  Future<void> addJsonToFirebase() async {
      final String response = await rootBundle.loadString('assets/images/orgDataUpdated.json');
      final data = await json.decode(response);
      _orgs = data;
      addToFirebase(_orgs,"orgs");
  }
  void addToFirebase(List orgs, String s) async{
    final firestore = FirebaseFirestore.instance;
    final collectionRef = firestore.collection("locations");
    
    for (int row =0; row<(orgs.length);row++){
      List<String> photos = [];
      await collectionRef.add({
        "name": orgs[row]["Organization"].toLowerCase(),
        "type": orgs[row]["Type of Organization"].toLowerCase(),
        "website": orgs[row]["Website"],
        "number": orgs[row]["Phone Number"],
        "latitude": orgs[row]["Latitude"],
        "longitude": orgs[row]["Longitude"],
        "description" : orgs[row]["Description"].toLowerCase(),
        "photos" : photos,
      });
    }
  }
}