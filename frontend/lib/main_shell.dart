import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'core/constants/app_colors.dart';
import 'core/constants/app_text_styles.dart';
import 'core/providers/cart_provider.dart';

/// Main shell with bottom navigation bar
class MainShell extends StatefulWidget {
  final Widget child;
  const MainShell({super.key, required this.child});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int _currentIndex = 0;

  static const _routes = ['/home', '/cart', '/admin', '/profile'];

  void _onNav(int index) {
    if (_currentIndex != index) {
      setState(() => _currentIndex = index);
      context.go(_routes[index]);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: widget.child,
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          color: AppColors.bgCard,
          border: Border(top: BorderSide(color: AppColors.glassBorder, width: 0.5)),
          boxShadow: [
            BoxShadow(
              color: Color(0x660D0E2B),
              blurRadius: 20,
              offset: Offset(0, -5),
            ),
          ],
        ),
        child: Consumer<CartProvider>(
          builder: (ctx, cart, _) {
            return BottomNavigationBar(
              currentIndex: _currentIndex,
              onTap: _onNav,
              backgroundColor: Colors.transparent,
              selectedItemColor: AppColors.gold,
              unselectedItemColor: AppColors.textHint,
              type: BottomNavigationBarType.fixed,
              elevation: 0,
              selectedLabelStyle: AppTextStyles.caption.copyWith(
                  color: AppColors.gold, fontWeight: FontWeight.w700),
              unselectedLabelStyle: AppTextStyles.caption,
              items: [
                const BottomNavigationBarItem(
                  icon: Icon(Icons.home_outlined),
                  activeIcon: Icon(Icons.home),
                  label: 'Home',
                ),
                BottomNavigationBarItem(
                  icon: Stack(
                    clipBehavior: Clip.none,
                    children: [
                      const Icon(Icons.shopping_cart_outlined),
                      if (cart.itemCount > 0)
                        Positioned(
                          top: -6, right: -6,
                          child: Container(
                            padding: const EdgeInsets.all(3),
                            decoration: const BoxDecoration(
                              color: AppColors.pyro,
                              shape: BoxShape.circle,
                            ),
                            constraints: const BoxConstraints(minWidth: 16, minHeight: 16),
                            child: Text(
                              '${cart.itemCount}',
                              style: const TextStyle(color: Colors.white, fontSize: 9,
                                  fontWeight: FontWeight.w700),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                    ],
                  ),
                  activeIcon: Stack(
                    clipBehavior: Clip.none,
                    children: [
                      const Icon(Icons.shopping_cart),
                      if (cart.itemCount > 0)
                        Positioned(
                          top: -6, right: -6,
                          child: Container(
                            padding: const EdgeInsets.all(3),
                            decoration: const BoxDecoration(
                              color: AppColors.pyro, shape: BoxShape.circle,
                            ),
                            constraints: const BoxConstraints(minWidth: 16, minHeight: 16),
                            child: Text('${cart.itemCount}',
                              style: const TextStyle(color: Colors.white, fontSize: 9,
                                  fontWeight: FontWeight.w700),
                              textAlign: TextAlign.center),
                          ),
                        ),
                    ],
                  ),
                  label: 'Cart',
                ),
                const BottomNavigationBarItem(
                  icon: Icon(Icons.admin_panel_settings_outlined),
                  activeIcon: Icon(Icons.admin_panel_settings),
                  label: 'Admin',
                ),
                const BottomNavigationBarItem(
                  icon: Icon(Icons.person_outline),
                  activeIcon: Icon(Icons.person),
                  label: 'Profile',
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
