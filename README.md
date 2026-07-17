# LOKATE — Application Flutter de Location Immobilière

> **"Loue depuis chez toi"** — Plateforme de location immobilière à distance pour le marché camerounais.

---

## 🏗️ Architecture du projet

```
lib/
├── main.dart                        # Point d'entrée
├── models/
│   └── models.dart                  # Tous les modèles de données
├── services/
│   ├── auth_service.dart            # Firebase Auth (email, Google, OTP)
│   ├── property_service.dart        # CRUD logements + avis
│   └── theme_service.dart           # Gestion thème clair/sombre
├── theme/
│   └── app_theme.dart               # Couleurs, typographie, thèmes
├── utils/
│   └── router.dart                  # Navigation GoRouter
├── widgets/
│   ├── property_card.dart           # Carte logement (grille)
│   ├── property_card_horizontal.dart # Carte logement (liste)
│   ├── lokate_text_field.dart       # Champ de saisie
│   ├── social_auth_button.dart      # Bouton auth social
│   └── badge_chip.dart              # Badge vérifié/certifié/fiable
└── screens/
    ├── auth/
    │   ├── splash_screen.dart       # Écran de démarrage
    │   ├── onboarding_screen.dart   # Présentation (4 slides)
    │   ├── login_screen.dart        # Connexion
    │   ├── register_screen.dart     # Inscription (email ou OTP)
    │   └── otp_screen.dart          # Vérification SMS
    ├── home/
    │   ├── main_shell.dart          # Shell avec bottom nav
    │   ├── home_screen.dart         # Accueil (grille + liste)
    │   └── map_screen.dart          # Carte Google Maps interactive
    ├── property/
    │   ├── property_detail_screen.dart  # Détail du logement
    │   ├── virtual_tour_screen.dart    # Visite 360°
    │   └── filter_screen.dart          # Filtres de recherche
    ├── booking/
    │   ├── booking_screen.dart      # Réservation
    │   ├── payment_screen.dart      # Paiement (MTN/Orange/Stripe)
    │   └── contract_screen.dart     # Contrat en ligne
    ├── chat/
    │   ├── chat_list_screen.dart    # Liste des conversations
    │   └── chat_screen.dart         # Messagerie temps réel
    ├── profile/
    │   ├── profile_screen.dart      # Profil utilisateur
    │   └── review_screen.dart       # Laisser un avis
    └── owner/
        ├── owner_dashboard_screen.dart    # Dashboard propriétaire
        ├── add_property_screen.dart       # Ajouter un logement (3 étapes)
        └── owner_reservations_screen.dart # Gérer les demandes
```

---

## 🚀 Installation

### 1. Prérequis
- Flutter SDK ≥ 3.0.0
- Compte Firebase
- Clé API Google Maps
- Compte Stripe (optionnel)

### 2. Firebase Setup
```bash
# Installer FlutterFire CLI
dart pub global activate flutterfire_cli

# Configurer Firebase
flutterfire configure
```

### 3. Variables d'environnement
Créer un fichier `android/app/google-services.json` et `ios/Runner/GoogleService-Info.plist` depuis la console Firebase.

### 4. Google Maps
Dans `android/app/src/main/AndroidManifest.xml`, ajouter :
```xml
<meta-data
    android:name="com.google.android.geo.API_KEY"
    android:value="VOTRE_CLE_API"/>
```

### 5. Lancer le projet
```bash
flutter pub get
flutter run
```

---

## 💳 Modes de paiement

| Mode | API | Statut |
|------|-----|--------|
| MTN Mobile Money | MTN MoMo API | Intégré (simulation) |
| Orange Money | Orange Money API | Intégré (simulation) |
| Carte bancaire | Stripe | Intégré (simulation) |

> Pour la production, remplacer les simulations par les vraies APIs dans `payment_screen.dart`.

---

## 🔥 Collections Firestore

```
users/          → Profils utilisateurs
properties/     → Logements publiés
reservations/   → Demandes de location
payments/       → Transactions
contracts/      → Contrats signés
chats/          → Conversations
  └── messages/ → Messages
reviews/        → Avis et notes
```

---

## 🌍 Localisation

L'app supporte **Français** et **Anglais** via `flutter_localizations`.
Les fichiers de traduction sont à créer dans `lib/l10n/`.

---

## 👥 Profils utilisateurs

### Locataire
- Recherche + filtres
- Carte interactive
- Visite 360°
- Réservation + paiement
- Signature contrat
- Messagerie
- Notation propriétaire/logement

### Propriétaire
- Publication de biens (3 étapes)
- Tableau de bord
- Gestion des demandes (approuver/refuser)
- Historique des paiements
- Messagerie locataires

---

*Développé pour le marché camerounais — LOKATE © 2026*
