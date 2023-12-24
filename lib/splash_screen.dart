import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fyp/select_screen.dart';
import 'package:fyp/tailor_console/tailor_home_master_screen.dart';
import 'package:fyp/user_console/user_home_master_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    splashFunction();
  }

  void splashFunction() {
    Timer(const Duration(seconds: 2), () => checkUser());
  }

  void checkUser() async {
    FirebaseAuth firebaseAuth = FirebaseAuth.instance;
    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

    User? user = firebaseAuth.currentUser;
    if (user != null) {
      DocumentSnapshot inUsersCollection =
          await firebaseFirestore.collection('users').doc(user.uid).get();
      if (inUsersCollection.exists) {
        navigateToUser();
      }
      DocumentSnapshot inTailorsCollection =
          await firebaseFirestore.collection('tailors').doc(user.uid).get();
      if (inTailorsCollection.exists) {
        navigateToTailor();
      }
    } else {
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const SelectScreen()));
    }
  }

  void navigateToUser() {
    Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const UserHomeMasterScreen()));
  }

  void navigateToTailor() {
    Navigator.of(context).pushReplacement(MaterialPageRoute(
        builder: (context) => const TailorHomeMasterScreen()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Image.asset(
            'assets/icon.png',
            height: 200,
          ),
        ),
      ),
    );
  }
}
