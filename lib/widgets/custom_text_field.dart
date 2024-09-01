import 'package:flutter/material.dart';

import '/common/color_constants.dart';

class CustomTextField extends StatelessWidget {
  final String hintText;
  final TextEditingController controller;
  final bool lastField;

  const CustomTextField({
    super.key,
    required this.hintText,
    required this.controller,
    this.lastField = false,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
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
        fillColor: AppTheme.grey.withOpacity(0.25),
        border: const OutlineInputBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(35),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: const BorderRadius.all(
            Radius.circular(35),
          ),
          borderSide: BorderSide(color: AppTheme.primaryColor, width: 2),
        ),
      ),
    );
  }
}
