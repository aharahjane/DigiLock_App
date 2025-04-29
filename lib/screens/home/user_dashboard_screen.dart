import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class UserDashboardScreen extends StatelessWidget {
  const UserDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Dashboard'),
        backgroundColor: const Color(0xFF0C1C30),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Hello, ${user?.email ?? "User"}!',
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            Card(
              elevation: 4,
              child: ListTile(
                leading: const Icon(Icons.shopping_cart),
                title: const Text('My Purchases'),
                onTap: () {
                  // TODO: Navigate to purchases list
                },
              ),
            ),
            const SizedBox(height: 10),
            Card(
              elevation: 4,
              child: ListTile(
                leading: const Icon(Icons.sell),
                title: const Text('My Uploaded Content'),
                onTap: () {
                  // TODO: Navigate to my uploads
                },
              ),
            ),
            const SizedBox(height: 10),
            Card(
              elevation: 4,
              child: ListTile(
                leading: const Icon(Icons.people),
                title: const Text('Followers / Following'),
                onTap: () {
                  // TODO: Navigate to follow page
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
