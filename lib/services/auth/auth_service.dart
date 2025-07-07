import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:talksy/services/shared_pref.dart';

class AuthService {
  // Firebase Auth instance
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Get current user
  User? getCurrentUser() {
    return _auth.currentUser;
  }

  // Google Sign-In
  Future<void> signInWithGoogle(BuildContext context) async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn(
        scopes: ['email', 'profile'],
      ).signIn();

      if (googleUser == null) {
        if (!context.mounted) return;
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("Google sign-in cancelled")));
        return;
      }

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      UserCredential userCredential = await _auth.signInWithCredential(
        credential,
      );
      User? user = userCredential.user;

      if (user == null || user.email == null) {
        if (!context.mounted) return;
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("Google sign-in failed")));
        return;
      }

      // Extract user details
      final String email = user.email!;
      final String uid = user.uid;
      final String displayName = user.displayName ?? "User";
      final String photoURL = user.photoURL ?? "";
      final String username = email.split('@')[0];
      final String firstLetter = username.isNotEmpty
          ? username[0].toUpperCase()
          : "U";

      // Save user info to Shared Preferences
      await SharedPrefHelper().saveUserName(displayName);
      await SharedPrefHelper().saveUserEmail(email);
      await SharedPrefHelper().saveUserId(uid);
      await SharedPrefHelper().saveUserUserName(username);
      await SharedPrefHelper().saveUserImage(photoURL);

      // Firestore user data
      final Map<String, dynamic> userData = {
        "email": email,
        "uid": uid,
        "name": displayName,
        "Image": photoURL,
        "username": username.toUpperCase(),
        "firstLetter": firstLetter,
        "keywords": _generateSearchKeywords(displayName, email),
      };

      // Save user to Firestore only if they don’t already exist
      final userDoc = await _firestore.collection("users").doc(uid).get();
      if (!userDoc.exists) {
        await _firestore.collection("users").doc(uid).set(userData);
      }

      if (!context.mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Welcome $displayName!")));
    } catch (e) {
      print("Google Sign-In Error: $e");
      if (!context.mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Error: ${e.toString()}")));
    }
  }

  // Logout
  Future<void> signOut() async {
    try {
      // Sign out from Firebase
      await _auth.signOut();

      // Disconnect Google account to force re-prompt
      final googleSignIn = GoogleSignIn();
      if (await googleSignIn.isSignedIn()) {
        await googleSignIn.disconnect();
      }

      // Optional: clear Shared Preferences
      await SharedPrefHelper().clearUserInfo();

      print("Signed out from Firebase and Google.");
    } catch (e) {
      throw Exception('Failed to sign out: ${e.toString()}');
    }
  }

  List<String> _generateSearchKeywords(String name, String email) {
    final Set<String> keywords = {};

    void addKeywords(String text) {
      text = text.toLowerCase();
      for (int i = 1; i <= text.length; i++) {
        keywords.add(text.substring(0, i));
      }
    }

    addKeywords(name);
    addKeywords(email.split('@')[0]);

    return keywords.toList();
  }
}
