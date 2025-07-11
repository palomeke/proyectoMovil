import 'dart:io' as io;
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';
import 'package:open_file/open_file.dart';

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

  final dir = await getApplicationDocumentsDirectory();
  final file = io.File('${dir.path}/reporte_prendas.pdf');
  await file.writeAsBytes(await pdf.save());
  await OpenFile.open(file.path);
}
