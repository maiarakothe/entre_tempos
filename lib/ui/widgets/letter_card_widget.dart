import 'dart:async';

import 'package:flutter/material.dart';

import '../../core/default_colors.dart';
import '../../core/utils.dart';
import '../../data/models/letter.dart';
import 'app_button.dart';

class LetterCardWidget extends StatefulWidget {
  final Letter letter;
  final VoidCallback onOpen;

  const LetterCardWidget({
    super.key,
    required this.letter,
    required this.onOpen,
  });

  @override
  State<LetterCardWidget> createState() => _LetterCardWidgetState();
}

class _LetterCardWidgetState extends State<LetterCardWidget> {
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 1), (Timer timer) {
      if (mounted) {
        setState(() {});
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bool isLocked = DateTime.now().isBefore(widget.letter.openingDate);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isLocked ? Colors.white70 : DefaultColors.cardLight,
        borderRadius: DefaultBorders.card,
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: <BoxShadow>[
          BoxShadow(
            blurRadius: 20,
            color: DefaultColors.textSecondary.withValues(alpha: 0.1),
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  borderRadius: DefaultBorders.container,
                  color: isLocked
                      ? DefaultColors.error.withValues(alpha: 0.1)
                      : DefaultColors.success.withValues(alpha: 0.1),
                  shape: BoxShape.rectangle,
                ),
                child: Icon(
                  isLocked ? Icons.lock_clock_rounded : Icons.mark_email_read,
                  color: isLocked ? DefaultColors.error : DefaultColors.success,
                  size: 18,
                ),
              ),
              if (widget.letter.parentId != null)
                Row(
                  children: <Widget>[
                    Icon(
                      Icons.reply,
                      size: 10,
                      color: DefaultColors.textSecondary,
                    ),
                    const SizedBox(width: 4),
                    const Text(
                      'RESPOSTA',
                      style: TextStyle(
                        color: DefaultColors.textSecondary,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
            ],
          ),
          const SizedBox(height: 12),
          Expanded(
            child: Text(
              widget.letter.title,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.bold,
                color: DefaultColors.text,
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            isLocked ? "Disponível em:" : "Liberada em:",
            style: TextStyle(color: DefaultColors.textSecondary, fontSize: 11),
          ),
          Text(
            formatDate(widget.letter.openingDate),
            style: TextStyle(
              color: isLocked
                  ? DefaultColors.textSecondary
                  : DefaultColors.primary,
              fontWeight: FontWeight.w600,
              fontSize: 13,
            ),
          ),
          const SizedBox(height: 12),
          AppButton(
            text: isLocked
                ? "Faltam ${getCountdownText(widget.letter.openingDate)}"
                : "Abrir carta",
            icon: isLocked ? Icons.lock : Icons.visibility,
            onPressed: widget.onOpen,
            disabled: isLocked,
            fontSize: 14,
            height: 40,
          ),
        ],
      ),
    );
  }
}
