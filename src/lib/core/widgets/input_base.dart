import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:src/core/themes/styles.dart';

class InputBase extends StatelessWidget {
  final Function? onChange;
  final String hintText;
  final TextInputType? textInputType;
  final TextEditingController? controller;
  final Color? color;
  final Function? validator;
  final String? errorText;
  final int? maxLength;
  final Function? onTap;

  const InputBase({
    Key? key,
    this.onChange,
    this.color,
    required this.hintText,
    this.textInputType,
    this.controller,
    this.validator,
    this.errorText,
    this.maxLength,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
      child: TextFormField(
        keyboardType: textInputType ?? TextInputType.name,
        controller: controller,
        onChanged: (value) {
          if (onChange != null) {
            onChange!(value);
          }
        },
        onTap: () {
          if (onTap != null) {
            onTap!();
          }
        },
        maxLength: maxLength,
        style: AppTextStyle.input(context),
        textAlignVertical: TextAlignVertical.center,
        decoration: InputDecoration(
          filled: true,
          contentPadding: const EdgeInsets.only(
            top: 20.0,
            bottom: 20.0,
            left: 20.0,
            right: 20.0,
          ),
          hintStyle: AppTextStyle.input(context),
          hintText: hintText,
          errorText: errorText,
          border: OutlineInputBorder(
            borderSide: BorderSide.none,
            borderRadius: BorderRadius.circular(8.0),
          ),
        ),
      ),
    );
  }
}
