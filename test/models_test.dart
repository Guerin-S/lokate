import 'package:flutter_test/flutter_test.dart';
import 'package:lokate/models/models.dart';

void main() {
  group('PropertyType', () {
    test('should have all expected values', () {
      expect(PropertyType.values.length, 5);
      expect(PropertyType.values, contains(PropertyType.appartement));
      expect(PropertyType.values, contains(PropertyType.studio));
      expect(PropertyType.values, contains(PropertyType.villa));
      expect(PropertyType.values, contains(PropertyType.chambre));
      expect(PropertyType.values, contains(PropertyType.autre));
    });
  });

  group('UserRole', () {
    test('should have locataire and proprietaire', () {
      expect(UserRole.values.length, 2);
      expect(UserRole.values, contains(UserRole.locataire));
      expect(UserRole.values, contains(UserRole.proprietaire));
    });
  });

  group('Property model', () {
    test('should create with required fields', () {
      final now = DateTime.now();
      final property = Property(
        id: 'test-id',
        ownerId: 'owner123',
        ownerName: 'Propriétaire Test',
        title: 'Bel appartement',
        description: 'Description test',
        type: PropertyType.appartement,
        city: 'Douala',
        district: 'Bonapriso',
        address: '123 Rue Test',
        latitude: 4.05,
        longitude: 9.70,
        photoUrls: [],
        priceDisplay: PriceDisplay.exact,
        exactPrice: 150000.0,
        reservationMode: ReservationMode.immediate,
        createdAt: now,
        updatedAt: now,
      );

      expect(property.id, 'test-id');
      expect(property.title, 'Bel appartement');
      expect(property.type, PropertyType.appartement);
      expect(property.city, 'Douala');
      expect(property.exactPrice, 150000.0);
      expect(property.bedrooms, 1);
      expect(property.isAvailable, true);
      expect(property.priceLabel, '150000 FCFA/mois');
    });

    test('should serialize to Firestore map', () {
      final now = DateTime.now();
      final property = Property(
        id: 'test-id',
        ownerId: 'owner123',
        ownerName: 'Propriétaire',
        title: 'Villa',
        description: 'Test',
        type: PropertyType.villa,
        city: 'Yaoundé',
        district: 'Bastos',
        address: '456 Rue',
        latitude: 3.87,
        longitude: 11.52,
        photoUrls: ['url1'],
        priceDisplay: PriceDisplay.range,
        minPrice: 100000,
        maxPrice: 200000,
        reservationMode: ReservationMode.approval,
        createdAt: now,
        updatedAt: now,
      );

      final map = property.toFirestore();
      expect(map['title'], 'Villa');
      expect(map['type'], 'villa');
      expect(map['city'], 'Yaoundé');
      expect(map['minPrice'], 100000);
      expect(map['maxPrice'], 200000);
      expect(map['reservationMode'], 'approval');
    });

    test('should handle price display range', () {
      final now = DateTime.now();
      final property = Property(
        id: 'id',
        ownerId: 'owner',
        ownerName: 'Owner',
        title: 'Studio',
        description: 'Desc',
        type: PropertyType.studio,
        city: 'Douala',
        district: 'Akwa',
        address: 'Addr',
        latitude: 4.0,
        longitude: 9.7,
        photoUrls: [],
        priceDisplay: PriceDisplay.range,
        minPrice: 80000,
        maxPrice: 120000,
        reservationMode: ReservationMode.immediate,
        createdAt: now,
        updatedAt: now,
      );

      expect(property.priceLabel, '80000 - 120000 FCFA/mois');
    });
  });

  group('AppUser model', () {
    test('should create with required fields', () {
      final user = AppUser(
        id: 'user-1',
        name: 'Jean Dupont',
        email: 'jean@test.com',
        phone: '699123456',
        role: UserRole.locataire,
        isVerified: true,
        createdAt: DateTime.now(),
      );

      expect(user.id, 'user-1');
      expect(user.name, 'Jean Dupont');
      expect(user.role, UserRole.locataire);
      expect(user.isVerified, true);
      expect(user.language, 'fr');
    });

    test('should serialize to Firestore map', () {
      final user = AppUser(
        id: 'user-1',
        name: 'Jean Dupont',
        email: 'jean@test.com',
        phone: '699123456',
        role: UserRole.locataire,
        isVerified: true,
        createdAt: DateTime(2024, 1, 15),
      );

      final map = user.toFirestore();
      expect(map['name'], 'Jean Dupont');
      expect(map['email'], 'jean@test.com');
      expect(map['role'], 'locataire');
      expect(map['phone'], '699123456');
    });
  });

  group('PaymentMethod', () {
    test('should have all expected values', () {
      expect(PaymentMethod.values.length, 3);
      expect(PaymentMethod.values, contains(PaymentMethod.mtnMomo));
      expect(PaymentMethod.values, contains(PaymentMethod.orangeMoney));
      expect(PaymentMethod.values, contains(PaymentMethod.stripe));
    });
  });

  group('ReservationStatus', () {
    test('should have all expected values', () {
      expect(ReservationStatus.values.length, 6);
      expect(ReservationStatus.values, contains(ReservationStatus.pending));
      expect(ReservationStatus.values, contains(ReservationStatus.approved));
      expect(ReservationStatus.values, contains(ReservationStatus.active));
      expect(ReservationStatus.values, contains(ReservationStatus.rejected));
      expect(ReservationStatus.values, contains(ReservationStatus.completed));
      expect(ReservationStatus.values, contains(ReservationStatus.cancelled));
    });
  });

  group('ChatMessage model', () {
    test('should create with required fields', () {
      final msg = ChatMessage(
        id: 'msg-1',
        senderId: 'user-1',
        senderName: 'Jean',
        content: 'Bonjour',
        sentAt: DateTime(2024, 1, 15, 10, 30),
      );

      expect(msg.id, 'msg-1');
      expect(msg.content, 'Bonjour');
      expect(msg.isRead, false);
      expect(msg.senderName, 'Jean');
    });

    test('should serialize to Firestore map', () {
      final msg = ChatMessage(
        id: 'msg-1',
        senderId: 'user-1',
        senderName: 'Jean',
        content: 'Bonjour',
        sentAt: DateTime(2024, 1, 15, 10, 30),
      );

      final map = msg.toFirestore();
      expect(map['senderId'], 'user-1');
      expect(map['content'], 'Bonjour');
      expect(map['isRead'], false);
    });
  });
}
