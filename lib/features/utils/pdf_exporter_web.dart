import 'dart:typed_data';
import 'dart:js_interop'; // ← para usar .toJS
import 'package:web/web.dart' as web; // ← reemplaza dart:html
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
                '• ${item.name} - Tipo: ${item.type}, Talla: ${item.size}, Cantidad: ${item.quantity}',
              )),
        ],
      ),
    ),
  );

  // bytes del PDF
  final Uint8List bytes = await pdf.save();

  // Crear Blob y URL con package:web
  final blob = web.Blob([bytes.toJS]); // ← importante: .toJS
  final url = web.URL.createObjectURL(blob);

  // Crear <a>, disparar descarga, limpiar
  final anchor = web.document.createElement('a') as web.HTMLAnchorElement;
  anchor.href = url;
  anchor.download = 'reporte_prendas.pdf';
  anchor.style.display = 'none';
  web.document.body?.appendChild(anchor);

  anchor.click();

  anchor.remove();
  web.URL.revokeObjectURL(url);
}
