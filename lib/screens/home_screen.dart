import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // Import Firestore
import 'package:flutter/material.dart';
import 'login_screen.dart'; // Import the LoginScreen

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  Future<bool> isAdmin(String? email) async {
    // Check if the user is an admin by checking Firestore
    if (email == null) return false;

    try {
      final userDoc =
          await FirebaseFirestore.instance.collection('users').doc(email).get();
      if (userDoc.exists) {
        final userData = userDoc.data();
        return userData?['role'] ==
            'admin'; // Assuming 'role' field holds the value 'admin' or 'user'
      }
    } catch (e) {
      print("Error checking admin: $e");
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    final userEmail = FirebaseAuth.instance.currentUser?.email;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Screen'),
        backgroundColor: const Color(0xFF0C1C30),
      ),
      body: FutureBuilder<bool>(
        future: isAdmin(userEmail),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          // If the user is an admin, navigate to the AdminPanelScreen
          if (snapshot.data == true) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Welcome, Admin!',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      // Navigate to the admin panel screen
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const AdminPanelScreen(),
                        ),
                      );
                    },
                    child: const Text('Go to Admin Panel'),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () async {
                      // Sign out logic
                      await FirebaseAuth.instance.signOut();
                      // After signing out, navigate to the login screen
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(
                          builder: (context) => const LoginScreen(),
                        ),
                      );
                    },
                    child: const Text('Logout'),
                  ),
                ],
              ),
            );
          } else {
            // If the user is not an admin, show a regular home screen
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Welcome to DigiLock!',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'Logged in as: ${userEmail ?? 'Unknown'}',
                    style: const TextStyle(fontSize: 18),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () async {
                      // Sign out logic
                      await FirebaseAuth.instance.signOut();
                      // After signing out, navigate to the login screen
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(
                          builder: (context) => const LoginScreen(),
                        ),
                      );
                    },
                    child: const Text('Logout'),
                  ),
                ],
              ),
            );
          }
        },
      ),
    );
  }
}

// Admin Panel Screen (for demonstration purposes)
class AdminPanelScreen extends StatelessWidget {
  const AdminPanelScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Panel'),
        backgroundColor: const Color(0xFF0C1C30),
      ),
      body: const Center(
        child: Text(
          'Welcome to the Admin Panel!',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}
