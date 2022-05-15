import 'package:flutter/material.dart';

class SnackBarUtil {
  static show(
      {required GlobalKey<ScaffoldState> scaffoldKey, required String text}) {
    if (scaffoldKey.currentContext != null) {
      return ScaffoldMessenger.of(scaffoldKey.currentContext!).showSnackBar(
        SnackBar(content: Text(text)),
      );
    }
  }
}
