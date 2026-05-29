import 'package:flutter/foundation.dart';
import 'package:uuid/uuid.dart';
import '../models/cart_item.dart';
import '../models/weapon.dart';
import '../models/artifact.dart';

class CartProvider extends ChangeNotifier {
  final List<CartItem> _items = [];
  final _uuid = const Uuid();

  List<CartItem> get items => List.unmodifiable(_items);
  int get itemCount => _items.fold(0, (sum, i) => sum + i.quantity);
  double get totalPrice => _items.fold(0.0, (sum, i) => sum + i.totalPrice);
  bool get isEmpty => _items.isEmpty;

  void addWeapon(Weapon weapon, int quantity) {
    final existingIdx = _items.indexWhere(
      (item) => item.weapon?.id == weapon.id,
    );
    if (existingIdx != -1) {
      final existing = _items[existingIdx];
      final newQty = (existing.quantity + quantity).clamp(1, weapon.stock);
      _items[existingIdx] = CartItem(
        id: existing.id, weapon: weapon, quantity: newQty,
      );
    } else {
      _items.add(CartItem(
        id: _uuid.v4(), weapon: weapon,
        quantity: quantity.clamp(1, weapon.stock),
      ));
    }
    notifyListeners();
  }

  void addArtifact(Artifact artifact, int quantity) {
    final existingIdx = _items.indexWhere(
      (item) => item.artifact?.id == artifact.id,
    );
    if (existingIdx != -1) {
      final existing = _items[existingIdx];
      final newQty = (existing.quantity + quantity).clamp(1, artifact.stock);
      _items[existingIdx] = CartItem(
        id: existing.id, artifact: artifact, quantity: newQty,
      );
    } else {
      _items.add(CartItem(
        id: _uuid.v4(), artifact: artifact,
        quantity: quantity.clamp(1, artifact.stock),
      ));
    }
    notifyListeners();
  }

  void updateQuantity(String itemId, int newQuantity) {
    final idx = _items.indexWhere((i) => i.id == itemId);
    if (idx != -1) {
      if (newQuantity <= 0) {
        _items.removeAt(idx);
      } else {
        final item = _items[idx];
        _items[idx] = CartItem(
          id: item.id,
          weapon: item.weapon,
          artifact: item.artifact,
          quantity: newQuantity.clamp(1, item.maxStock),
        );
      }
      notifyListeners();
    }
  }

  void removeItem(String itemId) {
    _items.removeWhere((i) => i.id == itemId);
    notifyListeners();
  }

  void clearCart() {
    _items.clear();
    notifyListeners();
  }
}
