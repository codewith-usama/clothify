import 'package:flutter/material.dart';
import 'package:fyp/tailor_console/tailor_registration_screen.dart';
import 'package:fyp/user_console/user_registration_screen.dart';
import 'package:google_fonts/google_fonts.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  String? imagePath;

  @override
  void initState() {
    super.initState();
    imagePath = 'assets/1.jpg';
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(imagePath!),
            fit: BoxFit.cover,
            opacity: 0.9,
          ),
        ),
        child: SafeArea(
          child: Center(
            child: Column(
              children: [
                SizedBox(height: height * 0.30),
                Text(
                  'CLOTHIFY',
                  style: GoogleFonts.mali(
                    textStyle: TextStyle(
                      color: Colors.white,
                      letterSpacing: 2,
                      fontSize: width * 0.17,
                    ),
                  ),
                ),
                Text(
                  'SLEEP SLAY & REPEAT',
                  style: GoogleFonts.golosText(
                    textStyle: TextStyle(
                      color: Colors.white,
                      letterSpacing: 2,
                      fontSize: width * 0.04,
                    ),
                  ),
                ),
                SizedBox(height: height * 0.10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: 50,
                      width: width * 0.25,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => TailorRegistrationScreen(
                                height: height,
                                width: width,
                              ),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.all(0),
                          side: BorderSide(
                            color: Colors.black.withOpacity(0.4),
                          ),
                          backgroundColor:
                              const Color.fromARGB(255, 79, 152, 116)
                                  .withOpacity(0.8),
                        ),
                        child: Center(
                          child: Text(
                            'Tailor',
                            style: GoogleFonts.lato(
                              fontSize: width * 0.07,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: width * 0.10),
                    SizedBox(
                      height: 50,
                      width: width * 0.25,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => UserRegistrationScreen(
                                height: height,
                                width: width,
                              ),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.all(0),
                          side: BorderSide(
                            color: Colors.black.withOpacity(0.4),
                          ),
                          backgroundColor:
                              const Color.fromARGB(255, 79, 152, 116)
                                  .withOpacity(0.8),
                        ),
                        child: Center(
                          child: Text(
                            'User',
                            style: GoogleFonts.lato(
                              fontSize: width * 0.07,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
