import 'package:flutter/material.dart';

/// Service de notifications — mode démo offline
/// Réactiver Firebase Messaging quand réseau OK :
/// 1. Décommenter firebase_messaging dans pubspec.yaml
/// 2. Restaurer l'implémentation FCM complète
class PushNotificationService {
  static String? _fcmToken;
  static bool _initialized = false;

  static String? get fcmToken => _fcmToken;

  static Future<void> initialize() async {
    if (_initialized) return;
    _initialized = true;
    debugPrint('Push notifications: mode démo (Firebase désactivé)');
  }

  static Future<void> subscribeToTopic(String topic) async {}
  static Future<void> unsubscribeFromTopic(String topic) async {}
  static Future<void> saveTokenToFirestore(String userId) async {}
}
