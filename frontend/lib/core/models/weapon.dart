
enum WeaponType { sword, claymore, polearm, catalyst, bow }
enum ElementType { anemo, pyro, hydro, electro, cryo, geo, dendro, none }

class Weapon {
  final int id;
  final String name;
  final WeaponType type;
  final ElementType element;
  final int rarity;
  final double price;
  final int stock;
  final String description;
  final String imageUrl;
  final int attack;
  final double critRate;
  bool isFavorite;

  Weapon({
    required this.id,
    required this.name,
    required this.type,
    required this.element,
    required this.rarity,
    required this.price,
    required this.stock,
    required this.description,
    required this.imageUrl,
    required this.attack,
    required this.critRate,
    this.isFavorite = false,
  });

  String get typeLabel {
    final t = type.name;
    return t.substring(0, 1).toUpperCase() + t.substring(1);
  }

  String get elementLabel {
    final e = element.name;
    return e.substring(0, 1).toUpperCase() + e.substring(1);
  }

  String get rarityStars => '★' * rarity;

  factory Weapon.fromJson(Map<String, dynamic> json) {
    return Weapon(
      id: json['id'] as int,
      name: json['name'] as String,
      type: WeaponType.values.firstWhere(
        (e) => e.name == (json['type'] as String).toLowerCase(),
        orElse: () => WeaponType.sword,
      ),
      element: ElementType.values.firstWhere(
        (e) => e.name == (json['element'] as String? ?? 'none').toLowerCase(),
        orElse: () => ElementType.none,
      ),
      rarity: json['rarity'] as int? ?? 3,
      price: (json['price'] as num).toDouble(),
      stock: json['stock'] as int? ?? 0,
      description: json['description'] as String? ?? '',
      imageUrl: json['image_url'] as String? ?? '',
      attack: json['attack'] as int? ?? 0,
      critRate: (json['crit_rate'] as num?)?.toDouble() ?? 0.0,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'type': type.name,
    'element': element.name,
    'rarity': rarity,
    'price': price,
    'stock': stock,
    'description': description,
    'image_url': imageUrl,
    'attack': attack,
    'crit_rate': critRate,
  };

  Weapon copyWith({
    String? name,
    WeaponType? type,
    ElementType? element,
    int? rarity,
    double? price,
    int? stock,
    String? description,
    String? imageUrl,
    int? attack,
    double? critRate,
    bool? isFavorite,
  }) {
    return Weapon(
      id: id,
      name: name ?? this.name,
      type: type ?? this.type,
      element: element ?? this.element,
      rarity: rarity ?? this.rarity,
      price: price ?? this.price,
      stock: stock ?? this.stock,
      description: description ?? this.description,
      imageUrl: imageUrl ?? this.imageUrl,
      attack: attack ?? this.attack,
      critRate: critRate ?? this.critRate,
      isFavorite: isFavorite ?? this.isFavorite,
    );
  }
}
