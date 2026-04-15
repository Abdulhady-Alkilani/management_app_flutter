import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../repositories/auth_repository.dart';
import '../models/user_model.dart';

class AuthProvider extends ChangeNotifier {
  final AuthRepository _authRepository = AuthRepository();

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  /// Whether the initial auth check has completed (splash → ready to route)
  bool _isInitialized = false;
  bool get isInitialized => _isInitialized;

  UserModel? _currentUser;
  UserModel? get currentUser => _currentUser;

  bool _isAuthenticated = false;
  bool get isAuthenticated => _isAuthenticated;

  /// Quick accessor for the user's primary role
  String? get userRole {
    if (_currentUser != null && _currentUser!.roles.isNotEmpty) {
      return _currentUser!.roles.first;
    }
    return null;
  }

  /// Returns true if the user has the given role (case-insensitive partial match)
  bool hasRole(String role) {
    if (_currentUser == null) return false;
    return _currentUser!.roles
        .any((r) => r.toLowerCase().contains(role.toLowerCase()));
  }

  /// Called once on startup to validate the stored token
  Future<void> checkAuthStatus() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token');

    if (token != null && token.isNotEmpty) {
      try {
        final res = await _authRepository.getUser();
        if (res['success'] == true) {
          _currentUser = UserModel.fromJson(res['data']);
          // Also restore roles from prefs if not in /user response
          if (_currentUser!.roles.isEmpty) {
            final savedRoles = prefs.getStringList('user_roles') ?? [];
            _currentUser = UserModel(
              id: _currentUser!.id,
              firstName: _currentUser!.firstName,
              lastName: _currentUser!.lastName,
              username: _currentUser!.username,
              email: _currentUser!.email,
              gender: _currentUser!.gender,
              name: _currentUser!.name,
              roles: savedRoles,
            );
          }
          _isAuthenticated = true;
        } else {
          await _clearSession();
        }
      } catch (e) {
        // Token might be invalid or server unreachable
        await _clearSession();
      }
    }

    _isInitialized = true;
    notifyListeners();
  }

  Future<bool> login(String username, String password) async {
    _isLoading = true;
    notifyListeners();
    try {
      final res = await _authRepository.login(username, password);
      if (res['success'] == true) {
        final token = res['data']['token'];
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('auth_token', token);

        final roles = List<String>.from(res['data']['roles'] ?? []);
        await prefs.setStringList('user_roles', roles);

        // Build user from login response (user object + roles)
        final userData = Map<String, dynamic>.from(res['data']['user'] ?? {});
        userData['roles'] = roles;
        _currentUser = UserModel.fromJson(userData);

        _isAuthenticated = true;
        _isLoading = false;
        notifyListeners();
        return true;
      }
      _isLoading = false;
      notifyListeners();
      return false;
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      rethrow;
    }
  }

  Future<void> logout() async {
    try {
      await _authRepository.logout();
    } catch (_) {
      // Server failure should not block local cleanup
    }
    await _clearSession();
    notifyListeners();
  }

  Future<void> _clearSession() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('auth_token');
    await prefs.remove('user_roles');
    _currentUser = null;
    _isAuthenticated = false;
  }
}
