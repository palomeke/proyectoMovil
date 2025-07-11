import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hive/hive.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'clothes_model.dart';

class ClothesRepository {
  final _firestore = FirebaseFirestore.instance;
  final _box = Hive.box<Clothes>('clothes');

  Stream<List<Clothes>> get clothesStream {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return const Stream.empty();

    return _firestore
        .collection('clothes')
        .where('uid', isEqualTo: uid)
        .snapshots()
        .map((snapshot) {
      final items =
          snapshot.docs.map((doc) => Clothes.fromMap(doc.data())).toList();
      _box.clear();
      for (final item in items) {
        _box.put(item.id, item);
      }
      return items;
    });
  }

  List<Clothes> getLocalClothes() {
    return _box.values.toList();
  }

  Future<void> addOrUpdateClothes(Clothes clothes) async {
    await _firestore.collection('clothes').doc(clothes.id).set(clothes.toMap());
    await _box.put(clothes.id, clothes);
  }

  Future<void> deleteClothes(String id) async {
    await _firestore.collection('clothes').doc(id).delete();
    await _box.delete(id);
  }
}
