import 'package:flutter/material.dart';
import 'package:fyp/tailor_console/tailor_authentication_vm.dart';
import 'package:provider/provider.dart';

class TailorLoginScreen extends StatelessWidget {
  const TailorLoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
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
                    child: Consumer<TailorAuthenticationVm>(
                      builder: (context, value, _) => ElevatedButton(
                        onPressed: () async {
                          if (formKey.currentState!.validate()) {
                            value.setLoading(true);
                            String email = emailController.text.trim();
                            String password = passwordController.text.trim();

                            TailorAuthenticationVm tailorAuthenticationVm =
                                TailorAuthenticationVm();
                            await tailorAuthenticationVm.tailorLogin(
                                email, password, context);
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 10),
                        ),
                        child: value.loading
                            ? const CircularProgressIndicator(
                                color: Colors.white)
                            : const Text('Login'),
                      ),
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
