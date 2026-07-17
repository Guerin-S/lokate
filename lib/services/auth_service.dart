import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/models.dart';

class AuthService extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  AppUser? _currentUser;
  AppUser? get currentUser => _currentUser;
  User? get firebaseUser => _auth.currentUser;
  bool get isLoggedIn => _auth.currentUser != null;

  AuthService() {
    _auth.authStateChanges().listen(_onAuthStateChanged);
  }

  Future<void> _onAuthStateChanged(User? user) async {
    if (user != null) {
      await _loadUserData(user.uid);
    } else {
      _currentUser = null;
    }
    notifyListeners();
  }

  Future<void> _loadUserData(String uid) async {
    try {
      final doc = await _db.collection('users').doc(uid).get();
      if (doc.exists) {
        _currentUser = AppUser.fromFirestore(doc);
      }
    } catch (e) {
      debugPrint('Error loading user: $e');
    }
  }

  // ── Email/Password ─────────────────────────────────────────────────────────

  Future<UserCredential> registerWithEmail({
    required String name,
    required String email,
    required String password,
    required UserRole role,
  }) async {
    final cred = await _auth.createUserWithEmailAndPassword(email: email, password: password);
    await cred.user?.updateDisplayName(name);
    await _createUserDoc(cred.user!, name: name, role: role);
    return cred;
  }

  Future<UserCredential> loginWithEmail(String email, String password) async {
    return _auth.signInWithEmailAndPassword(email: email, password: password);
  }

  // ── Google ─────────────────────────────────────────────────────────────────

  Future<UserCredential?> signInWithGoogle({UserRole role = UserRole.locataire}) async {
    final googleUser = await _googleSignIn.signIn();
    if (googleUser == null) return null;

    final googleAuth = await googleUser.authentication;
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );
    final cred = await _auth.signInWithCredential(credential);

    final doc = await _db.collection('users').doc(cred.user!.uid).get();
    if (!doc.exists) {
      await _createUserDoc(cred.user!, name: googleUser.displayName ?? 'Utilisateur', role: role);
    }
    return cred;
  }

  // ── Phone OTP ──────────────────────────────────────────────────────────────

  Future<void> sendOtp({
    required String phone,
    required Function(String verificationId) onCodeSent,
    required Function(String error) onError,
  }) async {
    await _auth.verifyPhoneNumber(
      phoneNumber: phone,
      verificationCompleted: (PhoneAuthCredential credential) async {
        await _auth.signInWithCredential(credential);
      },
      verificationFailed: (FirebaseAuthException e) {
        onError(e.message ?? 'Erreur de vérification');
      },
      codeSent: (String verificationId, int? resendToken) {
        onCodeSent(verificationId);
      },
      codeAutoRetrievalTimeout: (String verificationId) {},
    );
  }

  Future<UserCredential> verifyOtp({
    required String verificationId,
    required String smsCode,
    required String name,
    required UserRole role,
  }) async {
    final credential = PhoneAuthProvider.credential(
      verificationId: verificationId,
      smsCode: smsCode,
    );
    final cred = await _auth.signInWithCredential(credential);
    final doc = await _db.collection('users').doc(cred.user!.uid).get();
    if (!doc.exists) {
      await _createUserDoc(cred.user!, name: name, role: role);
    }
    return cred;
  }

  // ── Utils ──────────────────────────────────────────────────────────────────

  Future<void> _createUserDoc(User user, {required String name, required UserRole role}) async {
    final appUser = AppUser(
      id: user.uid,
      name: name,
      email: user.email ?? '',
      phone: user.phoneNumber,
      photoUrl: user.photoURL,
      role: role,
      createdAt: DateTime.now(),
    );
    await _db.collection('users').doc(user.uid).set(appUser.toFirestore());
  }

  Future<void> signOut() async {
    await _googleSignIn.signOut();
    await _auth.signOut();
    _currentUser = null;
    notifyListeners();
  }

  Future<void> resetPassword(String email) async {
    await _auth.sendPasswordResetEmail(email: email);
  }
}
