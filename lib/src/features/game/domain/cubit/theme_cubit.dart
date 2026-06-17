import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

class ThemeCubit extends Cubit<ThemeData> {
  ThemeCubit() : super(_buildDefault());

  void applyTheme(String themeId) {
    switch (themeId) {
      case 'dark':
        emit(_buildDark());
      case 'amber':
        emit(_buildAmber());
      case 'ocean':
        emit(_buildOcean());
      case 'neon':
        emit(_buildNeon());
      default:
        emit(_buildDefault());
    }
  }

  void resetToDefault() => emit(_buildDefault());

  static ThemeData _buildDefault() => ThemeData(
        useMaterial3: true,
        brightness: Brightness.light,
        colorScheme: ColorScheme.light(
          primary: const Color(0xFF000000),
          onPrimary: const Color(0xFFFFFFFF),
          secondary: const Color(0xFFF59E0B),
          onSecondary: const Color(0xFF1A1A1A),
          tertiary: const Color(0xFF3B82F6),
          surface: const Color(0xFFFFFFFF),
          onSurface: const Color(0xFF1A1A1A),
          error: const Color(0xFFEF4444),
          outline: const Color(0xFFE5E7EB),
          shadow: const Color(0xFF000000),
        ),
        textTheme: GoogleFonts.interTextTheme(),
        scaffoldBackgroundColor: const Color(0xFFF5F5F5),
        appBarTheme: AppBarTheme(
          backgroundColor: const Color(0xFFFFFFFF),
          foregroundColor: const Color(0xFF1A1A1A),
          elevation: 0,
          centerTitle: false,
          titleTextStyle: GoogleFonts.inter(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: const Color(0xFF1A1A1A),
          ),
        ),
        cardTheme: CardThemeData(
          color: const Color(0xFFFFFFFF),
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: const BorderSide(color: Color(0xFFE5E7EB)),
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF000000),
            foregroundColor: const Color(0xFFFFFFFF),
            elevation: 0,
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 32),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
            textStyle: GoogleFonts.inter(
              fontWeight: FontWeight.w600,
              fontSize: 15,
            ),
          ),
        ),
        outlinedButtonTheme: OutlinedButtonThemeData(
          style: OutlinedButton.styleFrom(
            foregroundColor: const Color(0xFF1A1A1A),
            side: const BorderSide(color: Color(0xFFE5E7EB)),
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 32),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
          ),
        ),
        snackBarTheme: SnackBarThemeData(
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          contentTextStyle: GoogleFonts.inter(color: Colors.white, fontSize: 14),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: const Color(0xFFFFFFFF),
          contentPadding: const EdgeInsets.symmetric(vertical: 18, horizontal: 20),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(color: Color(0xFF000000), width: 2),
          ),
        ),
      );

  static ThemeData _buildDark() => ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        colorScheme: ColorScheme.dark(
          primary: const Color(0xFF1A1A2E),
          onPrimary: const Color(0xFFE0E0E0),
          secondary: const Color(0xFFF59E0B),
          onSecondary: const Color(0xFF1A1A1A),
          tertiary: const Color(0xFF60A5FA),
          surface: const Color(0xFF1E1E1E),
          onSurface: const Color(0xFFE0E0E0),
          error: const Color(0xFFEF4444),
          outline: const Color(0xFF3A3A3A),
          shadow: const Color(0xFF000000),
        ),
        textTheme: GoogleFonts.interTextTheme(ThemeData.dark().textTheme),
        scaffoldBackgroundColor: const Color(0xFF121212),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF1E1E1E),
          foregroundColor: Colors.white,
          elevation: 0,
          centerTitle: false,
        ),
        cardTheme: CardThemeData(
          color: const Color(0xFF2A2A2A),
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFFF59E0B),
            foregroundColor: Colors.black,
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 32),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
          ),
        ),
        snackBarTheme: SnackBarThemeData(
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: const Color(0xFF2A2A2A),
          contentPadding: const EdgeInsets.symmetric(vertical: 18, horizontal: 20),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(color: Color(0xFF3A3A3A)),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(color: Color(0xFF3A3A3A)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(color: Color(0xFFF59E0B), width: 2),
          ),
        ),
      );

  static ThemeData _buildAmber() => ThemeData(
        useMaterial3: true,
        brightness: Brightness.light,
        colorScheme: const ColorScheme.light(
          primary: Color(0xFFF59E0B),
          onPrimary: Color(0xFFFFFFFF),
          secondary: Color(0xFF1A1A1A),
          onSecondary: Color(0xFFFFFFFF),
          tertiary: Color(0xFF0EA5E9),
          surface: Color(0xFFFFF8E1),
          onSurface: Color(0xFF1A1A1A),
          error: Color(0xFFEF4444),
          outline: Color(0xFFE8D5A3),
          shadow: Color(0xFF000000),
        ),
        textTheme: GoogleFonts.interTextTheme(),
        scaffoldBackgroundColor: const Color(0xFFFFF8E1),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFFFFF8E1),
          foregroundColor: Color(0xFF1A1A1A),
          elevation: 0,
          centerTitle: false,
        ),
        cardTheme: CardThemeData(
          color: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFFF59E0B),
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 32),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
          ),
        ),
        snackBarTheme: SnackBarThemeData(
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.white,
          contentPadding: const EdgeInsets.symmetric(vertical: 18, horizontal: 20),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(color: Color(0xFFE8D5A3)),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(color: Color(0xFFE8D5A3)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(color: Color(0xFFF59E0B), width: 2),
          ),
        ),
      );

  static ThemeData _buildOcean() => ThemeData(
        useMaterial3: true,
        brightness: Brightness.light,
        colorScheme: const ColorScheme.light(
          primary: Color(0xFF0D47A1),
          onPrimary: Color(0xFFFFFFFF),
          secondary: Color(0xFF00BCD4),
          onSecondary: Color(0xFF1A1A1A),
          tertiary: Color(0xFF26A69A),
          surface: Color(0xFFE3F2FD),
          onSurface: Color(0xFF0D1B2A),
          error: Color(0xFFEF4444),
          outline: Color(0xFFB0D4E8),
          shadow: Color(0xFF000000),
        ),
        textTheme: GoogleFonts.interTextTheme(),
        scaffoldBackgroundColor: const Color(0xFFE3F2FD),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFFE3F2FD),
          foregroundColor: Color(0xFF0D1B2A),
          elevation: 0,
          centerTitle: false,
        ),
        cardTheme: CardThemeData(
          color: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF0D47A1),
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 32),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
          ),
        ),
        snackBarTheme: SnackBarThemeData(
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.white,
          contentPadding: const EdgeInsets.symmetric(vertical: 18, horizontal: 20),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(color: Color(0xFFB0D4E8)),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(color: Color(0xFFB0D4E8)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(color: Color(0xFF0D47A1), width: 2),
          ),
        ),
      );

  static ThemeData _buildNeon() => ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        colorScheme: const ColorScheme.dark(
          primary: Color(0xFF00FF88),
          onPrimary: Color(0xFF000000),
          secondary: Color(0xFFFF00FF),
          onSecondary: Color(0xFF000000),
          tertiary: Color(0xFF00BFFF),
          surface: Color(0xFF0A0A1A),
          onSurface: Color(0xFFE0E0FF),
          error: Color(0xFFFF4444),
          outline: Color(0xFF2A2A4A),
          shadow: Color(0xFF000000),
        ),
        textTheme: GoogleFonts.shareTechMonoTextTheme(ThemeData.dark().textTheme),
        scaffoldBackgroundColor: const Color(0xFF0A0A1A),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF0A0A1A),
          foregroundColor: Color(0xFF00FF88),
          elevation: 0,
          centerTitle: false,
        ),
        cardTheme: CardThemeData(
          color: const Color(0xFF12122A),
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: const BorderSide(color: Color(0xFF00FF88), width: 0.5),
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF00FF88),
            foregroundColor: Colors.black,
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 32),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
          ),
        ),
        snackBarTheme: SnackBarThemeData(
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: const Color(0xFF12122A),
          contentPadding: const EdgeInsets.symmetric(vertical: 18, horizontal: 20),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(color: Color(0xFF2A2A4A)),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(color: Color(0xFF2A2A4A)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(color: Color(0xFF00FF88), width: 2),
          ),
        ),
      );
}
