import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class UserProfileScreen extends StatelessWidget {
  const UserProfileScreen({super.key});

  // Fetch user data
  Future<DocumentSnapshot> _getUserData() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      return await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
    }
    throw Exception('User not authenticated');
  }

  // Fetch purchased content for a user
  Future<Map<String, List<Map<String, dynamic>>>> _getPurchasedContent() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final snapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .collection('purchasedContent')
          .get();

      final Map<String, List<Map<String, dynamic>>> categorizedContent = {
        'epubs': [],
        'books': [],
        'arts': [],
        'videos': [],
      };

      for (var doc in snapshot.docs) {
        final content = doc.data();
        final contentType = content['type'] as String;

        if (contentType == 'epub') {
          categorizedContent['epubs']!.add(content);
        } else if (contentType == 'book') {
          categorizedContent['books']!.add(content);
        } else if (contentType == 'art') {
          categorizedContent['arts']!.add(content);
        } else if (contentType == 'video') {
          categorizedContent['videos']!.add(content);
        }
      }

      return categorizedContent;
    }
    throw Exception('User not authenticated');
  }

  // Fetch uploaded content for a user
  Future<Map<String, List<Map<String, dynamic>>>> _getMyUploads() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final snapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .collection('myUploads')
          .get();

      final Map<String, List<Map<String, dynamic>>> categorizedUploads = {
        'epubs': [],
        'books': [],
        'arts': [],
        'videos': [],
      };

      for (var doc in snapshot.docs) {
        final upload = doc.data();
        final uploadType = upload['type'] as String;

        if (uploadType == 'epub') {
          categorizedUploads['epubs']!.add(upload);
        } else if (uploadType == 'book') {
          categorizedUploads['books']!.add(upload);
        } else if (uploadType == 'art') {
          categorizedUploads['arts']!.add(upload);
        } else if (uploadType == 'video') {
          categorizedUploads['videos']!.add(upload);
        }
      }

      return categorizedUploads;
    }
    throw Exception('User not authenticated');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Profile'),
        backgroundColor: const Color(0xFF0C1C30),
        foregroundColor: Colors.white,
      ),
      backgroundColor: const Color(0xFFF8F8F8),
      body: FutureBuilder<DocumentSnapshot>(
        future: _getUserData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (!snapshot.hasData || !snapshot.data!.exists) {
            return const Center(child: Text('No user data found'));
          }

          final userData = snapshot.data!.data() as Map<String, dynamic>;
          final firstName = userData['firstName'] ?? 'John';
          final lastName = userData['lastName'] ?? 'Doe';
          final photoUrl = userData['photoUrl'] ?? 'assets/images/profile_placeholder.png';
          final followers = userData['followers']?.toString() ?? '0';
          final following = userData['following']?.toString() ?? '0';

          return FutureBuilder<Map<String, List<Map<String, dynamic>>>>(
            future: Future.wait([
              _getPurchasedContent(),
              _getMyUploads(),
            ]).then((results) => {
                  'purchasedContent': results[0]!,
                  'myUploads': results[1]!,
                }),
            builder: (context, contentSnapshot) {
              if (contentSnapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              if (contentSnapshot.hasError) {
                return Center(child: Text('Error: ${contentSnapshot.error}'));
              }

              final purchasedContent = contentSnapshot.data!['purchasedContent'];
              final myUploads = contentSnapshot.data!['myUploads'];

              return SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    _profileHeader(firstName, lastName, photoUrl, followers, following),
                    const SizedBox(height: 24),
                    _sectionTitle('Purchased Content'),
                    _contentCategoryList(purchasedContent),
                    const SizedBox(height: 24),
                    _sectionTitle('My Uploads'),
                    _contentCategoryList(myUploads),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }

  Widget _profileHeader(String firstName, String lastName, String photoUrl, String followers, String following) {
    return Column(
      children: [
        CircleAvatar(
          radius: 48,
          backgroundImage: NetworkImage(photoUrl),
        ),
        const SizedBox(height: 12),
        Text(
          '$firstName $lastName',
          style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 4),
        const Text(
          'Content Creator | Reader | Artist',
          style: TextStyle(color: Colors.grey),
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _statColumn('Followers', followers),
            const SizedBox(width: 32),
            _statColumn('Following', following),
          ],
        ),
      ],
    );
  }

  static const TextStyle _statStyle = TextStyle(fontSize: 16, fontWeight: FontWeight.bold);

  static const TextStyle _labelStyle = TextStyle(color: Colors.grey);

  static Widget _statColumn(String label, String count) {
    return Column(
      children: [
        Text(count, style: _statStyle),
        Text(label, style: _labelStyle),
      ],
    );
  }

  Widget _sectionTitle(String title) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        title,
        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _contentCategoryList(Map<String, List<Map<String, dynamic>>> content) {
    return Column(
      children: [
        _categoryButton('All', content),
        _categoryButton('Ebooks', content['epubs'] ?? []),
        _categoryButton('Books', content['books'] ?? []),
        _categoryButton('Arts', content['arts'] ?? []),
        _categoryButton('Videos', content['videos'] ?? []),
      ],
    );
  }

  Widget _categoryButton(String title, List<Map<String, dynamic>> categoryContent) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          categoryContent.isEmpty
              ? const Text('No content available')
              : Column(
                  children: categoryContent.map((item) {
                    return Container(
                      margin: const EdgeInsets.symmetric(vertical: 4),
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.file_copy, color: Color(0xFF0C1C30)),
                          const SizedBox(width: 12),
                          Expanded(child: Text(item['title'])),
                          const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
                        ],
                      ),
                    );
                  }).toList(),
                ),
        ],
      ),
    );
  }
}
