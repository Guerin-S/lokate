class Property {
  final String id;
  final String title;
  final String description;
  final double price;
  final String type;
  final String city;
  final bool isAvailable;
  final String imageUrl;

  Property({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    required this.type,
    required this.city,
    required this.isAvailable,
    required this.imageUrl,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'price': price,
      'type': type,
      'city': city,
      'isAvailable': isAvailable,
      'imageUrl': imageUrl,
    };
  }

  factory Property.fromMap(String id, Map<String, dynamic> map) {
    return Property(
      id: id,
      title: map['title'] ?? '',
      description: map['description'] ?? '',
      price: (map['price'] ?? 0.0).toDouble(),
      type: map['type'] ?? 'Appartement',
      city: map['city'] ?? 'Yaoundé',
      isAvailable: map['isAvailable'] ?? true,
      imageUrl: map['imageUrl'] ?? '',
    );
  }
}

class AppUser {
  final String id;
  final String email;
  final String name;
  final String phone;

  AppUser({
    required this.id,
    required this.email,
    required this.name,
    required this.phone,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'email': email,
      'name': name,
      'phone': phone,
    };
  }

  factory AppUser.fromMap(String id, Map<String, dynamic> map) {
    return AppUser(
      id: id,
      email: map['email'] ?? '',
      name: map['name'] ?? '',
      phone: map['phone'] ?? '',
    );
  }
}