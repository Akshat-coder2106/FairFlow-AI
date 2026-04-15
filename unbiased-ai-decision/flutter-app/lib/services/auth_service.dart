import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'firebase_service.dart';

class AuthService {
  AuthService._();

  static final AuthService instance = AuthService._();

  final FirebaseAuth _auth = FirebaseAuth.instance;
  Map<String, dynamic>? _preloadedGuestAudit;

  Stream<User?> get authStateChanges => _auth.authStateChanges();

  User? get currentUser => _auth.currentUser;

  bool get isGuest => _auth.currentUser?.isAnonymous ?? false;

  Map<String, dynamic>? consumePreloadedGuestAudit() {
    final payload = _preloadedGuestAudit;
    _preloadedGuestAudit = null;
    return payload;
  }

  Future<UserCredential> signInWithGoogle() async {
    if (kIsWeb) {
      final provider = GoogleAuthProvider();
      provider.addScope('email');
      return _auth.signInWithPopup(provider);
    }

    final googleUser = await GoogleSignIn(scopes: ['email']).signIn();
    if (googleUser == null) {
      throw Exception('Google sign-in was cancelled.');
    }

    final googleAuth = await googleUser.authentication;
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );
    return _auth.signInWithCredential(credential);
  }

  Future<Map<String, dynamic>?> signInAsGuest() async {
    await _auth.signInAnonymously();
    _preloadedGuestAudit = await FirebaseService.instance.fetchSampleAudit();
    return _preloadedGuestAudit;
  }

  Future<void> signOut() async {
    await Future.wait([
      GoogleSignIn().signOut().catchError((_) {}),
      _auth.signOut(),
    ]);
  }
}
