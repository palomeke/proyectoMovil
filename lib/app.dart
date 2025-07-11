import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'features/auth/auth_provider.dart';
import 'features/auth/auth_screen.dart';
import 'features/clothes/clothes_screen.dart';

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authStateProvider);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Gestor de Inventario de Ropa',
      theme: ThemeData(useMaterial3: true, colorSchemeSeed: Colors.indigo),
      home: authState.when(
        loading: () =>
            const Scaffold(body: Center(child: CircularProgressIndicator())),
        error: (e, _) => Scaffold(body: Center(child: Text('Error: \$e'))),
        data: (user) =>
            user != null ? const ClothesScreen() : const AuthScreen(),
      ),
    );
  }
}
