import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fyp/helper/firebase_helper.dart';
import 'package:fyp/initial/select_screen.dart';
import 'package:fyp/tailor_console/tailor_home_master_screen.dart';
import 'package:fyp/tailor_console/tailor_model.dart';
import 'package:fyp/user_console/user_home_master_screen.dart';
import 'package:fyp/user_console/user_model.dart';
import 'package:google_fonts/google_fonts.dart';

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

  String? imagePath;

  void splashFunction() {
    imagePath = 'assets/icon.png';
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
        UserModel? userModel = await FirebaseHelper.getUserModelById(user.uid);
        if (userModel != null) {
          navigateToUser(user, userModel);
        }
      }
      DocumentSnapshot inTailorsCollection =
          await firebaseFirestore.collection('tailors').doc(user.uid).get();
      if (inTailorsCollection.exists) {
        TailorModel? tailorModel =
            await FirebaseHelper.getTailorModelById(user.uid);
        if (tailorModel != null) {
          navigateToTailor(user, tailorModel);
        }
      }
    } else {
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const SelectScreen()));
    }
  }

  void navigateToUser(User user, UserModel userModel) async {
    Navigator.of(context).pushReplacement(MaterialPageRoute(
        builder: (context) => UserHomeMasterScreen(
              user: user,
              userModel: userModel,
            )));
  }

  void navigateToTailor(User user, TailorModel tailorModel) {
    Navigator.of(context).pushReplacement(MaterialPageRoute(
        builder: (context) => TailorHomeMasterScreen(
              user: user,
              tailorModel: tailorModel,
            )));
  }

  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/splash_screen_back.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: Column(
            children: [
              SizedBox(height: height * 0.30),
              Image.asset(
                imagePath!,
                height: height * 0.35,
              ),
              SizedBox(height: height * 0.10),
              Text(
                'CLOTHIFY',
                style: GoogleFonts.mali(
                  textStyle: TextStyle(
                    color: Colors.black87,
                    fontStyle: FontStyle.italic,
                    letterSpacing: 2,
                    fontSize: width * 0.10,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
