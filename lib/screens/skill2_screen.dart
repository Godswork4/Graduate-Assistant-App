import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Skill2Screen extends StatelessWidget {
  const Skill2Screen({super.key});

  @override
  Widget build(BuildContext context) {
    final Color deepPurple = const Color(0xFF4B1255);

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // Top image
          SizedBox(
            width: double.infinity,
            height: 375,
            child: Image.asset(
              'assets/pages_assets/skill2.png',
              fit: BoxFit.cover,
            ),
          ),
          // Main content
          Positioned(
            top: 323,
            left: 0,
            right: 0,
            child: Container(
              decoration: BoxDecoration(
                color: const Color(0xFFFBF8FF),
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(37)),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0x26B0AEAE),
                    blurRadius: 8.5,
                    offset: const Offset(9, -15),
                  )
                ],
              ),
              padding: const EdgeInsets.fromLTRB(25, 33, 25, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Graphic Design',
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w700,
                      fontSize: 32,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Learn Graphic Design from scratch both online and onsite and kickstart your tech career.',
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w500,
                      fontSize: 13,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 24),
                  Container(
                    decoration: BoxDecoration(
                      color: const Color(0x60DEC4FF),
                      borderRadius: BorderRadius.circular(11),
                    ),
                    padding: const EdgeInsets.symmetric(
                        vertical: 14, horizontal: 15),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Duration',
                                style: GoogleFonts.poppins(
                                  color: deepPurple,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 16,
                                )),
                            const SizedBox(height: 4),
                            Text('6 WEEKS',
                                style: GoogleFonts.poppins(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 13,
                                )),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Venue',
                                style: GoogleFonts.poppins(
                                  color: deepPurple,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 16,
                                )),
                            const SizedBox(height: 4),
                            SizedBox(
                              width: 112,
                              child: Text(
                                'No.3 Bolanle Street, agunbelewo, osun State, Osogbo.',
                                style: GoogleFonts.poppins(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 10,
                                ),
                              ),
                            ),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Reg Fee.',
                                style: GoogleFonts.poppins(
                                  color: const Color(0xFF5A1466),
                                  fontWeight: FontWeight.w700,
                                  fontSize: 16,
                                )),
                            const SizedBox(height: 4),
                            Text('35,000 N',
                                style: GoogleFonts.poppins(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 13,
                                )),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'Onsite training',
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w700,
                      fontSize: 13,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'You need a System working perfecting with good battery health, internet and all other material will be provided.',
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w500,
                      fontSize: 13,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 18),
                  Text(
                    'Online Training',
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w700,
                      fontSize: 13,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'A good Internet connection is required, a perfect working system and a writing material\nclass holds 9pm every working days except friday.',
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w500,
                      fontSize: 13,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 32),
                  Center(
                    child: SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: deepPurple,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 16),
                        ),
                        onPressed: () {
                          // Registration logic here
                        },
                        child: Text(
                          'Register Now',
                          style: GoogleFonts.poppins(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
          // Back button
          Positioned(
            top: 40,
            left: 16,
            child: IconButton(
              icon: const Icon(Icons.arrow_back_ios_new,
                  color: Colors.black, size: 28),
              onPressed: () => Navigator.pop(context),
            ),
          ),
        ],
      ),
    );
  }
}
