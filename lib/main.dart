import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'core/constants/app_theme.dart';
import 'core/providers/auth_provider.dart';
import 'core/providers/cart_provider.dart';
import 'core/providers/weapon_provider.dart';
import 'main_shell.dart';
import 'screens/splash/splash_screen.dart';
import 'screens/auth/login_screen.dart';
import 'screens/auth/register_screen.dart';
import 'screens/home/home_screen.dart';
import 'screens/weapon_detail/weapon_detail_screen.dart';
import 'screens/cart/cart_screen.dart';
import 'screens/admin/admin_dashboard_screen.dart';
import 'screens/profile/profile_screen.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => CartProvider()),
        ChangeNotifierProvider(create: (_) => WeaponProvider()),
      ],
      child: const GenshinImportApp(),
    ),
  );
}

class GenshinImportApp extends StatelessWidget {
  const GenshinImportApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Genshin Import',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkTheme,
      routerConfig: _router,
    );
  }
}

final GoRouter _router = GoRouter(
  initialLocation: '/splash',
  routes: [
    // ── No-shell routes ────────────────────────────────────────────────
    GoRoute(
      path: '/splash',
      pageBuilder: (ctx, state) => CustomTransitionPage(
        child: const SplashScreen(),
        transitionsBuilder: (ctx, animation, secondary, child) =>
            FadeTransition(opacity: animation, child: child),
      ),
    ),
    GoRoute(
      path: '/login',
      pageBuilder: (ctx, state) => CustomTransitionPage(
        child: const LoginScreen(),
        transitionsBuilder: (ctx, animation, secondary, child) =>
            FadeTransition(opacity: animation, child: child),
      ),
    ),
    GoRoute(
      path: '/register',
      pageBuilder: (ctx, state) => CustomTransitionPage(
        child: const RegisterScreen(),
        transitionsBuilder: (ctx, animation, secondary, child) =>
            SlideTransition(
              position: Tween<Offset>(begin: const Offset(1, 0), end: Offset.zero)
                  .animate(CurvedAnimation(parent: animation, curve: Curves.easeOutCubic)),
              child: child,
            ),
      ),
    ),

    // ── Main shell routes (with bottom nav) ────────────────────────────
    ShellRoute(
      builder: (ctx, state, child) => MainShell(child: child),
      routes: [
        GoRoute(
          path: '/home',
          pageBuilder: (ctx, state) => const NoTransitionPage(child: HomeScreen()),
        ),
        GoRoute(
          path: '/cart',
          pageBuilder: (ctx, state) => const NoTransitionPage(child: CartScreen()),
        ),
        GoRoute(
          path: '/admin',
          pageBuilder: (ctx, state) => const NoTransitionPage(child: AdminDashboardScreen()),
        ),
        GoRoute(
          path: '/profile',
          pageBuilder: (ctx, state) => const NoTransitionPage(child: ProfileScreen()),
        ),
      ],
    ),

    // ── Detail routes (no shell, with slide up) ────────────────────────
    GoRoute(
      path: '/weapon/:id',
      pageBuilder: (ctx, state) {
        final id = state.pathParameters['id'] ?? '0';
        return CustomTransitionPage(
          child: WeaponDetailScreen(weaponId: id),
          transitionsBuilder: (ctx, animation, secondary, child) =>
              SlideTransition(
                position: Tween<Offset>(begin: const Offset(0, 1), end: Offset.zero)
                    .animate(CurvedAnimation(parent: animation, curve: Curves.easeOutCubic)),
                child: child,
              ),
        );
      },
    ),
  ],
);
