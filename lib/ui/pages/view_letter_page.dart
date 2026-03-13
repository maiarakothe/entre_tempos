import 'package:entre_tempos/core/Colors.dart';
import 'package:entre_tempos/core/utils.dart';
import 'package:entre_tempos/ui/widgets/page_card_layout.dart';
import 'package:flutter/material.dart';

import '../../data/models/letter.dart';
import 'new_letter_page.dart';

class ViewLetterPage extends StatefulWidget {
  const ViewLetterPage({
    super.key,
    required this.letter,
    required this.allLetters,
  });

  @override
  State<ViewLetterPage> createState() => _ViewLetterPageState();
  final Letter letter;
  final List<Letter> allLetters;
}

class _ViewLetterPageState extends State<ViewLetterPage> {
  Letter? originalLetter;

  bool get isMobile => MediaQuery.of(context).size.width < kMobileWidth;

  Widget headerSection() {
    return Column(
      children: <Widget>[
        if (originalLetter != null)
          Padding(
            padding: const EdgeInsets.only(bottom: 16.0),
            child: InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute<dynamic>(
                    builder: (BuildContext context) => ViewLetterPage(
                      letter: originalLetter!,
                      allLetters: widget.allLetters,
                    ),
                  ),
                );
              },
              child: Row(
                children: <Widget>[
                  const Icon(
                    Icons.reply,
                    size: 16,
                    color: DefaultColors.primary,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Resposta para: ${originalLetter!.title}',
                    style: const TextStyle(
                      color: DefaultColors.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),
        Text(
          widget.letter.title,
          style: Theme.of(
            context,
          ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget dateSection() {
    return Row(
      children: <Widget>[
        Icon(
          Icons.calendar_today_outlined,
          color: DefaultColors.textSecondary,
          size: 16,
        ),
        SizedBox(width: 4),
        Text(
          'Escrita em ${formatDate(widget.letter.creationDate)}',
          style: TextStyle(color: DefaultColors.textSecondary, fontSize: 14),
          textAlign: TextAlign.center,
        ),
        Spacer(),
        Icon(
          Icons.access_time_rounded,
          color: DefaultColors.textSecondary,
          size: 16,
        ),
        SizedBox(width: 4),
        Text(
          'Aberta em ${formatDate(widget.letter.openingDate)}',
          style: TextStyle(color: DefaultColors.textSecondary, fontSize: 14),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget replyButton() {
    return Container(
      decoration: BoxDecoration(
        gradient: DefaultColors.colorTest,
        borderRadius: DefaultBorders.button,
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: DefaultColors.primary.withValues(alpha: 0.3),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ElevatedButton.icon(
        icon: const Icon(Icons.reply, color: Colors.white),
        label: const Text(
          'Responder essa carta',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: DefaultBorders.button,
          ),
        ),
        onPressed: () async {
          Letter? newLetter = await Navigator.push(
            context,
            MaterialPageRoute<Letter>(
              builder: (_) => NewLetterPage(parentId: widget.letter.id),
            ),
          );
          if (newLetter != null) {
            Navigator.pop(context, newLetter);
          }
        },
      ),
    );
  }

  Widget letterContent() {
    try {
      if (widget.letter.parentId != null) {
        originalLetter = widget.allLetters.firstWhere(
          (Letter l) => l.id == widget.letter.parentId,
        );
      }
    } catch (e) {
      print('Carta pai não encontrada');
    }

    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 800),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          headerSection(),
          const SizedBox(height: 20),
          dateSection(),
          const SizedBox(height: 20),
          Divider(color: DefaultColors.textSecondary.withValues(alpha: 0.1)),
          const SizedBox(height: 10),
          Text(
            widget.letter.content,
            style: const TextStyle(fontSize: 16, height: 1.5),
          ),
          const SizedBox(height: 32),
          replyButton(),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: DefaultColors.text),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: PageCardLayout(
        child: letterContent(),
      ),
    );
  }
}
