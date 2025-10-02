import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

class MastersScreen extends StatelessWidget {
  final Color deepPurple = const Color(0xFF6C2786);

  // Example real programs with links (customize or expand as needed)
  final List<Map<String, String>> mastersPrograms = [
    {
      'title': 'MSc Computer Science - University of Ibadan',
      'desc':
          'Advanced study in algorithms, AI, software engineering, and research.',
      'url': 'https://www.cs.ui.edu.ng/msc-programme/'
    },
    {
      'title': 'MSc Data Science - University of Lagos',
      'desc':
          'Focus on machine learning, big data, analytics, and data engineering.',
      'url': 'https://cis.unilag.edu.ng/programmes/msc-data-science/'
    },
    {
      'title': 'MSc Cybersecurity - Obafemi Awolowo University',
      'desc':
          'Specializes in network security, cryptography, and digital forensics.',
      'url':
          'https://oauife.edu.ng/faculties/science/department-of-computer-science-and-engineering/'
    },
    {
      'title': 'MSc Artificial Intelligence - Covenant University',
      'desc': 'Deep learning, NLP, robotics, and intelligent systems.',
      'url':
          'https://covenantuniversity.edu.ng/colleges/college-of-science-and-technology/computer-and-information-sciences/'
    },
    {
      'title': 'MSc Information Systems - Babcock University',
      'desc':
          'Blends business and IT for careers in IT management and consulting.',
      'url': 'https://www.babcock.edu.ng/computer-science/'
    },
    {
      'title': 'MSc Computer Science - University of Oxford (UK)',
      'desc': 'International: Advanced research and coursework in CS.',
      'url':
          'https://www.ox.ac.uk/admissions/graduate/courses/msc-computer-science'
    },
    {
      'title': 'MSc Data Science - University of Edinburgh (UK)',
      'desc': 'International: Data science, analytics, and machine learning.',
      'url': 'https://www.ed.ac.uk/informatics/postgraduate/msc-data-science'
    },
  ];

  void _openUrl(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: deepPurple,
        title: Text('Masters Guide',
            style: GoogleFonts.poppins(color: Colors.white)),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Text(
            'What is a Master\'s Program?',
            style: GoogleFonts.poppins(
              fontWeight: FontWeight.bold,
              fontSize: 22,
              color: deepPurple,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            'A Master\'s program is a postgraduate academic degree that allows you to specialize in a field, gain advanced knowledge, and improve your career prospects. '
            'It typically lasts 1-2 years and may involve coursework, research, or a thesis. '
            'Pursuing a master\'s can open doors to higher-level jobs, research roles, and even PhD opportunities.',
            style: GoogleFonts.poppins(fontSize: 15, color: Colors.black87),
          ),
          const SizedBox(height: 24),
          Text(
            'Available Master\'s Programs in Computer Science & Related Fields:',
            style: GoogleFonts.poppins(
              fontWeight: FontWeight.bold,
              fontSize: 18,
              color: deepPurple,
            ),
          ),
          const SizedBox(height: 12),
          ...mastersPrograms.map((prog) => Card(
                margin: const EdgeInsets.only(bottom: 16),
                elevation: 2,
                child: ListTile(
                  title: Text(prog['title'] ?? '',
                      style: GoogleFonts.poppins(
                          fontWeight: FontWeight.bold, fontSize: 16)),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(prog['desc'] ?? '',
                          style: GoogleFonts.poppins(fontSize: 13)),
                      if (prog['url'] != null)
                        Padding(
                          padding: const EdgeInsets.only(top: 6),
                          child: GestureDetector(
                            onTap: () => _openUrl(prog['url']!),
                            child: Text(
                              'View Program',
                              style: GoogleFonts.poppins(
                                color: deepPurple,
                                decoration: TextDecoration.underline,
                                fontSize: 13,
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                  isThreeLine: true,
                ),
              )),
          const SizedBox(height: 16),
          Text(
            'Tip: Research each program\'s requirements and deadlines. Most require a good undergraduate result, transcripts, reference letters, and sometimes an entrance exam or interview.',
            style: GoogleFonts.poppins(
                fontSize: 13,
                color: Colors.black87,
                fontStyle: FontStyle.italic),
          ),
        ],
      ),
    );
  }
}
