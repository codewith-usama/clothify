import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserAuthenticationVM {
  final CollectionReference usersCollection =
      FirebaseFirestore.instance.collection('users');
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  Future<bool> userRegistration(Map<String, String> userData) async {
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

        await usersCollection.doc(userCredential.user!.uid).set(userData);

        return true;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }

  Future<bool> userLogin(String email, String password) async {
    try {
      await firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);
      return true;
    } catch (e) {
      return false;
    }
  }
}
