import 'package:flutter/material.dart';

class AppTextStyle {
  static TextStyle button(BuildContext context) =>
      Theme.of(context).textTheme.button!;
  static TextStyle appBarTitle(BuildContext context) =>
      Theme.of(context).textTheme.headline6!;

  static TextStyle input(BuildContext context) =>
      Theme.of(context).textTheme.bodyText2!;
}
