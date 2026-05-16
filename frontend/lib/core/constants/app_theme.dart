import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

class AppTheme {
  AppTheme._();

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: AppColors.bgDarkNavy,
      colorScheme: const ColorScheme.dark(
        primary: AppColors.gold,
        secondary: AppColors.hydro,
        surface: AppColors.bgCard,
        error: AppColors.error,
        onPrimary: AppColors.bgDarkNavy,
        onSecondary: AppColors.bgDarkNavy,
        onSurface: AppColors.textPrimary,
        onError: Colors.white,
      ),
      textTheme: GoogleFonts.ralewayTextTheme(ThemeData.dark().textTheme).copyWith(
        displayLarge: GoogleFonts.cinzel(
          fontSize: 32, fontWeight: FontWeight.w700, color: AppColors.gold,
        ),
        headlineMedium: GoogleFonts.cinzel(
          fontSize: 20, fontWeight: FontWeight.w600, color: AppColors.gold,
        ),
        bodyLarge: GoogleFonts.raleway(fontSize: 16, color: AppColors.textPrimary),
        bodyMedium: GoogleFonts.raleway(fontSize: 14, color: AppColors.textSecondary),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: GoogleFonts.cinzel(
          fontSize: 20, fontWeight: FontWeight.w600, color: AppColors.gold,
          letterSpacing: 1.5,
        ),
        iconTheme: const IconThemeData(color: AppColors.gold),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.glassWhite2,
        hintStyle: GoogleFonts.raleway(color: AppColors.textHint, fontSize: 14),
        labelStyle: GoogleFonts.raleway(color: AppColors.textSecondary, fontSize: 14),
        errorStyle: GoogleFonts.raleway(color: AppColors.error, fontSize: 12),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.glassBorder),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.glassBorder, width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.gold, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.error, width: 1.5),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.error, width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.gold,
          foregroundColor: AppColors.bgDarkNavy,
          minimumSize: const Size(double.infinity, 52),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          textStyle: GoogleFonts.raleway(fontSize: 15, fontWeight: FontWeight.w700, letterSpacing: 1.2),
        ),
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: AppColors.bgCard,
        selectedItemColor: AppColors.gold,
        unselectedItemColor: AppColors.textHint,
        type: BottomNavigationBarType.fixed,
        elevation: 0,
      ),
      chipTheme: ChipThemeData(
        backgroundColor: AppColors.glassWhite2,
        selectedColor: AppColors.gold.withAlpha(50),
        labelStyle: GoogleFonts.raleway(fontSize: 12, color: AppColors.textPrimary),
        side: const BorderSide(color: AppColors.glassBorder),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      ),
      dividerTheme: const DividerThemeData(
        color: AppColors.glassBorder,
        thickness: 0.5,
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: AppColors.bgCard,
        contentTextStyle: GoogleFonts.raleway(color: AppColors.textPrimary),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        behavior: SnackBarBehavior.floating,
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: AppColors.bgCard,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        titleTextStyle: GoogleFonts.cinzel(fontSize: 18, color: AppColors.gold, fontWeight: FontWeight.w600),
        contentTextStyle: GoogleFonts.raleway(fontSize: 14, color: AppColors.textSecondary),
      ),
    );
  }
}
