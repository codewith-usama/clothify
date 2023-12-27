import 'package:flutter/material.dart';
import 'package:fyp/tailor_console/choose_tailor_screen.dart';
import 'package:fyp/user_console/choose_user_screen.dart';

class SelectScreen extends StatelessWidget {
  const SelectScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => const ChooseTailorScreen()));
                  },
                  child: const Text('Tailor')),
              ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => const ChooseUserScreen()));
                  },
                  child: const Text('User')),
            ],
          ),
        ),
      ),
    );
  }
}
