import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_text_styles.dart';
import '../../core/models/weapon.dart';
import '../../core/providers/weapon_provider.dart';
import '../../core/providers/cart_provider.dart';
import '../../widgets/genshin_button.dart';
import '../../widgets/rarity_stars.dart';
import '../../widgets/elemental_badge.dart';

class WeaponDetailScreen extends StatefulWidget {
  final String weaponId;
  const WeaponDetailScreen({super.key, required this.weaponId});

  @override
  State<WeaponDetailScreen> createState() => _WeaponDetailScreenState();
}

class _WeaponDetailScreenState extends State<WeaponDetailScreen> {
  int _quantity = 1;
  Weapon? _weapon;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final id = int.tryParse(widget.weaponId) ?? 0;
      final provider = context.read<WeaponProvider>();
      try {
        setState(() {
          _weapon = provider.allWeapons.firstWhere((w) => w.id == id);
        });
      } catch (_) {}
    });
  }

  void _addToCart() {
    if (_weapon == null) return;
    context.read<CartProvider>().addWeapon(_weapon!, _quantity);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.shopping_cart_checkout, color: AppColors.gold, size: 18),
            const SizedBox(width: 8),
            Text('${_weapon!.name} ($_quantity) added to cart!',
              style: AppTextStyles.bodySmall),
          ],
        ),
        backgroundColor: AppColors.bgCard,
        action: SnackBarAction(
          label: 'View Cart',
          textColor: AppColors.gold,
          onPressed: () => context.go('/cart'),
        ),
      ),
    );
  }

  void _buyNow() {
    _addToCart();
    context.go('/cart');
  }

  @override
  Widget build(BuildContext context) {
    if (_weapon == null) {
      return Scaffold(
        backgroundColor: AppColors.bgDarkNavy,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios, color: AppColors.gold),
            onPressed: () => context.pop(),
          ),
        ),
        body: const Center(child: CircularProgressIndicator(color: AppColors.gold)),
      );
    }

    final weapon = _weapon!;
    final rarityColor = weapon.rarity == 5 ? AppColors.rarity5 : AppColors.rarity4;

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(gradient: AppColors.bgGradient),
        child: CustomScrollView(
          slivers: [
            // ── Hero Image App Bar ─────────────────────────────────────────
            SliverAppBar(
              expandedHeight: 320,
              pinned: true,
              backgroundColor: AppColors.bgDarkNavy,
              leading: IconButton(
                icon: Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: AppColors.bgDarkNavy.withAlpha(200),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.arrow_back_ios, color: AppColors.gold, size: 18),
                ),
                onPressed: () => context.pop(),
              ),
              actions: [
                Consumer<WeaponProvider>(
                  builder: (ctx, prov, _) {
                    final isFav = prov.allWeapons
                        .where((w) => w.id == weapon.id)
                        .firstOrNull?.isFavorite ?? false;
                    return IconButton(
                      icon: Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: AppColors.bgDarkNavy.withAlpha(200),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          isFav ? Icons.favorite : Icons.favorite_border,
                          color: isFav ? AppColors.pyro : AppColors.textSecondary,
                          size: 20,
                        ),
                      ),
                      onPressed: () => prov.toggleFavorite(weapon.id),
                    );
                  },
                ),
              ],
              flexibleSpace: FlexibleSpaceBar(
                background: Stack(
                  fit: StackFit.expand,
                  children: [
                    CachedNetworkImage(
                      imageUrl: weapon.imageUrl,
                      fit: BoxFit.cover,
                      errorWidget: (_, __, ___) => Container(
                        color: AppColors.bgCard,
                        child: const Icon(Icons.auto_awesome, color: AppColors.gold, size: 80),
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.transparent,
                            AppColors.bgDarkNavy.withAlpha(220),
                          ],
                          stops: const [0.4, 1.0],
                        ),
                      ),
                    ),
                    // Rarity glow
                    Positioned.fill(
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                              color: rarityColor.withAlpha(30),
                              blurRadius: 60,
                              spreadRadius: 20,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // ── Content ───────────────────────────────────────────────────
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 8, 20, 100),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Name + Type
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(weapon.name,
                                style: AppTextStyles.headingLarge.copyWith(fontSize: 22)),
                              const SizedBox(height: 4),
                              Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                    decoration: BoxDecoration(
                                      color: AppColors.glassWhite2,
                                      borderRadius: BorderRadius.circular(8),
                                      border: Border.all(color: AppColors.glassBorder),
                                    ),
                                    child: Text(weapon.typeLabel,
                                      style: AppTextStyles.caption.copyWith(color: AppColors.textSecondary)),
                                  ),
                                  const SizedBox(width: 8),
                                  ElementalBadge(element: weapon.element, showLabel: true),
                                ],
                              ),
                            ],
                          ),
                        ),
                        RarityStars(rarity: weapon.rarity, size: 16),
                      ],
                    ),

                    const SizedBox(height: 20),

                    // Stats chips
                    Text('Weapon Stats', style: AppTextStyles.headingSmall.copyWith(fontSize: 14)),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        _StatChip(label: 'ATK', value: weapon.attack.toString(), icon: Icons.workspace_premium),
                        const SizedBox(width: 10),
                        _StatChip(
                          label: 'CRIT Rate',
                          value: weapon.critRate > 0 ? '${weapon.critRate}%' : 'N/A',
                          icon: Icons.gps_fixed,
                          color: AppColors.electro,
                        ),
                        const SizedBox(width: 10),
                        _StatChip(
                          label: 'Rarity',
                          value: '${weapon.rarity}★',
                          icon: Icons.star_rounded,
                          color: rarityColor,
                        ),
                      ],
                    ),

                    const SizedBox(height: 24),

                    // Lore
                    Text('Weapon Lore', style: AppTextStyles.headingSmall.copyWith(fontSize: 14)),
                    const SizedBox(height: 10),
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: AppColors.glassBorder),
                        color: AppColors.glassWhite2,
                      ),
                      child: Text(weapon.description,
                        style: AppTextStyles.bodySmall.copyWith(
                          color: AppColors.textSecondary,
                          height: 1.6,
                        )),
                    ),

                    const SizedBox(height: 24),

                    // Price & Stock
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Price', style: AppTextStyles.caption),
                              Text('Rp ${weapon.price.toStringAsFixed(0)}',
                                style: AppTextStyles.price.copyWith(fontSize: 22)),
                            ],
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                          decoration: BoxDecoration(
                            color: weapon.stock > 0
                                ? AppColors.success.withAlpha(30)
                                : AppColors.error.withAlpha(30),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: weapon.stock > 0 ? AppColors.success : AppColors.error,
                              width: 0.5,
                            ),
                          ),
                          child: Text(
                            weapon.stock > 0 ? 'In Stock (${weapon.stock})' : 'Out of Stock',
                            style: AppTextStyles.labelMedium.copyWith(
                              color: weapon.stock > 0 ? AppColors.success : AppColors.error,
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 20),

                    // Quantity selector
                    if (weapon.stock > 0) ...[
                      Text('Quantity', style: AppTextStyles.caption),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          _QtyButton(
                            icon: Icons.remove,
                            onTap: () {
                              if (_quantity > 1) setState(() => _quantity--);
                            },
                          ),
                          const SizedBox(width: 16),
                          Text('$_quantity',
                            style: AppTextStyles.headingMedium.copyWith(
                              color: AppColors.textPrimary, fontSize: 20)),
                          const SizedBox(width: 16),
                          _QtyButton(
                            icon: Icons.add,
                            onTap: () {
                              if (_quantity < weapon.stock) setState(() => _quantity++);
                            },
                          ),
                          const Spacer(),
                          Text(
                            'Total: Rp ${(weapon.price * _quantity).toStringAsFixed(0)}',
                            style: AppTextStyles.labelMedium.copyWith(color: AppColors.goldLight),
                          ),
                        ],
                      ),
                      const SizedBox(height: 28),
                      Row(
                        children: [
                          Expanded(
                            child: GenshinButton(
                              label: 'Add to Cart',
                              icon: Icons.shopping_cart_outlined,
                              outlined: true,
                              onPressed: _addToCart,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: GenshinButton(
                              label: 'Buy Now',
                              icon: Icons.flash_on,
                              onPressed: _buyNow,
                            ),
                          ),
                        ],
                      ),
                    ],

                    const SizedBox(height: 32),

                    // Related weapons
                    _buildRelated(),
                  ],
                ).animate().fadeIn(duration: 600.ms).slideY(begin: 0.1, end: 0),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRelated() {
    final provider = context.read<WeaponProvider>();
    final related = provider.allWeapons
        .where((w) => w.type == _weapon!.type && w.id != _weapon!.id)
        .take(3)
        .toList();
    if (related.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Related Weapons', style: AppTextStyles.headingSmall.copyWith(fontSize: 14)),
        const SizedBox(height: 12),
        SizedBox(
          height: 80,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: related.length,
            itemBuilder: (ctx, i) {
              final w = related[i];
              return GestureDetector(
                onTap: () => context.pushReplacement('/weapon/${w.id}'),
                child: Container(
                  width: 200,
                  margin: const EdgeInsets.only(right: 12),
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.glassBorder),
                    color: AppColors.glassWhite2,
                  ),
                  child: Row(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: CachedNetworkImage(
                          imageUrl: w.imageUrl,
                          width: 50, height: 50, fit: BoxFit.cover,
                          errorWidget: (_, __, ___) => Container(
                            width: 50, height: 50,
                            color: AppColors.bgCard,
                            child: const Icon(Icons.auto_awesome, color: AppColors.gold),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(w.name, style: AppTextStyles.labelMedium.copyWith(fontSize: 12),
                              maxLines: 1, overflow: TextOverflow.ellipsis),
                            Text('Rp ${w.price.toStringAsFixed(0)}',
                              style: AppTextStyles.price.copyWith(fontSize: 12)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

class _StatChip extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color color;

  const _StatChip({
    required this.label,
    required this.value,
    required this.icon,
    this.color = AppColors.gold,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withAlpha(80)),
          color: color.withAlpha(20),
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 18),
            const SizedBox(height: 4),
            Text(value, style: AppTextStyles.labelMedium.copyWith(color: color, fontSize: 14)),
            Text(label, style: AppTextStyles.caption),
          ],
        ),
      ),
    );
  }
}

class _QtyButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _QtyButton({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 36, height: 36,
        decoration: BoxDecoration(
          border: Border.all(color: AppColors.gold, width: 1.5),
          borderRadius: BorderRadius.circular(8),
          color: AppColors.gold.withAlpha(20),
        ),
        child: Icon(icon, color: AppColors.gold, size: 18),
      ),
    );
  }
}
