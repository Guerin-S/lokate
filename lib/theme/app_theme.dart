import 'package:flutter/material.dart';

/// LOKATE v2 — Design System Premium "Nuit Cameroun"
/// Sobre, pro, vendable. 100% unique.
/// Palette : Bleu nuit profond + Or laiton + Pierre claire
class AppColors {
  // ── Primary : Bleu nuit premium ──────────────────────────────
  static const Color primary = Color(0xFF0F2B3D); // Nuit Cameroun
  static const Color primaryDark = Color(0xFF0A1E2B);
  static const Color primaryLight = Color(0xFFE8EEF2);
  static const Color primaryMuted = Color(0xFF1A3A4F);

  // ── Gold : Or laiton sobre ──────────────────────────────────
  static const Color gold = Color(0xFFC5A059); // Laiton premium
  static const Color goldDark = Color(0xFF8B7355);
  static const Color goldLight = Color(0xFFF9F1E3);
  static const Color goldMuted = Color(0xFFE8DCC0);

  // ── Accent (CTA) : Bleu action ──────────────────────────────
  static const Color accent = Color(0xFFC5A059); // Or pour CTA premium
  static const Color accentLight = Color(0xFFF9F1E3);

  // ── Sémantique ──────────────────────────────────────────────
  static const Color success = Color(0xFF0E7C5B);
  static const Color error = Color(0xFFC0392B);
  static const Color warning = Color(0xFFB7791F);

  // ── Neutres Light : Pierre & brume ──────────────────────────
  static const Color bgLight = Color(0xFFF8F7F5); // Pierre très claire
  static const Color surfaceLight = Color(0xFFFFFFFF);
  static const Color surfaceMutedLight = Color(0xFFF1F0ED);
  static const Color textPrimaryLight = Color(0xFF0F2B3D);
  static const Color textSecondaryLight = Color(0xFF6B7C8D);
  static const Color textTertiaryLight = Color(0xFF9AA8B5);
  static const Color borderLight = Color(0xFFE8E6E1);
  static const Color borderMutedLight = Color(0xFFF1F0ED);

  // ── Neutres Dark : Nuit profonde ────────────────────────────
  static const Color bgDark = Color(0xFF0A1E2B);
  static const Color surfaceDark = Color(0xFF132F44);
  static const Color surfaceMutedDark = Color(0xFF1A3A4F);
  static const Color textPrimaryDark = Color(0xFFF1F0ED);
  static const Color textSecondaryDark = Color(0xFF8A9BA8);
  static const Color textTertiaryDark = Color(0xFF5A6C7D);
  static const Color borderDark = Color(0xFF1E3A4F);
  static const Color borderMutedDark = Color(0xFF1A3447);

  // ── Badges ──────────────────────────────────────────────────
  static const Color badgeVerified = Color(0xFF0F2B3D);
  static const Color badgeCertified = Color(0xFF0E7C5B);
  static const Color badgeTrusted = Color(0xFFC5A059);
  static const Color badgePremium = Color(0xFFC5A059);

  // ── Overlays ────────────────────────────────────────────────
  static const Color overlayDark = Color(0x990F2B3D);
  static const Color overlayLight = Color(0x66FFFFFF);
}

class AppTheme {
  static ThemeData light() {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.primary,
        brightness: Brightness.light,
        primary: AppColors.primary,
        secondary: AppColors.gold,
        surface: AppColors.surfaceLight,
        error: AppColors.error,
      ),
      scaffoldBackgroundColor: AppColors.bgLight,
      fontFamily: 'Poppins',
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.surfaceLight,
        foregroundColor: AppColors.textPrimaryLight,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        titleTextStyle: TextStyle(
          fontFamily: 'Poppins',
          fontSize: 18,
          fontWeight: FontWeight.w700,
          color: AppColors.textPrimaryLight,
          letterSpacing: -0.3,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          minimumSize: const Size(double.infinity, 52),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          textStyle: const TextStyle(
            fontFamily: 'Poppins',
            fontSize: 15,
            fontWeight: FontWeight.w600,
            letterSpacing: -0.2,
          ),
          elevation: 0,
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.primary,
          minimumSize: const Size(double.infinity, 52),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          side: const BorderSide(color: AppColors.borderLight, width: 1.2),
          textStyle: const TextStyle(
            fontFamily: 'Poppins',
            fontSize: 15,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColors.primary,
          textStyle: const TextStyle(
            fontFamily: 'Poppins',
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.surfaceLight,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.borderLight),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.borderLight),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.error),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.error, width: 1.5),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        hintStyle: const TextStyle(color: AppColors.textTertiaryLight, fontSize: 14, fontWeight: FontWeight.w400),
        labelStyle: const TextStyle(color: AppColors.textSecondaryLight, fontSize: 14),
        prefixIconColor: AppColors.textTertiaryLight,
        suffixIconColor: AppColors.textTertiaryLight,
      ),
      cardTheme: CardThemeData(
        color: AppColors.surfaceLight,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: AppColors.borderLight),
        ),
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: AppColors.surfaceLight,
        selectedItemColor: AppColors.primary,
        unselectedItemColor: AppColors.textTertiaryLight,
        type: BottomNavigationBarType.fixed,
        elevation: 0,
        selectedLabelStyle: TextStyle(fontFamily: 'Poppins', fontSize: 11, fontWeight: FontWeight.w600),
        unselectedLabelStyle: TextStyle(fontFamily: 'Poppins', fontSize: 11, fontWeight: FontWeight.w500),
      ),
      dividerTheme: const DividerThemeData(color: AppColors.borderLight, thickness: 1),
      chipTheme: ChipThemeData(
        backgroundColor: AppColors.surfaceMutedLight,
        selectedColor: AppColors.primary,
        labelStyle: const TextStyle(fontFamily: 'Poppins', fontSize: 13, fontWeight: FontWeight.w500),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20), side: const BorderSide(color: AppColors.borderLight)),
      ),
    );
  }

  static ThemeData dark() {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.primary,
        brightness: Brightness.dark,
        primary: AppColors.gold,
        secondary: AppColors.primary,
        surface: AppColors.surfaceDark,
        error: AppColors.error,
      ),
      scaffoldBackgroundColor: AppColors.bgDark,
      fontFamily: 'Poppins',
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.bgDark,
        foregroundColor: AppColors.textPrimaryDark,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        titleTextStyle: TextStyle(
          fontFamily: 'Poppins',
          fontSize: 18,
          fontWeight: FontWeight.w700,
          color: AppColors.textPrimaryDark,
          letterSpacing: -0.3,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.gold,
          foregroundColor: AppColors.primaryDark,
          minimumSize: const Size(double.infinity, 52),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          textStyle: const TextStyle(
            fontFamily: 'Poppins',
            fontSize: 15,
            fontWeight: FontWeight.w700,
            letterSpacing: -0.2,
          ),
          elevation: 0,
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.textPrimaryDark,
          minimumSize: const Size(double.infinity, 52),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          side: const BorderSide(color: AppColors.borderDark, width: 1.2),
          textStyle: const TextStyle(
            fontFamily: 'Poppins',
            fontSize: 15,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.surfaceDark,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.borderDark),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.borderDark),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.gold, width: 1.5),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        hintStyle: const TextStyle(color: AppColors.textTertiaryDark, fontSize: 14),
        labelStyle: const TextStyle(color: AppColors.textSecondaryDark, fontSize: 14),
      ),
      cardTheme: CardThemeData(
        color: AppColors.surfaceDark,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: AppColors.borderDark),
        ),
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: AppColors.bgDark,
        selectedItemColor: AppColors.gold,
        unselectedItemColor: AppColors.textTertiaryDark,
        type: BottomNavigationBarType.fixed,
        elevation: 0,
        selectedLabelStyle: TextStyle(fontFamily: 'Poppins', fontSize: 11, fontWeight: FontWeight.w600),
        unselectedLabelStyle: TextStyle(fontFamily: 'Poppins', fontSize: 11, fontWeight: FontWeight.w500),
      ),
      dividerTheme: const DividerThemeData(color: AppColors.borderDark, thickness: 1),
    );
  }
}

class AppTextStyles {
  static const TextStyle display = TextStyle(fontSize: 32, fontWeight: FontWeight.w700, fontFamily: 'Poppins', letterSpacing: -1.2, height: 1.1);
  static const TextStyle h1 = TextStyle(fontSize: 28, fontWeight: FontWeight.w700, fontFamily: 'Poppins', letterSpacing: -0.8, height: 1.2);
  static const TextStyle h2 = TextStyle(fontSize: 22, fontWeight: FontWeight.w700, fontFamily: 'Poppins', letterSpacing: -0.5, height: 1.3);
  static const TextStyle h3 = TextStyle(fontSize: 18, fontWeight: FontWeight.w600, fontFamily: 'Poppins', letterSpacing: -0.3, height: 1.4);
  static const TextStyle h4 = TextStyle(fontSize: 16, fontWeight: FontWeight.w600, fontFamily: 'Poppins', letterSpacing: -0.2, height: 1.4);
  static const TextStyle body1 = TextStyle(fontSize: 15, fontWeight: FontWeight.w400, fontFamily: 'Poppins', height: 1.6);
  static const TextStyle body2 = TextStyle(fontSize: 14, fontWeight: FontWeight.w400, fontFamily: 'Poppins', height: 1.5);
  static const TextStyle caption = TextStyle(fontSize: 12, fontWeight: FontWeight.w400, fontFamily: 'Poppins', height: 1.4);
  static const TextStyle label = TextStyle(fontSize: 13, fontWeight: FontWeight.w600, fontFamily: 'Poppins', letterSpacing: -0.1);
  static const TextStyle labelSmall = TextStyle(fontSize: 11, fontWeight: FontWeight.w600, fontFamily: 'Poppins', letterSpacing: 0.3);
  static const TextStyle price = TextStyle(fontSize: 20, fontWeight: FontWeight.w700, fontFamily: 'Poppins', color: AppColors.primary, letterSpacing: -0.5);
  static const TextStyle priceSmall = TextStyle(fontSize: 15, fontWeight: FontWeight.w700, fontFamily: 'Poppins', color: AppColors.primary, letterSpacing: -0.3);
}
