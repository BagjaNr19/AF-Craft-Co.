import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // ── Brand Color Palette ──────────────────────────────────────────────────────
  static const Color cream = Color(0xFFFAF7F2);
  static const Color warmWhite = Color(0xFFF5F0E8);
  static const Color softRose = Color(0xFFE8C4B8);
  static const Color dustyRose = Color(0xFFD4937A);
  static const Color terracotta = Color(0xFFC17B5E);
  static const Color warmBrown = Color(0xFF8B5E47);
  static const Color darkBrown = Color(0xFF4A2E1A);
  static const Color charcoal = Color(0xFF2D2015);

  static const Color sage = Color(0xFFB5C4B1);
  static const Color mutedGold = Color(0xFFD4AF7A);
  static const Color champagne = Color(0xFFF0D5A0);

  static const Color errorRed = Color(0xFFB04A4A);
  static const Color successGreen = Color(0xFF5A8A6A);

  // ── Light Theme ──────────────────────────────────────────────────────────────
  static ThemeData get lightTheme {
    final base = ThemeData.light(useMaterial3: true);

    return base.copyWith(
      colorScheme: const ColorScheme.light(
        primary: terracotta,
        onPrimary: Colors.white,
        primaryContainer: softRose,
        onPrimaryContainer: darkBrown,
        secondary: mutedGold,
        onSecondary: darkBrown,
        secondaryContainer: champagne,
        onSecondaryContainer: darkBrown,
        surface: cream,
        onSurface: charcoal,
        surfaceContainerHighest: warmWhite,
        error: errorRed,
        onError: Colors.white,
        outline: softRose,
        outlineVariant: Color(0xFFE8DDD0),
      ),
      scaffoldBackgroundColor: cream,
      textTheme: GoogleFonts.playfairDisplayTextTheme(base.textTheme).copyWith(
        displayLarge:
            GoogleFonts.playfairDisplay(fontSize: 57, fontWeight: FontWeight.w700, color: darkBrown),
        displayMedium:
            GoogleFonts.playfairDisplay(fontSize: 45, fontWeight: FontWeight.w700, color: darkBrown),
        displaySmall:
            GoogleFonts.playfairDisplay(fontSize: 36, fontWeight: FontWeight.w600, color: darkBrown),
        headlineLarge:
            GoogleFonts.playfairDisplay(fontSize: 32, fontWeight: FontWeight.w700, color: darkBrown),
        headlineMedium:
            GoogleFonts.playfairDisplay(fontSize: 26, fontWeight: FontWeight.w700, color: darkBrown),
        headlineSmall:
            GoogleFonts.playfairDisplay(fontSize: 22, fontWeight: FontWeight.w600, color: darkBrown),
        titleLarge:
            GoogleFonts.playfairDisplay(fontSize: 18, fontWeight: FontWeight.w700, color: darkBrown),
        titleMedium:
            GoogleFonts.playfairDisplay(fontSize: 16, fontWeight: FontWeight.w600, color: darkBrown),
        titleSmall:
            GoogleFonts.playfairDisplay(fontSize: 14, fontWeight: FontWeight.w600, color: darkBrown),
        bodyLarge:
            GoogleFonts.playfairDisplay(fontSize: 16, fontWeight: FontWeight.w400, color: charcoal, height: 1.6),
        bodyMedium:
            GoogleFonts.playfairDisplay(fontSize: 14, fontWeight: FontWeight.w400, color: charcoal, height: 1.5),
        bodySmall:
            GoogleFonts.playfairDisplay(fontSize: 12, fontWeight: FontWeight.w400, color: warmBrown),
        labelLarge:
            GoogleFonts.playfairDisplay(fontSize: 14, fontWeight: FontWeight.w600, color: terracotta),
        labelMedium:
            GoogleFonts.playfairDisplay(fontSize: 12, fontWeight: FontWeight.w500, color: warmBrown),
        labelSmall:
            GoogleFonts.playfairDisplay(fontSize: 10, fontWeight: FontWeight.w500, color: warmBrown),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: cream,
        foregroundColor: darkBrown,
        elevation: 0,
        scrolledUnderElevation: 0.5,
        shadowColor: softRose.withOpacity(0.5),
        centerTitle: true,
        titleTextStyle: GoogleFonts.playfairDisplay(
          fontSize: 20,
          fontWeight: FontWeight.w700,
          color: darkBrown,
          letterSpacing: 0.5,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: terracotta,
          foregroundColor: Colors.white,
          elevation: 0,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 16),
          textStyle: GoogleFonts.playfairDisplay(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.5,
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: terracotta,
          side: const BorderSide(color: terracotta, width: 1.5),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 16),
          textStyle: GoogleFonts.playfairDisplay(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.5,
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: terracotta,
          textStyle: GoogleFonts.playfairDisplay(
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: warmWhite,
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: Color(0xFFE8DDD0), width: 1.0),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: Color(0xFFE8DDD0), width: 1.0),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: terracotta, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: errorRed, width: 1.0),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: errorRed, width: 1.5),
        ),
        hintStyle: GoogleFonts.playfairDisplay(
          color: warmBrown.withOpacity(0.5),
          fontSize: 14,
        ),
        labelStyle: GoogleFonts.playfairDisplay(
          color: warmBrown,
          fontSize: 14,
        ),
        floatingLabelStyle: GoogleFonts.playfairDisplay(
          color: terracotta,
          fontSize: 12,
        ),
      ),
      cardTheme: CardThemeData(
        color: Colors.white,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: const BorderSide(color: Color(0xFFF0E8DF), width: 1),
        ),
        margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: Colors.white,
        selectedItemColor: terracotta,
        unselectedItemColor: const Color(0xFFC8B8AC),
        elevation: 8,
        type: BottomNavigationBarType.fixed,
        selectedLabelStyle: GoogleFonts.playfairDisplay(
          fontSize: 11,
          fontWeight: FontWeight.w600,
        ),
        unselectedLabelStyle: GoogleFonts.playfairDisplay(fontSize: 11),
      ),
      dividerTheme: const DividerThemeData(
        color: Color(0xFFF0E8DF),
        thickness: 1,
        space: 0,
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: darkBrown,
        contentTextStyle: GoogleFonts.playfairDisplay(
          color: Colors.white,
          fontSize: 14,
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  // ── Gradient Helpers ─────────────────────────────────────────────────────────
  static const LinearGradient warmGradient = LinearGradient(
    colors: [Color(0xFFFAF7F2), Color(0xFFF5EDE0)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient heroGradient = LinearGradient(
    colors: [Color(0xFF4A2E1A), Color(0xFF8B5E47), Color(0xFFC17B5E)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient roseGradient = LinearGradient(
    colors: [Color(0xFFE8C4B8), Color(0xFFF5EDE0)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  static const LinearGradient goldGradient = LinearGradient(
    colors: [Color(0xFFD4AF7A), Color(0xFFF0D5A0)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // ── Shadow Helpers ───────────────────────────────────────────────────────────
  static List<BoxShadow> get softShadow => [
        BoxShadow(
          color: const Color(0xFF8B5E47).withOpacity(0.08),
          blurRadius: 16,
          offset: const Offset(0, 4),
        ),
      ];

  static List<BoxShadow> get cardShadow => [
        BoxShadow(
          color: const Color(0xFF8B5E47).withOpacity(0.10),
          blurRadius: 24,
          offset: const Offset(0, 8),
          spreadRadius: -2,
        ),
      ];
}
