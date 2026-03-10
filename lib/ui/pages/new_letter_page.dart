import 'package:entre_tempos/core/Colors.dart';
import 'package:entre_tempos/core/utils.dart';
import 'package:entre_tempos/data/models/letter.dart';
import 'package:entre_tempos/ui/widgets/page_card_layout.dart';
import 'package:flutter/material.dart';

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

  @override
  void dispose() {
    titleController.dispose();
    contentController.dispose();
    super.dispose();
  }

  Widget header() {
    return Column(
      children: <Widget>[
        Text(
          'Escrever Nova Carta',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            color: DefaultColors.primary,
            fontWeight: FontWeight.bold,
          ),
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
                borderRadius: BorderRadius.circular(12),
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
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
          const SizedBox(height: 20),
          InkWell(
            onTap: () async {
              DateTime? result = await showDatePicker(
                context: context,
                currentDate: selectedDate,
                firstDate: DateTime.now(),
                lastDate: DateTime(2100, 9, 7, 17, 30),
              );
              setState(() {
                selectedDate = result;
              });
            },
            borderRadius: BorderRadius.circular(12),
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: <Widget>[
                  const Icon(
                    Icons.calendar_month,
                    color: DefaultColors.primary,
                  ),
                  const SizedBox(width: 12),
                  Text(
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
                ],
              ),
            ),
          ),
          const SizedBox(height: 30),
          Container(
            decoration: BoxDecoration(
              gradient: DefaultColors.primaryButtonGradient,
              borderRadius: BorderRadius.circular(12),
              boxShadow: <BoxShadow>[
                BoxShadow(
                  color: DefaultColors.primary.withValues(alpha: 0.3),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: ElevatedButton.icon(
              label: Text(
                'Enviar Carta',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              icon: const Icon(Icons.send_rounded, color: Colors.white),
              iconAlignment: IconAlignment.end,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.transparent,
                shadowColor: Colors.transparent,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(28),
                ),
              ),
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
                    const SnackBar(content: Text('Preencha todos os campos')),
                  );
                  return;
                }
                Letter letter = Letter(
                  id: DateTime.now().microsecondsSinceEpoch.toString(),
                  title: title,
                  content: content,
                  creationDate: DateTime.now(),
                  openingDate: selectedDate!,
                  parentId: widget.parentId,
                );
                Navigator.pop(context, letter);
              },
            ),
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
