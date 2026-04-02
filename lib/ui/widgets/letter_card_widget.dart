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

  bool get isLocked => DateTime.now().isBefore(widget.letter.openingDate);

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

  Widget iconContainer() {
    return Container(
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
    );
  }

  Widget response() {
    return Row(
      children: <Widget>[
        Icon(Icons.reply, size: 10, color: Theme.of(context).hintColor),
        const SizedBox(width: 4),
        Text(
          'RESPOSTA',
          style: TextStyle(
            color: Theme.of(context).hintColor,
            fontSize: 10,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget title() {
    return Expanded(
      child: Text(
        widget.letter.title,
        maxLines: 3,
        overflow: TextOverflow.ellipsis,
        style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget countDate() {
    return Column(
      children: <Widget>[
        Text(
          isLocked ? "Disponível em:" : "Liberada em:",
          style: TextStyle(color: Theme.of(context).hintColor, fontSize: 11),
        ),
        Text(
          formatDate(widget.letter.openingDate),
          style: TextStyle(
            color: isLocked
                ? Theme.of(context).hintColor
                : Theme.of(context).colorScheme.primary,
            fontWeight: FontWeight.w600,
            fontSize: 13,
          ),
        ),
      ],
    );
  }

  Widget iconsMedia() {
    return Row(
      children: <Widget>[
        if (widget.letter.audioUrl != null)
          Icon(
            Icons.audiotrack_rounded,
            size: 24,
            color: isLocked
                ? Theme.of(context).hintColor
                : Theme.of(context).colorScheme.primary,
          ),
        if (widget.letter.imageUrls.isNotEmpty)
          Icon(
            Icons.image_rounded,
            size: 24,
            color: isLocked
                ? Theme.of(context).hintColor
                : Theme.of(context).colorScheme.primary,
          ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isLocked
            ? Theme.of(context).canvasColor
            : Theme.of(context).cardColor,
        borderRadius: DefaultBorders.card,
        border: Border.all(color: Theme.of(context).dividerColor),
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
              iconContainer(),
              if (widget.letter.parentId != null) response(),
            ],
          ),
          const SizedBox(height: 12),
          title(),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              countDate(),
              const SizedBox(height: 8),
              iconsMedia(),
            ],
          ),
          const SizedBox(height: 12),
          AppButton(
            text: isLocked
                ? "Faltam ${getCountdownText(widget.letter.openingDate)}"
                : "Abrir carta",
            icon: isLocked ? Icons.timer_outlined : Icons.visibility,
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
