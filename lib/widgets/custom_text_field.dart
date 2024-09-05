import 'package:flutter/material.dart';

import '/common/color_constants.dart';

class CustomTextField extends StatelessWidget {
  final String hintText;
  final TextEditingController controller;
  final bool lastField;
  final bool isProfileField;
  final bool isEnabled;

  const CustomTextField({
    super.key,
    required this.hintText,
    required this.controller,
    this.lastField = false,
    this.isProfileField = false,
    this.isEnabled = true,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      enabled: isEnabled,
      textInputAction: lastField ? TextInputAction.done : TextInputAction.next,
      cursorColor: AppTheme.primaryColor,
      onTapOutside: (event) {
        FocusScope.of(context).unfocus();
      },
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: TextStyle(fontSize: 14, color: AppTheme.grey),
        contentPadding: const EdgeInsets.symmetric(vertical: 2, horizontal: 20),
        filled: true,
        fillColor:
            isProfileField ? AppTheme.white : AppTheme.grey.withOpacity(0.25),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(isProfileField ? 10 : 35),
          ),
          borderSide: BorderSide(width: isProfileField ? 0.5 : 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(isProfileField ? 10 : 35),
          ),
          borderSide: BorderSide(
              color: AppTheme.primaryColor, width: isProfileField ? 1 : 2),
        ),
      ),
    );
  }
}
