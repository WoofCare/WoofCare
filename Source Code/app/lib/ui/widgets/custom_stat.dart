import 'package:flutter/material.dart';

import '/config/colors.dart';

Widget customStat(String number, String label) {
  return Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Text(
        number,
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: WoofCareColors.primaryTextAndIcons,
        ),
      ),
      SizedBox(height: 4),
      Text(
        label,
        style: TextStyle(fontSize: 12, color: WoofCareColors.buttonColor),
      ),
    ],
  );
}
