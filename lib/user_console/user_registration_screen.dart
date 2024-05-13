import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:fyp/helper/ui_helper.dart';
import 'package:fyp/user_console/user_authentication_vm.dart';
import 'package:fyp/user_console/user_home_master_screen.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class UserRegistrationScreen extends StatelessWidget {
  final double height;
  final double width;
  const UserRegistrationScreen({
    super.key,
    required this.height,
    required this.width,
  });

  @override
  Widget build(BuildContext context) {
    final GlobalKey<FormState> formKey = GlobalKey<FormState>();

    final TextEditingController emailController = TextEditingController();
    final TextEditingController passwordController = TextEditingController();
    final TextEditingController fullNameController = TextEditingController();
    final TextEditingController phoneNumberController = TextEditingController();
    final TextEditingController areaController = TextEditingController();
    final TextEditingController cityController = TextEditingController();
    final TextEditingController zipCodeController = TextEditingController();

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 166, 206, 226),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          child: Center(
            child: Form(
              key: formKey,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    SizedBox(height: height * 0.04),
                    Text(
                      'GET STARTED',
                      style: GoogleFonts.mali(
                        textStyle: TextStyle(
                          color: Colors.white,
                          letterSpacing: 2,
                          fontSize: width * 0.12,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ),
                    SizedBox(height: height * 0.03),
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
                      style: const TextStyle(color: Colors.black, fontSize: 18),
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
                    const SizedBox(height: 20),
                    TextFormField(
                      controller: fullNameController,
                      keyboardType: TextInputType.name,
                      style: const TextStyle(color: Colors.black, fontSize: 18),
                      decoration: const InputDecoration(
                        label: Text("Enter Full Name"),
                        hintText: "Enter Full Name",
                      ),
                      validator: (value) => value != null && value.isNotEmpty
                          ? null
                          : 'Enter Full Name',
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      controller: phoneNumberController,
                      keyboardType: TextInputType.phone,
                      style: const TextStyle(color: Colors.black, fontSize: 18),
                      decoration: const InputDecoration(
                        label: Text("Enter Phone Number"),
                        hintText: "Enter Phone Number",
                      ),
                      validator: (value) => value != null && value.isNotEmpty
                          ? null
                          : 'Enter Phone Number',
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      controller: areaController,
                      keyboardType: TextInputType.text,
                      style: const TextStyle(color: Colors.black, fontSize: 18),
                      decoration: const InputDecoration(
                        label: Text("Enter Area"),
                        hintText: "Enter Area",
                      ),
                      validator: (value) => value != null && value.isNotEmpty
                          ? null
                          : 'Enter Area',
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      controller: cityController,
                      style: const TextStyle(color: Colors.black, fontSize: 18),
                      keyboardType: TextInputType.text,
                      decoration: const InputDecoration(
                        label: Text("Enter City"),
                        hintText: "Enter City",
                      ),
                      validator: (value) => value != null && value.isNotEmpty
                          ? null
                          : 'Enter City',
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      controller: zipCodeController,
                      keyboardType: TextInputType.number,
                      style: const TextStyle(color: Colors.black, fontSize: 18),
                      decoration: const InputDecoration(
                        label: Text("Enter Zipcode"),
                        hintText: "Enter Zipcode",
                      ),
                      validator: (value) => value != null && value.isNotEmpty
                          ? null
                          : 'Enter Zipcode',
                    ),
                    const SizedBox(height: 30),
                    SizedBox(
                      width: double.maxFinite,
                      child: Consumer<UserAuthenticationVM>(
                        builder: (context, value, _) => ElevatedButton(
                          onPressed: () async {
                            if (formKey.currentState!.validate()) {
                              value.setLoading(true);
                              // Hashing the password
                              var bytes = utf8.encode(passwordController.text
                                  .trim()); // data being hashed
                              var digest = sha256.convert(bytes);

                              String email = emailController.text.trim();
                              String password = digest.toString();
                              String fullName = fullNameController.text.trim();
                              String phoneNumber =
                                  phoneNumberController.text.trim();
                              String area = areaController.text.trim();
                              String city = cityController.text.trim();
                              String zipCode = zipCodeController.text.trim();

                              final userRegistrationData = {
                                'userEmail': email,
                                'userPassword': password,
                                'userFullName': fullName,
                                'userPhoneNumber': phoneNumber,
                                'userArea': area,
                                'userCity': city,
                                'userZipcode': zipCode,
                                'profilePic': "",
                                'id': "",
                              };

                              UserAuthenticationVM userAuthenticationVM =
                                  UserAuthenticationVM();
                              await userAuthenticationVM
                                  .userRegistration(userRegistrationData)
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
                                          context, 'Signup Failed', r),
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
                              : const Text('Register'),
                        ),
                      ),
                    ),
                    SizedBox(height: height * 0.04),
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
