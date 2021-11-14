import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:src/core/themes/colors.dart';
import 'package:src/core/themes/styles.dart';

class ButtonBase extends StatelessWidget {
  const ButtonBase({
    Key? key,
    required this.onTap,
    this.padding = const EdgeInsets.all(8.0),
    required this.title,
    this.radius = 20.0,
  }) : super(key: key);

  final Function onTap;
  final EdgeInsets padding;
  final double radius;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding,
      child: Material(
        borderRadius: BorderRadius.circular(radius),
        color: AppColors.button(context),
        child: ConstrainedBox(
          constraints: const BoxConstraints(minWidth: 128, minHeight: 50),
          child: InkWell(
              borderRadius: BorderRadius.circular(radius),
              hoverColor: AppColors.hover(context),
              highlightColor: AppColors.highlight(context),
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    title,
                    style: AppTextStyle.button(context),
                  ),
                ),
              ),
              onTap: () {
                onTap();
              }),
        ),
      ),
    );
  }
}
