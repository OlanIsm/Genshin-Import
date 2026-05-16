import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_text_styles.dart';
import '../../core/providers/weapon_provider.dart';
import '../../core/models/weapon.dart';
import '../../widgets/genshin_button.dart';
import '../../widgets/genshin_text_field.dart';

class AdminDashboardScreen extends StatefulWidget {
  const AdminDashboardScreen({super.key});

  @override
  State<AdminDashboardScreen> createState() => _AdminDashboardScreenState();
}

class _AdminDashboardScreenState extends State<AdminDashboardScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(gradient: AppColors.bgGradient),
        child: SafeArea(
          child: Consumer<WeaponProvider>(
            builder: (ctx, provider, _) {
              return CustomScrollView(
                slivers: [
                  // ── Header ──────────────────────────────────────────────
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              gradient: AppColors.goldGradient,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: const Icon(Icons.admin_panel_settings,
                                color: AppColors.bgDarkNavy, size: 22),
                          ),
                          const SizedBox(width: 12),
                          Text('Admin Dashboard', style: AppTextStyles.headingMedium),
                        ],
                      ),
                    ),
                  ),

                  // ── Analytics Row ────────────────────────────────────────
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(16, 20, 16, 0),
                      child: Row(
                        children: [
                          _AnalyticCard(
                            label: 'Total Weapons',
                            value: '${provider.allWeapons.length}',
                            icon: Icons.auto_awesome,
                            color: AppColors.gold,
                          ),
                          const SizedBox(width: 10),
                          const _AnalyticCard(
                            label: 'Total Users',
                            value: '142',
                            icon: Icons.people_outline,
                            color: AppColors.hydro,
                          ),
                          const SizedBox(width: 10),
                          const _AnalyticCard(
                            label: 'Sales',
                            value: '38',
                            icon: Icons.trending_up,
                            color: AppColors.success,
                          ),
                        ],
                      ).animate().fadeIn(delay: 200.ms),
                    ),
                  ),

                  // ── Sales Chart ──────────────────────────────────────────
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(16, 20, 16, 0),
                      child: Container(
                        height: 180,
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: AppColors.glassBorder),
                          color: AppColors.glassWhite2,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Weekly Sales', style: AppTextStyles.headingSmall.copyWith(fontSize: 13)),
                            const SizedBox(height: 10),
                            Expanded(
                              child: BarChart(
                                BarChartData(
                                  barGroups: [
                                    _bar(0, 5, AppColors.anemo),
                                    _bar(1, 8, AppColors.pyro),
                                    _bar(2, 3, AppColors.hydro),
                                    _bar(3, 12, AppColors.gold),
                                    _bar(4, 7, AppColors.electro),
                                    _bar(5, 9, AppColors.cryo),
                                    _bar(6, 6, AppColors.dendro),
                                  ],
                                  borderData: FlBorderData(show: false),
                                  gridData: const FlGridData(show: false),
                                  titlesData: FlTitlesData(
                                    leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                                    rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                                    topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                                    bottomTitles: AxisTitles(
                                      sideTitles: SideTitles(
                                        showTitles: true,
                                        getTitlesWidget: (v, m) {
                                          const days = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];
                                          return Text(days[v.toInt()],
                                            style: AppTextStyles.caption.copyWith(fontSize: 10));
                                        },
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ).animate().fadeIn(delay: 300.ms),
                    ),
                  ),

                  // ── Weapons Table Header ─────────────────────────────────
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(16, 20, 16, 8),
                      child: Row(
                        children: [
                          Text('Weapon Inventory', style: AppTextStyles.headingSmall),
                          const Spacer(),
                          GenshinButton(
                            label: 'Add Weapon',
                            icon: Icons.add,
                            width: 130,
                            height: 38,
                            onPressed: () => _showWeaponForm(context, provider),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // ── Weapons List ─────────────────────────────────────────
                  SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (ctx, i) {
                        final weapon = provider.allWeapons[i];
                        return _WeaponRow(
                          weapon: weapon,
                          onEdit: () => _showWeaponForm(context, provider, weapon: weapon),
                          onDelete: () => _showDeleteConfirm(context, provider, weapon),
                        ).animate(delay: (i * 40).ms).fadeIn().slideX(begin: 0.1, end: 0);
                      },
                      childCount: provider.allWeapons.length,
                    ),
                  ),

                  const SliverToBoxAdapter(child: SizedBox(height: 80)),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  BarChartGroupData _bar(int x, double y, Color color) {
    return BarChartGroupData(
      x: x,
      barRods: [
        BarChartRodData(
          toY: y,
          color: color,
          width: 18,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(4)),
        ),
      ],
    );
  }

  void _showWeaponForm(BuildContext ctx, WeaponProvider provider, {Weapon? weapon}) {
    showModalBottomSheet(
      context: ctx,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => WeaponFormModal(
        weapon: weapon,
        onSave: (data) async {
          if (weapon != null) {
            await provider.updateWeapon(weapon.id, data);
          } else {
            await provider.createWeapon(data);
          }
        },
      ),
    );
  }

  void _showDeleteConfirm(BuildContext ctx, WeaponProvider provider, Weapon weapon) {
    showDialog(
      context: ctx,
      builder: (_) => AlertDialog(
        title: Text('Delete Weapon', style: AppTextStyles.headingSmall.copyWith(color: AppColors.error)),
        content: RichText(
          text: TextSpan(
            style: AppTextStyles.bodySmall,
            children: [
              const TextSpan(text: 'Are you sure you want to delete '),
              TextSpan(text: weapon.name,
                style: const TextStyle(color: AppColors.gold, fontWeight: FontWeight.w700)),
              const TextSpan(text: '? This action cannot be undone.'),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel', style: TextStyle(color: AppColors.textSecondary)),
          ),
          TextButton(
            onPressed: () async {
              await provider.deleteWeapon(weapon.id);
              if (ctx.mounted) Navigator.pop(ctx);
            },
            child: const Text('Delete', style: TextStyle(color: AppColors.error, fontWeight: FontWeight.w700)),
          ),
        ],
      ),
    );
  }
}

// ── Weapon Form Modal ─────────────────────────────────────────────────────────
class WeaponFormModal extends StatefulWidget {
  final Weapon? weapon;
  final Future<void> Function(Map<String, dynamic> data) onSave;

  const WeaponFormModal({super.key, this.weapon, required this.onSave});

  @override
  State<WeaponFormModal> createState() => _WeaponFormModalState();
}

class _WeaponFormModalState extends State<WeaponFormModal> {
  final _nameCtrl    = TextEditingController();
  final _priceCtrl   = TextEditingController();
  final _stockCtrl   = TextEditingController();
  final _atkCtrl     = TextEditingController();
  final _descCtrl    = TextEditingController();
  String _selectedType = 'sword';
  bool _isSaving = false;

  String? _nameError;
  String? _priceError;
  String? _stockError;

  @override
  void initState() {
    super.initState();
    if (widget.weapon != null) {
      final w = widget.weapon!;
      _nameCtrl.text  = w.name;
      _priceCtrl.text = w.price.toStringAsFixed(0);
      _stockCtrl.text = w.stock.toString();
      _atkCtrl.text   = w.attack.toString();
      _descCtrl.text  = w.description;
      _selectedType   = w.type.name;
    }
  }

  @override
  void dispose() {
    _nameCtrl.dispose(); _priceCtrl.dispose(); _stockCtrl.dispose();
    _atkCtrl.dispose(); _descCtrl.dispose();
    super.dispose();
  }

  bool _validate() {
    setState(() { _nameError = null; _priceError = null; _stockError = null; });
    bool valid = true;

    if (_nameCtrl.text.trim().isEmpty) {
      setState(() => _nameError = 'Weapon name cannot be empty');
      valid = false;
    }

    final price = double.tryParse(_priceCtrl.text);
    if (price == null || price <= 0) {
      setState(() => _priceError = 'Price must be a positive number');
      valid = false;
    }

    final stock = int.tryParse(_stockCtrl.text);
    if (stock == null || stock < 0) {
      setState(() => _stockError = 'Stock must be a non-negative integer');
      valid = false;
    }

    return valid;
  }

  Future<void> _save() async {
    if (!_validate()) return;
    setState(() => _isSaving = true);
    await widget.onSave({
      'name': _nameCtrl.text.trim(),
      'type': _selectedType,
      'price': double.parse(_priceCtrl.text),
      'stock': int.parse(_stockCtrl.text),
      'attack': int.tryParse(_atkCtrl.text) ?? 0,
      'description': _descCtrl.text.trim(),
      'rarity': 4,
    });
    if (mounted) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.85,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      builder: (_, scrollCtrl) {
        return Container(
          decoration: const BoxDecoration(
            color: AppColors.bgCard,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
            border: Border(top: BorderSide(color: AppColors.glassBorder)),
          ),
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom + 16,
          ),
          child: SingleChildScrollView(
            controller: scrollCtrl,
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Handle
                Center(
                  child: Container(
                    width: 40, height: 4,
                    decoration: BoxDecoration(
                      color: AppColors.glassBorder,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  widget.weapon != null ? 'Edit Weapon' : 'Add New Weapon',
                  style: AppTextStyles.headingMedium,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                GenshinTextField(
                  label: 'Weapon Name',
                  hint: 'e.g. Primordial Jade Cutter',
                  controller: _nameCtrl,
                  prefixIcon: Icons.auto_awesome,
                  errorText: _nameError,
                  onChanged: (_) => setState(() => _nameError = null),
                ),
                const SizedBox(height: 16),
                // Type dropdown
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Weapon Type', style: AppTextStyles.labelMedium),
                    const SizedBox(height: 6),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      decoration: BoxDecoration(
                        color: AppColors.glassWhite2,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: AppColors.glassBorder),
                      ),
                      child: DropdownButton<String>(
                        value: _selectedType,
                        isExpanded: true,
                        dropdownColor: AppColors.bgCard,
                        underline: const SizedBox.shrink(),
                        style: AppTextStyles.bodyMedium,
                        icon: const Icon(Icons.arrow_drop_down, color: AppColors.gold),
                        items: ['sword', 'claymore', 'polearm', 'catalyst', 'bow']
                            .map((t) => DropdownMenuItem(
                              value: t,
                              child: Text(t.substring(0,1).toUpperCase() + t.substring(1),
                                style: AppTextStyles.bodyMedium),
                            ))
                            .toList(),
                        onChanged: (v) => setState(() => _selectedType = v!),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: GenshinTextField(
                        label: 'Price (Rp)',
                        hint: '4999',
                        controller: _priceCtrl,
                        keyboardType: TextInputType.number,
                        prefixIcon: Icons.payments_outlined,
                        errorText: _priceError,
                        onChanged: (_) => setState(() => _priceError = null),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: GenshinTextField(
                        label: 'Stock',
                        hint: '10',
                        controller: _stockCtrl,
                        keyboardType: TextInputType.number,
                        prefixIcon: Icons.inventory_2_outlined,
                        errorText: _stockError,
                        onChanged: (_) => setState(() => _stockError = null),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                GenshinTextField(
                  label: 'Base ATK',
                  hint: '542',
                  controller: _atkCtrl,
                  keyboardType: TextInputType.number,
                  prefixIcon: Icons.workspace_premium,
                ),
                const SizedBox(height: 16),
                GenshinTextField(
                  label: 'Description / Lore',
                  hint: 'Enter weapon lore...',
                  controller: _descCtrl,
                  maxLines: 3,
                  prefixIcon: Icons.notes,
                ),
                const SizedBox(height: 28),
                GenshinButton(
                  label: widget.weapon != null ? 'Save Changes' : 'Create Weapon',
                  icon: widget.weapon != null ? Icons.save_outlined : Icons.add_circle_outline,
                  isLoading: _isSaving,
                  onPressed: _save,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

// ── Weapon Row ─────────────────────────────────────────────────────────────────
class _WeaponRow extends StatelessWidget {
  final Weapon weapon;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const _WeaponRow({required this.weapon, required this.onEdit, required this.onDelete});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 8),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.glassBorder),
        color: AppColors.glassWhite,
      ),
      child: Row(
        children: [
          Container(
            width: 40, height: 40,
            decoration: BoxDecoration(
              color: (weapon.rarity == 5 ? AppColors.rarity5 : AppColors.rarity4).withAlpha(40),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: weapon.rarity == 5 ? AppColors.rarity5 : AppColors.rarity4,
                width: 0.5,
              ),
            ),
            child: Icon(Icons.auto_awesome,
              color: weapon.rarity == 5 ? AppColors.rarity5 : AppColors.rarity4,
              size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(weapon.name, style: AppTextStyles.labelMedium.copyWith(fontSize: 13),
                  maxLines: 1, overflow: TextOverflow.ellipsis),
                Text('${weapon.typeLabel} • Rp ${weapon.price.toStringAsFixed(0)} • Stock: ${weapon.stock}',
                  style: AppTextStyles.caption, maxLines: 1, overflow: TextOverflow.ellipsis),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.edit_outlined, color: AppColors.hydro, size: 18),
            onPressed: onEdit,
            tooltip: 'Edit',
          ),
          IconButton(
            icon: const Icon(Icons.delete_outline, color: AppColors.error, size: 18),
            onPressed: onDelete,
            tooltip: 'Delete',
          ),
        ],
      ),
    );
  }
}

// ── Analytic Card ──────────────────────────────────────────────────────────────
class _AnalyticCard extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color color;

  const _AnalyticCard({
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: color.withAlpha(80)),
          color: color.withAlpha(20),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: color, size: 20),
            const SizedBox(height: 6),
            Text(value, style: AppTextStyles.headingMedium.copyWith(color: color, fontSize: 22)),
            Text(label, style: AppTextStyles.caption, maxLines: 1, overflow: TextOverflow.ellipsis),
          ],
        ),
      ),
    );
  }
}
