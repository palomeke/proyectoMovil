import 'package:hive_flutter/hive_flutter.dart';
import '../../features/clothes/clothes_model.dart';

class HiveService {
  static Future<void> init() async {
    await Hive.initFlutter();
    Hive.registerAdapter(ClothesAdapter()); // generado con build_runner
    await Hive.openBox<Clothes>('clothes');
  }
}
