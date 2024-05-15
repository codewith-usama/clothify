import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:fyp/helper/ui_helper.dart';
import 'package:fyp/tailor_console/tailor_authentication_vm.dart';
import 'package:fyp/tailor_console/tailor_home_master_screen.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class TailorLoginScreen extends StatelessWidget {
  final double height;
  final double width;
  const TailorLoginScreen({
    super.key,
    required this.height,
    required this.width,
  });

  @override
  Widget build(BuildContext context) {
    final GlobalKey<FormState> formKey = GlobalKey<FormState>();
    final TextEditingController emailController = TextEditingController();
    final TextEditingController passwordController = TextEditingController();
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 166, 206, 226),
      body: SingleChildScrollView(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            child: Center(
              child: Form(
                key: formKey,
                child: Column(
                  children: [
                    SizedBox(height: height * 0.10),
                    Text(
                      'LOGIN',
                      style: GoogleFonts.mali(
                        textStyle: TextStyle(
                          color: Colors.white,
                          letterSpacing: 2,
                          fontSize: width * 0.17,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ),
                    SizedBox(height: height * 0.08),
                    TextFormField(
                      controller: emailController,
                      keyboardType: TextInputType.emailAddress,
                      style: const TextStyle(color: Colors.black, fontSize: 18),
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
                      style: const TextStyle(color: Colors.black, fontSize: 18),
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
                              var bytes = utf8.encode(passwordController.text
                                  .trim()); // data being hashed
                              var digest = sha256.convert(bytes);
                              String password = digest.toString();

                              await value.tailorLogin(email, password).then(
                                    (result) => result.fold(
                                      (l) =>
                                          Navigator.of(context).pushReplacement(
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              TailorHomeMasterScreen(
                                            user: value.user!,
                                            tailorModel: value.tailorModel1!,
                                          ),
                                        ),
                                      ),
                                      (r) => UIHelper.showAlertDialog(
                                          context, 'Login Failed', r),
                                    ),
                                  );
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
                              ? const SizedBox(
                                  width: 25,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                      color: Colors.white),
                                )
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
      ),
    );
  }
}
