import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

//   <meta name="google-signin-client_id" content="109622122352-7ipadlel10slau87fjsvjajitflu7k5p.apps.googleusercontent.com.apps.googleusercontent.com">
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:my_certifications/keys.dart';

class AuthProvider extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    clientId: clientId,
    scopes: ['email', 'profile'],
  );
  User? _user;

  User? get user => _user;

  bool get isAuthenticated => _user != null;

  AuthProvider() {
    _auth.authStateChanges().listen((user) {
      _user = user;
      notifyListeners();
    });
  }

  Future<void> signInWithGoogle(BuildContext context) async {
    try {
      if (kIsWeb) {
        GoogleAuthProvider googleProvider = GoogleAuthProvider();
        googleProvider.addScope('email');
        googleProvider.addScope('profile');

        final UserCredential userCredential =
            await _auth.signInWithPopup(googleProvider);

        await _updateUserData(userCredential.user!);
      } else {
        final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
        if (googleUser == null) return;

        final GoogleSignInAuthentication googleAuth =
            await googleUser.authentication;
        final credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );

        final UserCredential userCredential =
            await _auth.signInWithCredential(credential);

        await _updateUserData(userCredential.user!);
      }
    } catch (e) {
      if (e.toString().contains('popup_closed_by_user')) {
        debugPrint('Sign-in popup was closed by the user');
      } else {
        debugPrint('Error during sign in: $e');
      }
      rethrow;
    }
  }

  Future<void> _updateUserData(User user) async {
    await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
      'displayName': user.displayName,
      'email': user.email,
      'photoURL': user.photoURL,
      'lastSignIn': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
  }

  Future<void> signOut() async {
    if (kIsWeb) {
      await _auth.signOut();
    } else {
      await _googleSignIn.signOut();
      await _auth.signOut();
    }
  }
}
