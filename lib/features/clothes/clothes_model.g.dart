part of 'clothes_model.dart';

class ClothesAdapter extends TypeAdapter<Clothes> {
  @override
  final int typeId = 0;

  @override
  Clothes read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Clothes(
      id: fields[0] as String,
      name: fields[1] as String,
      type: fields[2] as String,
      size: fields[3] as String,
      color: fields[4] as String,
      quantity: fields[5] as int,
      imageUrl: fields[6] as String?,
      uid: fields[7] as String,
    );
  }

  @override
  void write(BinaryWriter writer, Clothes obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.type)
      ..writeByte(3)
      ..write(obj.size)
      ..writeByte(4)
      ..write(obj.color)
      ..writeByte(5)
      ..write(obj.quantity)
      ..writeByte(6)
      ..write(obj.imageUrl)
      ..writeByte(7)
      ..write(obj.uid);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ClothesAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
