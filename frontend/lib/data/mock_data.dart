import 'dart:math';
import '../core/models/weapon.dart';
import '../core/models/artifact.dart';
import '../core/models/user.dart';
import '../core/models/cart_item.dart';

/// Static mock data — used when ApiService.useMock == true
class MockData {
  MockData._();

  static final Random _rng = Random();

  // ── Weapon Image URLs (safe placeholder images) ───────────────────────────
  static const List<String> _weaponImages = [
    'https://images.unsplash.com/photo-1536704929015-22f06b42d40a?w=400&q=80', // sword glow
    'https://images.unsplash.com/photo-1593085512500-5d55148d6f0d?w=400&q=80', // magic orb
    'https://images.unsplash.com/photo-1518770660439-4636190af475?w=400&q=80', // tech/mystical
    'https://images.unsplash.com/photo-1571019613454-1cb2f99b2d8b?w=400&q=80', // fantasy
    'https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=400&q=80', // mystical mountain
    'https://images.unsplash.com/photo-1528360983277-13d401cdc186?w=400&q=80', // glowing
    'https://images.unsplash.com/photo-1558618666-fcd25c85cd64?w=400&q=80', // purple magic
    'https://images.unsplash.com/photo-1543722530-d2c3201371e7?w=400&q=80', // night sky
  ];

  static const List<String> _artifactImages = [
    'https://images.unsplash.com/photo-1546435770-a3e426bf472b?w=400&q=80',
    'https://images.unsplash.com/photo-1508615070457-7baeba4003ab?w=400&q=80',
    'https://images.unsplash.com/photo-1611532736597-de2d4265fba3?w=400&q=80',
    'https://images.unsplash.com/photo-1602634742165-b6f3a24f0076?w=400&q=80',
  ];

  // ── Weapons ───────────────────────────────────────────────────────────────
  static final List<Weapon> _weapons = [
    Weapon(
      id: 1, name: 'Primordial Jade Cutter', type: WeaponType.sword,
      element: ElementType.none, rarity: 5, price: 4999.00, stock: 12,
      description: 'A jade polearm, imbued with the memory of Liyue\'s forgotten nation. '
          'Its edge hums with a resonance that cuts through the very breath of mountains.',
      imageUrl: _weaponImages[0], attack: 542, critRate: 44.1,
    ),
    Weapon(
      id: 2, name: 'Wolf\'s Gravestone', type: WeaponType.claymore,
      element: ElementType.none, rarity: 5, price: 4499.00, stock: 8,
      description: 'An ancient claymore hailing from the mountains far in the North. '
          'A wolf howls, and the cold wind answers.',
      imageUrl: _weaponImages[1], attack: 608, critRate: 0.0,
    ),
    Weapon(
      id: 3, name: 'Engulfing Lightning', type: WeaponType.polearm,
      element: ElementType.electro, rarity: 5, price: 5299.00, stock: 5,
      description: 'A polearm that carries the power of the Raiden Shogun\'s vision. '
          'Lightning crackles along its shaft, yearning for the sky.',
      imageUrl: _weaponImages[2], attack: 608, critRate: 55.1,
    ),
    Weapon(
      id: 4, name: 'Skyward Atlas', type: WeaponType.catalyst,
      element: ElementType.anemo, rarity: 5, price: 4799.00, stock: 7,
      description: 'A catalyst infused with the wind of Mondstadt. '
          'Pages flutter like wings; knowledge rides the breeze.',
      imageUrl: _weaponImages[3], attack: 674, critRate: 33.1,
    ),
    Weapon(
      id: 5, name: 'Amos\' Bow', type: WeaponType.bow,
      element: ElementType.none, rarity: 5, price: 4299.00, stock: 9,
      description: 'A legendary bow from the era of the Archons. '
          'Arrows loosed from this bow are blessed by Barbatos himself.',
      imageUrl: _weaponImages[4], attack: 608, critRate: 0.0,
    ),
    Weapon(
      id: 6, name: 'The Flute', type: WeaponType.sword,
      element: ElementType.none, rarity: 4, price: 1299.00, stock: 25,
      description: 'A sword that once belonged to a wandering bard. '
          'Music lingers on its edge.',
      imageUrl: _weaponImages[5], attack: 510, critRate: 0.0,
    ),
    Weapon(
      id: 7, name: 'Rainslasher', type: WeaponType.claymore,
      element: ElementType.hydro, rarity: 4, price: 1199.00, stock: 30,
      description: 'Forged in the blue of ocean waves, this claymore swings with tidal power.',
      imageUrl: _weaponImages[6], attack: 510, critRate: 0.0,
    ),
    Weapon(
      id: 8, name: 'Dragon\'s Bane', type: WeaponType.polearm,
      element: ElementType.pyro, rarity: 4, price: 1099.00, stock: 20,
      description: 'A polearm soaked in draconic fire. Dragons themselves hesitate before it.',
      imageUrl: _weaponImages[7], attack: 454, critRate: 0.0,
    ),
    Weapon(
      id: 9, name: 'Favonius Sword', type: WeaponType.sword,
      element: ElementType.anemo, rarity: 4, price: 1199.00, stock: 22,
      description: 'Knights of Favonius official-issue blade. '
          'Light as the wind, sharp as dawn.',
      imageUrl: _weaponImages[0], attack: 454, critRate: 0.0,
    ),
    Weapon(
      id: 10, name: 'Lithic Blade', type: WeaponType.claymore,
      element: ElementType.geo, rarity: 4, price: 1399.00, stock: 15,
      description: 'Carved from the stone of Liyue\'s bedrock. '
          'As steady and immovable as the mountain Archon\'s will.',
      imageUrl: _weaponImages[1], attack: 510, critRate: 0.0,
    ),
  ];

  // ── Artifacts ─────────────────────────────────────────────────────────────
  static final List<Artifact> _artifacts = [
    Artifact(
      id: 1, name: 'Gladiator\'s Finale', setName: 'Gladiator\'s Finale',
      type: ArtifactType.flowerOfLife, rarity: 5, price: 2499.00, stock: 10,
      description: 'A flower that bloomed on the battlefield. Its petals are said to grant strength.',
      imageUrl: _artifactImages[0],
    ),
    Artifact(
      id: 2, name: 'Crimson Witch\'s Heart', setName: 'Crimson Witch of Flames',
      type: ArtifactType.gobletOfEonothem, rarity: 5, price: 2799.00, stock: 6,
      description: 'A goblet wreathed in eternal flame. The witch\'s obsession lives within.',
      imageUrl: _artifactImages[1],
    ),
    Artifact(
      id: 3, name: 'Thundersoother\'s Mask', setName: 'Thundersoother',
      type: ArtifactType.circletOfLogos, rarity: 4, price: 999.00, stock: 18,
      description: 'A circlet etched with electro sigils. Crackling energy hums within the metal.',
      imageUrl: _artifactImages[2],
    ),
    Artifact(
      id: 4, name: 'Viridescent Venerer\'s Plume', setName: 'Viridescent Venerer',
      type: ArtifactType.plume, rarity: 4, price: 899.00, stock: 22,
      description: 'A feather kissed by Anemo wind. Light as a sigh, swift as a gale.',
      imageUrl: _artifactImages[3],
    ),
    Artifact(
      id: 5, name: 'Archaic Petra Sands', setName: 'Archaic Petra',
      type: ArtifactType.sandsOfEon, rarity: 5, price: 2599.00, stock: 8,
      description: 'Ancient sands from the foundations of Liyue. Time flows differently within.',
      imageUrl: _artifactImages[0],
    ),
  ];

  // ── Cart ──────────────────────────────────────────────────────────────────
  static final List<CartItem> cartItems = [];

  // ── User ──────────────────────────────────────────────────────────────────
  static final AppUser currentUser = AppUser(
    id: 1,
    username: 'Traveler',
    email: 'traveler@teyvat.com',
    avatarUrl: 'https://images.unsplash.com/photo-1535713875002-d1d0cf377fde?w=150&q=80',
    role: 'admin',
    token: null,
  );

  // ── Mock purchase history ─────────────────────────────────────────────────
  static final List<Map<String, dynamic>> purchaseHistory = [
    {'name': 'Primordial Jade Cutter', 'date': '2026-05-01', 'price': 4999.00, 'qty': 1},
    {'name': 'Gladiator\'s Finale', 'date': '2026-04-15', 'price': 2499.00, 'qty': 2},
    {'name': 'Favonius Sword', 'date': '2026-03-28', 'price': 1199.00, 'qty': 1},
  ];

  // ── Methods ───────────────────────────────────────────────────────────────
  static List<Weapon> weapons({String? type}) {
    if (type == null || type.isEmpty) return List.from(_weapons);
    return _weapons.where((w) => w.typeLabel.toLowerCase() == type.toLowerCase()).toList();
  }

  static Weapon weaponById(int id) {
    return _weapons.firstWhere((w) => w.id == id);
  }

  static Weapon createWeapon(Map<String, dynamic> data) {
    final newId = _weapons.map((w) => w.id).reduce((a, b) => a > b ? a : b) + 1;
    final w = Weapon(
      id: newId,
      name: data['name'] as String,
      type: WeaponType.values.firstWhere(
        (e) => e.name == (data['type'] as String).toLowerCase(),
        orElse: () => WeaponType.sword,
      ),
      element: ElementType.none,
      rarity: int.tryParse(data['rarity'].toString()) ?? 3,
      price: double.tryParse(data['price'].toString()) ?? 0,
      stock: int.tryParse(data['stock'].toString()) ?? 0,
      description: data['description'] as String? ?? '',
      imageUrl: data['image_url'] as String? ?? _weaponImages[_rng.nextInt(_weaponImages.length)],
      attack: int.tryParse(data['attack'].toString()) ?? 0,
      critRate: double.tryParse(data['crit_rate'].toString()) ?? 0.0,
    );
    _weapons.add(w);
    return w;
  }

  static Weapon updateWeapon(int id, Map<String, dynamic> data) {
    final idx = _weapons.indexWhere((w) => w.id == id);
    final updated = _weapons[idx].copyWith(
      name: data['name'] as String?,
      rarity: int.tryParse(data['rarity'].toString()),
      price: double.tryParse(data['price'].toString()),
      stock: int.tryParse(data['stock'].toString()),
      description: data['description'] as String?,
      attack: int.tryParse(data['attack'].toString()),
      critRate: double.tryParse(data['crit_rate'].toString()),
    );
    _weapons[idx] = updated;
    return updated;
  }

  static void deleteWeapon(int id) {
    _weapons.removeWhere((w) => w.id == id);
  }

  static List<Artifact> artifacts() => List.from(_artifacts);

  /// Simulates login — returns a JWT-like alphanumeric token (≥20 chars)
  static Map<String, dynamic> loginResponse(String email, String password) {
    const chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789';
    final part1 = List.generate(40, (_) => chars[_rng.nextInt(chars.length)]).join();
    final part2 = List.generate(27, (_) => chars[_rng.nextInt(chars.length)]).join();
    final token = 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.$part1.$part2';
    return {
      'success': true,
      'token': token,
      'user': {
        'id': 1,
        'username': email.split('@').first,
        'email': email,
        'role': 'admin',
        'avatar_url': 'https://images.unsplash.com/photo-1535713875002-d1d0cf377fde?w=150&q=80',
      },
    };
  }

  static Map<String, dynamic> registerResponse(String username, String email) {
    return {'success': true, 'message': 'Account created successfully'};
  }
}
