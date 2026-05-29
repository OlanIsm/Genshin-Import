import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user.dart';
import '../services/api_service.dart';

enum AuthStatus { initial, loading, authenticated, unauthenticated, error }

class AuthProvider extends ChangeNotifier {
  AuthStatus _status = AuthStatus.initial;
  AppUser? _user;
  String? _errorMessage;
  String? _token;

  AuthStatus get status => _status;
  AppUser? get user => _user;
  String? get errorMessage => _errorMessage;
  String? get token => _token;
  bool get isAuthenticated => _status == AuthStatus.authenticated;
  bool get isAdmin => _user?.isAdmin ?? false;

  AuthProvider() {
    _checkStoredToken();
  }

  Future<void> _checkStoredToken() async {
    final prefs = await SharedPreferences.getInstance();
    final storedToken = prefs.getString('bearer_token');
    if (storedToken != null && storedToken.isNotEmpty) {
      _token = storedToken;
      _status = AuthStatus.authenticated;
      // Load profile with stored token
      try {
        _user = await ApiService.getProfile();
      } catch (_) {
        // Use minimal user from prefs
        final email = prefs.getString('user_email') ?? '';
        final username = prefs.getString('user_name') ?? 'Traveler';
        _user = AppUser(id: 0, username: username, email: email, role: 'user');
      }
      notifyListeners();
    } else {
      _status = AuthStatus.unauthenticated;
      notifyListeners();
    }
  }

  Future<bool> login(String email, String password) async {
    _status = AuthStatus.loading;
    _errorMessage = null;
    notifyListeners();

    try {
      final response = await ApiService.login(email, password);
      if (response['success'] == true) {
        _token = response['token'] as String;
        final userData = response['user'] as Map<String, dynamic>;
        _user = AppUser.fromJson({...userData, 'token': _token});

        // Persist token
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('bearer_token', _token!);
        await prefs.setString('user_email', email);
        await prefs.setString('user_name', _user!.username);

        _status = AuthStatus.authenticated;
        notifyListeners();
        return true;
      } else {
        _errorMessage = response['message'] as String? ?? 'Login failed';
        _status = AuthStatus.error;
        notifyListeners();
        return false;
      }
    } catch (e) {
      _errorMessage = 'Connection error. Please check your network.';
      _status = AuthStatus.error;
      notifyListeners();
      return false;
    }
  }

  Future<bool> register(String username, String email, String password) async {
    _status = AuthStatus.loading;
    _errorMessage = null;
    notifyListeners();

    try {
      final response = await ApiService.register(username, email, password);
      if (response['success'] == true) {
        _status = AuthStatus.unauthenticated;
        notifyListeners();
        return true;
      } else {
        _errorMessage = response['message'] as String? ?? 'Registration failed';
        _status = AuthStatus.error;
        notifyListeners();
        return false;
      }
    } catch (e) {
      _errorMessage = 'Connection error. Please try again.';
      _status = AuthStatus.error;
      notifyListeners();
      return false;
    }
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('bearer_token');
    await prefs.remove('user_email');
    await prefs.remove('user_name');
    _token = null;
    _user = null;
    _status = AuthStatus.unauthenticated;
    notifyListeners();
  }

  Future<bool> loginWithGoogle(String email, String username, String googleId) async {
    _status = AuthStatus.loading;
    _errorMessage = null;
    notifyListeners();

    try {
      final response = await ApiService.loginWithGoogle(email, username, googleId);
      if (response['success'] == true) {
        _token = response['token'] as String;
        final userData = response['user'] as Map<String, dynamic>;
        _user = AppUser.fromJson({...userData, 'token': _token});

        // Persist token and user info
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('bearer_token', _token!);
        await prefs.setString('user_email', email);
        await prefs.setString('user_name', _user!.username);

        _status = AuthStatus.authenticated;
        notifyListeners();
        return true;
      } else {
        _errorMessage = response['message'] as String? ?? 'Google login failed';
        _status = AuthStatus.error;
        notifyListeners();
        return false;
      }
    } catch (e) {
      _errorMessage = 'Connection error. Please try again.';
      _status = AuthStatus.error;
      notifyListeners();
      return false;
    }
  }

  void clearError() {
    _errorMessage = null;
    if (_status == AuthStatus.error) {
      _status = AuthStatus.unauthenticated;
    }
    notifyListeners();
  }
}
