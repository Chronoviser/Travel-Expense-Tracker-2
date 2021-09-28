import 'package:flutter/material.dart';

class ToastService {
  static errorToast({BuildContext context, String message}) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(message, textAlign: TextAlign.center),
        backgroundColor: Colors.red));
  }

  static msgToast({BuildContext context, String message}) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(message, textAlign: TextAlign.center),
        backgroundColor: Colors.black,
        duration: Duration(seconds: 1)));
  }
}
