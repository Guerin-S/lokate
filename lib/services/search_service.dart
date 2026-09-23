import 'dart:async';
import 'package:flutter/material.dart';
import '../models/models.dart';

/// SearchService — Mode démo offline, recherche locale
class SearchService extends ChangeNotifier {
  List<Property> _allProperties = [];
  List<Property> _results = [];
  bool _isSearching = false;
  String _query = '';
  Timer? _debounce;

  List<Property> get results => _results;
  bool get isSearching => _isSearching;
  String get query => _query;

  void setProperties(List<Property> properties) {
    _allProperties = properties;
  }

  void search(String query) {
    _query = query;
    _debounce?.cancel();
    if (query.trim().isEmpty) {
      _results = [];
      _isSearching = false;
      notifyListeners();
      return;
    }
    _debounce = Timer(const Duration(milliseconds: 400), () => _performSearch(query));
  }

  Future<void> _performSearch(String query) async {
    _isSearching = true;
    notifyListeners();
    await Future.delayed(const Duration(milliseconds: 200));
    final q = query.toLowerCase();
    _results = _allProperties.where((p) =>
        p.title.toLowerCase().contains(q) ||
        p.city.toLowerCase().contains(q) ||
        p.district.toLowerCase().contains(q) ||
        p.address.toLowerCase().contains(q) ||
        p.description.toLowerCase().contains(q)).toList();
    _isSearching = false;
    notifyListeners();
  }

  void clear() {
    _query = '';
    _results = [];
    _isSearching = false;
    _debounce?.cancel();
    notifyListeners();
  }

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }
}
