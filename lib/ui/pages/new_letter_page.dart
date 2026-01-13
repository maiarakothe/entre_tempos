import 'package:entre_tempos/core/utils.dart';
import 'package:entre_tempos/data/models/letter.dart';
import 'package:flutter/material.dart';

class NewLetterPage extends StatefulWidget {
  const NewLetterPage({super.key});

  @override
  State<NewLetterPage> createState() => _NewLetterPageState();
}

class _NewLetterPageState extends State<NewLetterPage> {
  TextEditingController titleController = TextEditingController();
  TextEditingController contentController = TextEditingController();
  DateTime? selectedDate;

  @override
  void dispose() {
    titleController.dispose();
    contentController.dispose();
    super.dispose();
  }

  Widget LetterForm() {
    return Center(
      child: Container(
        width: 600,
        height: 700,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Form(
          child: Padding(
            padding: const EdgeInsets.all(15),
            child: Column(
              children: <Widget>[
                Text('Nova carta', style: TextStyle(fontSize: 20)),
                TextFormField(
                  controller: titleController,
                  decoration: InputDecoration(hintText: 'Titulo'),
                ),
                TextFormField(
                  controller: contentController,
                  decoration: InputDecoration(hintText: 'Conteudo'),
                ),
                SizedBox(height: 10),
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
                        : formatDate(selectedDate!),
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
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: <Widget>[
            IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: Icon(Icons.arrow_back),
            ),
            LetterForm(),
          ],
        ),
      ),
    );
  }
}
