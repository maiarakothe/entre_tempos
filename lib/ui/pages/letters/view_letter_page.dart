import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:entre_tempos/core/default_colors.dart';
import 'package:entre_tempos/core/utils.dart';
import 'package:entre_tempos/ui/widgets/app_button.dart';
import 'package:entre_tempos/ui/widgets/page_card_layout.dart';
import 'package:flutter/material.dart';

import '../../../data/services/letter_service.dart';
import '../../widgets/image_card.dart';
import '../routes/routes.dart';
import '../../../data/models/letter.dart';

class ViewLetterPage extends StatefulWidget {
  const ViewLetterPage({super.key, required this.letter});

  final Letter letter;

  @override
  State<ViewLetterPage> createState() => _ViewLetterPageState();
}

class _ViewLetterPageState extends State<ViewLetterPage> {
  Letter? originalLetter;
  bool isLoadingParent = false;
  final LetterService _letterService = LetterService();

  bool get isMobile => MediaQuery.of(context).size.width < kMobileWidth;

  @override
  void initState() {
    super.initState();
    _findOriginalLetter();
  }

  Future<void> _findOriginalLetter() async {
    if (widget.letter.parentId == null) {
      return;
    }
    setState(() {
      isLoadingParent = true;
    });
    try {
      final Letter? letter = await _letterService.getLetterById(
        widget.letter.parentId!,
      );
      if (letter != null) {
        setState(() {
          originalLetter = letter;
        });
      }
    } catch (e) {
      showError(context, 'Erro ao buscar carta pai');
    } finally {
      setState(() {
        isLoadingParent = false;
      });
    }
  }

  Widget headerSection() {
    return Column(
      children: <Widget>[
        if (originalLetter != null)
          Padding(
            padding: const EdgeInsets.only(bottom: 16.0),
            child: InkWell(
              onTap: () {
                Navigator.pushNamed(
                  context,
                  AppRoutes.viewLetter,
                  arguments: ViewLetterArgs(letter: originalLetter!),
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
          'Liberada em ${formatDate(widget.letter.openingDate)}',
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
      child: AppButton(
        text: 'Responder essa carta',
        icon: Icons.reply,
        onPressed: () async {
          final Object? newLetter = await Navigator.pushNamed(
            context,
            AppRoutes.newLetter,
            arguments: widget.letter.id,
          );
          if (newLetter != null) {
            Navigator.pop(context, newLetter);
          }
        },
      ),
    );
  }

  Widget letterContent() {
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
          if (widget.letter.imageUrls.isNotEmpty) const SizedBox(height: 10),
          imagesSection(),
          const SizedBox(height: 32),
          replyButton(),
        ],
      ),
    );
  }

  Widget imagesSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Divider(color: DefaultColors.textSecondary.withValues(alpha: 0.1)),
        const SizedBox(height: 20),
        Text(
          'Memórias anexadas',
          style: TextStyle(fontSize: 14, color: DefaultColors.textSecondary),
        ),
        const SizedBox(height: 10),
        ImageCard(images: widget.letter.imageUrls.map(base64Decode).toList()),
      ],
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
      body: PageCardLayout(child: letterContent()),
    );
  }
}
