// ignore_for_file: use_build_context_synchronously, avoid_print

import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fyp/initial/select_screen.dart';
import 'package:google_fonts/google_fonts.dart';
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

  // Future<void> changePassword() async {
  //   try {
  //     await firebaseAuth.currentUser!.updatePassword(_passwordController.text);
  //     Navigator.of(context).pop();
  //   } on FirebaseAuthException catch (e) {
  //     setState(() {
  //       _errorMessage = e.message!;
  //     });
  //   }
  // }

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
          padding: const EdgeInsets.all(8.0),
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
                        builder: (context) => const ChangePasswordScreen(),
                      ),
                    );
                  },
                  child: const Text('Change Password'),
                ),
                const SizedBox(height: 50),
                ElevatedButton(
                  onPressed: () async {
                    await firebaseAuth.signOut();
                    pushRoute();
                  },
                  child: const Text('Logout'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({Key? key}) : super(key: key);

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final TextEditingController _currentPasswordController =
      TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmNewPasswordController =
      TextEditingController();
  String _errorMessage = '';
  bool loading = false;

  Future<void> changePassword() async {
    setState(() {
      loading = true;
    });
    final user = FirebaseAuth.instance.currentUser;
    final firestore = FirebaseFirestore.instance;
    if (user == null) {
      setState(() {
        _errorMessage = 'No user signed in.';
      });
      return;
    }
    if (_newPasswordController.text != _confirmNewPasswordController.text) {
      setState(() {
        _errorMessage = 'New passwords do not match.';
      });
      return;
    }

    final cred = EmailAuthProvider.credential(
      email: user.email!,
      password: _currentPasswordController.text,
    );

    try {
      // Reauthenticate user
      print('here');
      await user.reauthenticateWithCredential(cred);
      // If reauthentication is successful, update the password
      await user.updatePassword(_newPasswordController.text);
      // Update the password in Firestore
      await firestore.collection('users').doc(user.uid).update({
        'userPassword': _newPasswordController.text,
      });
      // Show a confirmation message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Password changed successfully')),
      );
      Navigator.of(context).pop(); // Go back to the previous screen
    } on FirebaseAuthException catch (e) {
      setState(() {
        _errorMessage = e.message ?? 'An error occurred.';
      });
    }
    setState(() {
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 166, 206, 226),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 22),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Change Password',
              style: GoogleFonts.mali(
                textStyle: const TextStyle(
                  color: Colors.white,
                  letterSpacing: 2,
                  fontSize: 34,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ),
            const SizedBox(height: 100),
            if (_errorMessage.isNotEmpty)
              Text(
                _errorMessage,
                style: const TextStyle(color: Colors.red),
              ),
            TextField(
              controller: _currentPasswordController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: 'Current Password',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _newPasswordController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: 'New Password',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _confirmNewPasswordController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: 'Confirm New Password',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.maxFinite,
              child: ElevatedButton(
                onPressed: changePassword,
                child: loading
                    ? const SizedBox(
                        width: 25,
                        height: 20,
                        child: CircularProgressIndicator(color: Colors.white))
                    : const Text('Update Password'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
