import 'dart:core';

import 'package:cloud_firestore/cloud_firestore.dart';

class Letter {
  String id;
  String title;
  String content;
  DateTime creationDate;
  DateTime openingDate;
  String? parentId;
  String userId;

  Letter({
    required this.id,
    required this.title,
    required this.content,
    required this.creationDate,
    required this.openingDate,
    required this.userId,
    this.parentId,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'userId': userId,
      'title': title,
      'content': content,
      'creationDate': Timestamp.fromDate(creationDate),
      'openingDate': Timestamp.fromDate(openingDate),
      'parentId': parentId,
    };
  }

  factory Letter.fromMap(Map<String, dynamic> data, String id) {
    return Letter(
      id: id,
      title: data['title'],
      content: data['content'],
      creationDate: (data['creationDate'] as Timestamp).toDate(),
      openingDate: (data['openingDate'] as Timestamp).toDate(),
      parentId: data['parentId'],
      userId: data['userId'],
    );
  }
}
