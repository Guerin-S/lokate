import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    return const FirebaseOptions(
      apiKey: 'demo-api-key',
      appId: 'demo-app-id',
      messagingSenderId: 'demo-messaging-sender-id',
      projectId: 'demo-project-id',
      authDomain: 'demo-project-id.firebaseapp.com',
      storageBucket: 'demo-project-id.appspot.com',
      measurementId: 'G-DEMO12345',
    );
  }
}
