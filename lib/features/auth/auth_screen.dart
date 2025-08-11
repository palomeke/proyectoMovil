import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'auth_provider.dart';
import 'package:pdf/widgets.dart' as pw;
import 'dart:io';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:path_provider/path_provider.dart';
import 'package:open_filex/open_filex.dart';
import '../clothes/clothes_model.dart';

class AuthScreen extends ConsumerStatefulWidget {
  const AuthScreen({super.key});

  @override
  ConsumerState<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends ConsumerState<AuthScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLogin = true;

  void _submit() async {
    if (_formKey.currentState!.validate()) {
      final repo = ref.read(authRepositoryProvider);
      try {
        if (_isLogin) {
          await repo.signIn(
            _emailController.text.trim(),
            _passwordController.text.trim(),
          );
        } else {
          await repo.signUp(
            _emailController.text.trim(),
            _passwordController.text.trim(),
          );
        }
      } catch (e) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error: $e')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            'assets/images/bg.jpg',
            fit: BoxFit.cover,
          ),
          Center(
            child: Container(
              padding: const EdgeInsets.all(24),
              margin: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.85),
                borderRadius: BorderRadius.circular(12),
              ),
              constraints: const BoxConstraints(maxWidth: 400),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      _isLogin ? 'Iniciar Sesión' : 'Registrarse',
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      controller: _emailController,
                      decoration: const InputDecoration(
                        labelText: 'Correo electrónico',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) => value != null && value.contains('@')
                          ? null
                          : 'Correo inválido',
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: _passwordController,
                      decoration: const InputDecoration(
                        labelText: 'Contraseña',
                        border: OutlineInputBorder(),
                      ),
                      obscureText: true,
                      validator: (value) => value != null && value.length >= 6
                          ? null
                          : 'Mínimo 6 caracteres',
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: _submit,
                      child: Text(_isLogin ? 'Entrar' : 'Registrarse'),
                    ),
                    TextButton(
                      onPressed: () => setState(() => _isLogin = !_isLogin),
                      child: Text(
                        _isLogin
                            ? '¿No tienes cuenta? Regístrate'
                            : '¿Ya tienes cuenta? Inicia sesión',
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

Future<void> exportClothesToPDF(List<Clothes> clothes) async {
  if (kIsWeb) {
    // En web, path_provider no funciona
    print('Exportación a PDF no disponible en Web.');
    return;
  }

  try {
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

    final outputDir = await getApplicationDocumentsDirectory();
    final filePath = '${outputDir.path}/reporte_prendas.pdf';
    final file = File(filePath);

    await file.writeAsBytes(await pdf.save());
    await OpenFilex.open(file.path);
  } catch (e) {
    print('Error exportando PDF: $e');
  }
}
