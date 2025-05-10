import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class UserProfileScreen extends StatefulWidget {
  const UserProfileScreen({Key? key}) : super(key: key);

  @override
  _UserProfileScreenState createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  String? photoUrl;
  String? fullName;
  String? bio;
  String? joinedDate;
  String? userId;

  bool isEditing = false;
  TextEditingController bioController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchUserProfile();
  }

  Future<void> fetchUserProfile() async {
    final user = _auth.currentUser;
    if (user != null) {
      final doc = await _firestore.collection('users').doc(user.uid).get();
      final data = doc.data();

      setState(() {
        photoUrl = data?['photoUrl'] ?? '';
        fullName = '${data?['firstName'] ?? ''} ${data?['lastName'] ?? ''}';
        bio = data?['bio'] ?? '';
        joinedDate = (data?['createdAt'] as Timestamp?)?.toDate().toString().split(' ')[0];
        userId = user.uid;
        bioController.text = bio!;
      });
    }
  }

  Future<void> updateBio() async {
    await _firestore.collection('users').doc(userId).update({
      'bio': bioController.text,
    });
    setState(() {
      bio = bioController.text;
      isEditing = false;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Bio updated successfully')),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (userId == null) {
      return const Center(child: CircularProgressIndicator());
    }

    return Scaffold(
      appBar: AppBar(title: const Text("My Profile")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Profile Picture
            CircleAvatar(
              radius: 50,
              backgroundImage: photoUrl != null && photoUrl!.isNotEmpty
                  ? NetworkImage(photoUrl!)
                  : const AssetImage('assets/default_avatar.jpg') as ImageProvider,
            ),
            const SizedBox(height: 12),

            // Full Name
            Text(fullName ?? '', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            Text("Joined: $joinedDate", style: const TextStyle(fontSize: 12, color: Colors.grey)),
            const SizedBox(height: 20),

            // Bio with Edit/Save
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Bio:', style: TextStyle(fontWeight: FontWeight.bold)),
                TextButton(
                  onPressed: () {
                    if (isEditing) {
                      updateBio();
                    } else {
                      setState(() => isEditing = true);
                    }
                  },
                  child: Text(isEditing ? 'Save Bio' : 'Edit Bio'),
                ),
              ],
            ),
            isEditing
                ? TextField(
                    controller: bioController,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                    ),
                    maxLines: 3,
                  )
                : Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      bio?.isEmpty ?? true ? 'No bio yet.' : bio!,
                      style: const TextStyle(fontSize: 14),
                    ),
                  ),
            const SizedBox(height: 30),

            const Divider(),
            const Text("Your Uploads", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),

            // Uploaded Content
            StreamBuilder<QuerySnapshot>(
              stream: _firestore
                  .collection('uploads')
                  .where('userId', isEqualTo: userId)
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) return const CircularProgressIndicator();
                final uploads = snapshot.data!.docs;

                if (uploads.isEmpty) return const Text("No uploads yet.");

                return ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: uploads.length,
                  itemBuilder: (context, index) {
                    final data = uploads[index].data() as Map<String, dynamic>;
                    return Card(
                      child: ListTile(
                        title: Text(data['title'] ?? ''),
                        subtitle: Text(data['description'] ?? ''),
                        trailing: Text(data['category'] ?? ''),
                      ),
                    );
                  },
                );
              },
            )
          ],
        ),
      ),
    );
  }
}