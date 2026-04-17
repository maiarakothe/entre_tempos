import 'dart:async';

import 'package:entre_tempos/core/utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../../data/services/letter_service.dart';
import '../routes/routes.dart';
import '../../../core/default_colors.dart';
import '../../../data/models/letter.dart';
import '../../widgets/app_bar_widget.dart';
import '../../widgets/app_button.dart';
import '../../widgets/letter_card_widget.dart';

class LetterPage extends StatefulWidget {
  const LetterPage({super.key});

  @override
  State<LetterPage> createState() => _LetterPageState();
}

class _LetterPageState extends State<LetterPage> {
  int selectedIndex = 0;
  bool get isMobile => MediaQuery.of(context).size.width < kMobileWidth;

  final LetterService _letterService = LetterService();

  Widget slogan() {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.userChanges(),
      builder: (BuildContext context, AsyncSnapshot<User?> snapshot) {
        final User? user = snapshot.data;
        final String name = user?.displayName?.split(' ').first ?? 'Usuário';

        return Padding(
          padding: const EdgeInsets.all(20),
          child: Container(
            padding: const EdgeInsets.all(30),
            decoration: BoxDecoration(
              gradient: DefaultColors.backgroundGradient,
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
                Text(
                  "${getGreeting()}, $name 👋",
                  style: const TextStyle(
                    color: DefaultColors.cardLight,
                    fontSize: 16,
                  ),
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
                  AppButton(
                    text: 'Escrever carta',
                    onPressed: createLetter,
                    icon: Icons.edit,
                    backgroundColor: Colors.white,
                    textColor: DefaultColors.primary,
                    fontSize: 15,
                  ),
              ],
            ),
          ),
        );
      },
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
                style: TextStyle(fontSize: 25, fontWeight: FontWeight.w600),
              ),
              Spacer(),
              if (!isMobile) ...<Widget>[
                AppButton(
                  text: 'Escrever carta',
                  icon: Icons.edit,
                  fullWidth: false,
                  onPressed: createLetter,
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }

  Widget textCount(int count) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: const EdgeInsets.only(left: 20),
        child: Text(
          '$count ${count == 1 ? 'carta' : 'cartas'}',
          style: TextStyle(
            fontSize: 15,
            color: Theme.of(context).hintColor,
            fontWeight: FontWeight.w400,
          ),
        ),
      ),
    );
  }

  List<Letter> getFilteredLetters(List<Letter> letters) {
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
          gradient: active ? DefaultColors.backgroundGradient : null,
          color: active ? null : Theme.of(context).cardColor,
          borderRadius: DefaultBorders.button,
          border: active
              ? null
              : Border.all(color: Theme.of(context).dividerColor),
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
        child: isMobile
            ? Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Icon(
                    icon,
                    size: 18,
                    color: active
                        ? DefaultColors.cardLight
                        : Theme.of(context).hintColor,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    label,
                    textAlign: TextAlign.center,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 12,
                      color: active
                          ? DefaultColors.cardLight
                          : Theme.of(context).hintColor,
                      fontWeight: active ? FontWeight.w600 : FontWeight.w500,
                    ),
                  ),
                ],
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Icon(
                    icon,
                    size: 18,
                    color: active
                        ? DefaultColors.cardLight
                        : Theme.of(context).hintColor,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    label,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: active
                          ? DefaultColors.cardLight
                          : Theme.of(context).hintColor,
                      fontWeight: active ? FontWeight.w600 : FontWeight.w500,
                    ),
                  ),
                ],
              ),
      ),
    );
  }

  Widget responsiveItem(Widget child) {
    return isMobile ? Expanded(child: child) : child;
  }

  Widget filters() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: <Widget>[
          responsiveItem(filterItem("Todas", Icons.mail, 0)),
          const SizedBox(width: 8),
          responsiveItem(filterItem("Bloqueadas", Icons.lock_clock_rounded, 1)),
          const SizedBox(width: 8),
          responsiveItem(filterItem("Liberadas", Icons.mark_email_read, 2)),
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

  Widget emptyFilteredState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(50),
        child: Column(
          children: <Widget>[
            Icon(
              selectedIndex == 1
                  ? Icons.lock_outline_sharp
                  : Icons.mark_email_read_outlined,
              size: 60,
            ),
            const SizedBox(height: 12),
            Text(
              selectedIndex == 1
                  ? "Nenhuma carta bloqueada"
                  : "Nenhuma carta liberada",
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> createLetter() async {
    await Navigator.pushNamed(context, AppRoutes.newLetter);
  }

  void openLetter(Letter letter) async {
    await Navigator.pushNamed(
      context,
      AppRoutes.envelopeAnimation,
      arguments: EnvelopeArgs(
        letterTitle: letter.title,
        onOpen: () {
          Navigator.pushReplacementNamed(
            context,
            AppRoutes.viewLetter,
            arguments: ViewLetterArgs(letter: letter),
          );
        },
      ),
    );
  }

  Widget content() {
    return StreamBuilder<List<Letter>>(
      stream: _letterService.getLetters(),
      builder: (BuildContext context, AsyncSnapshot<List<Letter>> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        final List<Letter> letters = snapshot.data ?? <Letter>[];
        final List<Letter> filtered = getFilteredLetters(letters);

        return SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              slogan(),
              newLetter(),
              const SizedBox(height: 5),
              textCount(filtered.length),
              const SizedBox(height: 10),
              filters(),
              const SizedBox(height: 20),
              if (letters.isEmpty)
                emptyState()
              else if (filtered.isEmpty)
                emptyFilteredState()
              else
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: filtered.length,
                    gridDelegate:
                        const SliverGridDelegateWithMaxCrossAxisExtent(
                          maxCrossAxisExtent: 500,
                          mainAxisExtent: 240,
                          crossAxisSpacing: 16,
                          mainAxisSpacing: 16,
                        ),
                    itemBuilder: (_, int i) => LetterCardWidget(
                      key: ValueKey<String>(filtered[i].id),
                      letter: filtered[i],
                      onOpen: () => openLetter(filtered[i]),
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBarWidget(), body: content());
  }
}
