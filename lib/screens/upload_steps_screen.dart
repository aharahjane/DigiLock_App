import 'package:flutter/material.dart';

class UploadStepsScreen extends StatelessWidget {
  const UploadStepsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0C1C30),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0C1C30),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('DigiLock', style: TextStyle(color: Colors.white)),
      ),
      body: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        decoration: const BoxDecoration(
          color: Color(0xFFE9E9E9),
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text(
              'Steps in uploading your work!',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF0C1C30),
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ..._buildStep("Step 1", "Fill in the title and description."),
            ..._buildStep("Step 2", "Choose the type of your work (video, image, or research paper)."),
            ..._buildStep("Step 3", "Select the date when it was created."),
            ..._buildStep("Step 4", "Set your price."),
            ..._buildStep("Step 5", "Upload your copyright certificate in PDF form."),
            ..._buildStep("Step 6", "Submit and wait for review in 1-2 days."),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/uploadWork');
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF0C1C30),
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              child: const Text(
                "Upload Now!",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildStep(String title, String detail) {
    return [
      Text(
        title,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          color: Color(0xFF0C1C30),
        ),
        textAlign: TextAlign.center,
      ),
      const SizedBox(height: 6),
      Text(
        detail,
        style: const TextStyle(
          fontSize: 14,
          color: Color(0xFF0C1C30),
        ),
        textAlign: TextAlign.center,
      ),
      const SizedBox(height: 20),
    ];
  }
}
