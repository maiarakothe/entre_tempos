import 'package:flutter/cupertino.dart';

const double kMobileWidth = 700;

class DefaultBorders {
  static const BorderRadius card = BorderRadius.all(Radius.circular(28));
  static const BorderRadius button = BorderRadius.all(Radius.circular(16));
  static const BorderRadius container = BorderRadius.all(Radius.circular(12));
}

String formatDate(DateTime d) {
  return '${d.day.toString().padLeft(2, '0')}/'
      '${d.month.toString().padLeft(2, '0')}/'
      '${d.year}';
}