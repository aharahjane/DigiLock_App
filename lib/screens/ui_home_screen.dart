import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'drawer_menu.dart';
import 'purchase_screen.dart';
import 'my_uploads_screen.dart';
import 'user_profile_screen.dart'; // ✅ Added import
import 'upload_model.dart';


class UiHomeScreen extends StatefulWidget {
  const UiHomeScreen({super.key});

  @override
  _UiHomeScreenState createState() => _UiHomeScreenState();
}

class _UiHomeScreenState extends State<UiHomeScreen> {
  int _selectedIndex = 0;
  String _selectedCategory = 'All'; // Track the selected category filter

  // Fetch content from Firestore
  Stream<QuerySnapshot> _fetchContent() {
    if (_selectedCategory == 'All') {
      return FirebaseFirestore.instance.collection('uploads').snapshots(); // Get all uploads
    } else {
      return FirebaseFirestore.instance
          .collection('uploads')
          .where('category', isEqualTo: _selectedCategory) // Filter by type
          .snapshots();
    }
  }

  void _onNavItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    switch (index) {
      case 0:
        Navigator.pushReplacementNamed(context, '/home');
        break;
      case 1:
        Navigator.pushReplacementNamed(context, '/ePub');
        break;
      case 2:
        Navigator.pushReplacementNamed(context, '/add');
        break;
      case 3:
        Navigator.pushReplacementNamed(context, '/arts');
        break;
      case 4:
        Navigator.pushReplacementNamed(context, '/video');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        backgroundColor: const Color(0xFFF8F8F8),
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Colors.white,
          elevation: 1,
          title: const Text(
            'DigiLock',
            style: TextStyle(
              color: Color(0xFF0C1C30),
              fontWeight: FontWeight.bold,
              fontSize: 22,
            ),
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.shopping_cart, color: Color(0xFF0C1C30)),
              onPressed: () {
                Navigator.of(context).push(_createCartRoute());
              },
            ),
            IconButton(
              icon: const Icon(Icons.person, color: Color(0xFF0C1C30)),
              onPressed: () {
                Navigator.of(context).push(_createProfileRoute()); // ✅ Profile route
              },
            ),
            Builder(
              builder: (context) => IconButton(
                icon: const Icon(Icons.menu, color: Color(0xFF0C1C30)),
                onPressed: () {
                  Scaffold.of(context).openEndDrawer();
                },
              ),
            ),
          ],
        ),
        endDrawer: const CustomDrawer(),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _searchBar(),
              const SizedBox(height: 16),
              _categoryFilter(), // Add filter for categories
              const SizedBox(height: 16),
              Expanded(
                child: _contentGrid(), // Display dynamic content
              ),
            ],
          ),
        ),
        bottomNavigationBar: _bottomNavigationBar(),
      ),
    );
  }

  // Filter options for content type (All, Image, Video, Literature)
  Widget _categoryFilter() {
    return Row(
      children: [
        _chipButton(context, 'All'),
        const SizedBox(width: 8),
        _chipButton(context, 'Image'),
        const SizedBox(width: 8),
        _chipButton(context, 'Video'),
        const SizedBox(width: 8),
        _chipButton(context, 'Literature'),
        const SizedBox(width: 8),
      ],
    );
  }

  // Create dynamic chip buttons for categories
  Widget _chipButton(BuildContext context, String label) {
    return ChoiceChip(
      label: Text(label),
      selected: _selectedCategory == label,
      onSelected: (isSelected) {
        setState(() {
          _selectedCategory = label;
        });
      },
      selectedColor: const Color(0xFF0C1C30),
      backgroundColor: Colors.grey[200],
      labelStyle: TextStyle(color: _selectedCategory == label ? Colors.white : Colors.black),
    );
  }

  // Fetch and display content as grid
  Widget _contentGrid() {
    return StreamBuilder<QuerySnapshot>(
      stream: _fetchContent(), // ✅ Use your filtered stream here
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const Center(child: Text('No content available.'));
        }

        // Convert Firestore data to UploadModel list
        final uploads = snapshot.data!.docs.map((doc) {
          return UploadModel.fromFirestore(doc.data() as Map<String, dynamic>);
        }).toList();

        return GridView.builder(
          itemCount: uploads.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 3 / 4,
          ),
          itemBuilder: (context, index) {
            final item = uploads[index];
            return _contentCard(item);
          },
        );
      },
    );
  }

  // Create content card for each upload
  Widget _contentCard(UploadModel item) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Display the thumbnail image
          item.category == 'Image' || item.category == 'Literature'
              ? Image.network(item.url, height: 120, width: double.infinity, fit: BoxFit.cover)
              : const Icon(Icons.play_circle_outline, size: 120),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(item.title, style: const TextStyle(fontWeight: FontWeight.bold)),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Text("${item.author}\n${item.description}", style: TextStyle(color: Colors.grey[600])),
          ),
        ],
      ),
    );
  }

  // Bottom navigation bar
  Widget _bottomNavigationBar() {
    return BottomNavigationBar(
      backgroundColor: const Color(0xFF0C1C30),
      selectedItemColor: Colors.white,
      unselectedItemColor: Colors.white54,
      type: BottomNavigationBarType.fixed,
      currentIndex: _selectedIndex,
      onTap: _onNavItemTapped,
      items: [
        _buildNavItem(Icons.home_outlined, 'Home', 0),
        _buildNavItem(Icons.menu_book_outlined, 'E-Pub', 1),
        _buildNavItem(Icons.add_box_outlined, 'Add', 2),
        _buildNavItem(Icons.photo_library_outlined, 'Arts', 3),
        _buildNavItem(Icons.video_library_outlined, 'Video', 4),
      ],
    );
  }

  // Navigation bar item builder
  BottomNavigationBarItem _buildNavItem(IconData icon, String label, int index) {
    return BottomNavigationBarItem(
      icon: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        decoration: BoxDecoration(
          color: _selectedIndex == index ? Colors.white : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
        ),
        padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
        child: Column(
          children: [
            Icon(icon, color: _selectedIndex == index ? Colors.black : Colors.white),
            if (_selectedIndex == index)
              Container(
                margin: const EdgeInsets.only(top: 4),
                width: 28,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
          ],
        ),
      ),
      label: label,
    );
  }

  Route _createCartRoute() {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => const PurchaseScreen(),
      transitionsBuilder: _fadeSlideTransition,
    );
  }

  Route _createProfileRoute() {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => const UserProfileScreen(),
      transitionsBuilder: _fadeSlideTransition,
    );
  }

  // Transition for page routes
  Widget _fadeSlideTransition(
      BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation, Widget child) {
    const begin = Offset(0.0, -1.0);
    const end = Offset.zero;
    const curve = Curves.easeInOut;

    final tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
    final opacityTween = Tween<double>(begin: 0.0, end: 1.0);

    return SlideTransition(
      position: animation.drive(tween),
      child: FadeTransition(
        opacity: animation.drive(opacityTween),
        child: child,
      ),
    );
  }

  // Search bar widget
  Widget _searchBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(12),
      ),
      child: const TextField(
        decoration: InputDecoration(
          hintText: 'Search',
          border: InputBorder.none,
          icon: Icon(Icons.search, color: Colors.grey),
        ),
      ),
    );
  }
}
