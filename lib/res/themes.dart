import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:testfluter/res/colors.dart';

class AppTheme {

  static const TextStyle appBarTitle = TextStyle(
    color: AppColors.white,
  );

  static const TextStyle buttonsText = TextStyle(
    fontSize: 16,
    color: AppColors.black,
  );

  static const TextStyle infoTexts = TextStyle(
    fontSize: 15,
    color: AppColors.gray,
  );

  static ButtonStyle defaultButtons = ElevatedButton.styleFrom(
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(20),
    ),
    backgroundColor: AppColors.blueLight,
  );

}