import 'package:entre_tempos/ui/pages/new_letter_page.dart';
import 'package:entre_tempos/ui/pages/view_letter_page.dart';
import 'package:flutter/material.dart';

import '../../data/models/letter.dart';

class LetterPage extends StatefulWidget {
  const LetterPage({super.key});

  @override
  State<LetterPage> createState() => _LetterPageState();
}

class _LetterPageState extends State<LetterPage> {
  List<Letter> letters = [];

  Widget Letters() {
    if (letters.isEmpty) {
      return Text('Nenhuma carta');
    } else {
      return ListView.builder(
        itemBuilder: (context, index) {
          final letter = letters[index];
          DateTime now = DateTime.now();
          bool isLocked = now.isBefore(letter.openingDate);
          return GestureDetector(
            onTap: () async {
              if (isLocked) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Carta bloqueada')),
                );
              } else {
                final Letter? result = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ViewLetterPage(letter: letter),
                  ),
                );

                if (result != null) {
                  setState(() {
                    letters.add(result);
                  });
                }
              }
            },
            child: Card(
              child: Column(
                children: [
                  Text(letter.title),
                  Text(letter.openingDate.toString()),
                  Text(isLocked ? 'Bloqueada' : 'Disponível'),
                ],
              ),
            ),
          );
        },
        itemCount: letters.length,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(10),
            child: Row(
              children: [
                Text('Minhas Cartas', style: TextStyle(fontSize: 18)),
                Spacer(),
                ElevatedButton(
                  onPressed: () async {
                    Letter? result = await Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => NewLetterPage()),
                    );
                    if (result != null) {
                      setState(() {
                        letters.add(result);
                      });
                    }
                  },
                  child: Text('Nova carta'),
                ),
              ],
            ),
          ),
          Expanded(child: Letters()),
        ],
      ),
    );
  }
}
