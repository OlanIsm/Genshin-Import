import 'package:flutter/material.dart';
import '../core/constants/app_colors.dart';
import '../core/constants/app_text_styles.dart';

/// Primary glowing CTA button with gold gradient and shimmer animation
class GenshinButton extends StatefulWidget {
  final String label;
  final VoidCallback? onPressed;
  final bool isLoading;
  final IconData? icon;
  final bool outlined;
  final double? width;
  final double height;

  const GenshinButton({
    super.key,
    required this.label,
    this.onPressed,
    this.isLoading = false,
    this.icon,
    this.outlined = false,
    this.width,
    this.height = 52,
  });

  @override
  State<GenshinButton> createState() => _GenshinButtonState();
}

class _GenshinButtonState extends State<GenshinButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _glowController;

  @override
  void initState() {
    super.initState();
    _glowController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _glowController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.outlined) {
      return SizedBox(
        width: widget.width ?? double.infinity,
        height: widget.height,
        child: OutlinedButton.icon(
          onPressed: widget.isLoading ? null : widget.onPressed,
          icon: widget.icon != null
              ? Icon(widget.icon, color: AppColors.gold, size: 18)
              : const SizedBox.shrink(),
          label: Text(widget.label, style: AppTextStyles.buttonText.copyWith(
            color: AppColors.gold, fontSize: 14,
          )),
          style: OutlinedButton.styleFrom(
            side: const BorderSide(color: AppColors.gold, width: 1.5),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
        ),
      );
    }

    return AnimatedBuilder(
      animation: _glowController,
      builder: (context, child) {
        final glowOpacity = 0.3 + 0.4 * _glowController.value;
        return Container(
          width: widget.width ?? double.infinity,
          height: widget.height,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: AppColors.gold.withAlpha((glowOpacity * 255).toInt()),
                blurRadius: 20,
                spreadRadius: 2,
              ),
            ],
          ),
          child: child,
        );
      },
      child: DecoratedBox(
        decoration: BoxDecoration(
          gradient: widget.onPressed != null
              ? AppColors.goldGradient
              : const LinearGradient(colors: [Color(0xFF444444), Color(0xFF333333)]),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Material(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(12),
          child: InkWell(
            onTap: widget.isLoading ? null : widget.onPressed,
            borderRadius: BorderRadius.circular(12),
            child: Center(
              child: widget.isLoading
                  ? const SizedBox(
                      width: 22,
                      height: 22,
                      child: CircularProgressIndicator(
                        color: AppColors.bgDarkNavy,
                        strokeWidth: 2.5,
                      ),
                    )
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        if (widget.icon != null) ...[
                          Icon(widget.icon, color: AppColors.bgDarkNavy, size: 18),
                          const SizedBox(width: 8),
                        ],
                        Text(widget.label, style: AppTextStyles.buttonText),
                      ],
                    ),
            ),
          ),
        ),
      ),
    );
  }
}
