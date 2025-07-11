import 'package:hive/hive.dart';
part 'clothes_model.g.dart';

@HiveType(typeId: 0)
class Clothes extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  String name;

  @HiveField(2)
  String type;

  @HiveField(3)
  String size;

  @HiveField(4)
  String color;

  @HiveField(5)
  int quantity;

  @HiveField(6)
  String? imageUrl;

  @HiveField(7)
  String uid;

  Clothes({
    required this.id,
    required this.name,
    required this.type,
    required this.size,
    required this.color,
    required this.quantity,
    this.imageUrl,
    required this.uid,
  });

  Map<String, dynamic> toMap() => {
        'id': id,
        'name': name,
        'type': type,
        'size': size,
        'color': color,
        'quantity': quantity,
        'imageUrl': imageUrl,
        'uid': uid,
      };

  factory Clothes.fromMap(Map<String, dynamic> map) => Clothes(
        id: map['id'],
        name: map['name'],
        type: map['type'],
        size: map['size'],
        color: map['color'],
        quantity: map['quantity'],
        imageUrl: map['imageUrl'],
        uid: map['uid'],
      );
}
