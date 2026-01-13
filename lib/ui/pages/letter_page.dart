import 'package:entre_tempos/core/utils.dart';
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
  List<Letter> letters = <Letter>[];

  Widget Header() {
    return AppBar(
      title: Text('entreTempos'),
      backgroundColor: Colors.white60,
      actions: <Widget>[
        TextButton.icon(
          onPressed: () {},
          label: const Text(
            'Minhas Cartas',
            style: TextStyle(color: Colors.black, fontSize: 18),
          ),
        ),
        TextButton.icon(
          onPressed: () {},
          icon: const Icon(Icons.person, color: Colors.black),
          label: const Text(
            'Conta',
            style: TextStyle(color: Colors.black, fontSize: 18),
          ),
        ),
      ],
    );
  }

  Widget slogan() {
    return Container(
      height: 100,
      width: 800,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: <Widget>[
          SizedBox(height: 10),
          Text('Escreva hoje. Leia amanhã.', style: TextStyle(fontSize: 20)),
          Text(
            'Envie mensagens para para seu futuro.',
            style: TextStyle(fontSize: 20),
          ),
        ],
      ),
    );
  }

  Widget newLetter() {
    return Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(10),
          child: Row(
            children: <Widget>[
              Text('Minhas Cartas', style: TextStyle(fontSize: 18)),
              Spacer(),
              ElevatedButton(
                onPressed: () async {
                  Letter? result = await Navigator.push(
                    context,
                    MaterialPageRoute<Letter>(
                      builder: (BuildContext context) => NewLetterPage(),
                    ),
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
      ],
    );
  }

  Widget LettersSection() {
    if (letters.isEmpty) {
      return const Padding(
        padding: EdgeInsets.all(20),
        child: Center(child: Text('Nenhuma carta')),
      );
    }
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final bool isMobile = constraints.maxWidth < 600;
        final double itemHeight = 180.0;
        final int rows = (letters.length / (isMobile ? 1 : 2)).ceil();
        final double gridHeight = rows * (itemHeight + 16);

        return SizedBox(
          height: gridHeight,
          child: GridView.builder(
            physics: const NeverScrollableScrollPhysics(),
            padding: const EdgeInsets.all(20),
            itemCount: letters.length,
            gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: 550,
              mainAxisExtent: itemHeight,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
            ),
            itemBuilder: (BuildContext context, int index) {
              final Letter letter = letters[index];
              final bool isLocked = DateTime.now().isBefore(letter.openingDate);
              return buildLetterCard(letter, isLocked);
            },
          ),
        );
      },
    );
  }

  Widget buildLetterCard(Letter letter, bool isLocked) {
    return Card(
      elevation: 2,
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            if (letter.parentId != null)
              Container(
                margin: const EdgeInsets.only(bottom: 4),
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(4),
                ),
                child: const Text(
                  'RESPOSTA',
                  style: TextStyle(
                    color: Colors.blue,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            Text(
              letter.title,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 4),
            Row(
              children: <Widget>[
                Icon(Icons.access_time, size: 14, color: Colors.grey[500]),
                const SizedBox(width: 5),
                Text(
                  isLocked
                      ? "Abre em: ${formatDate(letter.openingDate)}"
                      : "Aberto em: ${formatDate(letter.creationDate)}",
                  style: TextStyle(color: Colors.grey[600], fontSize: 13),
                ),
              ],
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              height: 40,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: isLocked
                      ? Colors.grey[100]
                      : Colors.blueAccent,
                  foregroundColor: isLocked ? Colors.grey[600] : Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onPressed: () async {
                  if (isLocked) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Carta bloqueada')),
                    );
                  } else {
                    final Letter? result = await Navigator.push(
                      context,
                      MaterialPageRoute<Letter>(
                        builder: (BuildContext context) =>
                            ViewLetterPage(letter: letter, allLetters: letters),
                      ),
                    );
                    if (result != null) {
                      setState(() {
                        letters.add(result);
                      });
                    }
                  }
                },
                icon: Icon(isLocked ? Icons.lock : Icons.visibility),
                label: Text(
                  isLocked ? 'Bloqueada' : 'Abrir Carta',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      extendBodyBehindAppBar: true,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: Header(),
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: <Color>[Color(0xFFFFD3E0), Color(0xFFD4E2FF)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                const SizedBox(height: 10),
                slogan(),
                const SizedBox(height: 10),
                newLetter(),
                const SizedBox(height: 10),
                LettersSection(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
