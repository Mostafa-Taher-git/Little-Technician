import 'package:flutter/material.dart';

class Nav {
  static void push(BuildContext context, Widget screen) {
    Navigator.push(context, MaterialPageRoute(builder: (_) => screen));
  }

  static void replace(BuildContext context, Widget screen) {
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => screen));
  }

  static void pushReplacement(BuildContext context, Widget screen) {
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => screen));
  }

  static void replaceAll(BuildContext context, Widget screen) {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => screen),
      (_) => false,
    );
  }

  static void pop(BuildContext context) => Navigator.pop(context);
}
