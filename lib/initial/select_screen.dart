import 'package:flutter/material.dart';
import 'package:fyp/tailor_console/choose_tailor_screen.dart';
import 'package:fyp/user_console/choose_user_screen.dart';
import 'package:google_fonts/google_fonts.dart';

class SelectScreen extends StatelessWidget {
  const SelectScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/background1.jpg'),
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
                              builder: (context) => const ChooseTailorScreen(),
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
                              builder: (context) => const ChooseUserScreen(),
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
