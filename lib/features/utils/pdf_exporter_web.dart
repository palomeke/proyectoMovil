/// ignore: avoid_web_libraries_in_flutter
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
          pw.SizedBox(height: 21),
          ...clothes.map((item) => pw.Text(
              '• ${item.name} - Tipo: ${item.type}, Talla: ${item.size}, Cantidad: ${item.quantity}')),
        ],
      ),
    ),
  );

  final bytes = await pdf.save();
  final blob = html.Blob([bytes]);
  final url = html.Url.createObjectUrlFromBlob(blob);
  final anchor = html.AnchorElement(href: url)
    ..setAttribute("download", "reporte_prendas_web.pdf")
    ..click();
  html.Url.revokeObjectUrl(url);
}
