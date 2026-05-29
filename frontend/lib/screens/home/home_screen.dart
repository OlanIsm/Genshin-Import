import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_text_styles.dart';
import '../../core/providers/weapon_provider.dart';
import '../../core/providers/cart_provider.dart';
import '../../core/models/weapon.dart';
import '../../core/models/artifact.dart';
import '../../widgets/weapon_card.dart';
import '../../widgets/genshin_button.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _carouselIdx = 0;
  final _searchCtrl = TextEditingController();

  static const _categories = [
    'All', 'Sword', 'Claymore', 'Polearm', 'Catalyst', 'Bow', 'Artifacts'
  ];

  static const _categoryIcons = [
    Icons.all_inclusive,
    Icons.auto_awesome,
    Icons.hardware,
    Icons.south,
    Icons.blur_on,
    Icons.architecture,
    Icons.diamond,
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<WeaponProvider>().loadWeapons();
    });
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final weaponProvider = context.watch<WeaponProvider>();

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(gradient: AppColors.bgGradient),
        child: SafeArea(
          child: CustomScrollView(
            slivers: [
              // ── App Bar ──────────────────────────────────────────────────
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                  child: Row(
                    children: [
                      const Icon(Icons.auto_awesome, color: AppColors.gold, size: 28),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text('Genshin Import', style: AppTextStyles.headingMedium),
                      ),
                      Stack(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.notifications_outlined, color: AppColors.textSecondary),
                            onPressed: () {},
                          ),
                          Positioned(
                            right: 8, top: 8,
                            child: Container(
                              width: 8, height: 8,
                              decoration: const BoxDecoration(
                                color: AppColors.pyro, shape: BoxShape.circle,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              // ── Search Bar ───────────────────────────────────────────────
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                  child: TextField(
                    controller: _searchCtrl,
                    style: AppTextStyles.bodyMedium,
                    onChanged: (v) => weaponProvider.setSearchQuery(v),
                    decoration: InputDecoration(
                      hintText: 'Search weapons and artifacts...',
                      hintStyle: AppTextStyles.hintText,
                      prefixIcon: const Icon(Icons.search, color: AppColors.textHint),
                      suffixIcon: _searchCtrl.text.isNotEmpty
                          ? IconButton(
                              icon: const Icon(Icons.clear, color: AppColors.textHint, size: 18),
                              onPressed: () {
                                _searchCtrl.clear();
                                weaponProvider.setSearchQuery('');
                              },
                            )
                          : const Icon(Icons.diamond_outlined,
                              color: AppColors.gold, size: 18),
                      filled: true,
                      fillColor: AppColors.glassWhite2,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide: const BorderSide(color: AppColors.glassBorder),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide: const BorderSide(color: AppColors.glassBorder),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide: const BorderSide(color: AppColors.gold, width: 1.5),
                      ),
                      contentPadding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                  ),
                ).animate().fadeIn(delay: 200.ms),
              ),

              // ── Featured Banner ──────────────────────────────────────────
              if (weaponProvider.featuredWeapons.isNotEmpty)
                SliverToBoxAdapter(child: _buildFeaturedBanner(weaponProvider)),

              // ── Categories ───────────────────────────────────────────────
              SliverToBoxAdapter(child: _buildCategories(weaponProvider)),

              // ── Weapons Grid ─────────────────────────────────────────────
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                sliver: _buildWeaponsGrid(weaponProvider),
              ),

              // ── Daily Deals ──────────────────────────────────────────────
              SliverToBoxAdapter(child: _buildDailyDeals(weaponProvider)),

              const SliverToBoxAdapter(child: SizedBox(height: 80)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFeaturedBanner(WeaponProvider provider) {
    final featured = provider.featuredWeapons;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 20, 16, 12),
          child: Row(
            children: [
              const Icon(Icons.local_fire_department, color: AppColors.pyro, size: 18),
              const SizedBox(width: 6),
              Text('Legendary Weapons', style: AppTextStyles.headingSmall),
            ],
          ),
        ),
        CarouselSlider.builder(
          itemCount: featured.length,
          options: CarouselOptions(
            height: 200,
            viewportFraction: 0.88,
            enableInfiniteScroll: true,
            autoPlay: true,
            autoPlayInterval: const Duration(seconds: 4),
            autoPlayCurve: Curves.fastOutSlowIn,
            onPageChanged: (i, _) => setState(() => _carouselIdx = i),
          ),
          itemBuilder: (ctx, i, _) {
            final weapon = featured[i];
            return GestureDetector(
              onTap: () => context.push('/weapon/${weapon.id}'),
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 4),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: AppColors.gold.withAlpha(80), width: 1),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.gold.withAlpha(30),
                      blurRadius: 20,
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      CachedNetworkImage(
                        imageUrl: weapon.imageUrl,
                        fit: BoxFit.cover,
                        errorWidget: (_, __, ___) => Container(
                          color: AppColors.bgCard,
                          child: const Icon(Icons.auto_awesome,
                              color: AppColors.gold, size: 60),
                        ),
                      ),
                      // Gradient overlay
                      const DecoratedBox(
                        decoration: BoxDecoration(
                          gradient: AppColors.bannerGradient,
                        ),
                      ),
                      // Weapon info
                      Positioned(
                        bottom: 16, left: 16, right: 16,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                    decoration: BoxDecoration(
                                      color: AppColors.rarity5.withAlpha(220),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Text('5★ Legendary',
                                      style: AppTextStyles.caption.copyWith(color: Colors.white)),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(weapon.name,
                                    style: AppTextStyles.headingSmall.copyWith(fontSize: 15),
                                    maxLines: 1, overflow: TextOverflow.ellipsis),
                                  Text(weapon.typeLabel,
                                    style: AppTextStyles.caption),
                                ],
                              ),
                            ),
                            const SizedBox(width: 12),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                              decoration: BoxDecoration(
                                gradient: AppColors.goldGradient,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text('Rp ${(weapon.price / 1000).toStringAsFixed(0)}K',
                                    style: AppTextStyles.buttonText.copyWith(fontSize: 13)),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
        const SizedBox(height: 10),
        // Dots indicator
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(
            featured.length,
            (i) => AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              margin: const EdgeInsets.symmetric(horizontal: 3),
              width: _carouselIdx == i ? 20 : 6,
              height: 6,
              decoration: BoxDecoration(
                color: _carouselIdx == i ? AppColors.gold : AppColors.glassBorder,
                borderRadius: BorderRadius.circular(3),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCategories(WeaponProvider provider) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 20, 16, 12),
          child: Text('Categories', style: AppTextStyles.headingSmall),
        ),
        SizedBox(
          height: 80,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            itemCount: _categories.length,
            itemBuilder: (ctx, i) {
              final cat = _categories[i];
              final selected = provider.selectedCategory == cat;
              return GestureDetector(
                onTap: () => provider.setCategory(cat),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color: selected ? AppColors.gold : AppColors.glassBorder,
                      width: selected ? 1.5 : 1,
                    ),
                    gradient: selected
                        ? const LinearGradient(
                            colors: [Color(0x33D4AF37), Color(0x1AD4AF37)])
                        : null,
                    color: selected ? null : AppColors.glassWhite2,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        _categoryIcons[i],
                        color: selected ? AppColors.gold : AppColors.textSecondary,
                        size: 22,
                      ),
                      const SizedBox(height: 4),
                      Text(cat,
                        style: AppTextStyles.caption.copyWith(
                          color: selected ? AppColors.gold : AppColors.textSecondary,
                          fontWeight: selected ? FontWeight.w700 : FontWeight.w400,
                        )),
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

  Widget _buildWeaponsGrid(WeaponProvider provider) {
    if (provider.isLoading) {
      return const SliverToBoxAdapter(
        child: Center(
          child: Padding(
            padding: EdgeInsets.all(40),
            child: CircularProgressIndicator(color: AppColors.gold),
          ),
        ),
      );
    }

    final displayList = provider.selectedCategory == 'Artifacts'
        ? <dynamic>[...provider.artifacts]
        : <dynamic>[...provider.weapons];

    if (displayList.isEmpty) {
      return SliverToBoxAdapter(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(40),
            child: Column(
              children: [
                const Icon(Icons.search_off, color: AppColors.textHint, size: 48),
                const SizedBox(height: 12),
                Text('No items found', style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.textHint)),
              ],
            ),
          ),
        ),
      );
    }

    if (provider.selectedCategory != 'Artifacts') {
      return SliverGrid(
        delegate: SliverChildBuilderDelegate(
          (ctx, i) {
            final w = displayList[i] as Weapon;
            return WeaponCard(
              weapon: w,
              onTap: () => context.push('/weapon/${w.id}'),
              onBuyNow: () {
                context.read<CartProvider>().addWeapon(w, 1);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('${w.name} added to cart!',
                      style: AppTextStyles.bodySmall),
                    backgroundColor: AppColors.bgCard,
                    duration: const Duration(seconds: 2),
                    action: SnackBarAction(
                      label: 'View Cart',
                      textColor: AppColors.gold,
                      onPressed: () => context.go('/cart'),
                    ),
                  ),
                );
              },
            ).animate(delay: (i * 50).ms).fadeIn().slideY(begin: 0.2, end: 0);
          },
          childCount: displayList.length,
        ),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 12,
          crossAxisSpacing: 12,
          childAspectRatio: 0.72,
        ),
      );
    }

    // Artifacts list
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (ctx, i) {
          final a = provider.artifacts[i];
          return Container(
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: AppColors.glassBorder),
              color: AppColors.glassWhite2,
            ),
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: CachedNetworkImage(
                    imageUrl: a.imageUrl,
                    width: 70, height: 70, fit: BoxFit.cover,
                    errorWidget: (_, __, ___) => Container(
                      width: 70, height: 70,
                      color: AppColors.bgCard,
                      child: const Icon(Icons.diamond, color: AppColors.gold),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(a.name, style: AppTextStyles.headingSmall.copyWith(fontSize: 13)),
                      Text(a.setName, style: AppTextStyles.caption),
                      const SizedBox(height: 4),
                      Text(a.typeLabel, style: AppTextStyles.caption.copyWith(color: AppColors.hydro)),
                      const SizedBox(height: 6),
                      Text('Rp ${a.price.toStringAsFixed(0)}',
                        style: AppTextStyles.price.copyWith(fontSize: 14)),
                    ],
                  ),
                ),
                GenshinButton(
                  label: 'Buy',
                  width: 70,
                  height: 36,
                  onPressed: () {
                    context.read<CartProvider>().addArtifact(a, 1);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('${a.name} added to cart!',
                          style: AppTextStyles.bodySmall),
                        backgroundColor: AppColors.bgCard,
                        duration: const Duration(seconds: 2),
                        action: SnackBarAction(
                          label: 'View Cart',
                          textColor: AppColors.gold,
                          onPressed: () => context.go('/cart'),
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          );
        },
        childCount: provider.artifacts.length,
      ),
    );
  }

  Widget _buildDailyDeals(WeaponProvider provider) {
    final deals = provider.allWeapons.where((w) => w.rarity == 4).take(5).toList();
    if (deals.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
          child: Row(
            children: [
              const Icon(Icons.flash_on, color: AppColors.geo, size: 18),
              const SizedBox(width: 6),
              Text('Daily Deals', style: AppTextStyles.headingSmall),
              const Spacer(),
              TextButton(
                onPressed: () {},
                child: Text('See all', style: AppTextStyles.caption.copyWith(color: AppColors.gold)),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 160,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: deals.length,
            itemBuilder: (ctx, i) {
              final w = deals[i];
              return GestureDetector(
                onTap: () => context.push('/weapon/${w.id}'),
                child: Container(
                  width: 140,
                  margin: const EdgeInsets.only(right: 12),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: AppColors.geo.withAlpha(80)),
                    color: AppColors.glassWhite2,
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(14),
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        CachedNetworkImage(
                          imageUrl: w.imageUrl,
                          fit: BoxFit.cover,
                          errorWidget: (_, __, ___) => Container(
                            color: AppColors.bgCard,
                            child: const Icon(Icons.auto_awesome, color: AppColors.gold),
                          ),
                        ),
                        const DecoratedBox(decoration: BoxDecoration(gradient: AppColors.bannerGradient)),
                        Positioned(
                          top: 8, right: 8,
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                            decoration: BoxDecoration(
                              color: AppColors.geo,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text('-15%', style: AppTextStyles.caption.copyWith(
                              color: AppColors.bgDarkNavy, fontWeight: FontWeight.w700)),
                          ),
                        ),
                        Positioned(
                          bottom: 8, left: 8, right: 8,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(w.name, style: AppTextStyles.caption.copyWith(
                                color: Colors.white, fontWeight: FontWeight.w600),
                                maxLines: 1, overflow: TextOverflow.ellipsis),
                              Text('Rp ${w.price.toStringAsFixed(0)}',
                                style: AppTextStyles.price.copyWith(fontSize: 12)),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }
}
