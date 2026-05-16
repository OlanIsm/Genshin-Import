import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  // ── Primary Backgrounds ──────────────────────────────────────────────────
  static const Color bgDarkNavy   = Color(0xFF0D0E2B);
  static const Color bgRoyalBlue  = Color(0xFF1A1F5E);
  static const Color bgDeepPurple = Color(0xFF2D1B69);
  static const Color bgCard       = Color(0xFF151A3F);

  // ── Gold Accents ──────────────────────────────────────────────────────────
  static const Color gold         = Color(0xFFD4AF37);
  static const Color goldLight    = Color(0xFFF5D76E);
  static const Color goldDark     = Color(0xFF9E7A0F);

  // ── Text ──────────────────────────────────────────────────────────────────
  static const Color textPrimary   = Color(0xFFF0F0F0);
  static const Color textSecondary = Color(0xFFB0B8D4);
  static const Color textHint      = Color(0xFF6B7A99);

  // ── Element Colors ────────────────────────────────────────────────────────
  static const Color anemo    = Color(0xFF74C69D);
  static const Color pyro     = Color(0xFFFF6B35);
  static const Color hydro    = Color(0xFF4FC3F7);
  static const Color electro  = Color(0xFFAA77FF);
  static const Color cryo     = Color(0xFF8ECAE6);
  static const Color geo      = Color(0xFFFFB703);
  static const Color dendro   = Color(0xFF70E000);

  // ── Status ────────────────────────────────────────────────────────────────
  static const Color error    = Color(0xFFE74C3C);
  static const Color success  = Color(0xFF2ECC71);
  static const Color warning  = Color(0xFFF39C12);

  // ── Glass / Overlay ───────────────────────────────────────────────────────
  static const Color glassWhite  = Color(0x0FFFFFFF);
  static const Color glassBorder = Color(0x33D4AF37);
  static const Color glassWhite2 = Color(0x1AFFFFFF);
  static const Color overlay     = Color(0xCC000000);

  // ── Rarity Colors ────────────────────────────────────────────────────────
  static const Color rarity5 = Color(0xFFB87333); // 5★ orange-gold
  static const Color rarity4 = Color(0xFF7E57C2); // 4★ purple
  static const Color rarity3 = Color(0xFF1E88E5); // 3★ blue

  // ── Gradients ────────────────────────────────────────────────────────────
  static const LinearGradient bgGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [bgDarkNavy, bgRoyalBlue, bgDeepPurple],
  );

  static const LinearGradient goldGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [goldDark, gold, goldLight, gold],
  );

  static const LinearGradient cardGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF1C2050), Color(0xFF0F1230)],
  );

  static const LinearGradient bannerGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [Colors.transparent, Color(0xDD0D0E2B)],
  );
}
