import 'package:flutter/material.dart';
import '../core/constants/app_colors.dart';
import '../core/models/weapon.dart';

/// Colored elemental badge chip (Anemo=green, Pyro=orange, etc.)
class ElementalBadge extends StatelessWidget {
  final ElementType element;
  final bool showLabel;
  final double size;

  const ElementalBadge({
    super.key,
    required this.element,
    this.showLabel = false,
    this.size = 24,
  });

  static Color colorFor(ElementType element) {
    switch (element) {
      case ElementType.anemo:   return AppColors.anemo;
      case ElementType.pyro:    return AppColors.pyro;
      case ElementType.hydro:   return AppColors.hydro;
      case ElementType.electro: return AppColors.electro;
      case ElementType.cryo:    return AppColors.cryo;
      case ElementType.geo:     return AppColors.geo;
      case ElementType.dendro:  return AppColors.dendro;
      case ElementType.none:    return AppColors.textHint;
    }
  }

  static IconData iconFor(ElementType element) {
    switch (element) {
      case ElementType.anemo:   return Icons.air;
      case ElementType.pyro:    return Icons.local_fire_department;
      case ElementType.hydro:   return Icons.water_drop;
      case ElementType.electro: return Icons.bolt;
      case ElementType.cryo:    return Icons.ac_unit;
      case ElementType.geo:     return Icons.landscape;
      case ElementType.dendro:  return Icons.eco;
      case ElementType.none:    return Icons.auto_awesome;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (element == ElementType.none && !showLabel) return const SizedBox.shrink();
    final color = colorFor(element);
    return Container(
      padding: EdgeInsets.all(showLabel ? 6 : 4),
      decoration: BoxDecoration(
        color: color.withAlpha(40),
        shape: showLabel ? BoxShape.rectangle : BoxShape.circle,
        borderRadius: showLabel ? BorderRadius.circular(20) : null,
        border: Border.all(color: color.withAlpha(120), width: 1),
      ),
      child: showLabel
          ? Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(iconFor(element), color: color, size: 14),
                const SizedBox(width: 4),
                Text(
                  element.name.substring(0, 1).toUpperCase() + element.name.substring(1),
                  style: TextStyle(color: color, fontSize: 11, fontWeight: FontWeight.w600),
                ),
              ],
            )
          : Icon(iconFor(element), color: color, size: size * 0.6),
    );
  }
}
