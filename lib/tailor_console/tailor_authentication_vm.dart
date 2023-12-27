import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fyp/tailor_console/tailor_model.dart';
import 'package:dartz/dartz.dart';

class TailorAuthenticationVm extends ChangeNotifier {
  final CollectionReference usersCollection =
      FirebaseFirestore.instance.collection('tailors');
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  bool isLoading = false;

  TailorModel? tailorModel1;
  User? user;

  bool get loading => isLoading;

  void setLoading(bool loading) {
    isLoading = loading;
    notifyListeners();
  }

  Future<Either<bool, String>> tailorRegistration(
      Map<String, String> tailorData) async {
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
        tailorModel1 = tailorModel;
        user = userCredential.user;

        await usersCollection.doc(userCredential.user!.uid).set(tailorData);
        setLoading(false);
        return left(true);
      } else {
        setLoading(false);

        return right('Some error occured');
      }
    } on FirebaseAuthException catch (e) {
      setLoading(false);

      return right(e.message.toString());
    }
  }

  Future<Either<bool, String>> tailorLogin(
      String email, String password) async {
    try {
      UserCredential userCredential =
          await firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      if (userCredential.user != null) {
        String id = userCredential.user!.uid;

        DocumentSnapshot tailorData = await FirebaseFirestore.instance
            .collection("tailors")
            .doc(id)
            .get();

        Map<String, dynamic>? data = tailorData.data() as Map<String, dynamic>?;

        if (data != null) {
          TailorModel tailorModel = TailorModel.fromMap(data);
          tailorModel1 = tailorModel;
          user = userCredential.user;
          setLoading(false);
          return left(true);
        } else {
          setLoading(false);
          return right('Data in null');
        }
      } else {
        return right('User is null');
      }
    } on FirebaseAuthException catch (e) {
      setLoading(false);
      return right(e.message.toString());
    }
  }
}
