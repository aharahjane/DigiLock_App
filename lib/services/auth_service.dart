import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_model.dart'; // Make sure this file exists

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // ✅ Listen to changes in auth state (ex: login/logout)
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  // ✅ Sign up with email and password
  Future<UserCredential> signUpWithEmail({
    required String email,
    required String password,
  }) async {
    final userCredential = await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

    final user = userCredential.user;

    // ✅ Add user data to Firestore
    if (user != null) {
      final newUser = AppUser(uid: user.uid, email: email);
      await _firestore.collection('users').doc(user.uid).set(newUser.toMap());
    }

    return userCredential;
  }

  // ✅ Sign in with email and password
  Future<UserCredential> signInWithEmail({
    required String email,
    required String password,
  }) async {
    return await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  // ✅ Sign out current user
  Future<void> signOut() async {
    await _auth.signOut();
  }

  // ✅ Get currently signed-in user
  User? getCurrentUser() {
    return _auth.currentUser;
  }

  // ✅ Get current user's UID
  String? getCurrentUserId() {
    return _auth.currentUser?.uid;
  }
}
