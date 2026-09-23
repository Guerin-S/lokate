// Stub Firestore pour build offline sans Firebase
class Timestamp {
  final DateTime _date;
  const Timestamp._(this._date);
  factory Timestamp.fromDate(DateTime date) => Timestamp._(date);
  DateTime toDate() => _date;
  static Timestamp now() => Timestamp._(DateTime.now());
}

class DocumentSnapshot {
  final String id;
  final Map<String, dynamic> _data;
  DocumentSnapshot(this.id, this._data);
  dynamic get data => _data;
  bool get exists => true;
}

DateTime _parseDate(dynamic v) {
  if (v == null) return DateTime.now();
  if (v is Timestamp) return v.toDate();
  if (v is DateTime) return v;
  if (v is String) return DateTime.tryParse(v) ?? DateTime.now();
  return DateTime.now();
}

// ─── Enums ───────────────────────────────────────────────────────────────────

enum UserRole { locataire, proprietaire }
enum PropertyType { appartement, studio, villa, chambre, maison, duplex, terrain, bureau, commerce, autre }
enum PriceDisplay { exact, range }
enum ReservationMode { immediate, approval }
enum PaymentMethod { mtnMomo, orangeMoney, stripe }
enum PaymentFrequency { monthly, yearly }
enum ReservationStatus { pending, approved, rejected, active, completed, cancelled }
enum ContractStatus { draft, signed, active, terminated }
enum SubscriptionTier { gratuit, decouverte, pro, premium }

// ─── User ────────────────────────────────────────────────────────────────────

class AppUser {
  final String id;
  final String name;
  final String email;
  final String? phone;
  final String? photoUrl;
  final UserRole role;
  final bool isVerified;
  final bool isTrusted;
  final double rating;
  final int ratingCount;
  final DateTime createdAt;
  final String? fcmToken;
  final String language; // 'fr' | 'en'
  final SubscriptionTier subscriptionTier;
  final DateTime? subscriptionExpiry;

  AppUser({
    required this.id,
    required this.name,
    required this.email,
    this.phone,
    this.photoUrl,
    required this.role,
    this.isVerified = false,
    this.isTrusted = false,
    this.rating = 0.0,
    this.ratingCount = 0,
    required this.createdAt,
    this.fcmToken,
    this.language = 'fr',
    this.subscriptionTier = SubscriptionTier.gratuit,
    this.subscriptionExpiry,
  });

  factory AppUser.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return AppUser(
      id: doc.id,
      name: data['name'] ?? '',
      email: data['email'] ?? '',
      phone: data['phone'],
      photoUrl: data['photoUrl'],
      role: UserRole.values.firstWhere((e) => e.name == data['role'], orElse: () => UserRole.locataire),
      isVerified: data['isVerified'] ?? false,
      isTrusted: data['isTrusted'] ?? false,
      rating: (data['rating'] ?? 0.0).toDouble(),
      ratingCount: data['ratingCount'] ?? 0,
      createdAt: _parseDate(data['createdAt']),
      fcmToken: data['fcmToken'],
      language: data['language'] ?? 'fr',
      subscriptionTier: SubscriptionTier.values.firstWhere((e) => e.name == data['subscriptionTier'], orElse: () => SubscriptionTier.gratuit),
      subscriptionExpiry: data['subscriptionExpiry'] != null ? _parseDate(data['subscriptionExpiry']) : null,
    );
  }

  Map<String, dynamic> toFirestore() => {
    'name': name,
    'email': email,
    'phone': phone,
    'photoUrl': photoUrl,
    'role': role.name,
    'isVerified': isVerified,
    'isTrusted': isTrusted,
    'rating': rating,
    'ratingCount': ratingCount,
    'createdAt': Timestamp.fromDate(createdAt),
    'fcmToken': fcmToken,
    'language': language,
    'subscriptionTier': subscriptionTier.name,
    'subscriptionExpiry': subscriptionExpiry != null ? Timestamp.fromDate(subscriptionExpiry!) : null,
  };
}

// ─── Property ────────────────────────────────────────────────────────────────

class Property {
  final String id;
  final String ownerId;
  final String ownerName;
  final String? ownerPhotoUrl;
  final bool ownerVerified;
  final bool ownerTrusted;

  final String title;
  final String description;
  final PropertyType type;
  final String city;        // ex: "Douala"
  final String district;    // ex: "Bonapriso"
  final String address;
  final double latitude;
  final double longitude;

  final List<String> photoUrls;
  final List<String> tour360Urls; // URLs images 360°

  final PriceDisplay priceDisplay;
  final double? exactPrice;
  final double? minPrice;
  final double? maxPrice;

  final int bedrooms;
  final int bathrooms;
  final double surface; // m²
  final List<String> amenities;

  final bool isAvailable;
  final ReservationMode reservationMode;
  final bool isCertified;

  final double rating;
  final int ratingCount;
  final DateTime createdAt;
  final DateTime updatedAt;

  Property({
    required this.id,
    required this.ownerId,
    required this.ownerName,
    this.ownerPhotoUrl,
    this.ownerVerified = false,
    this.ownerTrusted = false,
    required this.title,
    required this.description,
    required this.type,
    required this.city,
    required this.district,
    required this.address,
    required this.latitude,
    required this.longitude,
    required this.photoUrls,
    this.tour360Urls = const [],
    required this.priceDisplay,
    this.exactPrice,
    this.minPrice,
    this.maxPrice,
    this.bedrooms = 1,
    this.bathrooms = 1,
    this.surface = 0,
    this.amenities = const [],
    this.isAvailable = true,
    required this.reservationMode,
    this.isCertified = false,
    this.rating = 0.0,
    this.ratingCount = 0,
    required this.createdAt,
    required this.updatedAt,
  });

  String get priceLabel {
    if (priceDisplay == PriceDisplay.exact && exactPrice != null) {
      return '${exactPrice!.toStringAsFixed(0)} FCFA/mois';
    } else if (priceDisplay == PriceDisplay.range && minPrice != null && maxPrice != null) {
      return '${minPrice!.toStringAsFixed(0)} - ${maxPrice!.toStringAsFixed(0)} FCFA/mois';
    }
    return 'Prix sur demande';
  }

  factory Property.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Property(
      id: doc.id,
      ownerId: data['ownerId'] ?? '',
      ownerName: data['ownerName'] ?? '',
      ownerPhotoUrl: data['ownerPhotoUrl'],
      ownerVerified: data['ownerVerified'] ?? false,
      ownerTrusted: data['ownerTrusted'] ?? false,
      title: data['title'] ?? '',
      description: data['description'] ?? '',
      type: PropertyType.values.firstWhere((e) => e.name == data['type'], orElse: () => PropertyType.appartement),
      city: data['city'] ?? 'Douala',
      district: data['district'] ?? '',
      address: data['address'] ?? '',
      latitude: (data['latitude'] ?? 4.05).toDouble(),
      longitude: (data['longitude'] ?? 9.70).toDouble(),
      photoUrls: List<String>.from(data['photoUrls'] ?? []),
      tour360Urls: List<String>.from(data['tour360Urls'] ?? []),
      priceDisplay: PriceDisplay.values.firstWhere((e) => e.name == data['priceDisplay'], orElse: () => PriceDisplay.exact),
      exactPrice: data['exactPrice']?.toDouble(),
      minPrice: data['minPrice']?.toDouble(),
      maxPrice: data['maxPrice']?.toDouble(),
      bedrooms: data['bedrooms'] ?? 1,
      bathrooms: data['bathrooms'] ?? 1,
      surface: (data['surface'] ?? 0).toDouble(),
      amenities: List<String>.from(data['amenities'] ?? []),
      isAvailable: data['isAvailable'] ?? true,
      reservationMode: ReservationMode.values.firstWhere((e) => e.name == data['reservationMode'], orElse: () => ReservationMode.approval),
      isCertified: data['isCertified'] ?? false,
      rating: (data['rating'] ?? 0.0).toDouble(),
      ratingCount: data['ratingCount'] ?? 0,
      createdAt: _parseDate(data['createdAt']),
      updatedAt: _parseDate(data['updatedAt']),
    );
  }

  Map<String, dynamic> toFirestore() => {
    'ownerId': ownerId,
    'ownerName': ownerName,
    'ownerPhotoUrl': ownerPhotoUrl,
    'ownerVerified': ownerVerified,
    'ownerTrusted': ownerTrusted,
    'title': title,
    'description': description,
    'type': type.name,
    'city': city,
    'district': district,
    'address': address,
    'latitude': latitude,
    'longitude': longitude,
    'photoUrls': photoUrls,
    'tour360Urls': tour360Urls,
    'priceDisplay': priceDisplay.name,
    'exactPrice': exactPrice,
    'minPrice': minPrice,
    'maxPrice': maxPrice,
    'bedrooms': bedrooms,
    'bathrooms': bathrooms,
    'surface': surface,
    'amenities': amenities,
    'isAvailable': isAvailable,
    'reservationMode': reservationMode.name,
    'isCertified': isCertified,
    'rating': rating,
    'ratingCount': ratingCount,
    'createdAt': Timestamp.fromDate(createdAt),
    'updatedAt': Timestamp.fromDate(updatedAt),
  };
}

// ─── Reservation ─────────────────────────────────────────────────────────────

class Reservation {
  final String id;
  final String propertyId;
  final String propertyTitle;
  final String tenantId;
  final String tenantName;
  final String ownerId;
  final ReservationStatus status;
  final PaymentFrequency paymentFrequency;
  final double amount;
  final DateTime startDate;
  final DateTime? endDate;
  final DateTime createdAt;
  final String? message;

  Reservation({
    required this.id,
    required this.propertyId,
    required this.propertyTitle,
    required this.tenantId,
    required this.tenantName,
    required this.ownerId,
    required this.status,
    required this.paymentFrequency,
    required this.amount,
    required this.startDate,
    this.endDate,
    required this.createdAt,
    this.message,
  });

  factory Reservation.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Reservation(
      id: doc.id,
      propertyId: data['propertyId'] ?? '',
      propertyTitle: data['propertyTitle'] ?? '',
      tenantId: data['tenantId'] ?? '',
      tenantName: data['tenantName'] ?? '',
      ownerId: data['ownerId'] ?? '',
      status: ReservationStatus.values.firstWhere((e) => e.name == data['status'], orElse: () => ReservationStatus.pending),
      paymentFrequency: PaymentFrequency.values.firstWhere((e) => e.name == data['paymentFrequency'], orElse: () => PaymentFrequency.monthly),
      amount: (data['amount'] ?? 0).toDouble(),
      startDate: _parseDate(data['startDate']),
      endDate: data['endDate'] != null ? _parseDate(data['endDate']) : null,
      createdAt: _parseDate(data['createdAt']),
      message: data['message'],
    );
  }
}

// ─── Message ─────────────────────────────────────────────────────────────────

class ChatMessage {
  final String id;
  final String senderId;
  final String senderName;
  final String? senderPhotoUrl;
  final String content;
  final bool isRead;
  final DateTime sentAt;
  final String? imageUrl;

  ChatMessage({
    required this.id,
    required this.senderId,
    required this.senderName,
    this.senderPhotoUrl,
    required this.content,
    this.isRead = false,
    required this.sentAt,
    this.imageUrl,
  });

  factory ChatMessage.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return ChatMessage(
      id: doc.id,
      senderId: data['senderId'] ?? '',
      senderName: data['senderName'] ?? '',
      senderPhotoUrl: data['senderPhotoUrl'],
      content: data['content'] ?? '',
      isRead: data['isRead'] ?? false,
      sentAt: _parseDate(data['sentAt']),
      imageUrl: data['imageUrl'],
    );
  }

  Map<String, dynamic> toFirestore() => {
    'senderId': senderId,
    'senderName': senderName,
    'senderPhotoUrl': senderPhotoUrl,
    'content': content,
    'isRead': isRead,
    'sentAt': Timestamp.fromDate(sentAt),
    'imageUrl': imageUrl,
  };
}

// ─── Review ──────────────────────────────────────────────────────────────────

class Review {
  final String id;
  final String authorId;
  final String authorName;
  final String? authorPhotoUrl;
  final String targetId;   // propertyId ou userId
  final String targetType; // 'property' | 'owner' | 'tenant'
  final double rating;
  final String comment;
  final DateTime createdAt;

  Review({
    required this.id,
    required this.authorId,
    required this.authorName,
    this.authorPhotoUrl,
    required this.targetId,
    required this.targetType,
    required this.rating,
    required this.comment,
    required this.createdAt,
  });

  factory Review.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Review(
      id: doc.id,
      authorId: data['authorId'] ?? '',
      authorName: data['authorName'] ?? '',
      authorPhotoUrl: data['authorPhotoUrl'],
      targetId: data['targetId'] ?? '',
      targetType: data['targetType'] ?? 'property',
      rating: (data['rating'] ?? 0.0).toDouble(),
      comment: data['comment'] ?? '',
      createdAt: _parseDate(data['createdAt']),
    );
  }
}

// ─── Payment ─────────────────────────────────────────────────────────────────

class Payment {
  final String id;
  final String reservationId;
  final String tenantId;
  final String ownerId;
  final double amount;
  final PaymentMethod method;
  final String status; // 'pending' | 'success' | 'failed'
  final DateTime createdAt;
  final String? transactionRef;

  Payment({
    required this.id,
    required this.reservationId,
    required this.tenantId,
    required this.ownerId,
    required this.amount,
    required this.method,
    required this.status,
    required this.createdAt,
    this.transactionRef,
  });
}
