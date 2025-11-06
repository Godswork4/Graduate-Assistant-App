import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SkillProgressScreen extends StatefulWidget {
  const SkillProgressScreen({super.key});

  @override
  State<SkillProgressScreen> createState() => _SkillProgressScreenState();
}

class _SkillProgressScreenState extends State<SkillProgressScreen> {
  double progress = 0.85; // 85% progress

  void _updateProgress(double value) {
    setState(() {
      progress = value.clamp(0.0, 1.0);
    });
  }

  @override
  Widget build(BuildContext context) {
    final Color deepPurple = const Color(0xFF6C2786);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back_ios_new,
                        color: Colors.black),
                    onPressed: () => Navigator.pop(context),
                  ),
                  IconButton(
                    icon: const Icon(Icons.notifications_none,
                        color: Colors.black),
                    onPressed: () {
                      // Notification logic
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            CircleAvatar(
              radius: 40,
              backgroundImage: AssetImage('assets/pages_assets/avatar.png'),
            ),
            const SizedBox(height: 18),
            Text(
              'Skill acquisition\nProgress',
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.bold,
                fontSize: 26,
                color: deepPurple,
              ),
            ),
            const SizedBox(height: 18),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: Column(
                children: [
                  LinearProgressIndicator(
                    value: progress,
                    minHeight: 14,
                    backgroundColor: Colors.grey[300],
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  const SizedBox(height: 8),
                  Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                      '${(progress * 100).toInt()}%',
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w600,
                        fontSize: 15,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  const SizedBox(height: 18),
                  Slider(
                    value: progress,
                    min: 0,
                    max: 1,
                    divisions: 20,
                    label: '${(progress * 100).toInt()}%',
                    activeColor: deepPurple,
                    onChanged: _updateProgress,
                  ),
                  Text(
                    'Mark your progress as you complete tasks and courses.',
                    style: GoogleFonts.poppins(
                      fontSize: 13,
                      color: Colors.grey[700],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
            Expanded(
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: deepPurple,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(40),
                    topRight: Radius.circular(40),
                  ),
                ),
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 28),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ListTile(
                        title: Text(
                          'Download Certification',
                          style: GoogleFonts.poppins(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                            fontSize: 17,
                          ),
                        ),
                        trailing: const Icon(Icons.arrow_downward,
                            color: Colors.white),
                        onTap: () {
                          // Download certificate logic
                        },
                      ),
                      Divider(color: Colors.white54),
                      ListTile(
                        title: Text(
                          'Checkout New Courses',
                          style: GoogleFonts.poppins(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                            fontSize: 17,
                          ),
                        ),
                        trailing: const Icon(Icons.arrow_forward_ios,
                            color: Colors.white),
                        onTap: () {
                          // Navigate to new courses
                        },
                      ),
                      const SizedBox(height: 32),
                      Container(
                        height: 100,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius: BorderRadius.circular(18),
                        ),
                        child: Center(
                          child: Text(
                            'Your project showcase or feedback area',
                            style: GoogleFonts.poppins(
                              color: Colors.black54,
                              fontSize: 15,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
