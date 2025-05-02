import 'package:flutter/material.dart';

class MyWorksScreen extends StatelessWidget {
  const MyWorksScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0C1C30),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0C1C30),
        elevation: 0,
        title: const Text('My Works', style: TextStyle(color: Colors.white)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: const Center(
        child: Text(
          'Your uploaded works will appear here.',
          style: TextStyle(color: Colors.white, fontSize: 16),
        ),
      ),
    );
  }
}
