// ignore_for_file: use_build_context_synchronously, avoid_print

import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fyp/initial/select_screen.dart';
import 'package:fyp/user_console/user_change_password_screen.dart';
import 'package:image_picker/image_picker.dart';

class UsersSettingScreen extends StatefulWidget {
  const UsersSettingScreen({super.key});

  @override
  State<UsersSettingScreen> createState() => _UsersSettingScreenState();
}

class _UsersSettingScreenState extends State<UsersSettingScreen> {
  File? image;
  String? imageUrl;
  String? fullName;
  String? email;
  final picker = ImagePicker();
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  final FirebaseStorage firebaseStorage = FirebaseStorage.instance;
  final FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

  String errorMessage = '';

  @override
  void initState() {
    super.initState();
    fetchProfileImage();
    fetchUserData();
  }

  Future<void> fetchUserData() async {
    try {
      String userId = firebaseAuth.currentUser!.uid;
      DocumentSnapshot userDoc =
          await firebaseFirestore.collection('users').doc(userId).get();
      setState(() {
        fullName = userDoc['userFullName'];
        email = userDoc['userEmail'];
      });
    } catch (e) {
      print('Error fetching user data: $e');
    }
  }

  Future<void> fetchProfileImage() async {
    try {
      String userId = firebaseAuth.currentUser!.uid;
      DocumentSnapshot userDoc =
          await firebaseFirestore.collection('users').doc(userId).get();
      setState(() {
        imageUrl = userDoc['profilePic'];
      });
    } catch (e) {
      setState(() {
        imageUrl = null;
        print('Error fetching profile image: $e');
      });
    }
  }

  Future getImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        image = File(pickedFile.path);
      });
      await uploadImageToFirebase();
      await fetchProfileImage(); // Fetch the updated profile image
    } else {
      print('No image selected.');
    }
  }

  Future<void> uploadImageToFirebase() async {
    if (image == null) return;

    String fileName = 'profile_${firebaseAuth.currentUser!.uid}';
    Reference firebaseStorageRef =
        firebaseStorage.ref().child('profilepics/$fileName');
    UploadTask uploadTask = firebaseStorageRef.putFile(image!);
    await uploadTask.whenComplete(() async {
      String downloadURL = await firebaseStorageRef.getDownloadURL();
      await firebaseFirestore
          .collection('users')
          .doc(firebaseAuth.currentUser!.uid)
          .set({'profilePic': downloadURL}, SetOptions(merge: true));
    });
  }

  void pushRoute() {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const SelectScreen()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(22.0),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                GestureDetector(
                  onTap: getImage,
                  child: CircleAvatar(
                    radius: 55,
                    backgroundImage: imageUrl != null && imageUrl!.isNotEmpty
                        ? NetworkImage(imageUrl!)
                        : null,
                    child: imageUrl == null || imageUrl!.isEmpty
                        ? const Icon(Icons.person,
                            size: 80, color: Colors.white)
                        : null,
                  ),
                ),
                const SizedBox(height: 20),
                Text(fullName ?? 'Full Name',
                    style: const TextStyle(
                        fontSize: 20, fontWeight: FontWeight.bold)),
                const SizedBox(height: 10),
                Text(email ?? 'Email', style: const TextStyle(fontSize: 16)),
                const SizedBox(height: 20),
                if (errorMessage.isNotEmpty)
                  Text(
                    errorMessage,
                    style: const TextStyle(color: Colors.red),
                  ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => const UserChangePasswordScreen(),
                      ),
                    );
                  },
                  child: const Text('Change Password'),
                ),
                const SizedBox(height: 50),
                SizedBox(
                  width: double.maxFinite,
                  child: ElevatedButton(
                    onPressed: () async {
                      await firebaseAuth.signOut();
                      pushRoute();
                    },
                    child: const Text('Logout'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
