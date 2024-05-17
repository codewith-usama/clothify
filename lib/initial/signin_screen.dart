import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:fyp/helper/ui_helper.dart';
import 'package:fyp/initial/signup_screen.dart';
import 'package:fyp/tailor_console/tailor_authentication_vm.dart';
import 'package:fyp/tailor_console/tailor_home_master_screen.dart';
import 'package:fyp/user_console/user_authentication_vm.dart';
import 'package:fyp/user_console/user_home_master_screen.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  String? imagePath;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  late TextEditingController emailController;
  late TextEditingController passwordController;

  @override
  void initState() {
    super.initState();
    imagePath = 'assets/1.jpg';
    emailController = TextEditingController();
    passwordController = TextEditingController();
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;

    return Scaffold(
      body: SafeArea(
        child: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage(
                imagePath!,
              ),
              fit: BoxFit.cover,
              opacity: 0.9,
            ),
          ),
          child: Center(
            child: Form(
              key: formKey,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'CLOTHIFY',
                      style: GoogleFonts.mali(
                        textStyle: TextStyle(
                          color: Colors.white,
                          letterSpacing: 2,
                          fontSize: width * 0.17,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ),
                    SizedBox(height: height * 0.03),
                    Text(
                      'Login',
                      style: TextStyle(
                        fontSize: width * 0.10,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: height * 0.02),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 40),
                      child: TextFormField(
                        controller: emailController,
                        style: const TextStyle(color: Colors.white),
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                          prefixIcon:
                              const Icon(Icons.email, color: Colors.white),
                          labelText: 'Email',
                          labelStyle: const TextStyle(color: Colors.white),
                          filled: true,
                          fillColor: Colors.black45,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide.none,
                          ),
                        ),
                        validator: (value) => value != null && value.isNotEmpty
                            ? null
                            : 'Enter Password',
                      ),
                    ),
                    SizedBox(height: height * 0.015),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 40),
                      child: TextFormField(
                        style: const TextStyle(color: Colors.white),
                        controller: passwordController,
                        keyboardType: TextInputType.visiblePassword,
                        obscureText: true,
                        decoration: InputDecoration(
                          prefixIcon:
                              const Icon(Icons.lock, color: Colors.white),
                          labelText: 'Password',
                          labelStyle: const TextStyle(color: Colors.white),
                          filled: true,
                          fillColor: Colors.black45,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide.none,
                          ),
                        ),
                        validator: (value) => value != null && value.isNotEmpty
                            ? null
                            : 'Enter your Email',
                      ),
                    ),
                    SizedBox(height: height * 0.01),
                    Padding(
                      padding: const EdgeInsets.only(right: 20),
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          onPressed: () {},
                          child: const Text(
                            'Forgot your password?',
                            style: TextStyle(
                              color: Colors.white38,
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: height * 0.015),
                    Consumer<UserAuthenticationVM>(
                      builder: (context, value, _) => GestureDetector(
                        onTap: () async {
                          value.setLoading(true);

                          TailorAuthenticationVm tailorAuthenticationVm =
                              TailorAuthenticationVm();
                          if (formKey.currentState!.validate()) {
                            String email = emailController.text.trim();
                            var bytes = utf8.encode(passwordController.text
                                .trim()); // data being hashed
                            var digest = sha256.convert(bytes);
                            String password = digest.toString();

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
                                        value.setLoading(true);
                                      }
                                    },
                                    (r) {
                                      tailorAuthenticationVm
                                          .tailorLogin(email, password)
                                          .then(
                                            (value) => value.fold(
                                              (l) {
                                                if (tailorAuthenticationVm
                                                            .user !=
                                                        null &&
                                                    tailorAuthenticationVm
                                                            .tailorModel1 !=
                                                        null) {
                                                  Navigator.of(context)
                                                      .pushReplacement(
                                                    MaterialPageRoute(
                                                      builder: (context) =>
                                                          TailorHomeMasterScreen(
                                                        user:
                                                            tailorAuthenticationVm
                                                                .user!,
                                                        tailorModel:
                                                            tailorAuthenticationVm
                                                                .tailorModel1!,
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
                                                context,
                                                'Login Failed',
                                                'Credentials incorrect',
                                              ),
                                            ),
                                          );
                                    },
                                  ),
                                );
                          }
                        },
                        child: Container(
                          height: height * 0.06,
                          width: width * 0.35,
                          decoration: BoxDecoration(
                            color: Colors.white60,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Center(
                            child: value.loading
                                ? const SizedBox(
                                    width: 25,
                                    height: 20,
                                    child: CircularProgressIndicator(
                                      color: Colors.black,
                                    ),
                                  )
                                : Text(
                                    'Login',
                                    style: TextStyle(
                                      color: Colors.black87,
                                      fontSize: width * 0.065,
                                      fontStyle: FontStyle.italic,
                                    ),
                                  ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: height * 0.02),
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const SignUpScreen(),
                          ),
                        );
                      },
                      child: Text(
                        'Don\'t have an Account Sign-in',
                        style: TextStyle(
                          color: Colors.blue[200],
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

    // return Scaffold(
    //   body: Container(
    //     decoration: BoxDecoration(
    //       image: DecorationImage(
    //         image: AssetImage(imagePath!),
    //         fit: BoxFit.cover,
    //         opacity: 0.9,
    //       ),
    //     ),
    //     child: SafeArea(
    //       child: Center(
    //         child: Column(
    //           children: [
    //             SizedBox(height: height * 0.30),
    //             Text(
    //               'CLOTHIFY',
    //               style: GoogleFonts.mali(
    //                 textStyle: TextStyle(
    //                   color: Colors.white,
    //                   letterSpacing: 2,
    //                   fontSize: width * 0.17,
    //                 ),
    //               ),
    //             ),
    //             Text(
    //               'SLEEP SLAY & REPEAT',
    //               style: GoogleFonts.golosText(
    //                 textStyle: TextStyle(
    //                   color: Colors.white,
    //                   letterSpacing: 2,
    //                   fontSize: width * 0.04,
    //                 ),
    //               ),
    //             ),
    //             SizedBox(height: height * 0.10),
    //             Row(
    //               mainAxisAlignment: MainAxisAlignment.center,
    //               children: [
    //                 SizedBox(
    //                   height: 50,
    //                   width: width * 0.25,
    //                   child: ElevatedButton(
    //                     onPressed: () {
    //                       Navigator.of(context).push(
    //                         MaterialPageRoute(
    //                           builder: (context) => const ChooseTailorScreen(),
    //                         ),
    //                       );
    //                     },
    //                     style: ElevatedButton.styleFrom(
    //                       padding: const EdgeInsets.all(0),
    //                       side: BorderSide(
    //                         color: Colors.black.withOpacity(0.4),
    //                       ),
    //                       backgroundColor:
    //                           const Color.fromARGB(255, 79, 152, 116)
    //                               .withOpacity(0.8),
    //                     ),
    //                     child: Center(
    //                       child: Text(
    //                         'Tailor',
    //                         style: GoogleFonts.lato(
    //                           fontSize: width * 0.07,
    //                           fontWeight: FontWeight.bold,
    //                         ),
    //                       ),
    //                     ),
    //                   ),
    //                 ),
    //                 SizedBox(width: width * 0.10),
    //                 SizedBox(
    //                   height: 50,
    //                   width: width * 0.25,
    //                   child: ElevatedButton(
    //                     onPressed: () {
    //                       Navigator.of(context).push(
    //                         MaterialPageRoute(
    //                           builder: (context) => const ChooseUserScreen(),
    //                         ),
    //                       );
    //                     },
    //                     style: ElevatedButton.styleFrom(
    //                       padding: const EdgeInsets.all(0),
    //                       side: BorderSide(
    //                         color: Colors.black.withOpacity(0.4),
    //                       ),
    //                       backgroundColor:
    //                           const Color.fromARGB(255, 79, 152, 116)
    //                               .withOpacity(0.8),
    //                     ),
    //                     child: Center(
    //                       child: Text(
    //                         'User',
    //                         style: GoogleFonts.lato(
    //                           fontSize: width * 0.07,
    //                           fontWeight: FontWeight.bold,
    //                         ),
    //                       ),
    //                     ),
    //                   ),
    //                 ),
    //               ],
    //             ),
    //           ],
    //         ),
    //       ),
    //     ),
    //   ),
    // );
  }
}
