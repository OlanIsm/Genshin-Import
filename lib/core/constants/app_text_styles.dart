import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

class AppTextStyles {
  AppTextStyles._();

  // ── Cinzel (Fantasy Serif) — Headings ─────────────────────────────────────
  static TextStyle get displayLarge => GoogleFonts.cinzel(
    fontSize: 32,
    fontWeight: FontWeight.w700,
    color: AppColors.gold,
    letterSpacing: 2.0,
  );

  static TextStyle get headingLarge => GoogleFonts.cinzel(
    fontSize: 24,
    fontWeight: FontWeight.w600,
    color: AppColors.gold,
    letterSpacing: 1.5,
  );

  static TextStyle get headingMedium => GoogleFonts.cinzel(
    fontSize: 20,
    fontWeight: FontWeight.w600,
    color: AppColors.gold,
    letterSpacing: 1.0,
  );

  static TextStyle get headingSmall => GoogleFonts.cinzel(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: AppColors.gold,
    letterSpacing: 0.8,
  );

  // ── Raleway (Clean Sans-Serif) — Body ────────────────────────────────────
  static TextStyle get bodyLarge => GoogleFonts.raleway(
    fontSize: 16,
    fontWeight: FontWeight.w500,
    color: AppColors.textPrimary,
  );

  static TextStyle get bodyMedium => GoogleFonts.raleway(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: AppColors.textPrimary,
  );

  static TextStyle get bodySmall => GoogleFonts.raleway(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    color: AppColors.textSecondary,
  );

  static TextStyle get caption => GoogleFonts.raleway(
    fontSize: 11,
    fontWeight: FontWeight.w400,
    color: AppColors.textHint,
    letterSpacing: 0.5,
  );

  static TextStyle get labelMedium => GoogleFonts.raleway(
    fontSize: 13,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
    letterSpacing: 0.4,
  );

  static TextStyle get price => GoogleFonts.cinzel(
    fontSize: 18,
    fontWeight: FontWeight.w700,
    color: AppColors.goldLight,
    letterSpacing: 0.5,
  );

  static TextStyle get buttonText => GoogleFonts.raleway(
    fontSize: 15,
    fontWeight: FontWeight.w700,
    color: AppColors.bgDarkNavy,
    letterSpacing: 1.2,
  );

  static TextStyle get errorText => GoogleFonts.raleway(
    fontSize: 12,
    fontWeight: FontWeight.w500,
    color: AppColors.error,
  );

  static TextStyle get hintText => GoogleFonts.raleway(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: AppColors.textHint,
  );
}
