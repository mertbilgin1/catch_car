import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static const Color midnightBlue = Color(0xFF051424);
  static const Color surfaceBright = Color(0xFF2C3A4C);
  static const Color surfaceContainer = Color(0xFF122131);
  static const Color electricBlue = Color(0xFF3B82F6); // primary / focus
  static const Color electricBlueLight = Color(0xFFADC6FF);
  static const Color cyberLime = Color(0xFFA4D64C); // secondary / highlight
  static const Color textMain = Color(0xFFD4E4FA);
  static const Color textMuted = Color(0xFFC2C6D6);
  static const Color outline = Color(0xFF424754);

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: midnightBlue,
      colorScheme: const ColorScheme.dark(
        primary: electricBlue,
        onPrimary: Colors.white,
        secondary: cyberLime,
        onSecondary: Colors.black,
        surface: surfaceContainer,
        onSurface: textMain,
        error: Color(0xFFFFB4AB),
      ),
      textTheme: TextTheme(
        displayLarge: GoogleFonts.plusJakartaSans(
          fontSize: 40,
          fontWeight: FontWeight.w800,
          letterSpacing: -0.02,
          color: Colors.white,
        ),
        headlineLarge: GoogleFonts.plusJakartaSans(
          fontSize: 32,
          fontWeight: FontWeight.w700,
          letterSpacing: -0.01,
          color: Colors.white,
        ),
        headlineMedium: GoogleFonts.plusJakartaSans(
          fontSize: 24,
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),
        bodyLarge: GoogleFonts.inter(
          fontSize: 18,
          fontWeight: FontWeight.w400,
          color: textMain,
        ),
        bodyMedium: GoogleFonts.inter(
          fontSize: 16,
          fontWeight: FontWeight.w400,
          color: textMain,
        ),
        labelMedium: GoogleFonts.inter(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.05,
          color: textMuted,
        ),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: midnightBlue,
        elevation: 0,
        centerTitle: true,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: midnightBlue,
        selectedItemColor: cyberLime,
        unselectedItemColor: textMuted,
        type: BottomNavigationBarType.fixed,
        elevation: 8,
      ),
      cardTheme: CardThemeData(
        color: surfaceContainer,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        elevation: 0,
        margin: EdgeInsets.zero,
      ),
    );
  }
}
