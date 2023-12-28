import 'package:flutter/material.dart';
import 'package:fyp/helper/ui_helper.dart';
import 'package:fyp/user_console/user_authentication_vm.dart';
import 'package:fyp/user_console/user_home_master_screen.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class UserLoginScreen extends StatelessWidget {
  final double height;
  final double width;
  const UserLoginScreen({
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
                      child: Consumer<UserAuthenticationVM>(
                        builder: (context, value, _) => ElevatedButton(
                          onPressed: () async {
                            value.setLoading(true);
                            if (formKey.currentState!.validate()) {
                              String email = emailController.text.trim();
                              String password = passwordController.text.trim();

                              await value.userLogin(email, password).then(
                                    (result) => result.fold(
                                      (l) {
                                        if (value.user != null &&
                                            value.userModel1 != null) {
                                          Navigator.of(context).pushReplacement(
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  UserHomeMasterScreen(
                                                user: value.user!,
                                                userModel: value.userModel1!,
                                              ),
                                            ),
                                          );
                                        } else {
                                          UIHelper.showAlertDialog(
                                              context,
                                              'Login Failed',
                                              'User or UserModel is null');
                                        }
                                      },
                                      (r) => UIHelper.showAlertDialog(
                                          context, 'Login Failed', r),
                                    ),
                                  );
                            }
                          },
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
