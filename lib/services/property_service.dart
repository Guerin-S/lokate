import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';
import '../models/models.dart';

class PropertyFilter {
  final PropertyType? type;
  final String? city;
  final String? district;
  final double? minPrice;
  final double? maxPrice;
  final int? minBedrooms;
  final bool? isAvailable;

  const PropertyFilter({
    this.type,
    this.city,
    this.district,
    this.minPrice,
    this.maxPrice,
    this.minBedrooms,
    this.isAvailable,
  });
}

class PropertyService extends ChangeNotifier {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  List<Property> _properties = [];
  List<Property> get properties => _properties;

  PropertyFilter _activeFilter = const PropertyFilter();
  PropertyFilter get activeFilter => _activeFilter;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  void setFilter(PropertyFilter filter) {
    _activeFilter = filter;
    notifyListeners();
    fetchProperties();
  }

  Future<void> fetchProperties() async {
    _isLoading = true;
    notifyListeners();
    try {
      Query<Map<String, dynamic>> query = _db.collection('properties');

      if (_activeFilter.type != null) {
        query = query.where('type', isEqualTo: _activeFilter.type!.name);
      }
      if (_activeFilter.city != null) {
        query = query.where('city', isEqualTo: _activeFilter.city);
      }
      if (_activeFilter.isAvailable != null) {
        query = query.where('isAvailable', isEqualTo: _activeFilter.isAvailable);
      }

      final snap = await query.orderBy('createdAt', descending: true).limit(50).get();
      _properties = snap.docs.map((d) => Property.fromFirestore(d)).toList();

      // Client-side price filter
      if (_activeFilter.minPrice != null || _activeFilter.maxPrice != null) {
        _properties = _properties.where((p) {
          final price = p.exactPrice ?? p.minPrice ?? 0;
          if (_activeFilter.minPrice != null && price < _activeFilter.minPrice!) return false;
          if (_activeFilter.maxPrice != null && price > _activeFilter.maxPrice!) return false;
          return true;
        }).toList();
      }
    } catch (e) {
      debugPrint('Error fetching properties: $e');
    }
    _isLoading = false;
    notifyListeners();
  }

  Future<Property?> getProperty(String id) async {
    final doc = await _db.collection('properties').doc(id).get();
    if (doc.exists) return Property.fromFirestore(doc);
    return null;
  }

  Future<List<Property>> getOwnerProperties(String ownerId) async {
    final snap = await _db.collection('properties')
        .where('ownerId', isEqualTo: ownerId)
        .orderBy('createdAt', descending: true)
        .get();
    return snap.docs.map((d) => Property.fromFirestore(d)).toList();
  }

  Future<String> addProperty(Property property, List<File> photos, List<File> tour360) async {
    // Upload photos
    final photoUrls = <String>[];
    for (final file in photos) {
      final ref = _storage.ref('properties/${DateTime.now().millisecondsSinceEpoch}_${file.path.split('/').last}');
      await ref.putFile(file);
      photoUrls.add(await ref.getDownloadURL());
    }

    // Upload 360 images
    final tour360Urls = <String>[];
    for (final file in tour360) {
      final ref = _storage.ref('tours/${DateTime.now().millisecondsSinceEpoch}_${file.path.split('/').last}');
      await ref.putFile(file);
      tour360Urls.add(await ref.getDownloadURL());
    }

    final data = property.toFirestore()
      ..['photoUrls'] = photoUrls
      ..['tour360Urls'] = tour360Urls;

    final doc = await _db.collection('properties').add(data);
    return doc.id;
  }

  Future<List<Review>> getPropertyReviews(String propertyId) async {
    final snap = await _db.collection('reviews')
        .where('targetId', isEqualTo: propertyId)
        .orderBy('createdAt', descending: true)
        .get();
    return snap.docs.map((d) => Review.fromFirestore(d)).toList();
  }

  Future<void> addReview(Review review) async {
    await _db.collection('reviews').add({
      'authorId': review.authorId,
      'authorName': review.authorName,
      'authorPhotoUrl': review.authorPhotoUrl,
      'targetId': review.targetId,
      'targetType': review.targetType,
      'rating': review.rating,
      'comment': review.comment,
      'createdAt': Timestamp.fromDate(review.createdAt),
    });

    // Update average rating
    final reviews = await getPropertyReviews(review.targetId);
    final avg = reviews.map((r) => r.rating).reduce((a, b) => a + b) / reviews.length;
    await _db.collection('properties').doc(review.targetId).update({
      'rating': avg,
      'ratingCount': reviews.length,
    });
  }
}
