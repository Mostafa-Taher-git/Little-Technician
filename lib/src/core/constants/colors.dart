import 'package:flutter/material.dart';

class AppColors {
  // Primary palette — Teal (from frog icon background)
  static const Color primary = Color(0xFF4A9BA8);
  static const Color onPrimary = Color(0xFFFFFFFF);

  // Accent — Gold (from frog icon eyes)
  static const Color accent = Color(0xFFE8C840);
  static const Color onAccent = Color(0xFF1A3A3E);

  // Neutrals
  static const Color background = Color(0xFFE8F4F6);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color surfaceVariant = Color(0xFFD4ECEE);
  static const Color onSurface = Color(0xFF1A3A3E);
  static const Color onSurfaceMuted = Color(0xFF5A8A8E);

  // Borders / dividers
  static const Color border = Color(0xFFB8D8DC);
  static const Color divider = Color(0xFFD4ECEE);

  // Feedback
  static const Color success = Color(0xFF7CC860);
  static const Color error = Color(0xFFEF4444);
  static const Color warning = Color(0xFFE8C840);
  static const Color info = Color(0xFF80E0E0);

  // Gradient helper
  static const LinearGradient darkGradient = LinearGradient(
    colors: [Color(0xFF1A3A3E), Color(0xFF0D2426)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient accentGradient = LinearGradient(
    colors: [Color(0xFFE8C840), Color(0xFFD4B030)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}
