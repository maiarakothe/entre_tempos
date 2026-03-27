import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'firebase_service.dart';

class AuthService {
  final FirebaseFirestore _firestore = FirebaseService.firestore;
  final FirebaseAuth _auth = FirebaseService.auth;

  Future<User?> register({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      final UserCredential result = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      final User? user = result.user;
      if (user == null) {
        return null;
      }
      await user.updateDisplayName(name);
      await _firestore.collection('users').doc(user.uid).set(<String, dynamic>{
        'uid': user.uid,
        'name': name,
        'email': email,
        'createdAt': FieldValue.serverTimestamp(),
      });
      return user;
    } on FirebaseAuthException {
      rethrow;
    }
  }

  Future<User?> login({required String email, required String password}) async {
    try {
      final UserCredential result = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return result.user;
    } on FirebaseAuthException {
      rethrow;
    }
  }

  Future<void> resetPassword(String email) async {
    await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
  }
}
