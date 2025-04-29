import 'package:flutter/material.dart';
import 'drawer_menu.dart';

class MyUploadsScreen extends StatelessWidget {
  const MyUploadsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const CustomDrawer(),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0C1C30),
        title: const Text('My Uploads', style: TextStyle(color: Colors.white)),
        actions: [
          IconButton(
            icon: const Icon(Icons.upload),
            onPressed: () {
              _showUploadDialog(context);
            },
          ),
        ],
      ),
      backgroundColor: Colors.white,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              'My Purchases',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              'Continue Watching',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          _buildUploadGrid(),
        ],
      ),
      bottomNavigationBar: _bottomNavigationBar(),
    );
  }

  /// Generates the grid view for displaying uploads.
  Widget _buildUploadGrid() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: GridView.builder(
        shrinkWrap: true,  // Makes the grid only take up as much space as necessary
        physics: NeverScrollableScrollPhysics(),  // Disables scrolling to allow flexible height
        itemCount: 8,  // ❗ Make this dynamic based on actual uploads
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
        ),
        itemBuilder: (context, index) => _buildUploadItem(index),
      ),
    );
  }

  /// Creates an individual upload item.
  Widget _buildUploadItem(int index) {
    return GestureDetector(
      onTap: () {
        // ❗ Add navigation or preview functionality for uploads
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.grey[300],
          borderRadius: BorderRadius.circular(12),
        ),
        child: Center(
          child: Text('Upload ${index + 1}', style: const TextStyle(fontSize: 16)),
        ),
      ),
    );
  }

  /// Displays an upload dialog.
  void _showUploadDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Upload File'),
        content: const Text('Feature coming soon!'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  /// Creates the bottom navigation bar.
  Widget _bottomNavigationBar() {
    return BottomNavigationBar(
      backgroundColor: const Color(0xFF0C1C30),
      selectedItemColor: Colors.white,
      unselectedItemColor: Colors.white54,
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
        BottomNavigationBarItem(icon: Icon(Icons.shop), label: 'Store'),
        BottomNavigationBarItem(icon: Icon(Icons.add), label: 'Add'),
        BottomNavigationBarItem(icon: Icon(Icons.video_collection), label: 'Videos'),
        BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
      ],
      currentIndex: 3,  // ✅ My Uploads active
      onTap: (index) {
        // ❗ Implement navigation logic
      },
    );
  }
}
