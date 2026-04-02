import 'dart:convert';

import 'package:audioplayers/audioplayers.dart';
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

  final AudioPlayer _audioPlayer = AudioPlayer();
  bool isPlaying = false;
  Duration _duration = Duration.zero;
  Duration _position = Duration.zero;

  @override
  void initState() {
    super.initState();
    _findOriginalLetter();
    _initAudioPlayer();
  }

  void _initAudioPlayer() {
    _audioPlayer.onPlayerStateChanged.listen((PlayerState state) {
      if (mounted) {
        setState(() {
          isPlaying = state == PlayerState.playing;
        });
      }
    });

    _audioPlayer.onDurationChanged.listen((Duration newDuration) {
      if (mounted) {
        setState(() => _duration = newDuration);
      }
    });

    _audioPlayer.onPositionChanged.listen((Duration newPosition) {
      if (mounted) {
        setState(() => _position = newPosition);
      }
    });

    _audioPlayer.onPlayerComplete.listen((_) {
      if (mounted) {
        setState(() {
          isPlaying = false;
          _position = Duration.zero;
        });
      }
    });
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  Future<void> _toggleAudio() async {
    if (widget.letter.audioUrl == null) {
      return;
    }
    try {
      if (isPlaying) {
        await _audioPlayer.pause();
      } else {
        if (_audioPlayer.state == PlayerState.paused) {
          await _audioPlayer.resume();
        } else {
          String audioData = widget.letter.audioUrl!.trim();
          if (audioData.contains(',')) {
            audioData = audioData.split(',').last;
          }
          // O formato audio/mpeg é um fallback comum, o navegador detectará o real (webm/mp4/etc)
          await _audioPlayer.play(
            UrlSource('data:audio/mpeg;base64,$audioData'),
          );
        }
      }
    } catch (e) {
      debugPrint('Erro ao reproduzir áudio: $e');
      showError(context, 'Não foi possível reproduzir o áudio');
    }
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
                  Icon(
                    Icons.reply,
                    size: 16,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Resposta para: ${originalLetter!.title}',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.primary,
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
          color: Theme.of(context).hintColor,
          size: 16,
        ),
        SizedBox(width: 4),
        Text(
          'Escrita em ${formatDate(widget.letter.creationDate)}',
          style: TextStyle(color: Theme.of(context).hintColor, fontSize: 14),
          textAlign: TextAlign.center,
        ),
        Spacer(),
        Icon(
          Icons.access_time_rounded,
          color: Theme.of(context).hintColor,
          size: 16,
        ),
        SizedBox(width: 4),
        Text(
          'Liberada em ${formatDate(widget.letter.openingDate)}',
          style: TextStyle(color: Theme.of(context).hintColor, fontSize: 14),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget replyButton() {
    return AppButton(
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
          Divider(color: Theme.of(context).dividerColor),
          const SizedBox(height: 10),
          Text(
            widget.letter.content,
            style: const TextStyle(fontSize: 16, height: 1.5),
          ),
          if (widget.letter.audioUrl != null ||
              widget.letter.imageUrls.isNotEmpty) ...<Widget>[
            const SizedBox(height: 10),
            Divider(color: Theme.of(context).dividerColor),
            const SizedBox(height: 20),
            Text(
              'Memórias anexadas',
              style: TextStyle(
                fontSize: 14,
                color: Theme.of(context).hintColor,
              ),
            ),
            imagesSection(),
            audioSection(),
          ],
          const SizedBox(height: 32),
          replyButton(),
        ],
      ),
    );
  }

  Widget audioSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        const SizedBox(height: 10),
        Container(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
          decoration: BoxDecoration(
            color: Theme.of(
              context,
            ).colorScheme.primary.withValues(alpha: 0.09),
            borderRadius: DefaultBorders.container,
            border: Border.all(color: Theme.of(context).colorScheme.primary),
          ),
          child: Row(
            children: <Widget>[
              IconButton(
                onPressed: _toggleAudio,
                icon: Icon(
                  isPlaying
                      ? Icons.pause_circle_filled
                      : Icons.play_circle_fill,
                  color: Theme.of(context).colorScheme.primary,
                  size: 40,
                ),
              ),
              Expanded(
                child: Column(
                  children: <Widget>[
                    Slider(
                      activeColor: Theme.of(context).colorScheme.primary,
                      inactiveColor: Theme.of(
                        context,
                      ).colorScheme.primary.withValues(alpha: 0.2),
                      min: 0,
                      max: _duration.inMilliseconds.toDouble() > 0
                          ? _duration.inMilliseconds.toDouble()
                          : 0,
                      value: _position.inMilliseconds.toDouble(),
                      onChanged: (double value) async {
                        await _audioPlayer.seek(
                          Duration(milliseconds: value.toInt()),
                        );
                      },
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(
                            formatDurationAudio(_position),
                            style: const TextStyle(fontSize: 12),
                          ),
                          Text(
                            formatDurationAudio(_duration),
                            style: const TextStyle(fontSize: 12),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget imagesSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
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
          icon: Icon(
            Icons.arrow_back,
            color: Theme.of(context).appBarTheme.foregroundColor,
          ),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: PageCardLayout(child: letterContent()),
    );
  }
}
