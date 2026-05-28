import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/weapon.dart';
import '../models/artifact.dart';
import '../models/user.dart';
import '../models/cart_item.dart';
import '../../data/mock_data.dart';

/// API Service — pre-wired to backend at [baseUrl].
/// Set [useMock] to false when the real backend is running.
class ApiService {
  static const String baseUrl = 'http://10.0.2.2:3000/api';
  static const bool useMock = false;

  // ── Auth Header ────────────────────────────────────────────────────────────
  static Future<Map<String, String>> _authHeaders() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('bearer_token') ?? '';
    return {
      'Content-Type': 'application/json',
      if (token.isNotEmpty) 'Authorization': 'Bearer $token',
    };
  }

  // ── Auth ───────────────────────────────────────────────────────────────────
  static Future<Map<String, dynamic>> login(
    String email,
    String password,
  ) async {
    if (useMock) return MockData.loginResponse(email, password);
    final res = await http.post(
      Uri.parse('$baseUrl/auth/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'password': password}),
    );
    return jsonDecode(res.body) as Map<String, dynamic>;
  }

  static Future<Map<String, dynamic>> register(
    String username,
    String email,
    String password,
  ) async {
    if (useMock) return MockData.registerResponse(username, email);
    final res = await http.post(
      Uri.parse('$baseUrl/auth/register'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'username': username,
        'email': email,
        'password': password,
      }),
    );
    return jsonDecode(res.body) as Map<String, dynamic>;
  }

  // ── Weapons ────────────────────────────────────────────────────────────────
  static Future<List<Weapon>> getWeapons({String? type}) async {
    if (useMock) return MockData.weapons(type: type);
    final headers = await _authHeaders();
    final uri = Uri.parse(
      '$baseUrl/weapons${type != null ? '?type=$type' : ''}',
    );
    final res = await http.get(uri, headers: headers);
    final data = jsonDecode(res.body) as List;
    return data.map((e) => Weapon.fromJson(e)).toList();
  }

  static Future<Weapon> getWeapon(int id) async {
    if (useMock) return MockData.weaponById(id);
    final headers = await _authHeaders();
    final res = await http.get(
      Uri.parse('$baseUrl/weapons/$id'),
      headers: headers,
    );
    return Weapon.fromJson(jsonDecode(res.body));
  }

  static Future<Weapon> createWeapon(Map<String, dynamic> data) async {
    if (useMock) return MockData.createWeapon(data);
    final headers = await _authHeaders();
    final res = await http.post(
      Uri.parse('$baseUrl/weapons'),
      headers: headers,
      body: jsonEncode(data),
    );
    return Weapon.fromJson(jsonDecode(res.body));
  }

  static Future<Weapon> updateWeapon(int id, Map<String, dynamic> data) async {
    if (useMock) return MockData.updateWeapon(id, data);
    final headers = await _authHeaders();
    final res = await http.put(
      Uri.parse('$baseUrl/weapons/$id'),
      headers: headers,
      body: jsonEncode(data),
    );
    return Weapon.fromJson(jsonDecode(res.body));
  }

  static Future<void> deleteWeapon(int id) async {
    if (useMock) {
      MockData.deleteWeapon(id);
      return;
    }
    final headers = await _authHeaders();
    await http.delete(Uri.parse('$baseUrl/weapons/$id'), headers: headers);
  }

  // ── Artifacts ──────────────────────────────────────────────────────────────
  static Future<List<Artifact>> getArtifacts() async {
    if (useMock) return MockData.artifacts();
    final headers = await _authHeaders();
    final res = await http.get(
      Uri.parse('$baseUrl/artifacts'),
      headers: headers,
    );
    final data = jsonDecode(res.body) as List;
    return data.map((e) => Artifact.fromJson(e)).toList();
  }

  // ── Cart ───────────────────────────────────────────────────────────────────
  static Future<List<CartItem>> getCart() async {
    if (useMock) return MockData.cartItems;
    final headers = await _authHeaders();
    final res = await http.get(Uri.parse('$baseUrl/cart'), headers: headers);
    final data = jsonDecode(res.body) as List;
    return data
        .map(
          (e) => CartItem(
            id: e['id'].toString(),
            weapon: e['weapon'] != null ? Weapon.fromJson(e['weapon']) : null,
            quantity: e['quantity'] as int,
          ),
        )
        .toList();
  }

  static Future<void> addToCart(int weaponId, int quantity) async {
    if (useMock) return;
    final headers = await _authHeaders();
    await http.post(
      Uri.parse('$baseUrl/cart'),
      headers: headers,
      body: jsonEncode({'weapon_id': weaponId, 'quantity': quantity}),
    );
  }

  static Future<void> removeFromCart(String cartItemId) async {
    if (useMock) return;
    final headers = await _authHeaders();
    await http.delete(Uri.parse('$baseUrl/cart/$cartItemId'), headers: headers);
  }

  static Future<void> checkout(List<CartItem> items) async {
    if (useMock) return;
    final headers = await _authHeaders();
    final orderItems = items
        .where((item) => item.weapon != null)
        .map(
          (item) => {'weapon_id': item.weapon!.id, 'quantity': item.quantity},
        )
        .toList();

    await http.post(
      Uri.parse('$baseUrl/orders'),
      headers: headers,
      body: jsonEncode({'items': orderItems}),
    );
  }

  // ── User ───────────────────────────────────────────────────────────────────
  static Future<AppUser> getProfile() async {
    if (useMock) return MockData.currentUser;
    final headers = await _authHeaders();
    final res = await http.get(
      Uri.parse('$baseUrl/users/me'),
      headers: headers,
    );
    return AppUser.fromJson(jsonDecode(res.body));
  }
}
