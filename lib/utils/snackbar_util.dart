import 'package:flutter/material.dart';

///
class SnackBarUtil {
  ///
  final snackType = 'error';

  ///
  static showSnackBar(
    BuildContext context,
    String message, {
    bool error = false,
  }) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: error ? Colors.red : null,
      ),
    );
  }
}
