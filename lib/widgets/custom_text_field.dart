import 'package:flutter/material.dart';

import '/common/color_constants.dart';

class CustomTextField extends StatefulWidget {
  final TextEditingController controller;
  final String hintText;
  final bool lastField;
  final bool isEnabled;
  bool isHidden;
  final bool isPassword;

  CustomTextField({
    super.key,
    required this.controller,
    required this.hintText,
    this.lastField = false,
    this.isEnabled = true,
    this.isHidden = false,
    this.isPassword = false,
  });

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      enabled: widget.isEnabled,
      obscureText: widget.isHidden,
      textInputAction:
          widget.lastField ? TextInputAction.done : TextInputAction.next,
      cursorColor: AppTheme.primaryColor,
      onTapOutside: (event) {
        FocusScope.of(context).unfocus();
      },
      decoration: InputDecoration(
          hintText: widget.hintText,
          hintStyle: TextStyle(fontSize: 14, color: AppTheme.grey),
          contentPadding:
              const EdgeInsets.symmetric(vertical: 2, horizontal: 20),
          filled: true,
          fillColor: AppTheme.white,
          enabledBorder: const OutlineInputBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(10),
            ),
            borderSide: BorderSide(width: 0.5),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: const BorderRadius.all(
              Radius.circular(10),
            ),
            borderSide: BorderSide(color: AppTheme.primaryColor, width: 1),
          ),
          suffixIcon: widget.isPassword
              ? GestureDetector(
                  onTap: () {
                    setState(() {
                      widget.isHidden = !widget.isHidden;
                    });
                  },
                  child: widget.isHidden
                      ? const Icon(
                          Icons.visibility,
                        )
                      : const Icon(
                          Icons.visibility_off,
                        ),
                )
              : null),
    );
  }
}
