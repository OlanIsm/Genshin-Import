import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_text_styles.dart';
import '../../core/providers/auth_provider.dart';
import '../../widgets/genshin_button.dart';
import '../../widgets/genshin_text_field.dart';
import '../../widgets/particle_overlay.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailCtrl = TextEditingController();
  final _passCtrl = TextEditingController();

  String? _emailError;
  String? _passError;

  @override
  void dispose() {
    _emailCtrl.dispose();
    _passCtrl.dispose();
    super.dispose();
  }

  // ── Validation ─────────────────────────────────────────────────────────────
  bool _validate() {
    setState(() {
      _emailError = null;
      _passError = null;
    });
    bool valid = true;

    final email = _emailCtrl.text.trim();
    final password = _passCtrl.text;

    if (email.isEmpty) {
      setState(() => _emailError = 'Email cannot be empty');
      valid = false;
    } else if (!RegExp(r'^[\w\.-]+@[\w\.-]+\.\w{2,}$').hasMatch(email)) {
      setState(() => _emailError = 'Invalid email format');
      valid = false;
    }

    if (password.isEmpty) {
      setState(() => _passError = 'Password cannot be empty');
      valid = false;
    } else if (password.length < 8) {
      setState(() => _passError = 'Password must be at least 8 characters');
      valid = false;
    }

    return valid;
  }

  Future<void> _login() async {
    if (!_validate()) return;
    final auth = context.read<AuthProvider>();
    final success = await auth.login(_emailCtrl.text.trim(), _passCtrl.text);
    if (!mounted) return;
    if (success) {
      // Show token success snackbar
      final token = auth.token ?? '';
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(Icons.verified, color: AppColors.gold, size: 18),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Bearer Token Generated ✓',
                      style: AppTextStyles.labelMedium.copyWith(
                        color: AppColors.gold,
                      ),
                    ),
                    Text(
                      token.length > 30
                          ? '${token.substring(0, 30)}...'
                          : token,
                      style: AppTextStyles.caption.copyWith(fontSize: 10),
                    ),
                  ],
                ),
              ),
            ],
          ),
          backgroundColor: AppColors.bgCard,
          duration: const Duration(seconds: 4),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          behavior: SnackBarBehavior.floating,
        ),
      );
      context.go('/home');
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(auth.errorMessage ?? 'Login failed'),
          backgroundColor: AppColors.error,
        ),
      );
    }
  }

  Future<void> _oauthLogin(String provider) async {
    if (provider != 'Google') {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('$provider OAuth — coming soon!'),
          backgroundColor: AppColors.bgCard,
        ),
      );
      return;
    }

    try {
      final GoogleSignIn googleSignIn = GoogleSignIn(
        scopes: ['email', 'profile'],
      );

      final GoogleSignInAccount? account = await googleSignIn.signIn();
      if (account == null) return;

      if (!mounted) return;

      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('bearer_token', account.id);
      await prefs.setString('user_email', account.email);
      await prefs.setString('user_name', account.displayName ?? 'Traveler');

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(Icons.verified, color: AppColors.gold, size: 18),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Google login berhasil: ${account.displayName}',
                  style: AppTextStyles.labelMedium.copyWith(
                    color: AppColors.gold,
                  ),
                ),
              ),
            ],
          ),
          backgroundColor: AppColors.bgCard,
          duration: const Duration(seconds: 3),
        ),
      );

      context.go('/home');
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Google login gagal: $e'),
          backgroundColor: AppColors.error,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final isLoading = auth.status == AuthStatus.loading;

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(gradient: AppColors.bgGradient),
        child: Stack(
          children: [
            const ParticleOverlay(count: 30),
            SafeArea(
              child: Center(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    children: [
                      // Header
                      const Icon(
                            Icons.auto_awesome,
                            color: AppColors.gold,
                            size: 40,
                          )
                          .animate()
                          .fadeIn(duration: 600.ms)
                          .scaleXY(begin: 0.5, end: 1.0),
                      const SizedBox(height: 12),
                      Text(
                        'Welcome Back',
                        style: AppTextStyles.headingLarge,
                      ).animate().fadeIn(delay: 200.ms),
                      const SizedBox(height: 4),
                      Text(
                        'Sign in to the Teyvat Marketplace',
                        style: AppTextStyles.bodySmall,
                      ).animate().fadeIn(delay: 300.ms),
                      const SizedBox(height: 32),

                      // Glass card
                      Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(24),
                              border: Border.all(
                                color: AppColors.glassBorder,
                                width: 1,
                              ),
                              gradient: const LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: [Color(0x1AFFFFFF), Color(0x0DFFFFFF)],
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: AppColors.gold.withAlpha(20),
                                  blurRadius: 30,
                                  spreadRadius: 5,
                                ),
                              ],
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(24),
                              child: Form(
                                key: _formKey,
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  children: [
                                    GenshinTextField(
                                      label: 'Email',
                                      hint: 'traveler@teyvat.com',
                                      controller: _emailCtrl,
                                      keyboardType: TextInputType.emailAddress,
                                      prefixIcon: Icons.email_outlined,
                                      errorText: _emailError,
                                      onChanged: (_) =>
                                          setState(() => _emailError = null),
                                    ),
                                    const SizedBox(height: 20),
                                    GenshinTextField(
                                      label: 'Password',
                                      hint: 'Min. 8 characters',
                                      controller: _passCtrl,
                                      obscureText: true,
                                      prefixIcon: Icons.lock_outline,
                                      errorText: _passError,
                                      onChanged: (_) =>
                                          setState(() => _passError = null),
                                    ),
                                    const SizedBox(height: 8),
                                    Align(
                                      alignment: Alignment.centerRight,
                                      child: TextButton(
                                        onPressed: () {},
                                        child: Text(
                                          'Forgot Password?',
                                          style: AppTextStyles.bodySmall
                                              .copyWith(color: AppColors.hydro),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 16),
                                    GenshinButton(
                                      label: 'Sign In',
                                      icon: Icons.login,
                                      onPressed: _login,
                                      isLoading: isLoading,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          )
                          .animate()
                          .fadeIn(delay: 400.ms)
                          .slideY(begin: 0.2, end: 0),

                      const SizedBox(height: 28),

                      // Divider
                      Row(
                        children: [
                          const Expanded(
                            child: Divider(color: AppColors.glassBorder),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            child: Text(
                              'or continue with',
                              style: AppTextStyles.caption,
                            ),
                          ),
                          const Expanded(
                            child: Divider(color: AppColors.glassBorder),
                          ),
                        ],
                      ),

                      const SizedBox(height: 20),

                      // OAuth buttons
                      Row(
                        children: [
                          Expanded(
                            child: _OAuthButton(
                              label: 'Google',
                              color: const Color(0xFFDB4437),
                              icon: Icons.g_mobiledata,
                              onTap: () => _oauthLogin('Google'),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: _OAuthButton(
                              label: 'Facebook',
                              color: const Color(0xFF4267B2),
                              icon: Icons.facebook,
                              onTap: () => _oauthLogin('Facebook'),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: _OAuthButton(
                              label: 'Twitter',
                              color: const Color(0xFF1DA1F2),
                              icon: Icons.alternate_email,
                              onTap: () => _oauthLogin('Twitter'),
                            ),
                          ),
                        ],
                      ).animate().fadeIn(delay: 700.ms),

                      const SizedBox(height: 32),

                      // Register link
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Don't have an account? ",
                            style: AppTextStyles.bodySmall,
                          ),
                          GestureDetector(
                            onTap: () => context.go('/register'),
                            child: Text(
                              'Register',
                              style: AppTextStyles.bodySmall.copyWith(
                                color: AppColors.gold,
                                fontWeight: FontWeight.w700,
                                decoration: TextDecoration.underline,
                                decorationColor: AppColors.gold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _OAuthButton extends StatelessWidget {
  final String label;
  final Color color;
  final IconData icon;
  final VoidCallback onTap;

  const _OAuthButton({
    required this.label,
    required this.color,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withAlpha(100), width: 1),
          color: color.withAlpha(20),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: color, size: 24),
            const SizedBox(height: 4),
            Text(
              label,
              style: AppTextStyles.caption.copyWith(color: color),
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
