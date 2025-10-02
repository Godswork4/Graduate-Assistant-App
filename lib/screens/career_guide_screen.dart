import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CareerGuideScreen extends StatefulWidget {
  const CareerGuideScreen({super.key});

  @override
  State<CareerGuideScreen> createState() => _CareerGuideScreenState();
}

class _CareerGuideScreenState extends State<CareerGuideScreen> {
  final Color deepPurple = const Color(0xFF6C2786);
  final TextEditingController _messageController = TextEditingController();

  final List<Map<String, String>> messages = [
    {
      'from': 'ai',
      'text':
          '👋 Hi! I\'m your Career Guide AI. Ask me anything about Computer Science, career paths, skills, or how to use this app. I\'m here to help you succeed!'
    },
    {
      'from': 'ai',
      'text':
          'For example, you can ask:\n• What are the top fields in Computer Science?\n• How do I become a Data Scientist?\n• What skills do I need for Frontend Development?\n• How do I build my resume?\n• How can I use this app for my career growth?'
    },
  ];

  void _sendMessage() {
    final text = _messageController.text.trim();
    if (text.isEmpty) return;
    setState(() {
      messages.add({'from': 'user', 'text': text});
      messages.add({
        'from': 'ai',
        'text': _getAIResponse(text),
      });
      _messageController.clear();
    });
  }

  String _getAIResponse(String query) {
    query = query.toLowerCase();
    if (query.contains('data scientist')) {
      return 'To become a Data Scientist, focus on Python, statistics, machine learning, and data visualization. Start with online courses and build projects!';
    } else if (query.contains('frontend')) {
      return 'Frontend Developers need HTML, CSS, JavaScript, and frameworks like React or Flutter. Practice by building websites and apps.';
    } else if (query.contains('resume')) {
      return 'A great resume highlights your skills, projects, and experience. Use clear formatting and tailor it to the job you want.';
    } else if (query.contains('fields') || query.contains('career')) {
      return 'Top fields in Computer Science include Software Engineering, Data Science, Cybersecurity, AI, Web Development, and Mobile Development.';
    } else if (query.contains('app')) {
      return 'Use this app to find jobs, learn new skills, connect with mentors, and track your progress. Explore each section for resources!';
    } else {
      return 'I\'m here to help! Ask about Computer Science careers, skills, or how to use the app.';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: deepPurple,
        elevation: 0,
        title: Text('Career Guide AI',
            style: GoogleFonts.poppins(
                color: Colors.white, fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: messages.length,
              itemBuilder: (context, index) {
                final msg = messages[index];
                final isAI = msg['from'] == 'ai';
                return Align(
                  alignment:
                      isAI ? Alignment.centerLeft : Alignment.centerRight,
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 6),
                    padding: const EdgeInsets.all(14),
                    constraints: BoxConstraints(
                        maxWidth: MediaQuery.of(context).size.width * 0.75),
                    decoration: BoxDecoration(
                      color: isAI ? deepPurple.withOpacity(0.08) : deepPurple,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Text(
                      msg['text'] ?? '',
                      style: GoogleFonts.poppins(
                        color: isAI ? Colors.black : Colors.white,
                        fontSize: 15,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            color: Colors.white,
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    style: GoogleFonts.poppins(),
                    decoration: InputDecoration(
                      hintText: 'Ask your AI guide...',
                      hintStyle: GoogleFonts.poppins(color: Colors.grey),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide: BorderSide(color: deepPurple),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide: BorderSide(color: deepPurple, width: 2),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 10),
                    ),
                    onSubmitted: (_) => _sendMessage(),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  icon: Icon(Icons.send, color: deepPurple),
                  onPressed: _sendMessage,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
