# 🔥 Configuration Firebase — LOKATE

## Prérequis
- Compte Google (gratuit)
- [Flutter SDK](https://docs.flutter.dev/get-started/install) installé
- [Firebase CLI](https://firebase.google.com/docs/cli) installé :
  ```bash
  npm install -g firebase-tools
  firebase login
  ```

## Étape 1 : Créer le projet Firebase

1. Va sur [Firebase Console](https://console.firebase.google.com/)
2. Clique sur **"Créer un projet"**
3. Nom : `lokate-app` (ou un nom unique)
4. Désactive Google Analytics (pas nécessaire pour commencer)
5. Clique sur **"Créer le projet"**

## Étape 2 : Configurer FlutterFire CLI

```bash
dart pub global activate flutterfire_cli
flutterfire configure
```

> FlutterFire va :
> - Créer `lib/firebase_options.dart` avec tes vraies credentials
> - Télécharger `google-services.json` (Android)
> - Télécharger `GoogleService-Info.plist` (iOS)

## Étape 3 : Activer les services Firebase

Dans la [Firebase Console](https://console.firebase.google.com/) → ton projet :

### Authentication
1. Va dans **Authentication** → **Sign-in method**
2. Active :
   - **Email/Password** ✅
   - **Phone** ✅
   - **Google** ✅ (ajoute ton numéro de support client)
3. Dans **Settings** → **Authorized domains**, ajoute ton domaine si besoin

### Firestore Database
1. Va dans **Firestore Database** → **Create database**
2. Choisis **"Start in test mode"** pour commencer
3. Sélectionne une région proche du Cameroun (e.g., `europe-west1` ou `africa-south1`)

### Storage
1. Va dans **Storage** → **Get started**
2. Start in test mode

### Cloud Messaging
1. Va dans **Project Settings** → **Cloud Messaging**
2. Le Firebase Cloud Messaging est déjà activé par défaut

## Étape 4 : Configuration Android

### google-services.json
Le fichier devrait avoir été téléchargé par `flutterfire configure`.
Sinon, télécharge-le manuellement :
1. Firebase Console → Project Settings → Android app
2. Ajoute ton package name : `com.example.lokate`
3. Télécharge `google-services.json`
4. Place-le dans `android/app/`

### build.gradle (android/build.gradle)
```gradle
dependencies {
    classpath 'com.google.gms:google-services:4.4.0'
}
```

### build.gradle (android/app/build.gradle)
```gradle
plugins {
    id 'com.android.application'
    id 'kotlin-android'
    id 'com.google.gms.google-services'
}
```

### AndroidManifest.xml
Ajoute la clé Google Maps dans `android/app/src/main/AndroidManifest.xml` :
```xml
<meta-data
    android:name="com.google.android.geo.API_KEY"
    android:value="YOUR_GOOGLE_MAPS_API_KEY"/>
```

## Étape 5 : Configuration iOS

### GoogleService-Info.plist
Le fichier devrait avoir été téléchargé par `flutterfire configure`.
Sinon :
1. Firebase Console → Project Settings → iOS app
2. Ajoute ton Bundle ID : `com.example.lokate`
3. Télécharge `GoogleService-Info.plist`
4. Place-le dans `ios/Runner/`

### AppDelegate.swift (ios/Runner/AppDelegate.swift)
```swift
import UIKit
import Flutter
import FirebaseCore

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    FirebaseApp.configure()
    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
```

### Info.plist
Ajoute dans `ios/Runner/Info.plist` :
```xml
<key>io.flutter.embedded_views_preview</key>
<true/>
```

## Étape 6 : Clé Google Maps

1. Va sur [Google Cloud Console](https://console.cloud.google.com/)
2. Sélectionne ton projet Firebase
3. Va dans **APIs & Services** → **Credentials**
4. Crée une **API Key**
5. Restreins-la aux applications Android et iOS de ton app
6. Ajoute-la dans :
   - `android/app/src/main/AndroidManifest.xml` (voir étape 4)
   - `ios/Runner/AppDelegate.swift` (si utilisé)

## Étape 7 : Règles de sécurité Firestore

Remplace les règles de test par des règles sécurisées :

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    // Users can only read/write their own profile
    match /users/{userId} {
      allow read: if request.auth != null;
      allow write: if request.auth != null && request.auth.uid == userId;
    }

    // Properties are readable by all, writable by owner
    match /properties/{propertyId} {
      allow read: if true;
      allow create: if request.auth != null;
      allow update, delete: if request.auth != null && resource.data.ownerId == request.auth.uid;
    }

    // Reservations
    match /reservations/{reservationId} {
      allow read: if request.auth != null && (
        resource.data.tenantId == request.auth.uid ||
        resource.data.ownerId == request.auth.uid
      );
      allow create: if request.auth != null;
      allow update: if request.auth != null && (
        resource.data.tenantId == request.auth.uid ||
        resource.data.ownerId == request.auth.uid
      );
    }

    // Payments - only readable by involved parties
    match /payments/{paymentId} {
      allow read: if request.auth != null;
      allow create: if request.auth != null;
    }

    // Chats
    match /chats/{chatId} {
      allow read, write: if request.auth != null &&
        request.auth.uid in resource.data.participants;
      allow create: if request.auth != null;
    }

    // Reviews
    match /reviews/{reviewId} {
      allow read: if true;
      allow create: if request.auth != null;
    }
  }
}
```

## Étape 8 : Composite Indexes Firestore

Firestore va te demander des indexes composites quand tu lances l'app.
Pour chaque erreur dans la console, clique sur le lien fourni pour créer l'index automatiquement.

Ou crée manuellement les indexes courants :
- `properties` : `city` ASC, `price` ASC, `type` ASC
- `properties` : `ownerId` ASC, `isAvailable` ASC
- `reservations` : `tenantId` ASC, `status` ASC
- `reservations` : `ownerId` ASC, `status` ASC

## Étape 9 : Tester l'app

```bash
flutter pub get
flutter run
```

L'app devrait :
1. Se connecter à Firebase
2. Afficher l'écran de splash
3. Permettre l'inscription/connexion
4. Afficher les biens (si tu en ajoutes)

## Dépannage

### "DefaultFirebaseOptions not found"
→ Exécute `flutterfire configure` pour générer `firebase_options.dart`

### "Unable to get App Check token"
→ App Check n'est pas encore configuré. C'est OK pour le développement.

### "PERMISSION_DENIED on Firestore"
→ Vérifie les règles de sécurité dans Firestore Console

### Notifications push ne fonctionnent pas
→ Vérifie que `firebase_messaging` est configuré et que les permissions sont accordées sur l'appareil
