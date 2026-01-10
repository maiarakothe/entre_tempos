import 'package:entre_tempos/ui/pages/reply_letter_page.dart';
import 'package:flutter/material.dart';

import '../../data/models/letter.dart';

class ViewLetterPage extends StatefulWidget {
  const ViewLetterPage({super.key, required this.letter});

  @override
  State<ViewLetterPage> createState() => _ViewLetterPageState();
  final Letter letter;
}

class _ViewLetterPageState extends State<ViewLetterPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Card(
          child: Column(
            children: [
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
