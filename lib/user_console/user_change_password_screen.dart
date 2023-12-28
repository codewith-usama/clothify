// ignore_for_file: use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class UserChangePasswordScreen extends StatefulWidget {
  const UserChangePasswordScreen({Key? key}) : super(key: key);

  @override
  State<UserChangePasswordScreen> createState() =>
      _UserChangePasswordScreenState();
}

class _UserChangePasswordScreenState extends State<UserChangePasswordScreen> {
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
      loading = false;

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
      await user.reauthenticateWithCredential(cred);
      await user.updatePassword(_newPasswordController.text);

      await firestore.collection('users').doc(user.uid).update({
        'userPassword': _newPasswordController.text,
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Password changed successfully')),
      );
      Navigator.of(context).pop();
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
