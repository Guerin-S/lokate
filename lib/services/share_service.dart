import 'package:share_plus/share_plus.dart';
import '../models/models.dart';

class ShareService {
  static Future<void> shareProperty(Property property) async {
    final price = property.exactPrice != null
        ? '${property.exactPrice!.toStringAsFixed(0)} FCFA/mois'
        : 'Prix sur demande';
    final text = '''
🏠 ${property.title}
📍 ${property.district}, ${property.city}
💰 $price
🛏️ ${property.bedrooms} ch. · ${property.bathrooms} sdb · ${property.surface.toInt()} m²

Découvrez ce logement sur LOKATE — Loue depuis chez toi
    '''.trim();

    await Share.share(text, subject: property.title);
  }

  static Future<void> shareApp() async {
    await Share.share(
      'LOKATE — Trouvez votre logement idéal au Cameroun\n'
      'Louez depuis chez vous avec visite virtuelle 360° et paiement Mobile Money.\n'
      'Téléchargez l\'app !',
      subject: 'LOKATE - Location immobilière',
    );
  }
}
