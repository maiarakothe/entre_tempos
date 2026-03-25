import 'package:flutter/material.dart';

import 'default_colors.dart';

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

void showSnackBar(
  BuildContext context, {
  required String message,
  Color? color,
}) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(message),
      backgroundColor: color ?? DefaultColors.info,
      behavior: SnackBarBehavior.floating,
      margin: const EdgeInsets.all(16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      duration: const Duration(seconds: 3),
    ),
  );
}

void showError(BuildContext context, String message) {
  showSnackBar(context, message: message, color: DefaultColors.error);
}

void showSuccess(BuildContext context, String message) {
  showSnackBar(context, message: message, color: DefaultColors.success);
}
