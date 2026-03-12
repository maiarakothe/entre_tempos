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
  int selectedIndex = 0;
  bool get isMobile => MediaQuery.of(context).size.width < kMobileWidth;

  PreferredSizeWidget header() {
    return AppBar(
      backgroundColor: Colors.transparent,
      title: Row(
        children: <Widget>[
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              gradient: DefaultColors.colorTest,
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(
              Icons.mail,
              size: 18,
              color: DefaultColors.cardLight,
            ),
          ),
          const SizedBox(width: 8),
          const Text("EntreTempos"),
        ],
      ),
      actions: <Widget>[
        Padding(
          padding: const EdgeInsets.only(right: 20),
          child: PopupMenuButton<String>(
            icon: const Icon(Icons.person_outline),
            itemBuilder: (BuildContext context) =>
                const <PopupMenuEntry<String>>[
                  PopupMenuItem<String>(
                    value: 'perfil',
                    child: Row(
                      children: <Widget>[
                        Icon(Icons.person, size: 18),
                        SizedBox(width: 8),
                        Text('Perfil'),
                      ],
                    ),
                  ),
                  PopupMenuItem<String>(
                    value: 'sair',
                    child: Row(
                      children: <Widget>[
                        Icon(Icons.logout, size: 18),
                        SizedBox(width: 8),
                        Text('Sair'),
                      ],
                    ),
                  ),
                ],
          ),
        ),
      ],
    );
  }

  Widget slogan() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Container(
        padding: const EdgeInsets.all(30),
        decoration: BoxDecoration(
          gradient: DefaultColors.colorTest,
          borderRadius: DefaultBorders.card,
          boxShadow: <BoxShadow>[
            BoxShadow(
              color: DefaultColors.primary.withValues(alpha: 0.25),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const Text(
              "Olá, Fulano👋",
              style: TextStyle(color: DefaultColors.cardLight, fontSize: 16),
            ),
            const SizedBox(height: 8),
            const Text(
              "Envie mensagens para seu futuro",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w800,
                color: DefaultColors.cardLight,
                height: 1.2,
              ),
            ),
            const SizedBox(height: 20),
            if (isMobile)
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: createLetter,
                  icon: const Icon(Icons.edit, color: DefaultColors.primary),
                  label: const Text(
                    "Escrever carta",
                    style: TextStyle(
                      color: DefaultColors.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: DefaultColors.primary,
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: DefaultBorders.button,
                    ),
                  ),
                ),
              ),
          ],
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
                  fontSize: 25,
                  fontWeight: FontWeight.w500,
                  color: DefaultColors.text,
                ),
              ),
              Spacer(),
              if (!isMobile) ...<Widget>[
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: DefaultColors.primary,
                    padding: const EdgeInsets.all(16),
                    shape: RoundedRectangleBorder(
                      borderRadius: DefaultBorders.button,
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
                  onPressed: createLetter,
                ),
              ],
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
          '${filteredLetters.length} cartas',
          style: TextStyle(
            fontSize: 15,
            color: DefaultColors.textSecondary,
            fontWeight: FontWeight.w400,
          ),
        ),
      ),
    );
  }

  List<Letter> get filteredLetters {
    if (selectedIndex == 0) {
      return letters;
    }
    if (selectedIndex == 1) {
      return letters.where((Letter letter) {
        return DateTime.now().isBefore(letter.openingDate);
      }).toList();
    }
    if (selectedIndex == 2) {
      return letters.where((Letter letter) {
        return DateTime.now().isAfter(letter.openingDate);
      }).toList();
    }

    return letters;
  }

  Widget filterItem(String label, IconData icon, int index) {
    final bool active = selectedIndex == index;
    return InkWell(
      onTap: () {
        setState(() {
          selectedIndex = index;
        });
      },
      borderRadius: DefaultBorders.button,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
        decoration: BoxDecoration(
          gradient: active ? DefaultColors.colorTest : null,
          color: active ? null : DefaultColors.cardLight,
          borderRadius: DefaultBorders.button,
          border: active ? null : Border.all(color: Colors.grey.shade200),
          boxShadow: active
              ? <BoxShadow>[
                  BoxShadow(
                    color: DefaultColors.primary.withValues(alpha: 0.2),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ]
              : null,
        ),
        child: Row(
          children: <Widget>[
            Icon(
              icon,
              size: 18,
              color: active
                  ? DefaultColors.cardLight
                  : DefaultColors.textSecondary,
            ),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                color: active
                    ? DefaultColors.cardLight
                    : DefaultColors.textSecondary,
                fontWeight: active ? FontWeight.w600 : FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget filters() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          filterItem("Todas", Icons.mail, 0),
          const SizedBox(width: 8),
          filterItem("Bloqueadas", Icons.lock, 1),
          const SizedBox(width: 8),
          filterItem("Liberadas", Icons.mark_email_read, 2),
        ],
      ),
    );
  }

  Widget emptyState() {
    return Center(
      child: const Padding(
        padding: EdgeInsets.all(40),
        child: Column(
          children: <Widget>[
            Icon(Icons.mail_outline, size: 60),
            SizedBox(height: 12),
            Text(
              "Nenhuma carta ainda",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            SizedBox(height: 6),
            Text("Que tal escrever sua primeira mensagem?"),
          ],
        ),
      ),
    );
  }

  Widget letterCard(Letter letter) {
    final bool isLocked = DateTime.now().isBefore(letter.openingDate);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: DefaultBorders.card,
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
                  color: isLocked
                      ? DefaultColors.error.withValues(alpha: 0.1)
                      : DefaultColors.success.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  isLocked ? Icons.lock : Icons.mark_email_read,
                  color: isLocked ? DefaultColors.error : DefaultColors.success,
                  size: 18,
                ),
              ),
              if (letter.parentId != null)
                Container(
                  margin: const EdgeInsets.only(bottom: 4),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Row(
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
                ),
            ],
          ),
          const SizedBox(height: 12),
          Expanded(
            child: Text(
              letter.title,
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
            isLocked ? "Disponível em:" : "Aberta em:",
            style: TextStyle(color: DefaultColors.textSecondary, fontSize: 11),
          ),
          Text(
            isLocked
                ? formatDate(letter.openingDate)
                : formatDate(letter.creationDate),
            style: TextStyle(
              color: isLocked
                  ? DefaultColors.textSecondary
                  : DefaultColors.primary,
              fontWeight: FontWeight.w600,
              fontSize: 13,
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            height: 36,
            child: ElevatedButton.icon(
              icon: Icon(isLocked ? Icons.lock : Icons.visibility),
              onPressed: isLocked ? null : () => openLetter(letter),
              style: ElevatedButton.styleFrom(
                backgroundColor: isLocked
                    ? DefaultColors.textSecondary.withValues(alpha: 0.1)
                    : DefaultColors.primary,
                foregroundColor: isLocked
                    ? DefaultColors.textSecondary
                    : Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: DefaultBorders.button,
                ),
              ),
              label: Text(
                isLocked ? "Aguarde" : "Abrir carta",
                style: TextStyle(fontSize: 13),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> createLetter() async {
    final Letter? result = await Navigator.push(
      context,
      MaterialPageRoute<Letter>(builder: (_) => NewLetterPage()),
    );
    if (result != null) {
      setState(() {
        letters.add(result);
      });
    }
  }

  void openLetter(Letter letter) async {
    final dynamic result = await Navigator.push(
      context,
      MaterialPageRoute<dynamic>(
        builder: (_) => ViewLetterPage(letter: letter, allLetters: letters),
      ),
    );
    if (result != null && result is Letter) {
      setState(() {
        letters.add(result);
      });
    } else {
      setState(() {});
    }
  }

  Widget content() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          slogan(),
          newLetter(),
          const SizedBox(height: 5),
          textCount(),
          const SizedBox(height: 10),
          filters(),
          const SizedBox(height: 20),
          if (letters.isEmpty)
            emptyState()
          else
            Padding(
              padding: const EdgeInsets.all(20),
              child: GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: filteredLetters.length,
                gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                  maxCrossAxisExtent: 500,
                  mainAxisExtent: 240,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                ),
                itemBuilder: (_, int i) => letterCard(filteredLetters[i]),
              ),
            ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: DefaultColors.pageColor,
      appBar: header(),
      body: content(),
    );
  }
}
