import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'clothes_model.dart';
import 'clothes_repository.dart';

final clothesRepositoryProvider = Provider((ref) => ClothesRepository());

final clothesStreamProvider = StreamProvider<List<Clothes>>((ref) {
  final repo = ref.watch(clothesRepositoryProvider);
  return repo.clothesStream;
});
