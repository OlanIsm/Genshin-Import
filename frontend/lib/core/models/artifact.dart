enum ArtifactType { flowerOfLife, plume, sandsOfEon, gobletOfEonothem, circletOfLogos }

class Artifact {
  final int id;
  final String name;
  final String setName;
  final ArtifactType type;
  final int rarity;
  final double price;
  final int stock;
  final String description;
  final String imageUrl;
  bool isFavorite;

  Artifact({
    required this.id,
    required this.name,
    required this.setName,
    required this.type,
    required this.rarity,
    required this.price,
    required this.stock,
    required this.description,
    required this.imageUrl,
    this.isFavorite = false,
  });

  String get typeLabel {
    switch (type) {
      case ArtifactType.flowerOfLife:     return 'Flower of Life';
      case ArtifactType.plume:            return 'Plume';
      case ArtifactType.sandsOfEon:       return 'Sands of Eon';
      case ArtifactType.gobletOfEonothem: return 'Goblet of Eonothem';
      case ArtifactType.circletOfLogos:   return 'Circlet of Logos';
    }
  }

  String get rarityStars => '★' * rarity;

  factory Artifact.fromJson(Map<String, dynamic> json) {
    return Artifact(
      id: json['id'] as int,
      name: json['name'] as String,
      setName: json['set_name'] as String? ?? '',
      type: ArtifactType.values.firstWhere(
        (e) => e.name == (json['type'] as String? ?? 'flowerOfLife'),
        orElse: () => ArtifactType.flowerOfLife,
      ),
      rarity: json['rarity'] as int? ?? 3,
      price: (json['price'] as num).toDouble(),
      stock: json['stock'] as int? ?? 0,
      description: json['description'] as String? ?? '',
      imageUrl: json['image_url'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'set_name': setName,
    'type': type.name,
    'rarity': rarity,
    'price': price,
    'stock': stock,
    'description': description,
    'image_url': imageUrl,
  };
}
