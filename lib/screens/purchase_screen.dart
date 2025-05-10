import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'drawer_menu.dart';
import 'package:firebase_auth/firebase_auth.dart'; // Add this import

class PurchaseScreen extends StatefulWidget {
  const PurchaseScreen({super.key});

  @override
  _PurchaseScreenState createState() => _PurchaseScreenState();
}

class _PurchaseScreenState extends State<PurchaseScreen> {
  String userFirstName =
      "User"; // Default value if the user's name is not fetched

  @override
  void initState() {
    super.initState();
    _fetchUserName();
  }

  Future<void> _fetchUserName() async {
    // Fetching user name from Firestore (assuming user's first name is stored)
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      DocumentSnapshot userDoc =
          await FirebaseFirestore.instance
              .collection('users')
              .doc(user.uid)
              .get();
      setState(() {
        userFirstName = userDoc['firstName'] ?? 'User';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const CustomDrawer(),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0C1C30),
        title: const Text('DigiLock', style: TextStyle(color: Colors.white)),
        actions: [
          GestureDetector(
            onTap: () {
              // Handle cart click here
              setState(() {
                // Add animation for cart highlighting
              });
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.all(8),
              child: const Icon(Icons.shopping_cart, color: Colors.black),
            ),
          ),
        ],
      ),
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Hi $userFirstName!",
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            const Text("My Purchases", style: TextStyle(fontSize: 18)),
            const SizedBox(height: 10),
            _gridView(),
            const SizedBox(height: 20),
            const Text("Continue Watching", style: TextStyle(fontSize: 18)),
            const SizedBox(height: 10),
            _gridView(),
          ],
        ),
      ),
      bottomNavigationBar: _bottomNavigationBar(),
    );
  }

  Widget _gridView() {
    return SizedBox(
      height: 150,
      child: GridView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: 4,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 1,
          mainAxisSpacing: 10,
        ),
        itemBuilder:
            (context, index) => Container(
              width: 150,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(12),
              ),
            ),
      ),
    );
  }

  Widget _bottomNavigationBar() {
    return BottomNavigationBar(
      backgroundColor: const Color(0xFF0C1C30),
      selectedItemColor: Colors.white,
      unselectedItemColor: Colors.white54,
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
        BottomNavigationBarItem(icon: Icon(Icons.shop), label: 'Store'),
        BottomNavigationBarItem(icon: Icon(Icons.add), label: 'Add'),
        BottomNavigationBarItem(
          icon: Icon(Icons.video_collection),
          label: 'Videos',
        ),
        BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
      ],
      currentIndex: 1, // Purchases page active
      onTap: (index) {},
    );
  }
}
