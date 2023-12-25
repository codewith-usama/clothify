// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:fyp/tailor_console/tailor_authentication_vm.dart';
import 'package:fyp/tailor_console/tailor_home_master_screen.dart';
import 'package:provider/provider.dart';

class TailorRegistrationScreen extends StatelessWidget {
  const TailorRegistrationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final GlobalKey<FormState> formKey = GlobalKey<FormState>();

    // TextEditingControllers
    final TextEditingController emailController = TextEditingController();
    final TextEditingController passwordController = TextEditingController();
    final TextEditingController fullNameController = TextEditingController();
    final TextEditingController shopNameController = TextEditingController();
    final TextEditingController shopNumberController = TextEditingController();
    final TextEditingController descController = TextEditingController();
    final TextEditingController areaController = TextEditingController();
    final TextEditingController cityController = TextEditingController();
    final TextEditingController zipCodeController = TextEditingController();
    final TextEditingController availableTimingsController =
        TextEditingController();
    final TextEditingController typesOfClothsController =
        TextEditingController();
    final TextEditingController priceForEachTimeController =
        TextEditingController();
    final TextEditingController phoneNumberController = TextEditingController();

    void moveToTailorHomeMasterScreen() async {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const TailorHomeMasterScreen()),
      );
    }

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          child: Center(
            child: Form(
              key: formKey,
              child: Builder(
                builder: (context) => SingleChildScrollView(
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
                        controller: shopNameController,
                        decoration: const InputDecoration(
                          label: Text("Enter Shop Name"),
                          hintText: "Enter Shop Name",
                        ),
                        validator: (value) => value != null && value.isNotEmpty
                            ? null
                            : 'Enter Shop Name',
                      ),
                      const SizedBox(height: 20),
                      TextFormField(
                        controller: shopNumberController,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          label: Text("Enter Shop Number"),
                          hintText: "Enter Shop Number",
                        ),
                        validator: (value) => value != null && value.isNotEmpty
                            ? null
                            : 'Enter Shop Number',
                      ),
                      const SizedBox(height: 20),
                      TextFormField(
                        controller: descController,
                        keyboardType: TextInputType.multiline,
                        maxLines: null,
                        decoration: const InputDecoration(
                          label: Text("Enter Description"),
                          hintText: "Enter Description",
                        ),
                        validator: (value) => value != null && value.isNotEmpty
                            ? null
                            : 'Enter Description',
                      ),
                      const SizedBox(height: 20),
                      TextFormField(
                        controller: areaController,
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
                          label: Text("Enter Zip Code"),
                          hintText: "Enter Zip Code",
                        ),
                        validator: (value) => value != null && value.isNotEmpty
                            ? null
                            : 'Enter Zip Code',
                      ),
                      const SizedBox(height: 20),
                      TextFormField(
                        controller: availableTimingsController,
                        decoration: const InputDecoration(
                          label: Text("Enter Available Timings"),
                          hintText: "Enter Available Days of the Week",
                        ),
                        validator: (value) => value != null && value.isNotEmpty
                            ? null
                            : 'Enter Available Timings',
                      ),
                      const SizedBox(height: 20),
                      TextFormField(
                        controller: typesOfClothsController,
                        decoration: const InputDecoration(
                          label: Text("Enter Types of Cloths"),
                          hintText:
                              "Enter Types of Cloths (e.g., Adult, Child, Ladies)",
                        ),
                        validator: (value) => value != null && value.isNotEmpty
                            ? null
                            : 'Enter Types of Cloths',
                      ),
                      const SizedBox(height: 20),
                      TextFormField(
                        controller: priceForEachTimeController,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          label: Text("Enter Price for Each Time"),
                          hintText: "Enter Price",
                        ),
                        validator: (value) => value != null && value.isNotEmpty
                            ? null
                            : 'Enter Price for Each Time',
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
                      SizedBox(
                        width: double.maxFinite,
                        child: Consumer<TailorAuthenticationVm>(
                          builder: (context, value, _) => ElevatedButton(
                            onPressed: () async {
                              if (formKey.currentState!.validate()) {
                                value.setLoading(true);
                                // Collect all field values
                                Map<String, String> tailorsRegistrationData = {
                                  'tailorEmail': emailController.text.trim(),
                                  'tailorPassword':
                                      passwordController.text.trim(),
                                  'fullName': fullNameController.text.trim(),
                                  'shopName': shopNameController.text.trim(),
                                  'shopNumber':
                                      shopNumberController.text.trim(),
                                  'description': descController.text.trim(),
                                  'area': areaController.text.trim(),
                                  'city': cityController.text.trim(),
                                  'zipCode': zipCodeController.text.trim(),
                                  'availableTimings':
                                      availableTimingsController.text.trim(),
                                  'typesOfCloths':
                                      typesOfClothsController.text.trim(),
                                  'priceForEachTime':
                                      priceForEachTimeController.text.trim(),
                                  'phoneNumber':
                                      phoneNumberController.text.trim(),
                                  'profilePic': "",
                                };

                                // Handle registration logic
                                TailorAuthenticationVm tailorAuthenticationVM =
                                    TailorAuthenticationVm();
                                bool result = await tailorAuthenticationVM
                                    .tailorRegistration(
                                        tailorsRegistrationData);
                                if (result) {
                                  moveToTailorHomeMasterScreen();
                                  value.setLoading(false);
                                } else {
                                  value.setLoading(false);
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text(
                                          'Registration failed. Please try again.'),
                                      backgroundColor: Colors.red,
                                    ),
                                  );
                                }
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue, // Button color
                              foregroundColor: Colors.white, // Text color
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 12),
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
      ),
    );
  }
}
