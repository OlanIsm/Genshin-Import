import 'package:flutter/foundation.dart';
import '../models/weapon.dart';
import '../models/artifact.dart';
import '../services/api_service.dart';

class WeaponProvider extends ChangeNotifier {
  List<Weapon> _weapons = [];
  List<Artifact> _artifacts = [];
  bool _isLoading = false;
  String? _errorMessage;
  String _selectedCategory = 'All';
  String _searchQuery = '';

  List<Weapon> get weapons => _filteredWeapons;
  List<Weapon> get allWeapons => _weapons;
  List<Artifact> get artifacts => _artifacts;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  String get selectedCategory => _selectedCategory;
  String get searchQuery => _searchQuery;

  List<Weapon> get _filteredWeapons {
    var list = _weapons;
    if (_selectedCategory != 'All' && _selectedCategory != 'Artifacts') {
      list = list.where((w) => w.typeLabel == _selectedCategory).toList();
    }
    if (_searchQuery.isNotEmpty) {
      list = list.where((w) =>
        w.name.toLowerCase().contains(_searchQuery.toLowerCase())).toList();
    }
    return list;
  }

  List<Weapon> get featuredWeapons =>
      _weapons.where((w) => w.rarity == 5).take(5).toList();

  List<Weapon> get trendingWeapons =>
      _weapons.where((w) => w.rarity >= 4).take(4).toList();

  Future<void> loadWeapons() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();
    try {
      _weapons = await ApiService.getWeapons();
      _artifacts = await ApiService.getArtifacts();
    } catch (e) {
      _errorMessage = 'Failed to load weapons. Using offline data.';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void setCategory(String category) {
    _selectedCategory = category;
    notifyListeners();
  }

  void setSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  void toggleFavorite(int weaponId) {
    final idx = _weapons.indexWhere((w) => w.id == weaponId);
    if (idx != -1) {
      _weapons[idx] = _weapons[idx].copyWith(isFavorite: !_weapons[idx].isFavorite);
      notifyListeners();
    }
  }

  List<Weapon> get favoriteWeapons => _weapons.where((w) => w.isFavorite).toList();

  // ── Admin CRUD ────────────────────────────────────────────────────────────
  Future<void> createWeapon(Map<String, dynamic> data) async {
    final weapon = await ApiService.createWeapon(data);
    _weapons.add(weapon);
    notifyListeners();
  }

  Future<void> updateWeapon(int id, Map<String, dynamic> data) async {
    final updated = await ApiService.updateWeapon(id, data);
    final idx = _weapons.indexWhere((w) => w.id == id);
    if (idx != -1) _weapons[idx] = updated;
    notifyListeners();
  }

  Future<void> deleteWeapon(int id) async {
    await ApiService.deleteWeapon(id);
    _weapons.removeWhere((w) => w.id == id);
    notifyListeners();
  }
}
