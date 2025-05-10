// lib/screens/import_screen.dart
import 'dart:io'; // ← add this
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ImportScreen extends StatefulWidget {
  final PlatformFile uploadedFile;
  final String author;
  final String price;
  final String description;
  final DateTime creationDate;
  final String contentType;

  const ImportScreen({
    super.key,
    required this.uploadedFile,
    required this.author,
    required this.price,
    required this.description,
    required this.creationDate,
    required this.contentType,
  });

  @override
  State<ImportScreen> createState() => _ImportScreenState();
}

class _ImportScreenState extends State<ImportScreen> {
  bool isAgreed = false;
  bool _isUploading = false;

  Future<void> _handleUpload() async {
    setState(() => _isUploading = true);

    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) throw 'User not logged in';

      final uid = user.uid;
      final fileName = widget.uploadedFile.name;
      final storagePath = 'uploads/$uid/$fileName';
      final ref = FirebaseStorage.instance.ref().child(storagePath);

      UploadTask uploadTask;
      // if bytes are available, use them; otherwise fall back to file path
      if (widget.uploadedFile.bytes != null) {
        uploadTask = ref.putData(widget.uploadedFile.bytes!);
      } else if (widget.uploadedFile.path != null) {
        final file = File(widget.uploadedFile.path!);
        uploadTask = ref.putFile(file);
      } else {
        throw 'Cannot read file data';
      }

      // wait for upload and get URL
      final snapshot = await uploadTask.whenComplete(() {});
      final fileUrl = await snapshot.ref.getDownloadURL();

      // write metadata to Firestore
      await FirebaseFirestore.instance.collection('uploads').add({
        'userId': uid,
        'author': widget.author,
        'price': widget.price,
        'description': widget.description,
        'creationDate': widget.creationDate.toIso8601String(),
        'contentType': widget.contentType,
        'fileUrl': fileUrl,
        'uploadedAt': Timestamp.now(),
      });

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Upload successful!')));
      Navigator.popUntil(context, (route) => route.isFirst);
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Upload failed: $e')));
    } finally {
      setState(() => _isUploading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0C1C30),
      appBar: AppBar(
        title: const Text("DigiLock"),
        backgroundColor: const Color(0xFF0C1C30),
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: Center(
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                height: 300,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFFE9EBF2),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Text(
                  '• Please review and agree to the terms and conditions before uploading your content.',
                  style: TextStyle(color: Color(0xFF0C1C30)),
                ),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Checkbox(
                    value: isAgreed,
                    onChanged: (v) => setState(() => isAgreed = v ?? false),
                    activeColor: Colors.green,
                  ),
                  const Expanded(
                    child: Text(
                      "I Agree to the Terms and Conditions",
                      style: TextStyle(
                        color: Color(0xFF0C1C30),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: isAgreed && !_isUploading ? _handleUpload : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF0C1C30),
                  foregroundColor: Colors.white,
                  minimumSize: const Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child:
                    _isUploading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text(
                          "UPLOAD NOW!",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
