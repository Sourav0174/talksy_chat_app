import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:talksy/components/custom_bottom_nav_bar.dart';
import 'package:talksy/pages/auth_page.dart';
import 'package:talksy/pages/home_page.dart';

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        // initialData: initialData,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return CustomBottomNavBar();
          } else {
            return AuthPage();
          }
        },
      ),
    );
  }
}
