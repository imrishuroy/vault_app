import 'package:flutter/material.dart';

class ShowSnackBar {
  static void showSnackBar(
    BuildContext context, {
    required String? title,
    Color? backgroundColor,
    VoidCallback? onTap,
    Color? textColor,
  }) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(8.0),
        backgroundColor: backgroundColor,
        content: Text(
          '$title',
          style: TextStyle(color: textColor ?? Colors.white),
        ),
        action: SnackBarAction(
          label: 'OK',
          textColor: textColor != null ? Colors.grey.shade600 : Colors.white,
          onPressed: () {
            ScaffoldMessenger.of(context).removeCurrentSnackBar();
            if (onTap != null) {
              onTap();
            }
          },
        ),
      ),
    );
  }
}
