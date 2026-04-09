import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../repositories/auth_repository.dart';
import '../models/user_model.dart';

class AuthProvider extends ChangeNotifier {
  final AuthRepository _authRepository = AuthRepository();

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  UserModel? _currentUser;
  UserModel? get currentUser => _currentUser;

  bool _isAuthenticated = false;
  bool get isAuthenticated => _isAuthenticated;

  Future<void> checkAuthStatus() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token');
    if (token != null && token.isNotEmpty) {
      try {
        final res = await _authRepository.getUser();
        if (res['success'] == true) {
          _currentUser = UserModel.fromJson(res['data']);
          _isAuthenticated = true;
        } else {
          await logout();
        }
      } catch (e) {
        // Token might be invalid
        await logout();
      }
    }
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
        
        _currentUser = UserModel.fromJson(res['data']['user'] ?? {});
        final roles = List<String>.from(res['data']['roles'] ?? []);
        // Save roles for router
        await prefs.setStringList('user_roles', roles);
        
        _isAuthenticated = true;
        _isLoading = false;
        notifyListeners();
        return true;
      }
      return false;
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      rethrow;
    }
  }

  Future<void> logout() async {
    await _authRepository.logout();
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('auth_token');
    await prefs.remove('user_roles');
    _currentUser = null;
    _isAuthenticated = false;
    notifyListeners();
  }
}
