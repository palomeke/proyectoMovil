import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../auth/auth_provider.dart';
import 'clothes_provider.dart';
import 'clothes_model.dart';
import 'clothes_form_screen.dart';
import '../utils/pdf_exporter.dart';

class ClothesScreen extends ConsumerStatefulWidget {
  const ClothesScreen({super.key});

  @override
  ConsumerState<ClothesScreen> createState() => _ClothesScreenState();
}

class _ClothesScreenState extends ConsumerState<ClothesScreen> {
  String _search = '';
  String _filterType = '';
  String _filterSize = '';

  @override
  Widget build(BuildContext context) {
    final clothesAsync = ref.watch(clothesStreamProvider);
    final repo = ref.read(clothesRepositoryProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Mis Prendas'),
        actions: [
          IconButton(
            icon: CircleAvatar(child: Text('📄')),
            onPressed: () async {
              final clothesAsync = ref.read(clothesStreamProvider);
              final clothes = clothesAsync.maybeWhen(
                data: (items) => items.cast<Clothes>(),
                orElse: () => <Clothes>[],
              );
              await exportClothesToPDF(clothes);
            },
          ),
          IconButton(
            icon: CircleAvatar(child: Text('🚪')),
            onPressed: () async {
              final repo = ref.read(authRepositoryProvider);
              await repo.signOut();
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                TextField(
                  decoration: const InputDecoration(
                    labelText: 'Buscar por nombre',
                    prefixIcon: CircleAvatar(child: Text('🔍')),
                  ),
                  onChanged: (value) =>
                      setState(() => _search = value.toLowerCase()),
                ),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        decoration: const InputDecoration(
                          labelText: 'Filtrar por tipo',
                        ),
                        onChanged: (value) =>
                            setState(() => _filterType = value.toLowerCase()),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: TextField(
                        decoration: const InputDecoration(
                          labelText: 'Filtrar por talla',
                        ),
                        onChanged: (value) =>
                            setState(() => _filterSize = value.toLowerCase()),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            child: clothesAsync.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, _) {
                debugPrint('🔥 Error al cargar prendas: $e');
                return const Center(child: Text('Error al cargar prendas'));
              },
              data: (clothes) {
                final filtered = clothes.where((item) {
                  final nameMatch = item.name.toLowerCase().contains(_search);
                  final typeMatch =
                      item.type.toLowerCase().contains(_filterType);
                  final sizeMatch =
                      item.size.toLowerCase().contains(_filterSize);
                  return nameMatch && typeMatch && sizeMatch;
                }).toList();

                if (filtered.isEmpty) {
                  return const Center(child: Text('No hay coincidencias.'));
                }

                return ListView.builder(
                  itemCount: filtered.length,
                  itemBuilder: (context, index) {
                    final item = filtered[index];
                    return Dismissible(
                      key: ValueKey(item.id),
                      direction: DismissDirection.endToStart,
                      background: Container(
                        color: Colors.red,
                        alignment: Alignment.centerRight,
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: const Icon(Icons.delete, color: Colors.white),
                      ),
                      confirmDismiss: (_) async {
                        return await showDialog(
                          context: context,
                          builder: (ctx) => AlertDialog(
                            title: const Text('Confirmar eliminación'),
                            content:
                                const Text('¿Deseas eliminar esta prenda?'),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.of(ctx).pop(false),
                                child: const Text('Cancelar'),
                              ),
                              TextButton(
                                onPressed: () => Navigator.of(ctx).pop(true),
                                child: const Text('Eliminar'),
                              ),
                            ],
                          ),
                        );
                      },
                      onDismissed: (_) async {
                        await repo.deleteClothes(item.id);
                      },
                      child: ListTile(
                        leading: CircleAvatar(
                          child: Text(item.name[0].toUpperCase()),
                        ),
                        title: Text(item.name),
                        subtitle:
                            Text("Tipo: ${item.type}, Talla: ${item.size}"),
                        trailing: Text("x${item.quantity}"),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => ClothesFormScreen(item: item),
                            ),
                          );
                        },
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const ClothesFormScreen()),
          );
        },
        child: CircleAvatar(child: Text('➕')),
      ),
    );
  }
}
