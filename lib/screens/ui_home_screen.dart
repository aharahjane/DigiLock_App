import 'package:flutter/material.dart';
import 'drawer_menu.dart';
import 'purchase_screen.dart';
import 'my_uploads_screen.dart';

class UiHomeScreen extends StatefulWidget {
  const UiHomeScreen({super.key});

  @override
  _UiHomeScreenState createState() => _UiHomeScreenState();
}

class _UiHomeScreenState extends State<UiHomeScreen> {
  int _selectedIndex = 0;

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
        Navigator.pushReplacementNamed(context, '/videos');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F8F8),
      appBar: AppBar(
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
              Navigator.of(context).push(_createUploadsRoute());
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
            _categoryOptions(context),
            const SizedBox(height: 16),
            Expanded(child: _contentGrid()),
          ],
        ),
      ),
      bottomNavigationBar: _bottomNavigationBar(),
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

  Widget _chipButton(BuildContext context, String label, {bool dark = false}) {
    return ElevatedButton(
      onPressed: () {
        // Handle navigation based on label
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: dark ? const Color(0xFF0C1C30) : Colors.blue,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      ),
      child: Text(label),
    );
  }

  Route _createCartRoute() {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => const PurchaseScreen(),
      transitionsBuilder: _fadeSlideTransition,
    );
  }

  Route _createUploadsRoute() {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => const MyUploadsScreen(),
      transitionsBuilder: _fadeSlideTransition,
    );
  }

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

  Widget _categoryOptions(BuildContext context) {
    return Row(
      children: [
        _chipButton(context, 'Trending'),
        const SizedBox(width: 8),
        _chipButton(context, 'My Uploads', dark: true),
        const SizedBox(width: 8),
        GestureDetector(
          onTap: () {
            Navigator.of(context).push(_createUploadsRoute());
          },
          child: const Text(
            'Upload your work',
            style: TextStyle(
              color: Color(0xFF0C1C30),
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ),
      ],
    );
  }

  Widget _contentGrid() {
    return GridView.builder(
      itemCount: 6,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 3 / 4,
      ),
      itemBuilder: (context, index) => Container(
        decoration: BoxDecoration(
          color: Colors.grey[300],
          borderRadius: BorderRadius.circular(16),
        ),
      ),
    );
  }
}
