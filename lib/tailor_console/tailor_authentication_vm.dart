// ignore_for_file: use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fyp/tailor_console/tailor_home_master_screen.dart';
import 'package:fyp/tailor_console/tailor_model.dart';

class TailorAuthenticationVm extends ChangeNotifier {
  final CollectionReference usersCollection =
      FirebaseFirestore.instance.collection('tailors');
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  bool isLoading = false;

  bool get loading => isLoading;

  void setLoading(bool loading) {
    isLoading = loading;
    notifyListeners();
  }

  Future<void> tailorRegistration(
      Map<String, String> tailorData, BuildContext context) async {
    try {
      String tailorEmail = tailorData['tailorEmail'] ?? '';
      String password = tailorData['tailorPassword'] ?? '';

      QuerySnapshot querySnapshot = await usersCollection
          .where('tailorEmail', isEqualTo: tailorEmail)
          .limit(1)
          .get();

      if (querySnapshot.docs.isEmpty) {
        UserCredential userCredential =
            await firebaseAuth.createUserWithEmailAndPassword(
          email: tailorEmail,
          password: password,
        );
        tailorData['id'] = userCredential.user!.uid;
        TailorModel tailorModel = TailorModel.fromMap(tailorData);

        await usersCollection
            .doc(userCredential.user!.uid)
            .set(tailorData)
            .then((value) {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (context) => TailorHomeMasterScreen(
                user: userCredential.user!,
                tailorModel: tailorModel,
              ),
            ),
          );
        });
      } else {}
    } catch (e) {
      Text(e.toString());
    }
  }

  Future<void> tailorLogin(
      String email, String password, BuildContext context) async {
    try {
      await firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);

      UserCredential? userCredential;
      String id = userCredential!.user!.uid;

      DocumentSnapshot tailorData =
          await FirebaseFirestore.instance.collection("tailors").doc(id).get();

      TailorModel tailorModel =
          TailorModel.fromMap(tailorData as Map<String, dynamic>);

      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => TailorHomeMasterScreen(
              user: userCredential.user!, tailorModel: tailorModel),
        ),
      );
    } catch (e) {
      Text(e.toString());
    }
  }
}
