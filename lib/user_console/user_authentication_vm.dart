// ignore_for_file: use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fyp/user_console/user_home_master_screen.dart';
import 'package:fyp/user_console/user_model.dart';

class UserAuthenticationVM extends ChangeNotifier {
  final CollectionReference usersCollection =
      FirebaseFirestore.instance.collection('users');
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  bool isLoading = false;

  bool get loading => isLoading;

  void setLoading(bool loading) {
    isLoading = loading;
    notifyListeners();
  }

  Future<void> userRegistration(
      Map<String, String> userData, BuildContext context) async {
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
        print('2');
        await usersCollection
            .doc(userCredential.user!.uid)
            .set(userData)
            .then((value) {
          print('3');
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (context) {
                print('1');
                return UserHomeMasterScreen(
                  user: userCredential.user!,
                  userModel: userModel,
                );
              },
            ),
          );
        });
      } else {
        print('4');
      }
    } catch (e) {
      print('5');
      Text(e.toString());
    }
  }

  Future<bool> userLogin(
      String email, String password, BuildContext context) async {
    try {
      await firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);

      UserCredential? userCredential;
      String id = userCredential!.user!.uid;

      DocumentSnapshot userData =
          await FirebaseFirestore.instance.collection("users").doc(id).get();

      UserModel userModel = UserModel.fromMap(userData as Map<String, dynamic>);

      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => UserHomeMasterScreen(
              user: userCredential.user!, userModel: userModel),
        ),
      );

      return true;
    } catch (e) {
      return false;
    }
  }
}
