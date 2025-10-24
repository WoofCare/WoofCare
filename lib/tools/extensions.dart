import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

extension ToolsString on String {
  String capitalize() => substring(0, 1).toUpperCase() + substring(1);

  Color toColor() => Color("0xFF$this".toInt());

  num toNum() => num.parse(this);
  double toDouble() => double.parse(this);
  int toInt() => int.parse(this);
}

extension ToolsColor on Color {
  String code() => toString().toLowerCase().split("f")[2].split(")")[0];
}

extension ToolsLocale on Locale {
  String code() => toLanguageTag().replaceAll("-", "_");
}

extension ToolsDateTime on DateTime {
  String toFormattedDate() => DateFormat("dd MMMM").format(this);
}

extension ToolsRestorableTextEditingController
    on RestorableTextEditingController {
  String text() => value.text.trim();
}
