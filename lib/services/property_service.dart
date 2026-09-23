import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import '../models/models.dart';
import '../data/cameroun.dart';

class PropertyFilter {
  final PropertyType? type;
  final String? city;
  final String? district;
  final double? minPrice;
  final double? maxPrice;
  final int? minBedrooms;
  final bool? isAvailable;
  const PropertyFilter({this.type, this.city, this.district, this.minPrice, this.maxPrice, this.minBedrooms, this.isAvailable});
}

/// PropertyService — Hybride Firebase temps réel + Mock fallback
/// Si Firebase configuré : écoute Firestore en temps réel pour status/disponibilité
/// Sinon : utilise 24 biens mock (10 régions, vendable offline)
class PropertyService extends ChangeNotifier {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  List<Property> _allProperties = [];
  List<Property> _properties = [];
  List<Property> get properties => _properties;

  PropertyFilter _activeFilter = const PropertyFilter();
  PropertyFilter get activeFilter => _activeFilter;

  bool _isLoading = false;
  bool get isLoading => _isLoading;
  bool _isFirebaseMode = false;
  bool get isFirebaseMode => _isFirebaseMode;

  StreamSubscription<QuerySnapshot>? _realtimeSub;

  PropertyService() {
    _init();
  }

  Future<void> _init() async {
    // Teste si Firebase est configuré (pas demo)
    try {
      final test = await _db.collection('properties').limit(1).get();
      _isFirebaseMode = true;
      _listenRealtime();
    } catch (_) {
      _isFirebaseMode = false;
      _generateMockData();
    }
  }

  void _listenRealtime() {
    _isLoading = true;
    notifyListeners();
    _realtimeSub = _db.collection('properties').orderBy('createdAt', descending: true).limit(100).snapshots().listen((snap) {
      _allProperties = snap.docs.map((d) => Property.fromFirestore(d)).toList();
      if (_allProperties.isEmpty) _generateMockData(silent: true);
      _applyFilter();
      _isLoading = false;
      notifyListeners();
    }, onError: (_) {
      _generateMockData();
      _isLoading = false;
      notifyListeners();
    });
  }

  void _generateMockData({bool silent = false}) {
    if (!silent) {
      _allProperties = [
        _mock('1', 'Villa moderne à Bonapriso', 'Magnifique villa 4 chambres avec piscine, jardin et garage. Quartier sécurisé.', PropertyType.villa, 'Douala', 'Bonapriso', 4.0511, 9.7679, 850000, 5, 4, 320, true),
        _mock('2', 'Appartement 3 pièces Akwa', 'Bel appartement au cœur d\'Akwa, proche commerces et transports.', PropertyType.appartement, 'Douala', 'Akwa', 4.0483, 9.7043, 250000, 3, 2, 110, true),
        _mock('3', 'Studio meublé Bonamoussadi', 'Studio moderne meublé, idéal étudiant ou jeune pro.', PropertyType.studio, 'Douala', 'Bonamoussadi', 4.0910, 9.7400, 80000, 1, 1, 35, true),
        _mock('4', 'Duplex Bastos Yaoundé', 'Duplex luxueux à Bastos, 5 chambres, vue panoramique.', PropertyType.duplex, 'Yaoundé', 'Bastos', 3.8480, 11.5021, 1200000, 5, 4, 400, true),
        _mock('5', 'Maison familiale Mendong', 'Maison 4 chambres avec cour, calme et sécurisé.', PropertyType.maison, 'Yaoundé', 'Mendong', 3.8300, 11.4800, 400000, 4, 3, 200, true),
        _mock('6', 'Chambre Emana', 'Chambre meublée propre, eau et électricité incluses.', PropertyType.chambre, 'Yaoundé', 'Emana', 3.9000, 11.5200, 35000, 1, 1, 18, true),
        _mock('7', 'Villa Bafoussam Tamdja', 'Villa 3 chambres, grand terrain, quartier résidentiel.', PropertyType.villa, 'Bafoussam', 'Tamdja', 5.4778, 10.4170, 300000, 3, 2, 180, true),
        _mock('8', 'Bureau Dschang centre', 'Bureau 60m² centre-ville, idéal cabinet ou startup.', PropertyType.bureau, 'Dschang', 'Centre', 5.4450, 10.0550, 150000, 2, 1, 60, true),
        _mock('9', 'Appartement Bamenda Nkwen', 'Appartement 2 pièces, bien aéré, proche université.', PropertyType.appartement, 'Bamenda', 'Nkwen', 5.9631, 10.1591, 120000, 2, 1, 75, true),
        _mock('10', 'Maison Molyko Buea', 'Maison 3 chambres proche UB, parfaite pour étudiants.', PropertyType.maison, 'Buea', 'Molyko', 4.1527, 9.2406, 200000, 3, 2, 140, true),
        _mock('11', 'Villa bord de mer Kribi', 'Villa pieds dans l\'eau, 4 chambres, vue océan.', PropertyType.villa, 'Kribi', 'Lobé', 2.9400, 9.9100, 950000, 4, 3, 280, true),
        _mock('12', 'Commerce Kribi centre', 'Local commercial 40m² face mer, fort passage.', PropertyType.commerce, 'Kribi', 'New Bell', 2.9350, 9.9150, 180000, 1, 1, 40, true),
        _mock('13', 'Maison Bertoua Monou', 'Maison 3 chambres, grande cour, calme.', PropertyType.maison, 'Bertoua', 'Monou', 4.5773, 13.6846, 180000, 3, 2, 160, true),
        _mock('14', 'Terrain Ngaoundéré Bali', 'Terrain 500m² titré, zone résidentielle en pleine expansion.', PropertyType.terrain, 'Ngaoundéré', 'Bali', 7.3265, 13.5847, 4500000, 1, 1, 500, true),
        _mock('15', 'Appartement Joli Soir', 'Appartement 2 pièces moderne, proche centre.', PropertyType.appartement, 'Ngaoundéré', 'Joli Soir', 7.3200, 13.5900, 140000, 2, 1, 85, true),
        _mock('16', 'Villa Garoua Roumdé', 'Villa 4 chambres avec climatisation, grand jardin.', PropertyType.villa, 'Garoua', 'Roumdé Adjia', 9.3000, 13.4000, 500000, 4, 3, 250, true),
        _mock('17', 'Studio Yelwa Garoua', 'Studio 30m² proche marché, bon état.', PropertyType.studio, 'Garoua', 'Yelwa', 9.3050, 13.4050, 60000, 1, 1, 30, true),
        _mock('18', 'Maison Maroua Pitoare', 'Maison 3 chambres, cour spacieuse, sécurisée.', PropertyType.maison, 'Maroua', 'Pitoare', 10.5900, 14.3150, 160000, 3, 2, 150, true),
        _mock('19', 'Commerce Maroua Domayo', 'Boutique 25m² centre-ville, très bon emplacement.', PropertyType.commerce, 'Maroua', 'Domayo', 10.5950, 14.3200, 90000, 1, 1, 25, true),
        _mock('20', 'Duplex Makepe Douala', 'Duplex 4 chambres, finitions haut de gamme.', PropertyType.duplex, 'Douala', 'Makepe', 4.0700, 9.7500, 600000, 4, 3, 220, true),
        _mock('21', 'Terrain Bonapriso Douala', 'Terrain 800m² titré Bonapriso, zone huppée.', PropertyType.terrain, 'Douala', 'Bonapriso', 4.0520, 9.7680, 12000000, 1, 1, 800, true),
        _mock('22', 'Bureau Akwa Douala', 'Open space 120m² Akwa, vue sur mer, 5 bureaux.', PropertyType.bureau, 'Douala', 'Akwa', 4.0490, 9.7050, 800000, 5, 3, 120, true),
        _mock('23', 'Chambre Bonamoussadi', 'Chambre avec douche interne, sécurisée.', PropertyType.chambre, 'Douala', 'Bonamoussadi', 4.0920, 9.7410, 40000, 1, 1, 20, true),
        _mock('24', 'Maison Bastos Yaoundé', 'Maison standing Bastos, 5 chambres, piscine.', PropertyType.maison, 'Yaoundé', 'Bastos', 3.8490, 11.5030, 1500000, 5, 5, 450, false),
      ];
    }
    _properties = List.from(_allProperties);
    if (!silent) notifyListeners();
  }

  Property _mock(String id, String title, String desc, PropertyType type, String city, String district, double lat, double lng, double price, int bed, int bath, double surf, bool avail) {
    return Property(
      id: id, ownerId: 'owner_$id', ownerName: 'Proprio $city', ownerVerified: true, ownerTrusted: id.hashCode % 3 == 0,
      title: title, description: desc, type: type, city: city, district: district, address: '$district, $city, Cameroun',
      latitude: lat, longitude: lng, photoUrls: ['https://picsum.photos/seed/lokate$id/600/400'],
      tour360Urls: id.hashCode % 2 == 0 ? ['https://picsum.photos/seed/lokate360$id/800/400'] : [],
      priceDisplay: PriceDisplay.exact, exactPrice: price, bedrooms: bed, bathrooms: bath, surface: surf,
      amenities: ['WiFi', 'Parking', 'Climatisation'], isAvailable: avail, reservationMode: ReservationMode.immediate,
      isCertified: id.hashCode % 4 == 0, rating: 3.8 + (id.hashCode % 12) / 10, ratingCount: 5 + id.hashCode % 20,
      createdAt: DateTime.now().subtract(Duration(days: id.hashCode % 30)), updatedAt: DateTime.now(),
    );
  }

  void setFilter(PropertyFilter filter) {
    _activeFilter = filter;
    _applyFilter();
  }

  void _applyFilter() {
    _properties = _allProperties.where((p) {
      if (_activeFilter.type != null && p.type != _activeFilter.type) return false;
      if (_activeFilter.city != null && p.city != _activeFilter.city) return false;
      if (_activeFilter.isAvailable != null && p.isAvailable != _activeFilter.isAvailable) return false;
      final price = p.exactPrice ?? p.minPrice ?? 0;
      if (_activeFilter.minPrice != null && price < _activeFilter.minPrice!) return false;
      if (_activeFilter.maxPrice != null && price > _activeFilter.maxPrice!) return false;
      if (_activeFilter.minBedrooms != null && p.bedrooms < _activeFilter.minBedrooms!) return false;
      return true;
    }).toList();
    notifyListeners();
  }

  Future<void> fetchProperties() async {
    if (_isFirebaseMode) return; // temps réel gère déjà
    _isLoading = true;
    notifyListeners();
    await Future.delayed(const Duration(milliseconds: 400));
    _applyFilter();
    _isLoading = false;
    notifyListeners();
  }

  Future<Property?> getProperty(String id) async {
    try {
      if (_isFirebaseMode) {
        final doc = await _db.collection('properties').doc(id).get();
        if (doc.exists) return Property.fromFirestore(doc);
      }
      return _allProperties.firstWhere((p) => p.id == id);
    } catch (_) {
      try { return _allProperties.firstWhere((p) => p.id == id); } catch (_) { return null; }
    }
  }

  Future<List<Property>> getOwnerProperties(String ownerId) async {
    if (_isFirebaseMode) {
      try {
        final snap = await _db.collection('properties').where('ownerId', isEqualTo: ownerId).orderBy('createdAt', descending: true).get();
        return snap.docs.map((d) => Property.fromFirestore(d)).toList();
      } catch (_) {}
    }
    return _allProperties.where((p) => p.ownerId == ownerId).toList();
  }

  Future<void> updateProperty(String propertyId, Map<String, dynamic> data) async {
    if (_isFirebaseMode) {
      data['updatedAt'] = Timestamp.now();
      await _db.collection('properties').doc(propertyId).update(data);
    } else {
      final idx = _allProperties.indexWhere((p) => p.id == propertyId);
      if (idx >= 0) notifyListeners();
    }
  }

  Future<void> toggleAvailability(String propertyId, bool isAvailable) async {
    if (_isFirebaseMode) {
      await _db.collection('properties').doc(propertyId).update({'isAvailable': isAvailable, 'updatedAt': Timestamp.now()});
    } else {
      final idx = _allProperties.indexWhere((p) => p.id == propertyId);
      if (idx >= 0) {
        final old = _allProperties[idx];
        _allProperties[idx] = Property(
          id: old.id, ownerId: old.ownerId, ownerName: old.ownerName, ownerPhotoUrl: old.ownerPhotoUrl,
          ownerVerified: old.ownerVerified, ownerTrusted: old.ownerTrusted, title: old.title, description: old.description,
          type: old.type, city: old.city, district: old.district, address: old.address, latitude: old.latitude, longitude: old.longitude,
          photoUrls: old.photoUrls, tour360Urls: old.tour360Urls, priceDisplay: old.priceDisplay, exactPrice: old.exactPrice,
          minPrice: old.minPrice, maxPrice: old.maxPrice, bedrooms: old.bedrooms, bathrooms: old.bathrooms, surface: old.surface,
          amenities: old.amenities, isAvailable: isAvailable, reservationMode: old.reservationMode, isCertified: old.isCertified,
          rating: old.rating, ratingCount: old.ratingCount, createdAt: old.createdAt, updatedAt: DateTime.now(),
        );
        _applyFilter();
      }
    }
  }

  Future<void> deleteProperty(String propertyId) async {
    if (_isFirebaseMode) {
      await _db.collection('properties').doc(propertyId).delete();
    } else {
      _allProperties.removeWhere((p) => p.id == propertyId);
      _applyFilter();
    }
  }

  Future<String> addProperty(Property property, List<File> photos, List<File> tour360) async {
    if (_isFirebaseMode) {
      final photoUrls = <String>[];
      for (final file in photos) {
        final ref = _storage.ref('properties/${DateTime.now().millisecondsSinceEpoch}_${file.path.split('/').last}');
        await ref.putFile(file);
        photoUrls.add(await ref.getDownloadURL());
      }
      final tour360Urls = <String>[];
      for (final file in tour360) {
        final ref = _storage.ref('tours/${DateTime.now().millisecondsSinceEpoch}_${file.path.split('/').last}');
        await ref.putFile(file);
        tour360Urls.add(await ref.getDownloadURL());
      }
      final data = property.toFirestore()..['photoUrls'] = photoUrls..['tour360Urls'] = tour360Urls;
      final doc = await _db.collection('properties').add(data);
      return doc.id;
    } else {
      final newProp = Property(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        ownerId: property.ownerId, ownerName: property.ownerName, title: property.title, description: property.description,
        type: property.type, city: property.city, district: property.district, address: property.address,
        latitude: property.latitude, longitude: property.longitude, photoUrls: ['https://picsum.photos/seed/new${DateTime.now().millisecondsSinceEpoch}/600/400'],
        priceDisplay: property.priceDisplay, exactPrice: property.exactPrice, bedrooms: property.bedrooms, bathrooms: property.bathrooms,
        surface: property.surface, amenities: property.amenities, isAvailable: property.isAvailable, reservationMode: property.reservationMode,
        createdAt: DateTime.now(), updatedAt: DateTime.now(),
      );
      _allProperties.insert(0, newProp);
      _applyFilter();
      return newProp.id;
    }
  }

  Future<List<Review>> getPropertyReviews(String propertyId) async {
    if (_isFirebaseMode) {
      try {
        final snap = await _db.collection('reviews').where('targetId', isEqualTo: propertyId).orderBy('createdAt', descending: true).get();
        return snap.docs.map((d) => Review.fromFirestore(d)).toList();
      } catch (_) {}
    }
    return [
      Review(id: 'r1', authorId: 'u1', authorName: 'Jean M.', targetId: propertyId, targetType: 'property', rating: 5, comment: 'Excellent logement, très propre !', createdAt: DateTime.now().subtract(const Duration(days: 5))),
      Review(id: 'r2', authorId: 'u2', authorName: 'Marie K.', targetId: propertyId, targetType: 'property', rating: 4, comment: 'Bien situé, propriétaire réactif.', createdAt: DateTime.now().subtract(const Duration(days: 12))),
    ];
  }

  Future<void> addReview(Review review) async {
    if (_isFirebaseMode) {
      await _db.collection('reviews').add({
        'authorId': review.authorId, 'authorName': review.authorName, 'authorPhotoUrl': review.authorPhotoUrl,
        'targetId': review.targetId, 'targetType': review.targetType, 'rating': review.rating,
        'comment': review.comment, 'createdAt': Timestamp.fromDate(review.createdAt),
      });
      if (review.targetType == 'property') {
        final reviews = await getPropertyReviews(review.targetId);
        if (reviews.isNotEmpty) {
          final avg = reviews.map((r) => r.rating).reduce((a, b) => a + b) / reviews.length;
          await _db.collection('properties').doc(review.targetId).update({'rating': avg, 'ratingCount': reviews.length});
        }
      }
    }
  }

  @override
  void dispose() {
    _realtimeSub?.cancel();
    super.dispose();
  }
}
