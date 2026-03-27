import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../models/letter.dart';
import 'firebase_service.dart';

class LetterService {
  final FirebaseFirestore _firestore = FirebaseService.firestore;
  final FirebaseAuth _auth = FirebaseService.auth;

  Future<void> createLetter(Letter letter) async {
    final User? user = _auth.currentUser;
    if (user == null) {
      throw Exception('Usuário não logado');
    }
    await _firestore.collection('letters').add(letter.toMap());
  }

  Stream<List<Letter>> getLetters() {
    final User? user = _auth.currentUser;
    if (user == null) {
      return const Stream<List<Letter>>.empty();
    }
    return _firestore
        .collection('letters')
        .where('userId', isEqualTo: user.uid)
        .orderBy('creationDate', descending: true)
        .snapshots()
        .map((QuerySnapshot<Map<String, dynamic>> snapshot) {
          return snapshot.docs.map((
            QueryDocumentSnapshot<Map<String, dynamic>> doc,
          ) {
            return Letter.fromMap(doc.data(), doc.id);
          }).toList();
        });
  }

  Future<Letter?> getLetterById(String id) async {
    final DocumentSnapshot<Map<String, dynamic>> doc = await _firestore
        .collection('letters')
        .doc(id)
        .get();
    if (!doc.exists) {
      return null;
    }
    return Letter.fromMap(doc.data()!, doc.id);
  }
}
