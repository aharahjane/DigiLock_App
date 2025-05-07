import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';

class UploadLandingScreen extends StatefulWidget {
  final String author;
  final String price;
  final String description;
  final DateTime creationDate;
  final File certificateFile;

  const UploadLandingScreen({
    super.key,
    required this.author,
    required this.price,
    required this.description,
    required this.creationDate,
    required this.certificateFile,
  });

  @override
  State<UploadLandingScreen> createState() => _UploadLandingScreenState();
}

class _UploadLandingScreenState extends State<UploadLandingScreen> {
  bool _isUploading = true;
  String? _statusMessage;

  @override
  void initState() {
    super.initState();
    _uploadData();
  }

  Future<void> _uploadData() async {
    try {
      // 1. Upload file to Firebase Storage
      final fileName = 'certificates/${DateTime.now().millisecondsSinceEpoch}_${widget.author}.pdf';
      final storageRef = FirebaseStorage.instance.ref().child(fileName);
      await storageRef.putFile(widget.certificateFile);
      final downloadURL = await storageRef.getDownloadURL();

      // 2. Save metadata to Firestore
      await FirebaseFirestore.instance.collection('uploadedWorks').add({
        'author': widget.author,
        'price': widget.price,
        'description': widget.description,
        'creationDate': widget.creationDate,
        'certificateUrl': downloadURL,
        'uploadedAt': Timestamp.now(),
      });

      setState(() {
        _isUploading = false;
        _statusMessage = 'Upload successful!';
      });
    } catch (e) {
      setState(() {
        _isUploading = false;
        _statusMessage = 'Error during upload: $e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0C1C30),
      body: Center(
        child: _isUploading
            ? const CircularProgressIndicator(color: Colors.white)
            : Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      _statusMessage == 'Upload successful!' ? Icons.check_circle : Icons.error,
                      size: 80,
                      color: _statusMessage == 'Upload successful!' ? Colors.green : Colors.red,
                    ),
                    const SizedBox(height: 20),
                    Text(
                      _statusMessage ?? '',
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: Colors.white, fontSize: 18),
                    ),
                    const SizedBox(height: 30),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: const Color(0xFF0C1C30),
                      ),
                      onPressed: () => Navigator.pop(context),
                      child: const Text("Back"),
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}
