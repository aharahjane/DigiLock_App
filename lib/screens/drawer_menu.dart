import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: const Color(0xFF0C1C30),
      child: FutureBuilder<User?>(
        future: FirebaseAuth.instance.authStateChanges().first,  // Get the current user
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final user = snapshot.data;
          String userName = user?.displayName ?? 'User';  // Default to "User" if no display name

          return ListView(
            padding: EdgeInsets.zero,
            children: [
              // Drawer Header with the app name "DigiLock"
              const DrawerHeader(
                decoration: BoxDecoration(
                  color: Color(0xFF0C1C30),
                ),
                child: Center(
                  child: Text(
                    'DigiLock',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              // Greeting text with dynamic name
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                child: Text(
                  'Hi $userName!',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 24,  // Increased font size for better visibility
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              // Menu Items
              ListTile(
                leading: const Icon(Icons.person, color: Colors.white),
                title: const Text('Personal Info', style: TextStyle(color: Colors.white)),
                onTap: () {
                  Navigator.pushReplacementNamed(context, '/personal_info');
                },
              ),
              ListTile(
                leading: const Icon(Icons.notifications, color: Colors.white),
                title: const Text('Notifications', style: TextStyle(color: Colors.white)),
                onTap: () {
                  Navigator.pushReplacementNamed(context, '/notifications');
                },
              ),
              ListTile(
                leading: const Icon(Icons.security, color: Colors.white),
                title: const Text('Security', style: TextStyle(color: Colors.white)),
                onTap: () {
                  Navigator.pushReplacementNamed(context, '/security');
                },
              ),
              ListTile(
                leading: const Icon(Icons.upload_file, color: Colors.white),
                title: const Text('Upload My Work', style: TextStyle(color: Colors.white)),
                onTap: () {
                  Navigator.pushReplacementNamed(context, '/upload_my_work');
                },
              ),
              ListTile(
                leading: const Icon(Icons.info, color: Colors.white),
                title: const Text('About DigiLock', style: TextStyle(color: Colors.white)),
                onTap: () {
                  Navigator.pushReplacementNamed(context, '/about_digilock');
                },
              ),
              ListTile(
                leading: const Icon(Icons.bar_chart, color: Colors.white),
                title: const Text('Reports', style: TextStyle(color: Colors.white)),
                onTap: () {
                  Navigator.pushReplacementNamed(context, '/reports');
                },
              ),
              const Divider(color: Colors.white54),
              ListTile(
                leading: const Icon(Icons.logout, color: Colors.white),
                title: const Text('Logout', style: TextStyle(color: Colors.white)),
                onTap: () async {
                  await FirebaseAuth.instance.signOut();
                  Navigator.pushReplacementNamed(context, '/login');
                },
              ),
            ],
          );
        },
      ),
    );
  }
}
