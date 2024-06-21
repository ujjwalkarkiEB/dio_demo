import 'package:flutter/material.dart';

void showSuccessSnackbar(BuildContext context, String text) {
  final snackBar = SnackBar(
    content: Text(text),
    backgroundColor: Colors.green, // You can use any color to indicate success
    behavior: SnackBarBehavior.floating,
    duration: const Duration(seconds: 3),
    action: SnackBarAction(
      label: 'OK',
      textColor: Colors.white,
      onPressed: () {
        // Code to execute when the action is pressed, if needed
      },
    ),
  );

  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}
