import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/models.dart';

/// AuthService — Mode démo offline 100% (sans Firebase)
/// Réactiver Firebase en décommentant les dépendances dans pubspec.yaml
/// et en restaurant l'implémentation Firebase complète
class AuthService extends ChangeNotifier {
  static const String _demoUsersKey = 'lokate_demo_users';
  static const String _demoSessionKey = 'lokate_demo_session';

  AppUser? _currentUser;
  AppUser? get currentUser => _currentUser;
  bool get isLoggedIn => _currentUser != null;
  bool get isDemoMode => true;

  AuthService() {
    _restoreDemoSession();
  }

  Future<void> _restoreDemoSession() async {
    final prefs = await SharedPreferences.getInstance();
    final email = prefs.getString(_demoSessionKey);
    if (email == null || email.isEmpty) return;
    final user = await _getStoredDemoUser(email);
    if (user != null) {
      _currentUser = user;
      notifyListeners();
    }
  }

  Future<AppUser?> _getStoredDemoUser(String email) async {
    final prefs = await SharedPreferences.getInstance();
    final users = prefs.getStringList(_demoUsersKey) ?? <String>[];
    for (final raw in users) {
      final data = jsonDecode(raw) as Map<String, dynamic>;
      if ((data['email'] as String?) == email) {
        final role = UserRole.values.firstWhere((e) => e.name == data['role'], orElse: () => UserRole.locataire);
        return AppUser(id: email, name: data['name'] ?? 'Utilisateur', email: email, role: role, createdAt: DateTime.now());
      }
    }
    return null;
  }

  Future<void> _saveDemoUser({required String name, required String email, required String password, required UserRole role}) async {
    final prefs = await SharedPreferences.getInstance();
    final users = prefs.getStringList(_demoUsersKey) ?? <String>[];
    final userMap = {'name': name, 'email': email, 'password': password, 'role': role.name, 'createdAt': DateTime.now().toIso8601String()};
    final existingIndex = users.indexWhere((raw) {
      final data = jsonDecode(raw) as Map<String, dynamic>;
      return (data['email'] as String?) == email;
    });
    if (existingIndex >= 0) {
      users[existingIndex] = jsonEncode(userMap);
    } else {
      users.add(jsonEncode(userMap));
    }
    await prefs.setStringList(_demoUsersKey, users);
    await prefs.setString(_demoSessionKey, email);
    _currentUser = AppUser(id: email, name: name, email: email, role: role, createdAt: DateTime.now());
    notifyListeners();
  }

  Future<bool> registerWithEmail({required String name, required String email, required String password, required UserRole role}) async {
    await _saveDemoUser(name: name, email: email, password: password, role: role);
    return true;
  }

  Future<bool> loginWithEmail(String email, String password) async {
    final prefs = await SharedPreferences.getInstance();
    final users = prefs.getStringList(_demoUsersKey) ?? <String>[];
    for (final raw in users) {
      final data = jsonDecode(raw) as Map<String, dynamic>;
      if ((data['email'] as String?) == email && (data['password'] as String?) == password) {
        await prefs.setString(_demoSessionKey, email);
        _currentUser = AppUser(
          id: email,
          name: data['name'] ?? 'Utilisateur',
          email: email,
          role: UserRole.values.firstWhere((e) => e.name == data['role'], orElse: () => UserRole.locataire),
          createdAt: DateTime.now(),
        );
        notifyListeners();
        return true;
      }
    }
    return false;
  }

  Future<bool> signInWithGoogle({UserRole role = UserRole.locataire}) async {
    await _saveDemoUser(name: 'Google User', email: 'google-user@demo.local', password: 'demo-google', role: role);
    return true;
  }

  Future<void> sendOtp({required String phone, required Function(String verificationId) onCodeSent, required Function(String error) onError}) async {
    onCodeSent('demo-verification-id');
  }

  Future<bool> verifyOtp({required String verificationId, required String smsCode, required String name, required UserRole role}) async {
    await _saveDemoUser(name: name, email: 'phone-user@demo.local', password: 'demo-phone', role: role);
    return true;
  }

  Future<void> signOut() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_demoSessionKey);
    _currentUser = null;
    notifyListeners();
  }

  Future<void> resetPassword(String email) async {}
}
