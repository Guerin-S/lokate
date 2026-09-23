// Firebase désactivé pour build offline — stub
class FirebaseOptions {
  final String apiKey;
  final String appId;
  final String messagingSenderId;
  final String projectId;
  final String? authDomain;
  final String? storageBucket;
  final String? measurementId;
  const FirebaseOptions({required this.apiKey, required this.appId, required this.messagingSenderId, required this.projectId, this.authDomain, this.storageBucket, this.measurementId});
}

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
