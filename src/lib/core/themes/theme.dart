import 'package:flutter/material.dart';
import 'package:src/core/values/strings.dart';

class AppTheme {
  static final ThemeData light = ThemeData(
    fontFamily: AppStrings.font,
    brightness: Brightness.light,
  );
  static final ThemeData dark = ThemeData(
    fontFamily: AppStrings.font,
    brightness: Brightness.dark,
  );
}
