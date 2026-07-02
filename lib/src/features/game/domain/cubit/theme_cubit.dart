import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

class _ThemeConfig {
  final Brightness brightness;
  final ColorScheme colorScheme;
  final Color scaffoldBackground;
  final Color appBarBackground;
  final Color appBarForeground;
  final Color cardColor;
  final Color cardBorder;
  final Color buttonBackground;
  final Color buttonForeground;
  final Color inputFill;
  final Color inputBorder;
  final TextStyle? titleStyle;
  final TextTheme? textTheme;

  const _ThemeConfig({
    required this.brightness,
    required this.colorScheme,
    required this.scaffoldBackground,
    required this.appBarBackground,
    required this.appBarForeground,
    required this.cardColor,
    required this.cardBorder,
    required this.buttonBackground,
    required this.buttonForeground,
    required this.inputFill,
    required this.inputBorder,
    this.titleStyle,
    this.textTheme,
  });
}

class ThemeCubit extends Cubit<ThemeData> {
  ThemeCubit() : super(_buildDefault());

  void applyTheme(String themeId) {
    final configs = <String, _ThemeConfig>{
      'dark': _darkConfig,
      'amber': _amberConfig,
      'ocean': _oceanConfig,
      'neon': _neonConfig,
      'medieval': _medievalConfig,
      'dungeon': _dungeonConfig,
      'arcane': _arcaneConfig,
      'dragon_fire': _dragonFireConfig,
    };
    emit(_buildTheme(configs[themeId] ?? _defaultConfig));
  }

  void resetToDefault() => emit(_buildDefault());

  static ThemeData _buildTheme(_ThemeConfig cfg) {
    final defaultTextTheme = cfg.brightness == Brightness.dark
        ? ThemeData.dark().textTheme
        : ThemeData.light().textTheme;
    return ThemeData(
      useMaterial3: true,
      brightness: cfg.brightness,
      colorScheme: cfg.colorScheme,
      textTheme: cfg.textTheme ?? GoogleFonts.interTextTheme(defaultTextTheme),
      scaffoldBackgroundColor: cfg.scaffoldBackground,
      appBarTheme: AppBarTheme(
        backgroundColor: cfg.appBarBackground,
        foregroundColor: cfg.appBarForeground,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: cfg.titleStyle ??
            GoogleFonts.inter(fontSize: 20, fontWeight: FontWeight.w700, color: cfg.appBarForeground),
      ),
      cardTheme: CardThemeData(
        color: cfg.cardColor,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(color: cfg.cardBorder),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: cfg.buttonBackground,
          foregroundColor: cfg.buttonForeground,
          elevation: 0,
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 32),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        ),
      ),
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        contentTextStyle: GoogleFonts.inter(color: Colors.white, fontSize: 14),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: cfg.inputFill,
        contentPadding: const EdgeInsets.symmetric(vertical: 18, horizontal: 20),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: cfg.inputBorder),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: cfg.inputBorder),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: cfg.colorScheme.primary, width: 2),
        ),
      ),
    );
  }

  static ThemeData _buildDefault() => _buildTheme(_defaultConfig);

  static const _defaultConfig = _ThemeConfig(
    brightness: Brightness.light,
    colorScheme: ColorScheme.light(
      primary: Color(0xFF4A9BA8),
      onPrimary: Color(0xFFFFFFFF),
      secondary: Color(0xFFE8C840),
      onSecondary: Color(0xFF1A3A3E),
      surface: Color(0xFFFFFFFF),
      onSurface: Color(0xFF1A3A3E),
      error: Color(0xFFEF4444),
      outline: Color(0xFFB8D8DC),
    ),
    scaffoldBackground: Color(0xFFE8F4F6),
    appBarBackground: Color(0xFFFFFFFF),
    appBarForeground: Color(0xFF1A3A3E),
    cardColor: Color(0xFFFFFFFF),
    cardBorder: Color(0xFFB8D8DC),
    buttonBackground: Color(0xFF4A9BA8),
    buttonForeground: Color(0xFFFFFFFF),
    inputFill: Color(0xFFFFFFFF),
    inputBorder: Color(0xFFB8D8DC),
  );

  static const _darkConfig = _ThemeConfig(
    brightness: Brightness.dark,
    colorScheme: ColorScheme.dark(
      primary: Color(0xFF1A1A2E),
      onPrimary: Color(0xFFE0E0E0),
      secondary: Color(0xFFF59E0B),
      onSecondary: Color(0xFF1A1A1A),
      surface: Color(0xFF1E1E1E),
      onSurface: Color(0xFFE0E0E0),
      error: Color(0xFFEF4444),
      outline: Color(0xFF3A3A3A),
    ),
    scaffoldBackground: Color(0xFF121212),
    appBarBackground: Color(0xFF1E1E1E),
    appBarForeground: Colors.white,
    cardColor: Color(0xFF2A2A2A),
    cardBorder: Color(0xFF3A3A3A),
    buttonBackground: Color(0xFFF59E0B),
    buttonForeground: Colors.black,
    inputFill: Color(0xFF2A2A2A),
    inputBorder: Color(0xFF3A3A3A),
  );

  static const _amberConfig = _ThemeConfig(
    brightness: Brightness.light,
    colorScheme: ColorScheme.light(
      primary: Color(0xFFF59E0B),
      onPrimary: Color(0xFFFFFFFF),
      secondary: Color(0xFF1A1A1A),
      onSecondary: Color(0xFFFFFFFF),
      surface: Color(0xFFFFF8E1),
      onSurface: Color(0xFF1A1A1A),
      error: Color(0xFFEF4444),
      outline: Color(0xFFE8D5A3),
    ),
    scaffoldBackground: Color(0xFFFFF8E1),
    appBarBackground: Color(0xFFFFF8E1),
    appBarForeground: Color(0xFF1A1A1A),
    cardColor: Colors.white,
    cardBorder: Color(0xFFE8D5A3),
    buttonBackground: Color(0xFFF59E0B),
    buttonForeground: Colors.white,
    inputFill: Colors.white,
    inputBorder: Color(0xFFE8D5A3),
  );

  static const _oceanConfig = _ThemeConfig(
    brightness: Brightness.light,
    colorScheme: ColorScheme.light(
      primary: Color(0xFF0D47A1),
      onPrimary: Color(0xFFFFFFFF),
      secondary: Color(0xFF00BCD4),
      onSecondary: Color(0xFF1A1A1A),
      surface: Color(0xFFE3F2FD),
      onSurface: Color(0xFF0D1B2A),
      error: Color(0xFFEF4444),
      outline: Color(0xFFB0D4E8),
    ),
    scaffoldBackground: Color(0xFFE3F2FD),
    appBarBackground: Color(0xFFE3F2FD),
    appBarForeground: Color(0xFF0D1B2A),
    cardColor: Colors.white,
    cardBorder: Color(0xFFB0D4E8),
    buttonBackground: Color(0xFF0D47A1),
    buttonForeground: Colors.white,
    inputFill: Colors.white,
    inputBorder: Color(0xFFB0D4E8),
  );

  static final _neonConfig = _ThemeConfig(
    brightness: Brightness.dark,
    colorScheme: const ColorScheme.dark(
      primary: Color(0xFF00FF88),
      onPrimary: Color(0xFF000000),
      secondary: Color(0xFFFF00FF),
      onSecondary: Color(0xFF000000),
      surface: Color(0xFF0A0A1A),
      onSurface: Color(0xFFE0E0FF),
      error: Color(0xFFFF4444),
      outline: Color(0xFF2A2A4A),
    ),
    scaffoldBackground: const Color(0xFF0A0A1A),
    appBarBackground: const Color(0xFF0A0A1A),
    appBarForeground: const Color(0xFF00FF88),
    cardColor: const Color(0xFF12122A),
    cardBorder: const Color(0xFF00FF88),
    buttonBackground: const Color(0xFF00FF88),
    buttonForeground: Colors.black,
    inputFill: const Color(0xFF12122A),
    inputBorder: const Color(0xFF2A2A4A),
    textTheme: GoogleFonts.shareTechMonoTextTheme(ThemeData.dark().textTheme),
  );

  static final _medievalConfig = _ThemeConfig(
    brightness: Brightness.light,
    colorScheme: const ColorScheme.light(
      primary: Color(0xFF5D4E37),
      onPrimary: Color(0xFFFFF8E1),
      secondary: Color(0xFFCFB53B),
      onSecondary: Color(0xFF1A1A1A),
      surface: Color(0xFFF5E6C8),
      onSurface: Color(0xFF2C1810),
      error: Color(0xFF8B0000),
      outline: Color(0xFFC4A97D),
    ),
    scaffoldBackground: const Color(0xFFEED9B7),
    appBarBackground: const Color(0xFFEED9B7),
    appBarForeground: const Color(0xFF2C1810),
    cardColor: const Color(0xFFF5E6C8),
    cardBorder: const Color(0xFFC4A97D),
    buttonBackground: const Color(0xFF5D4E37),
    buttonForeground: const Color(0xFFFFF8E1),
    inputFill: const Color(0xFFFFF8E1),
    inputBorder: const Color(0xFFC4A97D),
    textTheme: GoogleFonts.cinzelTextTheme(),
    titleStyle: GoogleFonts.cinzel(fontSize: 20, fontWeight: FontWeight.w700, color: const Color(0xFF2C1810)),
  );

  static const _dungeonConfig = _ThemeConfig(
    brightness: Brightness.dark,
    colorScheme: ColorScheme.dark(
      primary: Color(0xFF1A1A2E),
      onPrimary: Color(0xFFE0E0E0),
      secondary: Color(0xFFDC143C),
      onSecondary: Color(0xFFFFF8E1),
      surface: Color(0xFF2D2D44),
      onSurface: Color(0xFFE0D8C8),
      error: Color(0xFFFF4444),
      outline: Color(0xFF4A4A6A),
    ),
    scaffoldBackground: Color(0xFF16162A),
    appBarBackground: Color(0xFF16162A),
    appBarForeground: Color(0xFFDC143C),
    cardColor: Color(0xFF2D2D44),
    cardBorder: Color(0xFF4A4A6A),
    buttonBackground: Color(0xFFDC143C),
    buttonForeground: Color(0xFFFFF8E1),
    inputFill: Color(0xFF2D2D44),
    inputBorder: Color(0xFF4A4A6A),
  );

  static const _arcaneConfig = _ThemeConfig(
    brightness: Brightness.dark,
    colorScheme: ColorScheme.dark(
      primary: Color(0xFF4A0E8F),
      onPrimary: Color(0xFFE0E0FF),
      secondary: Color(0xFF00E5FF),
      onSecondary: Color(0xFF000000),
      surface: Color(0xFF1A0A2E),
      onSurface: Color(0xFFE0D0FF),
      error: Color(0xFFFF4444),
      outline: Color(0xFF3A1A6A),
    ),
    scaffoldBackground: Color(0xFF0D0519),
    appBarBackground: Color(0xFF0D0519),
    appBarForeground: Color(0xFF00E5FF),
    cardColor: Color(0xFF1A0A2E),
    cardBorder: Color(0xFF3A1A6A),
    buttonBackground: Color(0xFF4A0E8F),
    buttonForeground: Color(0xFFE0E0FF),
    inputFill: Color(0xFF1A0A2E),
    inputBorder: Color(0xFF3A1A6A),
  );

  static const _dragonFireConfig = _ThemeConfig(
    brightness: Brightness.dark,
    colorScheme: ColorScheme.dark(
      primary: Color(0xFF8B0000),
      onPrimary: Color(0xFFFFF8E1),
      secondary: Color(0xFFFFD700),
      onSecondary: Color(0xFF1A1A1A),
      surface: Color(0xFF1A0A0A),
      onSurface: Color(0xFFFFF0E0),
      error: Color(0xFFFF4444),
      outline: Color(0xFF3A1A1A),
    ),
    scaffoldBackground: Color(0xFF0D0505),
    appBarBackground: Color(0xFF0D0505),
    appBarForeground: Color(0xFFFFD700),
    cardColor: Color(0xFF1A0A0A),
    cardBorder: Color(0xFF3A1A1A),
    buttonBackground: Color(0xFF8B0000),
    buttonForeground: Color(0xFFFFF8E1),
    inputFill: Color(0xFF1A0A0A),
    inputBorder: Color(0xFF3A1A1A),
  );
}
