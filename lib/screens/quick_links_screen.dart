import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

class QuickLinksScreen extends StatelessWidget {
  const QuickLinksScreen({super.key});

  Future<void> _open(BuildContext context, String url) async {
    final uri = Uri.parse(url);
    await launchUrl(uri, mode: LaunchMode.externalApplication);
  }

  @override
  Widget build(BuildContext context) {
    final Color deepPurple = const Color(0xFF6C2786);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: deepPurple,
        title: Text('NYSC Quick Links', style: GoogleFonts.poppins(color: Colors.white)),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          ListTile(
            leading: Image.asset('assets/pages_items/nysc_logo.png', width: 36, height: 36),
            title: Text('NYSC Official Portal', style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
            subtitle: Text('Registration, guidelines, and updates.', style: GoogleFonts.poppins(fontSize: 13)),
            trailing: const Icon(Icons.open_in_new),
            onTap: () => _open(context, 'https://portal.nysc.org.ng/nysc1/'),
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.rule_folder_outlined, color: Colors.orange),
            title: Text('NYSC Requirements', style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
            subtitle: Text('Eligibility, documents, and process.', style: GoogleFonts.poppins(fontSize: 13)),
            trailing: const Icon(Icons.open_in_new, color: Colors.orange),
            onTap: () => _open(context, 'https://www.nysc.gov.ng/'),
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.school, color: Colors.deepPurple),
            title: Text('Orientation Camp Tips', style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
            subtitle: Text('Advice for a successful camp experience.', style: GoogleFonts.poppins(fontSize: 13)),
            trailing: const Icon(Icons.open_in_new, color: Colors.deepPurple),
            onTap: () => _open(context, 'https://www.nysc.gov.ng/orientation-camp.html'),
          ),
        ],
      ),
    );
  }
}
