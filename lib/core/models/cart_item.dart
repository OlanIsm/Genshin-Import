import 'weapon.dart';
import 'artifact.dart';

class CartItem {
  final String id;
  final Weapon? weapon;
  final Artifact? artifact;
  int quantity;

  CartItem({
    required this.id,
    this.weapon,
    this.artifact,
    required this.quantity,
  }) : assert(weapon != null || artifact != null, 'CartItem must have weapon or artifact');

  String get name => weapon?.name ?? artifact?.name ?? '';
  String get imageUrl => weapon?.imageUrl ?? artifact?.imageUrl ?? '';
  double get unitPrice => weapon?.price ?? artifact?.price ?? 0;
  double get totalPrice => unitPrice * quantity;
  int get maxStock => weapon?.stock ?? artifact?.stock ?? 0;
}
