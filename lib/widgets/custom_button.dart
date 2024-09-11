import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final void Function()? onPressed;
  final String title;
  final width;
  const CustomButton(
      {super.key, this.onPressed, required this.title, this.width});

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      height: 40,
      minWidth: width,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      color: Colors.orange,
      textColor: Colors.white,
      onPressed: onPressed,
      child: Text(title),
    );
  }
}
