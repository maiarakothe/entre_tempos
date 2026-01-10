import 'package:entre_tempos/ui/pages/reply_letter_page.dart';
import 'package:flutter/material.dart';

import '../../data/models/letter.dart';

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

  @override
  Widget build(BuildContext context) {
    if (widget.letter.parentId != null) {
      originalLetter = widget.allLetters.firstWhere(
        (l) => l.id == widget.letter.parentId,
      );
    }

    return Scaffold(
      body: Center(
        child: Card(
          child: Column(
            children: [
              if (originalLetter != null)
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ViewLetterPage(
                          letter: originalLetter!,
                          allLetters: widget.allLetters,
                        ),
                      ),
                    );
                  },
                  child: Text(
                    'Resposta para: ${originalLetter!.title}',
                    style: TextStyle(color: Colors.blue),
                  ),
                ),
              Text(widget.letter.title),
              Text(widget.letter.content),
              Text(widget.letter.creationDate.toString()),
              ElevatedButton(
                onPressed: () async {
                  Letter? newLetter = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          ReplyLetterPage(originalLetter: widget.letter),
                    ),
                  );
                  if (newLetter != null) {
                    Navigator.pop(context, newLetter);
                  }
                },
                child: Text('Responder essa carta'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
