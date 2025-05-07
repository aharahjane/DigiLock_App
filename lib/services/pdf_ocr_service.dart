import 'dart:io';
import 'package:pdfx/pdfx.dart';

class PdfOcrService {
  static Future<String> extractTextFromPdf(File file) async {
    final document = await PdfDocument.openFile(file.path);
    StringBuffer extractedText = StringBuffer();

    for (int i = 1; i <= document.pagesCount; i++) {
      final page = await document.getPage(i);
      final text = await page.text;
      extractedText.writeln(text);
      await page.close();
    }

    await document.close();
    return extractedText.toString();
  }
}
