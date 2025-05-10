// lib/screens/ui_home_screen.dart
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:url_launcher/url_launcher.dart';
import 'drawer_menu.dart';
import 'purchase_screen.dart';
import 'my_uploads_screen.dart';
import 'user_profile_screen.dart';

class UiHomeScreen extends StatefulWidget {
  const UiHomeScreen({super.key});

  @override
  State<UiHomeScreen> createState() => _UiHomeScreenState();
}

class _UiHomeScreenState extends State<UiHomeScreen> {
  int _selectedIndex = 0;
  final user = FirebaseAuth.instance.currentUser;
  TextEditingController _fileController = TextEditingController();

  void _onNavItemTapped(int index) {
    switch (index) {
      case 0:
        break;
      case 1:
        Navigator.pushNamed(context, '/ePub');
        break;
      case 2:
        Navigator.pushNamed(context, '/add');
        break;
      case 3:
        Navigator.pushNamed(context, '/arts');
        break;
      case 4:
        Navigator.pushNamed(context, '/videos');
        break;
    }
    setState(() => _selectedIndex = index);
  }

  Widget _uploadedContentGrid() {
    return StreamBuilder<QuerySnapshot>(
      stream:
          FirebaseFirestore.instance
              .collection('uploads')
              .orderBy('uploadedAt', descending: true)
              .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const Center(
            child: Text(
              'No content uploaded yet.',
              style: TextStyle(color: Colors.black54),
            ),
          );
        }

        final docs = snapshot.data!.docs;
        return GridView.builder(
          itemCount: docs.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 3 / 4,
          ),
          itemBuilder: (context, index) {
            final data = docs[index].data()! as Map<String, dynamic>;
            final fileUrl = data['fileUrl'] as String;
            final title = data['author'] as String;
            final type = data['contentType'] as String;

            // For E-Books show a book icon; for images/videos, show cover
            Widget cover;
            if (type == 'E-Books') {
              cover = Container(
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Center(
                  child: Icon(Icons.book, size: 64, color: Colors.grey[700]),
                ),
              );
            } else {
              cover = Container(
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(16),
                  image: DecorationImage(
                    image: NetworkImage(fileUrl),
                    fit: BoxFit.cover,
                  ),
                ),
              );
            }

            return GestureDetector(
              onTap: () async {
                // launch the file URL (for EPUB it will download/open)
                final uri = Uri.parse(fileUrl);
                if (await canLaunchUrl(uri)) {
                  await launchUrl(uri);
                }
              },
              child: Column(
                children: [
                  Expanded(child: cover),
                  const SizedBox(height: 4),
                  Text(
                    title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

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
        _buildNavItem(Icons.video_library_outlined, 'Videos', 4),
      ],
    );
  }

  BottomNavigationBarItem _buildNavItem(
    IconData icon,
    String label,
    int index,
  ) {
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
            Icon(
              icon,
              color: _selectedIndex == index ? Colors.black : Colors.white,
            ),
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
              onPressed: () => Navigator.of(context).push(_createCartRoute()),
            ),
            IconButton(
              icon: const Icon(Icons.person, color: Color(0xFF0C1C30)),
              onPressed:
                  () => Navigator.of(context).push(_createProfileRoute()),
            ),
            Builder(
              builder:
                  (context) => IconButton(
                    icon: const Icon(Icons.menu, color: Color(0xFF0C1C30)),
                    onPressed: () => Scaffold.of(context).openEndDrawer(),
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
              _categoryOptions(context),
              const SizedBox(height: 16),
              Expanded(child: _uploadedContentGrid()),
            ],
          ),
        ),
        bottomNavigationBar: _bottomNavigationBar(),
      ),
    );
  }

  Widget _searchBar() => Container(
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

  Widget _categoryOptions(BuildContext context) => Row(
    children: [
      _chipButton('Trending'),
      const SizedBox(width: 8),
      _chipButton('My Uploads', dark: true),
      const SizedBox(width: 8),
    ],
  );

  Widget _chipButton(String label, {bool dark = false}) => ElevatedButton(
    onPressed: () {},
    style: ElevatedButton.styleFrom(
      backgroundColor: dark ? const Color(0xFF0C1C30) : Colors.blue,
      foregroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
    ),
    child: Text(label),
  );

  Route _createCartRoute() => PageRouteBuilder(
    pageBuilder: (_, anim, sec) => const PurchaseScreen(),
    transitionsBuilder: _fadeSlideTransition,
  );
  Route _createProfileRoute() => PageRouteBuilder(
    pageBuilder: (_, anim, sec) => const UserProfileScreen(),
    transitionsBuilder: _fadeSlideTransition,
  );

  Widget _fadeSlideTransition(
    BuildContext context,
    Animation<double> animation,
    Animation<double> sec,
    Widget child,
  ) {
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
}
