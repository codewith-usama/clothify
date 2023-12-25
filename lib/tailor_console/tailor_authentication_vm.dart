import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

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

  Future<bool> tailorRegistration(Map<String, String> tailorData) async {
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

        await usersCollection.doc(userCredential.user!.uid).set(tailorData);

        return true;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }

  Future<bool> tailorLogin(String email, String password) async {
    try {
      await firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);
      return true;
    } catch (e) {
      return false;
    }
  }
}
