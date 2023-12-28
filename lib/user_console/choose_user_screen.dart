import 'package:flutter/material.dart';
import 'package:fyp/user_console/user_login_screen.dart';
import 'package:fyp/user_console/user_registration_screen.dart';
import 'package:google_fonts/google_fonts.dart';

class ChooseUserScreen extends StatelessWidget {
  const ChooseUserScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/background.jpg'),
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
                      fontSize: width * 0.15,
                    ),
                  ),
                ),
                Text(
                  'USER',
                  style: GoogleFonts.mali(
                    textStyle: TextStyle(
                      color: Colors.black,
                      letterSpacing: 2,
                      fontWeight: FontWeight.w800,
                      fontStyle: FontStyle.italic,
                      fontSize: width * 0.12,
                    ),
                  ),
                ),
                SizedBox(height: height * 0.08),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: 50,
                      width: width * 0.28,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => UserLoginScreen(
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
                            'SIGN IN',
                            style: GoogleFonts.lato(
                              fontSize: width * 0.06,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: width * 0.10),
                    SizedBox(
                      height: 50,
                      width: width * 0.28,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).pushReplacement(
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
                            'SIGN UP',
                            style: GoogleFonts.lato(
                              fontSize: width * 0.06,
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
