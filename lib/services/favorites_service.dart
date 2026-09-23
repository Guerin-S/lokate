import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FavoritesService extends ChangeNotifier {
  static const String _key = 'lokate_favorites';
  Set<String> _favoriteIds = {};
  bool _loaded = false;

  Set<String> get favoriteIds => _favoriteIds;
  bool get isLoaded => _loaded;

  FavoritesService() {
    _load();
  }

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    final list = prefs.getStringList(_key) ?? <String>[];
    _favoriteIds = list.toSet();
    _loaded = true;
    notifyListeners();
  }

  Future<void> _save() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(_key, _favoriteIds.toList());
  }

  bool isFavorite(String propertyId) => _favoriteIds.contains(propertyId);

  Future<void> toggle(String propertyId) async {
    if (_favoriteIds.contains(propertyId)) {
      _favoriteIds.remove(propertyId);
    } else {
      _favoriteIds.add(propertyId);
    }
    await _save();
    notifyListeners();
  }
}
