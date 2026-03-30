import 'dart:convert';
import 'package:flutter/foundation.dart';

import 'package:entre_tempos/core/default_colors.dart';
import 'package:entre_tempos/core/utils.dart';
import 'package:entre_tempos/ui/widgets/image_card.dart';
import 'package:entre_tempos/ui/widgets/page_card_layout.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../../data/models/letter.dart';
import '../../../data/services/letter_service.dart';
import '../../widgets/app_button.dart';

class NewLetterPage extends StatefulWidget {
  final String? parentId;
  const NewLetterPage({super.key, this.parentId});

  @override
  State<NewLetterPage> createState() => _NewLetterPageState();
}

class _NewLetterPageState extends State<NewLetterPage> {
  TextEditingController titleController = TextEditingController();
  TextEditingController contentController = TextEditingController();
  DateTime? selectedDate;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool isSending = false;

  List<Uint8List> selectedImages = <Uint8List>[];

  final ImagePicker _picker = ImagePicker();

  final LetterService _letterService = LetterService();

  Future<void> pickImages() async {
    if (selectedImages.length >= 5) {
      return;
    }
    try {
      final List<XFile> images = await _picker.pickMultiImage(
        limit: 5 - selectedImages.length,
        imageQuality: 60,
        maxWidth: 1280,
        maxHeight: 720,
      );
      if (images.isEmpty) {
        return;
      }
      bool hasInvalidFile = false;
      final List<String> allowedExtensions = <String>[
        'jpg',
        'jpeg',
        'png',
        'gif',
        'webp',
        'bmp',
      ];
      for (XFile img in images) {
        if (selectedImages.length >= 5) {
          showSnackBar(
            context,
            message: 'Somente é permitido 5 imagens',
            color: DefaultColors.warning,
          );
          break;
        }
        final String extension = img.name.split('.').last.toLowerCase();
        if (allowedExtensions.contains(extension)) {
          final Uint8List bytes = await img.readAsBytes();
          selectedImages.add(bytes);
        } else {
          hasInvalidFile = true;
        }
      }
      if (hasInvalidFile) {
        showSnackBar(
          context,
          message: 'Apenas arquivos de imagem são permitidos',
          color: DefaultColors.warning,
        );
      }
      setState(() {});
    } catch (e) {
      print('ERRO REAL: $e');
      showError(context, 'Erro ao selecionar imagens');
    }
  }

  @override
  void dispose() {
    titleController.dispose();
    contentController.dispose();
    super.dispose();
  }

  static List<String> _encodeImages(List<Uint8List> images) {
    return images.map(base64Encode).toList();
  }

  Future<void> formSubmit() async {
    if (isSending) {
      return;
    }
    if (!_formKey.currentState!.validate()) {
      return;
    }
    if (selectedDate == null) {
      showSnackBar(
        context,
        message: 'Selecione uma data',
        color: DefaultColors.warning,
      );
      return;
    }
    setState(() {
      isSending = true;
    });
    try {
      final User? user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        throw Exception('Usuário não logado');
      }
      await Future<void>.delayed(const Duration(milliseconds: 100));
      String title = titleController.text.trim();
      String content = contentController.text.trim();
      List<String> imageUrls = <String>[];
      if (selectedImages.isNotEmpty) {
        imageUrls = await compute(_encodeImages, selectedImages);
      }
      final Letter letter = Letter(
        id: '',
        title: title,
        content: content,
        creationDate: DateTime.now(),
        openingDate: selectedDate!,
        parentId: widget.parentId,
        userId: user.uid,
        imageUrls: imageUrls,
      );
      await _letterService.createLetter(letter);
      showSuccess(context, 'Carta enviada com sucesso');
      Navigator.pop(context);
    } catch (e) {
      print('ERRO GERAL: $e');
      showError(context, 'Erro ao enviar carta');
    } finally {
      setState(() {
        isSending = false;
      });
    }
  }

  Widget header() {
    return Column(
      children: <Widget>[
        Text(
          'Escrever Nova Carta',
          style: Theme.of(
            context,
          ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 8),
        Text(
          'Escreva hoje para ler no futuro',
          style: TextStyle(fontSize: 14, color: DefaultColors.textSecondary),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget attachments() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text('Anexar memórias'),
        const SizedBox(height: 10),
        Row(
          children: <Widget>[
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  borderRadius: DefaultBorders.container,
                  border: Border.all(color: Colors.grey),
                ),
                child: InkWell(
                  onTap: pickImages,
                  child: Row(
                    children: <Widget>[
                      Icon(Icons.image_rounded, color: DefaultColors.primary),
                      SizedBox(width: 10),
                      Text('Imagens'),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(width: 10),
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  borderRadius: DefaultBorders.container,
                  border: Border.all(color: Colors.grey),
                ),
                child: InkWell(
                  onTap: () {},
                  child: Row(
                    children: <Widget>[
                      Icon(
                        Icons.audiotrack_rounded,
                        color: DefaultColors.primary.withValues(alpha: 0.5),
                      ),
                      SizedBox(width: 10),
                      Text('Audio'),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
        if (selectedImages.isNotEmpty) const SizedBox(height: 10),
        ImageCard(
          images: selectedImages,
          showRemove: true,
          onRemove: (int index) {
            setState(() {
              selectedImages.removeAt(index);
            });
          },
        ),
      ],
    );
  }

  Widget letterForm() {
    return Form(
      key: _formKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          header(),
          const SizedBox(height: 32),
          TextFormField(
            controller: titleController,
            validator: (String? value) {
              if (value == null || value.trim().isEmpty) {
                return 'Informe o título';
              }
              return null;
            },
            minLines: 1,
            maxLines: null,
            decoration: InputDecoration(
              labelText: 'Título da Carta',
              border: OutlineInputBorder(
                borderRadius: DefaultBorders.container,
              ),
            ),
          ),
          const SizedBox(height: 20),
          TextFormField(
            controller: contentController,
            validator: (String? value) {
              if (value == null || value.trim().isEmpty) {
                return 'Escreva sua mensagem';
              }
              return null;
            },
            minLines: 5,
            maxLines: null,
            decoration: InputDecoration(
              labelText: 'Sua mensagem',
              hintText: 'Escreva aqui suas palavras, pensamentos, sonhos...',
              alignLabelWithHint: true,
              border: OutlineInputBorder(
                borderRadius: DefaultBorders.container,
              ),
            ),
          ),
          const SizedBox(height: 20),
          attachments(),
          const SizedBox(height: 20),
          InkWell(
            onTap: () async {
              DateTime? result = await showDatePicker(
                context: context,
                initialDate: selectedDate ?? DateTime.now(),
                firstDate: DateTime.now(),
                lastDate: DateTime(2100, 9, 7, 17, 30),
              );
              if (result != null) {
                setState(() {
                  selectedDate = result;
                });
              }
            },
            borderRadius: BorderRadius.circular(12),
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: DefaultBorders.container,
              ),
              child: Row(
                children: <Widget>[
                  const Icon(
                    Icons.calendar_month,
                    color: DefaultColors.primary,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      selectedDate == null
                          ? 'Selecione quando a carta poderá ser aberta'
                          : formatDate(selectedDate!),
                      style: TextStyle(
                        color: selectedDate == null
                            ? DefaultColors.textSecondary
                            : DefaultColors.text,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 30),
          AppButton(
            text: isSending ? 'Enviando...' : 'Enviar Carta',
            icon: Icons.send_rounded,
            iconAlignment: IconAlignment.end,
            disabled: isSending,
            onPressed: formSubmit,
          ),
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
        leading: isSending
            ? null
            : IconButton(
                icon: const Icon(Icons.arrow_back, color: DefaultColors.text),
                onPressed: () => Navigator.pop(context),
              ),
      ),
      body: PageCardLayout(child: letterForm()),
    );
  }
}
