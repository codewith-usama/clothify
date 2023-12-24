import 'package:flutter/material.dart';
import 'package:fyp/user_console/user_login_screen.dart';
import 'package:fyp/user_console/user_registration_screen.dart';

class ChooseUserScreen extends StatelessWidget {
  const ChooseUserScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              ElevatedButton(
                  onPressed: () => Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => const UserRegistrationScreen(),
                        ),
                      ),
                  child: const Text('Registration')),
              ElevatedButton(
                onPressed: () => Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const UserLoginScreen(),
                  ),
                ),
                child: const Text('Login'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
