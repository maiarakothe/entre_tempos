import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:entre_tempos/core/default_colors.dart';
import 'package:entre_tempos/core/utils.dart';
import 'package:entre_tempos/ui/widgets/page_card_layout.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

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

  @override
  void dispose() {
    titleController.dispose();
    contentController.dispose();
    super.dispose();
  }

  Future<void> saveLetter() async {
    final User? user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      throw Exception('Usuário não logado');
    }
    await FirebaseFirestore.instance
        .collection('letters')
        .add(<String, dynamic>{
          'userId': user.uid,
          'title': titleController.text.trim(),
          'content': contentController.text.trim(),
          'creationDate': Timestamp.now(),
          'openingDate': Timestamp.fromDate(selectedDate!),
          'parentId': widget.parentId,
        });
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
            minLines: 5,
            maxLines: null,
            decoration: InputDecoration(
              labelText: 'Sua mensagem',
              alignLabelWithHint: true,
              border: OutlineInputBorder(
                borderRadius: DefaultBorders.container,
              ),
            ),
          ),
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
            text: 'Enviar Carta',
            icon: Icons.send_rounded,
            iconAlignment: IconAlignment.end,
            onPressed: () async {
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
              String title = titleController.text.trim();
              String content = contentController.text.trim();
              if (title.isEmpty || content.isEmpty) {
                showSnackBar(
                  context,
                  message: 'Preencha todos os campos',
                  color: DefaultColors.warning,
                );
                return;
              }
              try {
                await saveLetter();
                showSuccess(context, 'Carta enviada com sucesso');
                Navigator.pop(context);
              } catch (e) {
                showError(context, 'Erro: $e');
              }
            },
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
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: DefaultColors.text),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: PageCardLayout(child: letterForm()),
    );
  }
}
