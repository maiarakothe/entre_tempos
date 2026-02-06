import 'package:entre_tempos/core/utils.dart';
import 'package:entre_tempos/ui/pages/new_letter_page.dart';
import 'package:entre_tempos/ui/pages/view_letter_page.dart';
import 'package:flutter/material.dart';

import '../../core/Colors.dart';
import '../../data/models/letter.dart';

class LetterPage extends StatefulWidget {
  const LetterPage({super.key});

  @override
  State<LetterPage> createState() => _LetterPageState();
}

class _LetterPageState extends State<LetterPage> {
  List<Letter> letters = <Letter>[];
  int? selectedIndex;

  Widget Header() {
    return AppBar(
      title: Row(
        children: <Widget>[
          Container(
            padding: EdgeInsets.all(4),
            decoration: BoxDecoration(
              gradient: DefaultColors.colorTest,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              Icons.mail_outline,
              size: 20,
              color: DefaultColors.cardLight,
            ),
          ),
          SizedBox(width: 4),
          Text('EntreTempos', style: TextStyle(fontWeight: FontWeight.w500)),
        ],
      ),
      backgroundColor: Colors.white.withValues(alpha: 0.7),
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
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Container(
        decoration: BoxDecoration(
          gradient: DefaultColors.colorTest,
          borderRadius: BorderRadius.circular(40),
        ),
        child: Padding(
          padding: const EdgeInsets.all(40),
          child: Center(
            child: Column(
              children: <Widget>[
                SizedBox(height: 10),
                Text(
                  'Escreva hoje. Leia amanhã.',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: DefaultColors.cardLight,
                  ),
                ),
                Text(
                  'Envie mensagens para seu futuro.',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: DefaultColors.cardLight,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget newLetter() {
    return Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(left: 20, right: 20),
          child: Row(
            children: <Widget>[
              Text(
                'Minhas Cartas',
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.w600,
                  color: DefaultColors.text,
                ),
              ),
              Spacer(),
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: DefaultColors.primary,
                  padding: const EdgeInsets.all(16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                label: Text(
                  'Escrever Carta',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: DefaultColors.cardLight,
                  ),
                ),
                icon: Icon(Icons.edit, color: DefaultColors.cardLight),
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
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget textCount() {
    return Align(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: const EdgeInsets.only(left: 20),
        child: Text(
          '${letters.length} cartas no total',
          style: TextStyle(
            fontSize: 15,
            color: DefaultColors.textSecondary,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  Widget optionsFilter() {
    return Align(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Container(
          decoration: BoxDecoration(
            color: DefaultColors.cardLight,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.grey.withValues(alpha: 0.3)),
          ),
          child: Padding(
            padding: const EdgeInsets.all(5),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                InkWell(
                  onTap: () {
                    setState(() {
                      selectedIndex = 0;
                    });
                  },
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      gradient: selectedIndex == 0
                          ? DefaultColors.colorTest
                          : null,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      children: <Widget>[
                        Icon(
                          Icons.mail_outline,
                          color: selectedIndex == 0 ? Colors.white : null,
                        ),
                        SizedBox(width: 6),
                        Text(
                          'Todas',
                          style: TextStyle(
                            color: selectedIndex == 0 ? Colors.white : null,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(width: 10),
                InkWell(
                  onTap: () {
                    setState(() {
                      selectedIndex = 1;
                    });
                  },
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      gradient: selectedIndex == 1
                          ? DefaultColors.colorTest
                          : null,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      children: <Widget>[
                        Icon(
                          Icons.lock_outline_sharp,
                          color: selectedIndex == 1 ? Colors.white : null,
                        ),
                        SizedBox(width: 6),
                        Text(
                          'Bloqueadas',
                          style: TextStyle(
                            color: selectedIndex == 1 ? Colors.white : null,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(width: 10),
                InkWell(
                  onTap: () {
                    setState(() {
                      selectedIndex = 2;
                    });
                  },
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      gradient: selectedIndex == 2
                          ? DefaultColors.colorTest
                          : null,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      children: <Widget>[
                        Icon(
                          Icons.mark_email_read_outlined,
                          color: selectedIndex == 2 ? Colors.white : null,
                        ),
                        SizedBox(width: 6),
                        Text(
                          'Liberadas',
                          style: TextStyle(
                            color: selectedIndex == 2 ? Colors.white : null,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget LettersSection() {
    if (letters.isEmpty) {
      return const Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          children: <Widget>[
            Icon(Icons.mail_rounded, size: 48),
            SizedBox(height: 12),
            Text(
              'Você ainda não escreveu nenhuma carta.',
              style: TextStyle(fontWeight: FontWeight.w500, fontSize: 18),
            ),
            Text(
              'Que tal começar agora?',
              style: TextStyle(fontWeight: FontWeight.w700, fontSize: 19),
            ),
          ],
        ),
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
      elevation: 5,
      color: isLocked ? null : DefaultColors.cardLight,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            if (letter.parentId != null)
              Container(
                margin: const EdgeInsets.only(bottom: 4),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Row(
                  children: <Widget>[
                    Icon(Icons.reply, size: 10, color: DefaultColors.secondary),
                    const SizedBox(width: 4),
                    const Text(
                      'RESPOSTA',
                      style: TextStyle(
                        color: DefaultColors.secondary,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
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
              child: MouseRegion(
                cursor: SystemMouseCursors.forbidden,
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isLocked
                        ? Colors.grey
                        : DefaultColors.primary,
                    foregroundColor: isLocked
                        ? DefaultColors.textSecondary
                        : Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onPressed: isLocked
                      ? null
                      : () async {
                          final Letter? result = await Navigator.push(
                            context,
                            MaterialPageRoute<Letter>(
                              builder: (BuildContext context) => ViewLetterPage(
                                letter: letter,
                                allLetters: letters,
                              ),
                            ),
                          );
                          if (result != null) {
                            setState(() {
                              letters.add(result);
                            });
                          }
                        },
                  icon: Icon(isLocked ? Icons.lock : Icons.visibility),
                  label: Text(
                    isLocked ? 'Bloqueada' : 'Abrir Carta',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
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
      backgroundColor: DefaultColors.pageColor,
      extendBodyBehindAppBar: true,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: Header(),
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        // decoration: const BoxDecoration(
        //   gradient: DefaultColors.backgroundGradient,
        // ),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                const SizedBox(height: 10),
                slogan(),
                const SizedBox(height: 10),
                newLetter(),
                const SizedBox(height: 5),
                textCount(),
                const SizedBox(height: 5),
                optionsFilter(),
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
