import 'package:cloud_firestore/cloud_firestore.dart';

import '/config/constants.dart';

class Profile {
  final String id;
  final String name;
  final String email;
  final String role;
  final DocumentReference reference;
  String bio;
  var chats = [];

  Profile({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
    required this.bio,
    required this.reference,
  });

  static Future<Profile> fromID(String id) async {
    final DocumentSnapshot doc =
        await FIRESTORE.collection("users").doc(id).get();

    return Profile(
      id: id,
      name: doc.get("name") as String,
      email: doc.get("email") as String,
      role: doc.get("role") as String,
      bio: doc.get("bio") as String,
      reference: doc.reference,
    );
  }

  Future<void> updateProfile() async {
    try {
      await reference.update({'bio': bio});
      print("Document updated successfully");
    } catch (e) {
      print("error updating doc");
    }
  }

  Map<String, dynamic> toJson() => {
        "name": name,
        "email": email,
        "role": role,
      };
}
