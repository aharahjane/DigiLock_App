import 'package:cloud_firestore/cloud_firestore.dart';

class UploadModel {
  final String title;
  final String author;
  final String description;
  final DateTime dateCompleted;
  final String url;
  final String category;
  final String userId; // NEW

  UploadModel({
    required this.title,
    required this.author,
    required this.description,
    required this.dateCompleted,
    required this.url,
    required this.category,
    required this.userId, // NEW
  });

  factory UploadModel.fromFirestore(Map<String, dynamic> data) {
    return UploadModel(
      title: data['title'] ?? '',
      author: data['author'] ?? '',
      description: data['description'] ?? '',
      dateCompleted: (data['dateCompleted'] as Timestamp).toDate(),
      url: data['fileUrl'] ?? '', // use 'fileUrl' from Firestore but assign to 'url'
      category: data['category'] ?? '',
      userId: data['userId'] ?? '',
    );
  }
}