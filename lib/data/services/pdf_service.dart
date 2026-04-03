import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

import '../../core/utils.dart';
import '../models/letter.dart';

class PdfService {
  static Future<void> exportLetter(Letter letter) async {
    final pw.Document pdf = pw.Document();

    final pw.Font font = await PdfGoogleFonts.montserratRegular();
    final pw.Font boldFont = await PdfGoogleFonts.montserratBold();
    final pw.Font materialIcons = await PdfGoogleFonts.materialIcons();

    final ByteData logoBytes = await rootBundle.load(
      'assets/images/icone-sem-fundo.png',
    );
    final pw.MemoryImage logoImage = pw.MemoryImage(
      logoBytes.buffer.asUint8List(),
    );

    pdf.addPage(
      pw.MultiPage(
        margin: const pw.EdgeInsets.all(32),
        build: (pw.Context context) => <pw.Widget>[
          pw.Center(
            child: pw.Text(
              letter.title,
              style: pw.TextStyle(font: boldFont, fontSize: 22),
            ),
          ),
          pw.SizedBox(height: 40),
          pw.Row(
            children: <pw.Widget>[
              pw.Text(
                String.fromCharCode(0xe935),
                style: pw.TextStyle(font: materialIcons),
              ),
              pw.SizedBox(width: 4),
              pw.Text(
                "Escrita em ${formatDate(letter.creationDate)}",
                style: pw.TextStyle(font: font, fontSize: 12),
              ),
              pw.Spacer(),
              pw.Text(
                String.fromCharCode(0xe192),
                style: pw.TextStyle(font: materialIcons),
              ),
              pw.SizedBox(width: 4),
              pw.Text(
                "Liberada em ${formatDate(letter.openingDate)}",
                style: pw.TextStyle(font: font, fontSize: 12),
              ),
            ],
          ),
          pw.SizedBox(height: 20),
          pw.Divider(),
          pw.SizedBox(height: 20),
          pw.Text(
            letter.content,
            style: pw.TextStyle(font: font, fontSize: 14),
          ),
          if (letter.imageUrls.isNotEmpty) ...<pw.Widget>[
            pw.SizedBox(height: 20),
            pw.Text("Memórias anexadas", style: pw.TextStyle(font: boldFont)),
            pw.SizedBox(height: 15),
            ...letter.imageUrls.map((String img) {
              final pw.MemoryImage image = pw.MemoryImage(base64Decode(img));
              return pw.Padding(
                padding: const pw.EdgeInsets.only(bottom: 10),
                child: pw.Image(image, height: 190),
              );
            }),
          ],
          if (letter.audioUrl != null)
            pw.Text(
              'O áudio está disponível apenas no app',
              style: pw.TextStyle(font: boldFont),
            ),
          pw.SizedBox(height: 60),
          pw.Divider(),
          pw.SizedBox(height: 20),
          pw.Center(child: pw.Image(logoImage, height: 120, width: 120)),
        ],
      ),
    );
    final Uint8List bytes = await pdf.save();
    await Printing.sharePdf(bytes: bytes, filename: '${letter.title}.pdf');
  }
}
