import 'package:flutter/material.dart';
import 'package:fyp/helper/ui_helper.dart';
import 'package:fyp/user_console/user_authentication_vm.dart';
import 'package:fyp/user_console/user_home_master_screen.dart';
import 'package:provider/provider.dart';

class UserLoginScreen extends StatelessWidget {
  const UserLoginScreen({super.key});

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
                    child: Consumer<UserAuthenticationVM>(
                      builder: (context, value, _) => ElevatedButton(
                        onPressed: () async {
                          value.setLoading(true);
                          if (formKey.currentState!.validate()) {
                            String email = emailController.text.trim();
                            String password = passwordController.text.trim();

                            UserAuthenticationVM userAuthenticationVM =
                                UserAuthenticationVM();
                            await userAuthenticationVM
                                .userLogin(email, password)
                                .then(
                                  (result) => result.fold(
                                    (l) =>
                                        Navigator.of(context).pushReplacement(
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            UserHomeMasterScreen(
                                          user: value.user!,
                                          userModel: value.userModel1!,
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
    );
  }
}
