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

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _usernameCtrl = TextEditingController();
  final _emailCtrl    = TextEditingController();
  final _passCtrl     = TextEditingController();
  final _confirmCtrl  = TextEditingController();

  String? _usernameError;
  String? _emailError;
  String? _passError;
  String? _confirmError;

  @override
  void dispose() {
    _usernameCtrl.dispose();
    _emailCtrl.dispose();
    _passCtrl.dispose();
    _confirmCtrl.dispose();
    super.dispose();
  }

  bool _validate() {
    setState(() {
      _usernameError = null;
      _emailError = null;
      _passError = null;
      _confirmError = null;
    });
    bool valid = true;

    if (_usernameCtrl.text.trim().isEmpty) {
      setState(() => _usernameError = 'Username cannot be empty');
      valid = false;
    } else if (_usernameCtrl.text.trim().length < 3) {
      setState(() => _usernameError = 'Username must be at least 3 characters');
      valid = false;
    }

    final email = _emailCtrl.text.trim();
    if (email.isEmpty) {
      setState(() => _emailError = 'Email cannot be empty');
      valid = false;
    } else if (!RegExp(r'^[\w\.-]+@[\w\.-]+\.\w{2,}$').hasMatch(email)) {
      setState(() => _emailError = 'Invalid email format');
      valid = false;
    }

    if (_passCtrl.text.isEmpty) {
      setState(() => _passError = 'Password cannot be empty');
      valid = false;
    } else if (_passCtrl.text.length < 8) {
      setState(() => _passError = 'Password must be at least 8 characters');
      valid = false;
    }

    if (_confirmCtrl.text != _passCtrl.text) {
      setState(() => _confirmError = 'Passwords do not match');
      valid = false;
    }

    return valid;
  }

  Future<void> _register() async {
    if (!_validate()) return;
    final auth = context.read<AuthProvider>();
    final success = await auth.register(
      _usernameCtrl.text.trim(),
      _emailCtrl.text.trim(),
      _passCtrl.text,
    );
    if (!mounted) return;
    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Account created! Please sign in.',
            style: AppTextStyles.bodyMedium.copyWith(color: AppColors.success)),
          backgroundColor: AppColors.bgCard,
        ),
      );
      context.go('/login');
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(auth.errorMessage ?? 'Registration failed'),
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
            const ParticleOverlay(count: 25),
            SafeArea(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Column(
                  children: [
                    // Back button
                    Align(
                      alignment: Alignment.centerLeft,
                      child: IconButton(
                        icon: const Icon(Icons.arrow_back_ios, color: AppColors.gold),
                        onPressed: () => context.go('/login'),
                      ),
                    ),
                    const SizedBox(height: 8),

                    const Icon(Icons.person_add_alt_1, color: AppColors.gold, size: 40),
                    const SizedBox(height: 12),
                    Text('Create Account', style: AppTextStyles.headingLarge),
                    const SizedBox(height: 4),
                    Text('Join the Teyvat Marketplace',
                        style: AppTextStyles.bodySmall),
                    const SizedBox(height: 32),

                    // Form card
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(color: AppColors.glassBorder),
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
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          GenshinTextField(
                            label: 'Username',
                            hint: 'Your Traveler name',
                            controller: _usernameCtrl,
                            prefixIcon: Icons.person_outline,
                            errorText: _usernameError,
                            onChanged: (_) => setState(() => _usernameError = null),
                          ),
                          const SizedBox(height: 20),
                          GenshinTextField(
                            label: 'Email',
                            hint: 'traveler@teyvat.com',
                            controller: _emailCtrl,
                            keyboardType: TextInputType.emailAddress,
                            prefixIcon: Icons.email_outlined,
                            errorText: _emailError,
                            onChanged: (_) => setState(() => _emailError = null),
                          ),
                          const SizedBox(height: 20),
                          GenshinTextField(
                            label: 'Password',
                            hint: 'Min. 8 characters',
                            controller: _passCtrl,
                            obscureText: true,
                            prefixIcon: Icons.lock_outline,
                            errorText: _passError,
                            onChanged: (_) => setState(() => _passError = null),
                          ),
                          const SizedBox(height: 20),
                          GenshinTextField(
                            label: 'Confirm Password',
                            hint: 'Re-enter password',
                            controller: _confirmCtrl,
                            obscureText: true,
                            prefixIcon: Icons.lock_person_outlined,
                            errorText: _confirmError,
                            onChanged: (_) => setState(() => _confirmError = null),
                          ),
                          const SizedBox(height: 28),
                          GenshinButton(
                            label: 'Create Account',
                            icon: Icons.auto_awesome,
                            onPressed: _register,
                            isLoading: isLoading,
                          ),
                        ],
                      ),
                    ).animate().fadeIn(delay: 300.ms).slideY(begin: 0.2, end: 0),

                    const SizedBox(height: 24),

                    // Sign in link
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('Already have an account? ', style: AppTextStyles.bodySmall),
                        GestureDetector(
                          onTap: () => context.go('/login'),
                          child: Text('Sign In',
                            style: AppTextStyles.bodySmall.copyWith(
                              color: AppColors.gold, fontWeight: FontWeight.w700,
                              decoration: TextDecoration.underline,
                              decorationColor: AppColors.gold,
                            )),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
