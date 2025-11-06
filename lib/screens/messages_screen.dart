import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:newly_graduate_hub/services/backend.dart';
import 'package:newly_graduate_hub/config.dart' as app_config;

class MessagesScreen extends StatefulWidget {
  const MessagesScreen({super.key});

  @override
  State<MessagesScreen> createState() => _MessagesScreenState();
}

class _MessagesScreenState extends State<MessagesScreen> {
  String? _toUserId;
  String? _toLabel;
  final TextEditingController _controller = TextEditingController();
  final Color deepPurple = const Color(0xFF6C2786);
  List<Map<String, dynamic>> messages = [];

  @override
  void initState() {
    super.initState();
    _loadMessages();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args = ModalRoute.of(context)?.settings.arguments;
    if (args is Map) {
      _toUserId = args['toUserId'] as String?;
      _toLabel = args['toLabel'] as String?;
      setState(() {});
    }
  }

  Future<void> _loadMessages() async {
    try {
      final data = await Backend.instance.fetchMessages();
      setState(() => messages = data.map((m) => {
        'text': (m['content'] ?? '').toString(),
        'isMe': m['from'] == Backend.instance.getCurrentUser()?.id,
      }).toList().reversed.toList());
    } catch (_) {}
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Image.asset('assets/pages_assets/ChevronLeftOutline.png',
              width: 24, height: 24),
          onPressed: () => Navigator.pop(context),
        ),
        centerTitle: true,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'Messages',
              style: GoogleFonts.poppins(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 22,
              ),
            ),
            if (_toLabel != null || app_config.supportUserId != null)
              Text(
                'To: ' + (_toLabel ?? 'Support'),
                style: GoogleFonts.poppins(fontSize: 11, color: Colors.grey[700]),
              ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.people_outline, color: Colors.black87),
            onPressed: () => Navigator.pushNamed(context, '/conversations'),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Image.asset('assets/pages_items/Bell.png',
                width: 26, height: 26),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              itemCount: messages.length,
              reverse: false,
              itemBuilder: (context, index) {
                final msg = messages[index];
                return _buildChatBubble(msg['text'], msg['isMe']);
              },
            ),
          ),
          _buildInputBar(),
        ],
      ),
    );
  }

  Widget _buildChatBubble(String text, bool isMe) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment:
            isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (!isMe)
            CircleAvatar(
              radius: 16,
              backgroundImage:
                  AssetImage('assets/preloader_assets/charco_education.png'),
            ),
          if (!isMe) const SizedBox(width: 6),
          Flexible(
            child: Container(
              decoration: BoxDecoration(
                color: isMe ? const Color(0xFFF8F6FF) : Colors.white,
                border: Border.all(
                  color: deepPurple.withOpacity(0.7),
                  width: 2,
                ),
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(16),
                  topRight: const Radius.circular(16),
                  bottomLeft: Radius.circular(isMe ? 16 : 0),
                  bottomRight: Radius.circular(isMe ? 0 : 16),
                ),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              child: Text(
                text,
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  color: Colors.black87,
                ),
              ),
            ),
          ),
          if (isMe) const SizedBox(width: 6),
          if (isMe)
            CircleAvatar(
              radius: 16,
              backgroundImage:
                  AssetImage('assets/preloader_assets/charco_education.png'),
            ),
        ],
      ),
    );
  }

  Widget _buildInputBar() {
    return SafeArea(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        color: Colors.white,
        child: Row(
          children: [
            GestureDetector(
              onTap: () {
                // Handle attach action
              },
              child: Image.asset('assets/pages_assets/upload_files.png',
                  width: 24, height: 24),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: TextField(
                controller: _controller,
                decoration: InputDecoration(
                  hintText: 'Type a message',
                  hintStyle:
                      GoogleFonts.poppins(color: Colors.grey, fontSize: 15),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.grey.shade300),
                  ),
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                  filled: true,
                  fillColor: Colors.white,
                ),
              ),
            ),
            const SizedBox(width: 8),
            GestureDetector(
              onTap: () {
                // Handle camera action
              },
              child: Image.asset('assets/pages_assets/Camera.png',
                  width: 24, height: 24),
            ),
            const SizedBox(width: 8),
            GestureDetector(
              onTap: () async {
                final me = Backend.instance.getCurrentUser();
                if (_controller.text.trim().isEmpty || me == null) return;
                final toId = _toUserId ?? app_config.supportUserId ?? me.id;
                await Backend.instance.sendMessage(toUserId: toId, content: _controller.text.trim());
                _controller.clear();
                await _loadMessages();
              },
              child: Image.asset('assets/pages_assets/sender.png',
                  width: 24, height: 24),
            ),
          ],
        ),
      ),
    );
  }
}
