import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:newly_graduate_hub/services/backend.dart';

class ConversationsScreen extends StatefulWidget {
  const ConversationsScreen({super.key});

  @override
  State<ConversationsScreen> createState() => _ConversationsScreenState();
}

class _ConversationsScreenState extends State<ConversationsScreen> {
  bool _loading = true;
  List<Map<String, dynamic>> _convos = [];

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    try {
      _convos = await Backend.instance.fetchConversations();
    } catch (_) {
      _convos = [];
    }
    if (mounted) setState(() => _loading = false);
  }

  @override
  Widget build(BuildContext context) {
    final Color deepPurple = const Color(0xFF6C2786);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: deepPurple,
        title: Text('Conversations', style: GoogleFonts.poppins(color: Colors.white)),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : (_convos.isEmpty
              ? Center(child: Text('No conversations yet', style: GoogleFonts.poppins()))
              : ListView.separated(
                  itemCount: _convos.length,
                  separatorBuilder: (_, __) => const Divider(height: 1),
                  itemBuilder: (context, i) {
                    final c = _convos[i];
                    final label = (c['label'] ?? c['id']).toString();
                    return ListTile(
                      leading: const Icon(Icons.person_outline),
                      title: Text(label, style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
                      subtitle: Text('User ID: ${c['id']}', style: GoogleFonts.poppins(fontSize: 12)),
                      onTap: () {
                        Navigator.pop(context);
                        Navigator.pushNamed(context, '/messages', arguments: {
                          'toUserId': c['id'],
                          'toLabel': label,
                        });
                      },
                    );
                  },
                )),
      floatingActionButton: FloatingActionButton(
        onPressed: _newConversation,
        child: const Icon(Icons.add),
      ),
    );
  }

  Future<void> _newConversation() async {
    String email = '';
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Start new conversation', style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
        content: TextField(
          onChanged: (v) => email = v,
          decoration: InputDecoration(hintText: 'recipient@example.com', hintStyle: GoogleFonts.poppins()),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: Text('Cancel', style: GoogleFonts.poppins())),
          TextButton(onPressed: () => Navigator.pop(ctx, true), child: Text('Start', style: GoogleFonts.poppins())),
        ],
      ),
    );
    if (ok != true || email.trim().isEmpty) return;
    final id = await Backend.instance.findUserIdByEmail(email.trim());
    if (!mounted) return;
    if (id == null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('User not found', style: GoogleFonts.poppins()), backgroundColor: Colors.red));
      return;
    }
    Navigator.pop(context);
    Navigator.pushNamed(context, '/messages', arguments: {'toUserId': id, 'toLabel': email.trim()});
  }
}
