import 'package:flutter/material.dart';

import '../../data/models/letter.dart';

class ReplyLetterPage extends StatefulWidget {
  const ReplyLetterPage({super.key, required this.originalLetter});

  @override
  State<ReplyLetterPage> createState() => _ReaplyLetterPageState();
  final Letter originalLetter;
}

class _ReaplyLetterPageState extends State<ReplyLetterPage> {
  TextEditingController titleController = TextEditingController();
  TextEditingController contentController = TextEditingController();
  DateTime? selectedDate;

  @override
  void dispose() {
    titleController.dispose();
    contentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Text('Nova carta'),
            Form(
              child: Column(
                children: [
                  TextFormField(
                    controller: titleController,
                    decoration: InputDecoration(hintText: 'Titulo'),
                  ),
                  TextFormField(
                    controller: contentController,
                    decoration: InputDecoration(hintText: 'Conteudo'),
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      DateTime? result = await showDatePicker(
                        context: context,
                        currentDate: selectedDate,
                        firstDate: DateTime(2026, 1, 1, 17, 30),
                        lastDate: DateTime(2100, 9, 7, 17, 30),
                      );
                      setState(() {
                        selectedDate = result;
                      });
                    },
                    child: Text(
                      selectedDate == null
                          ? 'Escolher data'
                          : '${selectedDate!.day.toString().padLeft(2, '0')}/'
                                '${selectedDate!.month.toString().padLeft(2, '0')}/'
                                '${selectedDate!.year}',
                    ),
                  ),
                  SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: () {
                      if (selectedDate == null) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Selecione uma data')),
                        );
                        return;
                      }

                      String title = titleController.text;
                      String content = contentController.text;

                      if (title.isEmpty || content.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Preencha todos os campos'),
                          ),
                        );
                        return;
                      }

                      Letter letter = Letter(
                        id: DateTime.now().microsecondsSinceEpoch.toString(),
                        title: title,
                        content: content,
                        creationDate: DateTime.now(),
                        openingDate: selectedDate!,
                      );
                      Navigator.pop(context, letter);
                    },
                    child: Text('Salvar'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
