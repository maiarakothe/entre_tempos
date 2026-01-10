import 'dart:core';

class Letter {
  late String id;
  late String title;
  late String content;
  late DateTime creationDate;
  late DateTime openingDate;

  Letter({
    required this.id,
    required this.title,
    required this.content,
    required this.creationDate,
    required this.openingDate,
  });
}
