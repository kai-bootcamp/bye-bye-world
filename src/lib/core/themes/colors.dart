import 'package:flutter/material.dart';

class AppColors {
  static Color button(BuildContext context) =>
      Theme.of(context).colorScheme.primaryVariant;

  static Color highlight(BuildContext context) =>
      Theme.of(context).colorScheme.primary;

  static Color hover(BuildContext context) =>
      Theme.of(context).colorScheme.error;

  static Color backGroundDialog(BuildContext context) =>
      Theme.of(context).dialogBackgroundColor;
}
