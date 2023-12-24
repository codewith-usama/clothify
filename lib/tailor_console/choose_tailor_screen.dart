import 'package:flutter/material.dart';
import 'package:fyp/tailor_console/tailor_login_screen.dart';
import 'package:fyp/tailor_console/tailor_registration_screen.dart';

class ChooseTailorScreen extends StatelessWidget {
  const ChooseTailorScreen({super.key});

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
                          builder: (context) =>
                              const TailorRegistrationScreen(),
                        ),
                      ),
                  child: const Text('Registration')),
              ElevatedButton(
                onPressed: () => Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const TailorLoginScreen(),
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
