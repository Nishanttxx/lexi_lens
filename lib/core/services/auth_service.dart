import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_model.dart';

class AuthService extends ChangeNotifier {
  static const String _keyCurrentUser = 'lexi_lens_current_user';
  static const String _keyRegisteredUsers = 'lexi_lens_registered_users';

  UserModel? _currentUser;
  bool _isLoading = true;
  String? _authError;

  UserModel? get currentUser => _currentUser;
  bool get isLoading => _isLoading;
  String? get authError => _authError;
  bool get isLoggedIn => _currentUser != null && !_currentUser!.isGuest;
  bool get isGuest => _currentUser?.isGuest ?? true;

  AuthService() {
    _initSession();
  }

  Future<void> _initSession() async {
    _isLoading = true;
    notifyListeners();

    try {
      final prefs = await SharedPreferences.getInstance();
      final userJson = prefs.getString(_keyCurrentUser);
      if (userJson != null && userJson.isNotEmpty) {
        _currentUser = UserModel.fromJson(jsonDecode(userJson) as Map<String, dynamic>);
      } else {
        // Default to a guest user if no session
        _currentUser = UserModel.guest();
      }
    } catch (_) {
      _currentUser = UserModel.guest();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> login(String email, String password) async {
    _isLoading = true;
    _authError = null;
    notifyListeners();

    await Future.delayed(const Duration(milliseconds: 600)); // Smooth UX transition

    final cleanEmail = email.trim().toLowerCase();
    if (cleanEmail.isEmpty || !cleanEmail.contains('@')) {
      _authError = 'Please enter a valid email address.';
      _isLoading = false;
      notifyListeners();
      return false;
    }

    if (password.length < 6) {
      _authError = 'Password must be at least 6 characters.';
      _isLoading = false;
      notifyListeners();
      return false;
    }

    try {
      final prefs = await SharedPreferences.getInstance();
      final registeredMap = _getRegisteredUsers(prefs);

      if (registeredMap.containsKey(cleanEmail)) {
        final userData = registeredMap[cleanEmail]!;
        if (userData['password'] != password) {
          _authError = 'Incorrect password. Please try again.';
          _isLoading = false;
          notifyListeners();
          return false;
        }
        _currentUser = UserModel(
          id: userData['id'] as String,
          email: cleanEmail,
          displayName: userData['display_name'] as String?,
          isGuest: false,
          createdAt: DateTime.tryParse(userData['created_at'] as String) ?? DateTime.now(),
        );
      } else {
        // Automatically create account for ease of testing or authenticate demo accounts
        final newId = 'user_${DateTime.now().millisecondsSinceEpoch}';
        final user = UserModel(
          id: newId,
          email: cleanEmail,
          displayName: cleanEmail.split('@').first,
          isGuest: false,
          createdAt: DateTime.now(),
        );
        registeredMap[cleanEmail] = {
          'id': newId,
          'password': password,
          'display_name': user.displayName,
          'created_at': user.createdAt.toIso8601String(),
        };
        await prefs.setString(_keyRegisteredUsers, jsonEncode(registeredMap));
        _currentUser = user;
      }

      await prefs.setString(_keyCurrentUser, jsonEncode(_currentUser!.toJson()));
      _authError = null;
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _authError = 'Authentication failed: $e';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> signup(String email, String password, {String? displayName}) async {
    _isLoading = true;
    _authError = null;
    notifyListeners();

    await Future.delayed(const Duration(milliseconds: 600));

    final cleanEmail = email.trim().toLowerCase();
    if (cleanEmail.isEmpty || !cleanEmail.contains('@')) {
      _authError = 'Please enter a valid email address.';
      _isLoading = false;
      notifyListeners();
      return false;
    }

    if (password.length < 6) {
      _authError = 'Password must be at least 6 characters.';
      _isLoading = false;
      notifyListeners();
      return false;
    }

    try {
      final prefs = await SharedPreferences.getInstance();
      final registeredMap = _getRegisteredUsers(prefs);

      final newId = 'user_${DateTime.now().millisecondsSinceEpoch}';
      final user = UserModel(
        id: newId,
        email: cleanEmail,
        displayName: displayName?.trim().isNotEmpty == true
            ? displayName!.trim()
            : cleanEmail.split('@').first,
        isGuest: false,
        createdAt: DateTime.now(),
      );

      registeredMap[cleanEmail] = {
        'id': newId,
        'password': password,
        'display_name': user.displayName,
        'created_at': user.createdAt.toIso8601String(),
      };
      await prefs.setString(_keyRegisteredUsers, jsonEncode(registeredMap));

      _currentUser = user;
      await prefs.setString(_keyCurrentUser, jsonEncode(_currentUser!.toJson()));
      _authError = null;
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _authError = 'Signup failed: $e';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<void> continueAsGuest() async {
    _currentUser = UserModel.guest();
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_keyCurrentUser);
    _authError = null;
    notifyListeners();
  }

  Future<void> logout() async {
    _currentUser = UserModel.guest();
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_keyCurrentUser);
    notifyListeners();
  }

  Future<bool> resetPassword(String email) async {
    _isLoading = true;
    _authError = null;
    notifyListeners();

    await Future.delayed(const Duration(milliseconds: 600));

    final cleanEmail = email.trim().toLowerCase();
    if (cleanEmail.isEmpty || !cleanEmail.contains('@')) {
      _authError = 'Please enter a valid email address.';
      _isLoading = false;
      notifyListeners();
      return false;
    }

    _isLoading = false;
    notifyListeners();
    return true;
  }

  Map<String, dynamic> _getRegisteredUsers(SharedPreferences prefs) {
    final raw = prefs.getString(_keyRegisteredUsers);
    if (raw == null || raw.isEmpty) return {};
    try {
      return Map<String, dynamic>.from(jsonDecode(raw) as Map);
    } catch (_) {
      return {};
    }
  }
}
