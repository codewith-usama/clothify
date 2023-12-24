import 'package:flutter/material.dart';
import 'package:fyp/tailor_console/tailor_authentication_vm.dart';
import 'package:fyp/tailor_console/tailor_home_master_screen.dart';

class TailorLoginScreen extends StatelessWidget {
  const TailorLoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    void moveToTailorHomeMasterScreen() {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const TailorHomeMasterScreen()),
      );
    }

    final GlobalKey<FormState> formKey = GlobalKey<FormState>();
    final TextEditingController emailController = TextEditingController();
    final TextEditingController passwordController = TextEditingController();
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          child: Center(
            child: Form(
              key: formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextFormField(
                    controller: emailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: const InputDecoration(
                      label: Text("Enter Email"),
                      hintText: "Enter Email",
                    ),
                    validator: (value) => value != null && value.isNotEmpty
                        ? null
                        : 'Enter your Email',
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: passwordController,
                    obscureText: true,
                    keyboardType: TextInputType.visiblePassword,
                    decoration: const InputDecoration(
                      label: Text("Enter Password"),
                      hintText: "Enter Password",
                    ),
                    validator: (value) => value != null && value.isNotEmpty
                        ? null
                        : 'Enter Password',
                  ),
                  const SizedBox(height: 30),
                  SizedBox(
                    width: double.maxFinite,
                    child: ElevatedButton(
                      onPressed: () async {
                        if (formKey.currentState!.validate()) {
                          String email = emailController.text.trim();
                          String password = passwordController.text.trim();

                          TailorAuthenticationVm tailorAuthenticationVm =
                              TailorAuthenticationVm();
                          bool result = await tailorAuthenticationVm
                              .tailorLogin(email, password);
                          if (result == true) {
                            moveToTailorHomeMasterScreen();
                          } else {
                            const ScaffoldMessenger(
                                child: SnackBar(
                                    backgroundColor: Colors.red,
                                    content: Text('Some Error')));
                          }
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 10),
                      ),
                      child: const Text('Login'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
