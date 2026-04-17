import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../models/user.dart';
import 'firebase_service.dart';

class UserService {
  final FirebaseFirestore _firestore = FirebaseService.firestore;
  final FirebaseAuth _auth = FirebaseService.auth;

  Future<AppUser> getUserData() async {
    final User? user = _auth.currentUser;
    if (user == null) {
      throw Exception('Usuário não autenticado');
    }
    final DocumentSnapshot<Map<String, dynamic>> doc = await _firestore
        .collection('users')
        .doc(user.uid)
        .get();
    if (!doc.exists) {
      throw Exception('Usuário não encontrado');
    }
    return AppUser.fromMap(doc.data()!, user.email ?? '');
  }

  Future<void> updateUserName(String name) async {
    final User? user = _auth.currentUser;
    if (user == null) {
      throw Exception('Usuário não autenticado');
    }

    await user.updateDisplayName(name.trim());

    await _firestore.collection('users').doc(user.uid).update(<Object, Object?>{
      'name': name.trim(),
    });
  }
}
