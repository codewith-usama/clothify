// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:fyp/user_console/user_authentication_vm.dart';
import 'package:fyp/user_console/user_home_master_screen.dart';
import 'package:provider/provider.dart';

class UserRegistrationScreen extends StatelessWidget {
  const UserRegistrationScreen({super.key});

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

    void moveToUserHomeMasterScreen() {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const UserHomeMasterScreen()),
      );
    }

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          child: Center(
            child: Form(
              key: formKey,
              child: SingleChildScrollView(
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
                    const SizedBox(height: 20),
                    TextFormField(
                      controller: fullNameController,
                      keyboardType: TextInputType.name,
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
                              String email = emailController.text.trim();
                              String password = passwordController.text.trim();
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
                              };

                              UserAuthenticationVM userAuthenticationVM =
                                  UserAuthenticationVM();
                              bool result = await userAuthenticationVM
                                  .userRegistration(userRegistrationData);
                              if (result) {
                                moveToUserHomeMasterScreen();
                                value.setLoading(false);
                              } else {
                                value.setLoading(true);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    backgroundColor: Colors.red,
                                    content: Text(
                                        'Registration failed. Please try again.'),
                                  ),
                                );
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
                          child: value.loading
                              ? const CircularProgressIndicator(
                                  color: Colors.white)
                              : const Text('Register'),
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
