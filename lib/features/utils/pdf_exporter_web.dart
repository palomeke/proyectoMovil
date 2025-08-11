import 'dart:html' as html;
import 'package:pdf/widgets.dart' as pw;

import '../clothes/clothes_model.dart';

Future<void> exportClothesToPDF(List<Clothes> clothes) async {
  final pdf = pw.Document();

  pdf.addPage(
    pw.Page(
      build: (context) => pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text('Listado de Prendas', style: pw.TextStyle(fontSize: 24)),
          pw.SizedBox(height: 20),
          ...clothes.map((item) => pw.Text(
              '• ${item.name} - Tipo: ${item.type}, Talla: ${item.size}, Cantidad: ${item.quantity}')),
        ],
      ),
    ),
  );

  final bytes = await pdf.save();
  final blob = html.Blob([bytes]);
  final url = html.Url.createObjectUrlFromBlob(blob);

  final anchor = html.document.createElement('a') as html.AnchorElement;
  anchor.href = url;
  anchor.download = 'reporte_prendas.pdf';
  anchor.click();
}
