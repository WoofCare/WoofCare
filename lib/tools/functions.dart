import 'package:cloud_firestore/cloud_firestore.dart';

String formatDate(Timestamp timestamp) {
  DateTime dateTime = timestamp.toDate();
  final month = dateTime.month.toString();
  final day = dateTime.day.toString();
  final year = dateTime.year.toString();

  return '$month/$day/$year';
}
