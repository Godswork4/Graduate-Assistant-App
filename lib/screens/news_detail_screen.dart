import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class NewsDetailArgs {
  final String title;
  final String body;
  final String? imageAsset;
  final String? date;
  const NewsDetailArgs({required this.title, required this.body, this.imageAsset, this.date});
}

class NewsDetailScreen extends StatelessWidget {
  const NewsDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final Color deepPurple = const Color(0xFF6C2786);
    final args = ModalRoute.of(context)?.settings.arguments;

    String title = 'News';
    String body = '';
    String? imageAsset;
    String? date;

    if (args is NewsDetailArgs) {
      title = args.title;
      body = args.body;
      imageAsset = args.imageAsset;
      date = args.date;
    } else if (args is Map) {
      title = (args['title'] ?? title).toString();
      body = (args['body'] ?? body).toString();
      imageAsset = args['imageAsset'] as String?;
      date = args['date'] as String?;
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Image.asset('assets/pages_assets/ChevronLeftOutline.png', width: 24, height: 24),
          onPressed: () => Navigator.pop(context),
        ),
        centerTitle: true,
        title: Text('News', style: GoogleFonts.poppins(color: Colors.black, fontWeight: FontWeight.bold)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (imageAsset != null)
              Center(
                child: imageAsset!.startsWith('http') || imageAsset!.startsWith('data:')
                    ? Image.network(imageAsset!, width: 96, height: 96, fit: BoxFit.contain)
                    : Image.asset(imageAsset!, width: 96, height: 96, fit: BoxFit.contain),
              ),
            const SizedBox(height: 12),
            Text(title, style: GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.w700, color: deepPurple)),
            if (date != null) ...[
              const SizedBox(height: 4),
              Text(date!, style: GoogleFonts.poppins(fontSize: 12, color: Colors.grey[600])),
            ],
            const SizedBox(height: 12),
            Text(body, style: GoogleFonts.poppins(fontSize: 15, height: 1.5)),
          ],
        ),
      ),
    );
  }
}
