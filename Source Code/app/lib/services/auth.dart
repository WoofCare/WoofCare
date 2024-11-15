import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:woofcare/config/constants.dart';
import 'package:woofcare/models/profile.dart';

class Auth {
  static Future<void> signup({
    required String email,
    required String password,
    required Map<String, String> data,
    required BuildContext context,
    required void Function(FirebaseAuthException e) error,
  }) async {
    try {
      await AUTH.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      String uid = AUTH.currentUser!.uid;
      FIRESTORE.collection("users").doc(uid).set(data);

      profile = await Profile.fromID(uid);

      if (context.mounted) {
        Navigator.pushNamed(context, "/home");
      }
    } on FirebaseAuthException catch (e) {
      error(e);
    } catch (e) {
      print(e.toString());
    }
  }

  static Future<void> login({
    required String email,
    required String password,
    required BuildContext context,
    required void Function(FirebaseAuthException e) error,
  }) async {
    try {
      await AUTH.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      String uid = AUTH.currentUser!.uid;

      profile = await Profile.fromID(uid);

      if (context.mounted) {
        Navigator.pushNamed(context, "/home");
      }
    } on FirebaseAuthException catch (e) {
      error(e);
    } catch (e) {
      print(e.toString());
    }
  }

  static Future<void> signOut(BuildContext context) async {
    await AUTH.signOut();

    if (context.mounted) {
      Navigator.pushNamed(context, "/login");
    }
  }
}
