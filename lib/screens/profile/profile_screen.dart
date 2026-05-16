import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_text_styles.dart';
import '../../core/providers/auth_provider.dart';
import '../../core/providers/weapon_provider.dart';
import '../../data/mock_data.dart';
import '../../widgets/genshin_button.dart';
import '../../widgets/weapon_card.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final user = auth.user;

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(gradient: AppColors.bgGradient),
        child: SafeArea(
          child: CustomScrollView(
            slivers: [
              // ── Profile Header ────────────────────────────────────────
              SliverToBoxAdapter(
                child: Container(
                  margin: const EdgeInsets.all(16),
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: AppColors.glassBorder),
                    gradient: const LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [Color(0xFF1C2050), Color(0xFF0F1230)],
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.gold.withAlpha(20),
                        blurRadius: 20,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      // Avatar
                      Container(
                        width: 72, height: 72,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: AppColors.goldGradient,
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.gold.withAlpha(80),
                              blurRadius: 15,
                            ),
                          ],
                        ),
                        child: ClipOval(
                          child: user?.avatarUrl != null
                              ? CachedNetworkImage(
                                  imageUrl: user!.avatarUrl!,
                                  fit: BoxFit.cover,
                                  errorWidget: (_, __, ___) => const Icon(
                                    Icons.person, color: AppColors.bgDarkNavy, size: 40),
                                )
                              : const Icon(Icons.person, color: AppColors.bgDarkNavy, size: 40),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(user?.username ?? 'Traveler',
                                  style: AppTextStyles.headingMedium.copyWith(fontSize: 18)),
                                const SizedBox(width: 8),
                                if (auth.isAdmin)
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                    decoration: BoxDecoration(
                                      gradient: AppColors.goldGradient,
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Text('ADMIN',
                                      style: AppTextStyles.caption.copyWith(
                                        color: AppColors.bgDarkNavy,
                                        fontWeight: FontWeight.w800,
                                        letterSpacing: 1,
                                      )),
                                  ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Text(user?.email ?? '', style: AppTextStyles.bodySmall),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                _ProfileStat(label: 'Orders', value: '${MockData.purchaseHistory.length}'),
                                Container(
                                  width: 1, height: 24,
                                  color: AppColors.glassBorder,
                                  margin: const EdgeInsets.symmetric(horizontal: 12),
                                ),
                                Consumer<WeaponProvider>(
                                  builder: (_, prov, __) => _ProfileStat(
                                    label: 'Favorites',
                                    value: '${prov.favoriteWeapons.length}',
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ).animate().fadeIn(duration: 600.ms).slideY(begin: -0.1, end: 0),
              ),

              // ── Bearer Token Display ──────────────────────────────────
              if (auth.token != null)
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: AppColors.success.withAlpha(80)),
                        color: AppColors.success.withAlpha(20),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.verified_user, color: AppColors.success, size: 18),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Bearer Token Active',
                                  style: AppTextStyles.labelMedium.copyWith(color: AppColors.success)),
                                Text(
                                  auth.token!.length > 40
                                      ? '${auth.token!.substring(0, 40)}...'
                                      : auth.token!,
                                  style: AppTextStyles.caption.copyWith(fontSize: 10),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

              // ── Purchase History ──────────────────────────────────────
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 20, 16, 8),
                  child: Row(
                    children: [
                      const Icon(Icons.receipt_long_outlined,
                          color: AppColors.gold, size: 18),
                      const SizedBox(width: 6),
                      Text('Purchase History', style: AppTextStyles.headingSmall),
                    ],
                  ),
                ),
              ),

              SliverList(
                delegate: SliverChildBuilderDelegate(
                  (ctx, i) {
                    final order = MockData.purchaseHistory[i];
                    return Container(
                      margin: const EdgeInsets.fromLTRB(16, 0, 16, 8),
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: AppColors.glassBorder),
                        color: AppColors.glassWhite2,
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 40, height: 40,
                            decoration: BoxDecoration(
                              color: AppColors.gold.withAlpha(30),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(Icons.auto_awesome, color: AppColors.gold, size: 20),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(order['name'] as String, style: AppTextStyles.labelMedium),
                                Text(order['date'] as String, style: AppTextStyles.caption),
                              ],
                            ),
                          ),
                          Text('Rp ${(order['price'] as double).toStringAsFixed(0)}',
                            style: AppTextStyles.price.copyWith(fontSize: 13)),
                        ],
                      ),
                    ).animate(delay: (i * 80).ms).fadeIn().slideX(begin: 0.1, end: 0);
                  },
                  childCount: MockData.purchaseHistory.length,
                ),
              ),

              // ── Favorites ─────────────────────────────────────────────
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 20, 16, 8),
                  child: Row(
                    children: [
                      const Icon(Icons.favorite_outline, color: AppColors.pyro, size: 18),
                      const SizedBox(width: 6),
                      Text('Favorite Weapons', style: AppTextStyles.headingSmall),
                    ],
                  ),
                ),
              ),

              Consumer<WeaponProvider>(
                builder: (ctx, prov, _) {
                  final favs = prov.favoriteWeapons;
                  if (favs.isEmpty) {
                    return SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                        child: Text('No favorites yet — tap ♡ on a weapon!',
                          style: AppTextStyles.bodySmall.copyWith(color: AppColors.textHint)),
                      ),
                    );
                  }
                  return SliverToBoxAdapter(
                    child: SizedBox(
                      height: 220,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        itemCount: favs.length,
                        itemBuilder: (ctx, i) => SizedBox(
                          width: 150,
                          child: Padding(
                            padding: const EdgeInsets.only(right: 12),
                            child: WeaponCard(weapon: favs[i]),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),

              // ── Settings ──────────────────────────────────────────────
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 20, 16, 8),
                  child: Row(
                    children: [
                      const Icon(Icons.settings_outlined, color: AppColors.textSecondary, size: 18),
                      const SizedBox(width: 6),
                      Text('Settings', style: AppTextStyles.headingSmall),
                    ],
                  ),
                ),
              ),

              SliverToBoxAdapter(
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: AppColors.glassBorder),
                    color: AppColors.glassWhite2,
                  ),
                  child: Column(
                    children: [
                      _SettingsTile(icon: Icons.notifications_outlined, label: 'Notifications', onTap: () {}),
                      const Divider(color: AppColors.glassBorder, height: 1),
                      _SettingsTile(icon: Icons.language_outlined, label: 'Language', onTap: () {}),
                      const Divider(color: AppColors.glassBorder, height: 1),
                      _SettingsTile(icon: Icons.help_outline, label: 'Help & Support', onTap: () {}),
                      const Divider(color: AppColors.glassBorder, height: 1),
                      _SettingsTile(icon: Icons.info_outline, label: 'About Genshin Import', onTap: () {}),
                    ],
                  ),
                ),
              ),

              // ── Logout ────────────────────────────────────────────────
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: GenshinButton(
                    label: 'Logout',
                    icon: Icons.logout,
                    outlined: true,
                    onPressed: () async {
                      await context.read<AuthProvider>().logout();
                      if (context.mounted) context.go('/login');
                    },
                  ),
                ),
              ),

              const SliverToBoxAdapter(child: SizedBox(height: 60)),
            ],
          ),
        ),
      ),
    );
  }
}

class _ProfileStat extends StatelessWidget {
  final String label;
  final String value;
  const _ProfileStat({required this.label, required this.value});

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(value, style: AppTextStyles.headingSmall.copyWith(
          color: AppColors.textPrimary, fontSize: 16)),
      Text(label, style: AppTextStyles.caption),
    ],
  );
}

class _SettingsTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _SettingsTile({required this.icon, required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) => ListTile(
    leading: Icon(icon, color: AppColors.textSecondary, size: 20),
    title: Text(label, style: AppTextStyles.bodyMedium),
    trailing: const Icon(Icons.chevron_right, color: AppColors.textHint, size: 18),
    onTap: onTap,
  );
}
