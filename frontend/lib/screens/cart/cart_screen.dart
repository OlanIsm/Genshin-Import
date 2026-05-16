import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_text_styles.dart';
import '../../core/providers/cart_provider.dart';
import '../../core/models/cart_item.dart';
import '../../widgets/genshin_button.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(gradient: AppColors.bgGradient),
        child: SafeArea(
          child: Consumer<CartProvider>(
            builder: (ctx, cart, _) {
              return Column(
                children: [
                  // ── Header ─────────────────────────────────────────────
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                    child: Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.arrow_back_ios, color: AppColors.gold),
                          onPressed: () => context.go('/home'),
                        ),
                        Text('Your Cart', style: AppTextStyles.headingMedium),
                        const Spacer(),
                        if (cart.itemCount > 0)
                          TextButton.icon(
                            icon: const Icon(Icons.delete_outline,
                                color: AppColors.error, size: 18),
                            label: Text('Clear All',
                                style: AppTextStyles.bodySmall.copyWith(
                                    color: AppColors.error)),
                            onPressed: () => _showClearConfirm(ctx, cart),
                          ),
                      ],
                    ),
                  ),

                  const Divider(color: AppColors.glassBorder, height: 24),

                  // ── Cart items ─────────────────────────────────────────
                  Expanded(
                    child: cart.isEmpty
                        ? _buildEmptyState(context)
                        : ListView.builder(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            itemCount: cart.items.length,
                            itemBuilder: (ctx, i) {
                              final item = cart.items[i];
                              return _CartItemCard(
                                item: item,
                                onRemove: () => cart.removeItem(item.id),
                                onIncrease: () => cart.updateQuantity(item.id, item.quantity + 1),
                                onDecrease: () => cart.updateQuantity(item.id, item.quantity - 1),
                              ).animate(delay: (i * 60).ms).fadeIn().slideX(begin: -0.1, end: 0);
                            },
                          ),
                  ),

                  // ── Order Summary ──────────────────────────────────────
                  if (!cart.isEmpty)
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: const BoxDecoration(
                        color: AppColors.bgCard,
                        border: Border(top: BorderSide(color: AppColors.glassBorder)),
                        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
                      ),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Items (${cart.itemCount})',
                                  style: AppTextStyles.bodySmall),
                              Text('Rp ${cart.totalPrice.toStringAsFixed(0)}',
                                  style: AppTextStyles.bodyMedium),
                            ],
                          ),
                          const SizedBox(height: 6),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Shipping', style: AppTextStyles.bodySmall),
                              Text('Free', style: AppTextStyles.bodySmall.copyWith(
                                  color: AppColors.success)),
                            ],
                          ),
                          const Padding(
                            padding: EdgeInsets.symmetric(vertical: 10),
                            child: Divider(color: AppColors.glassBorder),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Total', style: AppTextStyles.headingSmall),
                              Text('Rp ${cart.totalPrice.toStringAsFixed(0)}',
                                  style: AppTextStyles.price.copyWith(fontSize: 20)),
                            ],
                          ),
                          const SizedBox(height: 16),
                          GenshinButton(
                            label: 'Proceed to Checkout',
                            icon: Icons.shopping_bag_outlined,
                            onPressed: () => _showCheckoutSuccess(context, cart),
                          ),
                        ],
                      ),
                    ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 100, height: 100,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.glassWhite2,
              border: Border.all(color: AppColors.glassBorder),
            ),
            child: const Icon(Icons.shopping_cart_outlined,
                color: AppColors.textHint, size: 48),
          )
              .animate(onPlay: (c) => c.repeat(reverse: true))
              .scaleXY(begin: 0.95, end: 1.05, duration: 2.seconds),
          const SizedBox(height: 20),
          Text('Your cart is empty', style: AppTextStyles.headingSmall.copyWith(
              color: AppColors.textHint)),
          const SizedBox(height: 8),
          Text('Find legendary weapons and add them to your cart',
              style: AppTextStyles.bodySmall, textAlign: TextAlign.center),
          const SizedBox(height: 28),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 60),
            child: GenshinButton(
              label: 'Browse Weapons',
              icon: Icons.auto_awesome,
              onPressed: () => context.go('/home'),
            ),
          ),
        ],
      ),
    );
  }

  void _showClearConfirm(BuildContext ctx, CartProvider cart) {
    showDialog(
      context: ctx,
      builder: (_) => AlertDialog(
        title: Text('Clear Cart', style: AppTextStyles.headingSmall),
        content: Text('Remove all items from your cart?',
            style: AppTextStyles.bodySmall),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel', style: TextStyle(color: AppColors.textSecondary)),
          ),
          TextButton(
            onPressed: () {
              cart.clearCart();
              Navigator.pop(ctx);
            },
            child: const Text('Clear', style: TextStyle(color: AppColors.error)),
          ),
        ],
      ),
    );
  }

  void _showCheckoutSuccess(BuildContext context, CartProvider cart) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.check_circle, color: AppColors.success, size: 64),
            const SizedBox(height: 12),
            Text('Order Placed!', style: AppTextStyles.headingMedium),
            const SizedBox(height: 8),
            Text('Your weapons will be delivered from Teyvat!',
                style: AppTextStyles.bodySmall, textAlign: TextAlign.center),
            const SizedBox(height: 4),
            Text('Total: Rp ${cart.totalPrice.toStringAsFixed(0)}',
                style: AppTextStyles.price),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              cart.clearCart();
              Navigator.pop(context);
              context.go('/home');
            },
            child: Text('Continue Shopping',
                style: AppTextStyles.labelMedium.copyWith(color: AppColors.gold)),
          ),
        ],
      ),
    );
  }
}

class _CartItemCard extends StatelessWidget {
  final CartItem item;
  final VoidCallback onRemove;
  final VoidCallback onIncrease;
  final VoidCallback onDecrease;

  const _CartItemCard({
    required this.item,
    required this.onRemove,
    required this.onIncrease,
    required this.onDecrease,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.glassBorder),
        gradient: const LinearGradient(
          colors: [Color(0xFF1C2050), Color(0xFF0F1230)],
        ),
      ),
      child: Row(
        children: [
          // Image
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: CachedNetworkImage(
              imageUrl: item.imageUrl,
              width: 70, height: 70, fit: BoxFit.cover,
              errorWidget: (_, __, ___) => Container(
                width: 70, height: 70,
                color: AppColors.bgCard,
                child: const Icon(Icons.auto_awesome, color: AppColors.gold),
              ),
            ),
          ),
          const SizedBox(width: 12),
          // Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(item.name, style: AppTextStyles.labelMedium,
                    maxLines: 1, overflow: TextOverflow.ellipsis),
                const SizedBox(height: 2),
                Text('Rp ${item.unitPrice.toStringAsFixed(0)} each',
                    style: AppTextStyles.caption),
                const SizedBox(height: 8),
                Row(
                  children: [
                    _SmallQtyBtn(icon: Icons.remove, onTap: onDecrease),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: Text('${item.quantity}',
                          style: AppTextStyles.bodyLarge.copyWith(fontSize: 16)),
                    ),
                    _SmallQtyBtn(icon: Icons.add, onTap: onIncrease),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          // Total + Remove
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              IconButton(
                icon: const Icon(Icons.close, color: AppColors.textHint, size: 18),
                onPressed: onRemove,
              ),
              Text('Rp ${item.totalPrice.toStringAsFixed(0)}',
                  style: AppTextStyles.price.copyWith(fontSize: 13)),
            ],
          ),
        ],
      ),
    );
  }
}

class _SmallQtyBtn extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  const _SmallQtyBtn({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 28, height: 28,
        decoration: BoxDecoration(
          border: Border.all(color: AppColors.glassBorder),
          borderRadius: BorderRadius.circular(6),
        ),
        child: Icon(icon, size: 16, color: AppColors.gold),
      ),
    );
  }
}
