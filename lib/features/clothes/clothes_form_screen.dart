import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'clothes_model.dart';
import 'clothes_repository.dart';
import 'clothes_provider.dart';
import 'package:uuid/uuid.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ClothesFormScreen extends ConsumerStatefulWidget {
  final Clothes? item;
  const ClothesFormScreen({super.key, this.item});

  @override
  ConsumerState<ClothesFormScreen> createState() => _ClothesFormScreenState();
}

class _ClothesFormScreenState extends ConsumerState<ClothesFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _typeController = TextEditingController();
  final _sizeController = TextEditingController();
  final _colorController = TextEditingController();
  final _quantityController = TextEditingController();

  @override
  void initState() {
    super.initState();
    final item = widget.item;
    if (item != null) {
      _nameController.text = item.name;
      _typeController.text = item.type;
      _sizeController.text = item.size;
      _colorController.text = item.color;
      _quantityController.text = item.quantity.toString();
    }
  }

  void _save() async {
    if (_formKey.currentState!.validate()) {
      final repo = ref.read(clothesRepositoryProvider);
      final user = FirebaseAuth.instance.currentUser;
      final clothes = Clothes(
        id: widget.item?.id ?? const Uuid().v4(),
        name: _nameController.text.trim(),
        type: _typeController.text.trim(),
        size: _sizeController.text.trim(),
        color: _colorController.text.trim(),
        quantity: int.parse(_quantityController.text.trim()),
        imageUrl: null,
        uid: user!.uid,
      );

      await repo.addOrUpdateClothes(clothes);
      if (mounted) Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title:
              Text(widget.item == null ? 'Agregar Prenda' : 'Editar Prenda')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Nombre'),
                validator: (value) => value!.isEmpty ? 'Campo requerido' : null,
              ),
              TextFormField(
                controller: _typeController,
                decoration: const InputDecoration(labelText: 'Tipo'),
                validator: (value) => value!.isEmpty ? 'Campo requerido' : null,
              ),
              TextFormField(
                controller: _sizeController,
                decoration: const InputDecoration(labelText: 'Talla'),
                validator: (value) => value!.isEmpty ? 'Campo requerido' : null,
              ),
              TextFormField(
                controller: _colorController,
                decoration: const InputDecoration(labelText: 'Color'),
                validator: (value) => value!.isEmpty ? 'Campo requerido' : null,
              ),
              TextFormField(
                controller: _quantityController,
                decoration: const InputDecoration(labelText: 'Cantidad'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) return 'Campo requerido';
                  if (int.tryParse(value) == null) return 'Debe ser un número';
                  return null;
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _save,
                child:
                    Text(widget.item == null ? 'Agregar' : 'Guardar cambios'),
              )
            ],
          ),
        ),
      ),
    );
  }
}
