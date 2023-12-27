import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fyp/tailor_console/tailor_model.dart';
import 'package:fyp/user_console/user_model.dart';

class FirebaseHelper {
  static Future<UserModel?> getUserModelById(String id) async {
    UserModel? userModel;
    DocumentSnapshot? snapshot =
        await FirebaseFirestore.instance.collection("users").doc(id).get();
    if (snapshot.data() != null) {
      userModel = UserModel.fromMap(snapshot.data() as Map<String, dynamic>);
    }

    return userModel;
  }

  static Future<TailorModel?> getTailorModelById(String id) async {
    TailorModel? tailorModel;
    DocumentSnapshot? snapshot =
        await FirebaseFirestore.instance.collection("tailors").doc(id).get();
    if (snapshot.data() != null) {
      tailorModel =
          TailorModel.fromMap(snapshot.data() as Map<String, dynamic>);
    }

    return tailorModel;
  }
}
