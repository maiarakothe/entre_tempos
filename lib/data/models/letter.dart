import 'dart:core';

class Letter {
  String id;
  String title;
  String content;
  DateTime creationDate;
  DateTime openingDate;
  String? parentId;

  Letter({
    required this.id,
    required this.title,
    required this.content,
    required this.creationDate,
    required this.openingDate,
    this.parentId,
  });
}
