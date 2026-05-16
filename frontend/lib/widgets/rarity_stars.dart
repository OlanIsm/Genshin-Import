import 'package:flutter/material.dart';
import '../core/constants/app_colors.dart';

class RarityStars extends StatelessWidget {
  final int rarity;
  final double size;

  const RarityStars({super.key, required this.rarity, this.size = 14});

  Color get _color {
    switch (rarity) {
      case 5: return AppColors.rarity5;
      case 4: return AppColors.rarity4;
      default: return AppColors.rarity3;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(
        rarity,
        (i) => Icon(Icons.star_rounded, color: _color, size: size),
      ),
    );
  }
}
