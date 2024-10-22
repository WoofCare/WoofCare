// ignore_for_file: non_constant_identifier_names, constant_identifier_names

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

// late Profile profile;

late ThemeData theme;

const bool TESTING = kDebugMode;
const String IP = "192.168.100.45";

const double SCREEN_HEIGHT = 876.5714285714286;
const double SCREEN_WIDTH = 411.42857142857144;

final FirebaseFirestore FIRESTORE = FirebaseFirestore.instance;
final FirebaseAuth AUTH = FirebaseAuth.instance;
