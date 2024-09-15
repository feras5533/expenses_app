import 'package:flutter/material.dart';
import 'package:expenses_app/common/color_constants.dart';

import 'package:animated_snack_bar/animated_snack_bar.dart';

customDialog({
  required title,
  required context,
  bool error = true,
}) {
  return AnimatedSnackBar(
    builder: (context) {
      return Container(
        height: 50,
        padding: const EdgeInsets.only(left: 20),
        decoration: BoxDecoration(
          border:
              Border.all(color: error ? Colors.black : AppTheme.primaryColor),
          borderRadius: const BorderRadius.all(
            Radius.circular(15),
          ),
          color: error ? Colors.grey.shade900 : AppTheme.primaryColor,
        ),
        child: Row(
          children: [
            Icon(
              error ? Icons.error_outline_outlined : Icons.done,
              color: Colors.white,
            ),
            const SizedBox(
              width: 10,
            ),
            Text(
              title,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ],
        ),
      );
    },
    duration: const Duration(seconds: 4),
    mobileSnackBarPosition: MobileSnackBarPosition.bottom,
    mobilePositionSettings: const MobilePositionSettings(
      bottomOnAppearance: 25,
      bottomOnDissapear: -60,
    ),
  ).show(context);
}
