import 'dart:async';
import '../models/models.dart';

class PropertyFilter {
  final PropertyType? type;
  final String? city;
  final double? minPrice;
  final double? maxPrice;
  final int? minBedrooms;
  final bool? isAvailable;
  const PropertyFilter({this.type, this.city, this.minPrice, this.maxPrice, this.minBedrooms, this.isAvailable});
}

class PropertyService extends ChangeNotifier {
  List<Property> _allProperties = [];
  List<Property> _properties = [];
  List<Property> get properties => _properties;

  PropertyFilter _activeFilter = const PropertyFilter();
  PropertyFilter get activeFilter => _activeFilter;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  PropertyService() {
    _init();
  }

  Future<void> _init() async {
    _allProperties = [];
    await Future.delayed(const Duration(milliseconds: 200));
    _generateMockData();
  }

  void _generateMockData() {
    _allProperties = [
      Property(
        id: '1', ownerId: 'owner_1', ownerName: 'Proprio Douala', ownerVerified: true, ownerTrusted: true,
        title: 'Villa moderne à Bonapriso', description: 'Magnifique villa 4 chambres avec piscine, jardin et garage. Quartier sécurisé.', type: PropertyType.villa, city: 'Douala', district: 'Bonapriso',
        address: 'Bonapriso, Douala, Cameroun',
        latitude: 4.0511, longitude: 9.7679, photoUrls: ['https://picsum.photos/seed/lokate1/600/400'],
        tour360Urls: id.hashCode % 2 == 0 ? ['https://picsum.photos/seed/lokate3601/800/400'] : [],
        priceDisplay: PriceDisplay.exact, exactPrice: 850000, bedrooms: 5, bathrooms: 4, surface: 320,
        amenities: ['WiFi', 'Parking', 'Climatisation'], isAvailable: true, reservationMode: ReservationMode.immediate,
        isCertified: true, rating: 4.5, ratingCount: 23,
        createdAt: DateTime.now().subtract(Duration(days: 10)), updatedAt: DateTime.now(),
      ),
      Property(
        id: '2', ownerId: 'owner_2', ownerName: 'Proprio Akwa', ownerVerified: true, ownerTrusted: false,
        title: 'Appartement 3 pièces Akwa', description: 'Bel appartement au cœur d\'Akwa, proche commerces et transports.', type: PropertyType.appartement, city: 'Douala', district: 'Akwa',
        address: 'Akwa, Douala, Cameroun',
        latitude: 4.0483, longitude: 9.7043, photoUrls: ['https://picsum.photos/seed/lokate2/600/400'],
        tour360Urls: [],
        priceDisplay: PriceDisplay.exact, exactPrice: 250000, bedrooms: 3, bathrooms: 2, surface: 110,
        amenities: ['WiFi', 'Climatisation'], isAvailable: true, reservationMode: ReservationMode.immediate,
        isCertified: false, rating: 4.2, ratingCount: 15,
        createdAt: DateTime.now().subtract(Duration(days: 20)), updatedAt: DateTime.now(),
      ),
      Property(
        id: '3', ownerId: 'owner_3', ownerName: 'Proprio Bonamoussadi', ownerVerified: false, ownerTrusted: true,
        title: 'Studio meublé Bonamoussadi', description: 'Studio moderne meublé, idéal étudiant ou jeune pro.', type: PropertyType.studio, city: 'Douala', district: 'Bonamoussadi',
        address: 'Bonamoussadi, Douala, Cameroun',
        latitude: 4.0910, longitude: 9.7400, photoUrls: ['https://picsum.photos/seed/lokate3/600/400'],
        tour360Urls: [],
        priceDisplay: PriceDisplay.exact, exactPrice: 80000, bedrooms: 1, bathrooms: 1, surface: 35,
        amenities: ['WiFi'], isAvailable: true, reservationMode: ReservationMode.immediate,
        isCertified: false, rating: 3.8, ratingCount: 8,
        createdAt: DateTime.now().subtract(Duration(days: 30)), updatedAt: DateTime.now(),
      ),
      Property(
        id: '4', ownerId: 'owner_4', ownerName: 'Proprio Bastos', ownerVerified: true, ownerTrusted: true,
        title: 'Duplex Bastos Yaoundé', description: 'Duplex luxueux à Bastos, 5 chambres, vue panoramique.', type: PropertyType.duplex, city: 'Yaoundé', district: 'Bastos',
        address: 'Bastos, Yaoundé, Cameroun',
        latitude: 3.8480, longitude: 11.5021, photoUrls: ['https://picsum.photos/seed/lokate4/600/400'],
        tour360Urls: id.hashCode % 2 == 0 ? ['https://picsum.photos/seed/lokate3604/800/400'] : [],
        priceDisplay: PriceDisplay.exact, exactPrice: 1200000, bedrooms: 5, bathrooms: 4, surface: 400,
        amenities: ['WiFi', 'Parking', 'Piscine', 'Climatisation'], isAvailable: true, reservationMode: ReservationMode.immediate,
        isCertified: true, rating: 4.8, ratingCount: 42,
        createdAt: DateTime.now().subtract(Duration(days: 5)), updatedAt: DateTime.now(),
      ),
      Property(
        id: '5', ownerId: 'owner_5', ownerName: 'Proprio Mendong', ownerVerified: true, ownerTrusted: false,
        title: 'Maison familiale Mendong', description: 'Maison 4 chambres avec cour, calme et sécurisé.', type: PropertyType.maison, city: 'Yaoundé', district: 'Mendong',
        address: 'Mendong, Yaoundé, Cameroun',
        latitude: 3.8300, longitude: 11.4800, photoUrls: ['https://picsum.photos/seed/lokate5/600/400'],
        tour360Urls: [],
        priceDisplay: PriceDisplay.exact, exactPrice: 400000, bedrooms: 4, bathrooms: 3, surface: 200,
        amenities: ['WiFi', 'Jardin'], isAvailable: true, reservationMode: ReservationMode.immediate,
        isCertified: false, rating: 4.1, ratingCount: 18,
        createdAt: DateTime.now().subtract(Duration(days: 15)), updatedAt: DateTime.now(),
      ),
    ];
    _properties = List.from(_allProperties);
    notifyListeners();
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
      final price = p.exactPrice ?? 0;
      if (_activeFilter.minPrice != null && price < _activeFilter.minPrice!) return false;
      if (_activeFilter.maxPrice != null && price > _activeFilter.maxPrice!) return false;
      if (_activeFilter.minBedrooms != null && p.bedrooms < _activeFilter.minBedrooms!) return false;
      return true;
    }).toList();
    notifyListeners();
  }

  Future<void> fetchProperties() async {
    _isLoading = true;
    notifyListeners();
    await Future.delayed(const Duration(milliseconds: 400));
    _applyFilter();
    _isLoading = false;
    notifyListeners();
  }

  Future<Property?> getProperty(String id) async {
    return _allProperties.firstWhere((p) => p.id == id, orElse: () => throw Exception('Property not found'));
  }

  Future<List<Property>> getOwnerProperties(String ownerId) async {
    return _allProperties.where((p) => p.ownerId == ownerId).toList();
  }

  Future<void> updateProperty(String propertyId, Map<String, dynamic> data) async {
    final idx = _allProperties.indexWhere((p) => p.id == propertyId);
    if (idx >= 0) notifyListeners();
  }

  Future<void> toggleAvailability(String propertyId, bool isAvailable) async {
    final idx = _allProperties.indexWhere((p) => p.id == propertyId);
    if (idx >= 0) {
      final old = _allProperties[idx];
      _allProperties[idx] = Property(
        id: old.id, ownerId: old.ownerId, ownerName: old.ownerName,
        ownerPhotoUrl: old.ownerPhotoUrl, ownerVerified: old.ownerVerified, ownerTrusted: old.ownerTrusted,
        title: old.title, description: old.description, type: old.type, city: old.city, district: old.district,
        address: old.address, latitude: old.latitude, longitude: old.longitude,
        photoUrls: old.photoUrls, tour360Urls: old.tour360Urls,
        priceDisplay: old.priceDisplay, exactPrice: old.exactPrice, bedrooms: old.bedrooms, bathrooms: old.bathrooms,
        surface: old.surface, amenities: old.amenities, isAvailable: isAvailable, reservationMode: old.reservationMode,
        isCertified: old.isCertified, rating: old.rating, ratingCount: old.ratingCount,
        createdAt: old.createdAt, updatedAt: DateTime.now(),
      );
      _applyFilter();
    }
  }

  Future<void> deleteProperty(String propertyId) {
    _allProperties.removeWhere((p) => p.id == propertyId);
    _applyFilter();
  }

  Future<String> addProperty(Property property, List<String> photoUrls, List<String> tour360Urls) async {
    final newProp = Property(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      ownerId: property.ownerId, ownerName: property.ownerName,
      title: property.title, description: property.description,
      type: property.type, city: property.city, district: property.district, address: property.address,
      latitude: property.latitude, longitude: property.longitude,
      photoUrls: photoUrls.isNotEmpty ? photoUrls : ['https://picsum.photos/seed/new${DateTime.now().millisecondsSinceEpoch}/600/400'],
      priceDisplay: property.priceDisplay, exactPrice: property.exactPrice, bedrooms: property.bedrooms,
      bathrooms: property.bathrooms, surface: property.surface, amenities: property.amenities,
      isAvailable: property.isAvailable, reservationMode: property.reservationMode,
      isCertified: property.isCertified, rating: property.rating, ratingCount: property.ratingCount,
      createdAt: DateTime.now(), updatedAt: DateTime.now(),
    );
    _allProperties.insert(0, newProp);
    _applyFilter();
    return newProp.id;
  }

  Future<List<dynamic>> getPropertyReviews(String propertyId) async {
    return [
      {'id': 'r1', 'authorName': 'Jean M.', 'rating': 5, 'comment': 'Excellent logement, très propre !', 'createdAt': DateTime.now().subtract(const Duration(days: 5)).toIso8601String()},
      {'id': 'r2', 'authorName': 'Marie K.', 'rating': 4, 'comment': 'Bien situé, propriétaire réactif.', 'createdAt': DateTime.now().subtract(const Duration(days: 12)).toIso8601String()},
    ];
  }

  Future<void> addReview(dynamic review) async {}

  @override
  void dispose() {
    super.dispose();
  }
}