import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_text_styles.dart';
import '../../widgets/particle_overlay.dart';
import '../../widgets/genshin_button.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // Auto-navigate after 4 seconds
    Future.delayed(const Duration(seconds: 4), () {
      if (mounted) context.go('/login');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(gradient: AppColors.bgGradient),
        child: Stack(
          children: [
            // Particles background
            const ParticleOverlay(count: 50),

            // Radial glow center
            Center(
              child: Container(
                width: 300,
                height: 300,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.gold.withAlpha(30),
                      blurRadius: 120,
                      spreadRadius: 60,
                    ),
                    BoxShadow(
                      color: AppColors.electro.withAlpha(20),
                      blurRadius: 80,
                      spreadRadius: 30,
                    ),
                  ],
                ),
              ),
            )
                .animate(onPlay: (c) => c.repeat(reverse: true))
                .scaleXY(begin: 0.9, end: 1.1, duration: 3.seconds, curve: Curves.easeInOut),

            // Main content
            SafeArea(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Logo glyph
                  Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: AppColors.goldGradient,
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.gold.withAlpha(120),
                          blurRadius: 30,
                          spreadRadius: 5,
                        ),
                      ],
                    ),
                    child: const Icon(Icons.auto_awesome, color: AppColors.bgDarkNavy, size: 48),
                  )
                      .animate()
                      .fadeIn(duration: 800.ms)
                      .scaleXY(begin: 0.5, end: 1.0, duration: 1000.ms, curve: Curves.elasticOut),

                  const SizedBox(height: 32),

                  // App Name
                  Text('GENSHIN IMPORT', style: AppTextStyles.displayLarge)
                      .animate()
                      .fadeIn(delay: 400.ms, duration: 800.ms)
                      .slideY(begin: 0.3, end: 0, duration: 800.ms, curve: Curves.easeOut),

                  const SizedBox(height: 8),

                  // Tagline
                  Text(
                    'Teyvat Weapons Marketplace',
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: AppColors.textSecondary,
                      letterSpacing: 2,
                    ),
                    textAlign: TextAlign.center,
                  )
                      .animate()
                      .fadeIn(delay: 700.ms, duration: 800.ms),

                  const SizedBox(height: 16),

                  // Decorative divider
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(width: 60, height: 1, color: AppColors.glassBorder),
                      Container(
                        margin: const EdgeInsets.symmetric(horizontal: 12),
                        child: const Icon(Icons.diamond_outlined, color: AppColors.gold, size: 16),
                      ),
                      Container(width: 60, height: 1, color: AppColors.glassBorder),
                    ],
                  ).animate().fadeIn(delay: 900.ms, duration: 600.ms),

                  const SizedBox(height: 60),

                  // Enter button
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 48),
                    child: GenshinButton(
                      label: 'Enter Teyvat Marketplace',
                      icon: Icons.auto_awesome,
                      onPressed: () => context.go('/login'),
                    ),
                  )
                      .animate()
                      .fadeIn(delay: 1200.ms, duration: 800.ms)
                      .slideY(begin: 0.5, end: 0, duration: 800.ms, curve: Curves.easeOut),

                  const SizedBox(height: 32),

                  // Loading indicator
                  const SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(
                      color: AppColors.gold,
                      strokeWidth: 2,
                    ),
                  ).animate().fadeIn(delay: 1500.ms),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
