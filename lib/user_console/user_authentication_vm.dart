import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fyp/user_console/user_model.dart';

class UserAuthenticationVM extends ChangeNotifier {
  final CollectionReference usersCollection =
      FirebaseFirestore.instance.collection('users');
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  bool isLoading = false;

  bool get loading => isLoading;

  UserModel? userModel1;
  User? user;

  void setLoading(bool loading) {
    isLoading = loading;
    notifyListeners();
  }

  Future<Either<bool, String>> userRegistration(
      Map<String, String> userData) async {
    try {
      String userEmail = userData['userEmail'] ?? '';
      String password = userData['userPassword'] ?? '';

      QuerySnapshot querySnapshot = await usersCollection
          .where('userEmail', isEqualTo: userEmail)
          .limit(1)
          .get();

      if (querySnapshot.docs.isEmpty) {
        UserCredential userCredential =
            await firebaseAuth.createUserWithEmailAndPassword(
          email: userEmail,
          password: password,
        );

        userData['id'] = userCredential.user!.uid;
        UserModel userModel = UserModel.fromMap(userData);
        userModel1 = userModel;
        user = userCredential.user;
        await usersCollection.doc(userCredential.user!.uid).set(userData);
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

  Future<Either<bool, String>> userLogin(String email, String password) async {
    try {
      UserCredential userCredential =
          await firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (userCredential.user != null) {
        String id = userCredential.user!.uid;

        DocumentSnapshot userData =
            await FirebaseFirestore.instance.collection("users").doc(id).get();

        Map<String, dynamic>? data = userData.data() as Map<String, dynamic>?;

        if (data != null) {
          UserModel userModel = UserModel.fromMap(data);
          userModel1 = userModel;
          user = userCredential.user;
          setLoading(false);

          return left(true);
        } else {
          setLoading(false);

          return right('Data is null');
        }
      } else {
        setLoading(false);
        return right('User is null');
      }
    } on FirebaseAuthException catch (e) {
      setLoading(false);

      return right(e.message.toString());
    }
  }
}
