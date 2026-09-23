/// Données Cameroun — 10 Régions
/// Support complet pour LOKATE v2 vendable

class CamerounRegion {
  final String name;
  final String capital;
  final List<String> cities;
  final List<String> districts; // quartiers principaux
  final double lat;
  final double lng;

  const CamerounRegion({
    required this.name,
    required this.capital,
    required this.cities,
    required this.districts,
    required this.lat,
    required this.lng,
  });
}

class CamerounData {
  static const List<CamerounRegion> regions = [
    CamerounRegion(
      name: 'Centre',
      capital: 'Yaoundé',
      cities: ['Yaoundé', 'Mbalmayo', 'Obala', 'Monatélé'],
      districts: ['Bastos', 'Mendong', 'Emana', 'Essos', 'Nlongkak', 'Mvan', 'Odza', 'Etoudi'],
      lat: 3.8480, lng: 11.5021,
    ),
    CamerounRegion(
      name: 'Littoral',
      capital: 'Douala',
      cities: ['Douala', 'Edéa', 'Nkongsamba', 'Loum'],
      districts: ['Bonapriso', 'Akwa', 'Bonamoussadi', 'Makepe', 'Deido', 'Ndokoti', 'Kotto', 'Logbessou'],
      lat: 4.0511, lng: 9.7679,
    ),
    CamerounRegion(
      name: 'Ouest',
      capital: 'Bafoussam',
      cities: ['Bafoussam', 'Dschang', 'Foumban', 'Mbouda'],
      districts: ['Tamdja', 'Djeleng', 'Kamkop', 'Ndiangdam', 'Famla'],
      lat: 5.4778, lng: 10.4170,
    ),
    CamerounRegion(
      name: 'Nord-Ouest',
      capital: 'Bamenda',
      cities: ['Bamenda', 'Kumbo', 'Ndop', 'Wum'],
      districts: ['Commercial Avenue', 'Nkwen', 'Mankon', 'Bambili'],
      lat: 5.9631, lng: 10.1591,
    ),
    CamerounRegion(
      name: 'Sud-Ouest',
      capital: 'Buea',
      cities: ['Buea', 'Limbe', 'Kumba', 'Mamfe'],
      districts: ['Molyko', 'Mile 17', 'Buea Town', 'Great Soppo'],
      lat: 4.1527, lng: 9.2406,
    ),
    CamerounRegion(
      name: 'Sud',
      capital: 'Ebolowa',
      cities: ['Ebolowa', 'Kribi', 'Sangmélima', 'Ambam'],
      districts: ['Angalé', 'New Bell', 'Mokolo', 'Lobé'],
      lat: 2.9000, lng: 11.1500,
    ),
    CamerounRegion(
      name: 'Est',
      capital: 'Bertoua',
      cities: ['Bertoua', 'Abong-Mbang', 'Batouri', 'Yokadouma'],
      districts: ['Monou', 'Nkolbikon', 'Enia', 'Tigaza'],
      lat: 4.5773, lng: 13.6846,
    ),
    CamerounRegion(
      name: 'Adamaoua',
      capital: 'Ngaoundéré',
      cities: ['Ngaoundéré', 'Meiganga', 'Tibati', 'Banyo'],
      districts: ['Bali', 'Dang', 'Joli Soir', 'Sabongari'],
      lat: 7.3265, lng: 13.5847,
    ),
    CamerounRegion(
      name: 'Nord',
      capital: 'Garoua',
      cities: ['Garoua', 'Guider', 'Pitoa', 'Figuil'],
      districts: ['Roumdé Adjia', 'Yelwa', 'Lainde', 'Barmari'],
      lat: 9.3000, lng: 13.4000,
    ),
    CamerounRegion(
      name: 'Extrême-Nord',
      capital: 'Maroua',
      cities: ['Maroua', 'Kousseri', 'Mokolo', 'Yagoua'],
      districts: ['Pitoare', 'Domayo', 'Dougoï', 'Makabaye'],
      lat: 10.5900, lng: 14.3150,
    ),
  ];

  static List<String> get allCities => regions.expand((r) => r.cities).toList();

  static List<String> get allDistricts => regions.expand((r) => r.districts).toList();

  static List<String> get mainCities => regions.map((r) => r.capital).toList();

  /// Trouve la région d'une ville
  static CamerounRegion? regionForCity(String city) {
    for (final region in regions) {
      if (region.cities.contains(city) || region.capital == city) return region;
    }
    return null;
  }
}

/// Types de biens étendus — Tout type
class PropertyTypeHelper {
  static const Map<String, String> labelsFr = {
    'appartement': 'Appartement',
    'studio': 'Studio',
    'villa': 'Villa',
    'chambre': 'Chambre',
    'maison': 'Maison',
    'duplex': 'Duplex',
    'terrain': 'Terrain',
    'bureau': 'Bureau',
    'commerce': 'Commerce',
    'autre': 'Autre',
  };

  static const Map<String, String> labelsEn = {
    'appartement': 'Apartment',
    'studio': 'Studio',
    'villa': 'Villa',
    'chambre': 'Room',
    'maison': 'House',
    'duplex': 'Duplex',
    'terrain': 'Land',
    'bureau': 'Office',
    'commerce': 'Shop',
    'autre': 'Other',
  };

  static const Map<String, String> icons = {
    'appartement': '🏢',
    'studio': '🏠',
    'villa': '🏡',
    'chambre': '🛏️',
    'maison': '🏘️',
    'duplex': '🏘️',
    'terrain': '🌿',
    'bureau': '🏢',
    'commerce': '🏪',
    'autre': '📦',
  };

  static String label(String type, {bool isEn = false}) {
    final map = isEn ? labelsEn : labelsFr;
    return map[type] ?? type;
  }
}

/// Abonnements proprio
class SubscriptionHelper {
  static const Map<String, Map<String, dynamic>> tiers = {
    'gratuit': {
      'name': 'Gratuit',
      'price': 0,
      'maxProperties': 1,
      'features': ['1 bien', 'Photos limitées', 'Support de base'],
      'color': 0xFF6B7C8D,
    },
    'decouverte': {
      'name': 'Découverte',
      'price': 5000,
      'maxProperties': 3,
      'features': ['3 biens', 'Visite 360°', 'Mise en avant', 'Support prioritaire'],
      'color': 0xFF0F2B3D,
    },
    'pro': {
      'name': 'Pro',
      'price': 15000,
      'maxProperties': 10,
      'features': ['10 biens', 'Visite 360°', 'Badge Vérifié', 'Statistiques', 'Support 24h'],
      'color': 0xFFC5A059,
    },
    'premium': {
      'name': 'Premium',
      'price': 35000,
      'maxProperties': 999,
      'features': ['Illimité', 'Tout inclus', 'Badge Premium', 'Top recherche', 'Manager dédié'],
      'color': 0xFF0A1E2B,
    },
  };
}
