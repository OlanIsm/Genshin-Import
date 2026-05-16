import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:shimmer/shimmer.dart';
import '../core/constants/app_colors.dart';
import '../core/constants/app_text_styles.dart';
import '../core/models/weapon.dart';
import 'rarity_stars.dart';
import 'elemental_badge.dart';

/// Glassmorphism weapon card with rarity shimmer, element badge, and buy button
class WeaponCard extends StatelessWidget {
  final Weapon weapon;
  final VoidCallback? onTap;
  final VoidCallback? onBuyNow;

  const WeaponCard({
    super.key,
    required this.weapon,
    this.onTap,
    this.onBuyNow,
  });

  Color get _rarityColor {
    switch (weapon.rarity) {
      case 5: return AppColors.rarity5;
      case 4: return AppColors.rarity4;
      default: return AppColors.rarity3;
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: _rarityColor.withAlpha(100), width: 1),
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF1C2050), Color(0xFF0F1230)],
          ),
          boxShadow: [
            BoxShadow(
              color: _rarityColor.withAlpha(40),
              blurRadius: 12,
              spreadRadius: 1,
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Image ──────────────────────────────────────────────────────
              Expanded(
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    CachedNetworkImage(
                      imageUrl: weapon.imageUrl,
                      fit: BoxFit.cover,
                      placeholder: (_, __) => Shimmer.fromColors(
                        baseColor: const Color(0xFF1C2050),
                        highlightColor: const Color(0xFF2D3580),
                        child: Container(color: Colors.white),
                      ),
                      errorWidget: (_, __, ___) => Container(
                        color: AppColors.bgCard,
                        child: const Icon(Icons.auto_awesome, color: AppColors.gold, size: 40),
                      ),
                    ),
                    // Gradient overlay
                    const DecoratedBox(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [Colors.transparent, Color(0xCC0D0E2B)],
                          stops: [0.5, 1.0],
                        ),
                      ),
                    ),
                    // Rarity badge top-left
                    Positioned(
                      top: 8, left: 8,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: _rarityColor.withAlpha(220),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: RarityStars(rarity: weapon.rarity, size: 10),
                      ),
                    ),
                    // Element badge top-right
                    Positioned(
                      top: 8, right: 8,
                      child: ElementalBadge(element: weapon.element),
                    ),
                    // Stock indicator bottom-right
                    Positioned(
                      bottom: 8, right: 8,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: weapon.stock > 0
                              ? AppColors.success.withAlpha(200)
                              : AppColors.error.withAlpha(200),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          weapon.stock > 0 ? 'Stock: ${weapon.stock}' : 'Out of Stock',
                          style: AppTextStyles.caption.copyWith(color: Colors.white, fontSize: 10),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              // ── Info ───────────────────────────────────────────────────────
              Padding(
                padding: const EdgeInsets.fromLTRB(10, 8, 10, 4),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(weapon.name, style: AppTextStyles.headingSmall.copyWith(fontSize: 13),
                      maxLines: 1, overflow: TextOverflow.ellipsis),
                    const SizedBox(height: 2),
                    Text(weapon.typeLabel, style: AppTextStyles.caption),
                    const SizedBox(height: 4),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Rp ${weapon.price.toStringAsFixed(0)}',
                          style: AppTextStyles.price.copyWith(fontSize: 13),
                        ),
                        GestureDetector(
                          onTap: onBuyNow,
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                            decoration: BoxDecoration(
                              gradient: AppColors.goldGradient,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text('Buy', style: AppTextStyles.buttonText.copyWith(fontSize: 11)),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
