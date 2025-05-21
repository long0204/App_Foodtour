// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'favorite_address_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class FavoritePlaceAdapter extends TypeAdapter<FavoritePlace> {
  @override
  final int typeId = 1;

  @override
  FavoritePlace read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return FavoritePlace(
      name: fields[0] as String,
      address: fields[1] as String,
      type: fields[2] as String,
      price: fields[3] as String,
    );
  }

  @override
  void write(BinaryWriter writer, FavoritePlace obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.name)
      ..writeByte(1)
      ..write(obj.address)
      ..writeByte(2)
      ..write(obj.type)
      ..writeByte(3)
      ..write(obj.price);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FavoritePlaceAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
