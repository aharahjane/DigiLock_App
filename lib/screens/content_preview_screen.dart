// lib/screens/content_preview_screen.dart
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class ContentPreviewScreen extends StatelessWidget {
  final String fileUrl;
  final String author;
  final String price;
  final String description;
  final String creationDate;
  final String contentType;

  const ContentPreviewScreen({
    super.key,
    required this.fileUrl,
    required this.author,
    required this.price,
    required this.description,
    required this.creationDate,
    required this.contentType,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF0C1C30),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 16),
            child: Center(
              child: Text(
                'DigiLock',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
            ),
          ),
        ],
      ),
      backgroundColor: const Color(0xFFF8F8F8),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Poster / Thumbnail
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  image: DecorationImage(
                    image: NetworkImage(fileUrl),
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            // Details
            Text(
              'Author: \$author',
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 4),
            Text('Price: \$price', style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 4),
            Text(
              'Created: \$creationDate',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 8),
            Text(description, style: const TextStyle(fontSize: 14)),
            const Spacer(),
            // Check it out button
            ElevatedButton(
              onPressed: () async {
                final uri = Uri.parse(fileUrl);
                if (await canLaunchUrl(uri)) {
                  await launchUrl(uri);
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF0C1C30),
                foregroundColor: Colors.white,
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              child: const Text(
                'Check it out now',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
