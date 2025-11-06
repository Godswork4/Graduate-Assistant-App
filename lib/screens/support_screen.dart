import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SupportScreen extends StatelessWidget {
  const SupportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final Color deepPurple = const Color(0xFF6C2786);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: deepPurple,
        title: Text('Support', style: GoogleFonts.poppins(color: Colors.white)),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: ListTile(
              leading: const Icon(Icons.help_outline, color: Colors.deepPurple),
              title: Text('FAQs', style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
              subtitle: Text('Answers to common questions', style: GoogleFonts.poppins()),
              onTap: () {},
            ),
          ),
          Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: ListTile(
              leading: const Icon(Icons.email_outlined, color: Colors.deepPurple),
              title: Text('Email Support', style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
              subtitle: Text('support@graduate-guide.app', style: GoogleFonts.poppins()),
              onTap: () {},
            ),
          ),
          Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: ListTile(
              leading: const Icon(Icons.chat_bubble_outline, color: Colors.deepPurple),
              title: Text('Customer Care', style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
              subtitle: Text('Chat with our customer care', style: GoogleFonts.poppins()),
              onTap: () => Navigator.pushNamed(context, '/customer-care'),
            ),
          ),
        ],
      ),
    );
  }
}