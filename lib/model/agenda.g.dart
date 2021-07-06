// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'agenda.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class AgendaAdapter extends TypeAdapter<Agenda> {
  @override
  final int typeId = 0;

  @override
  Agenda read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Agenda(
      fields[0] as String,
      fields[1] as String,
      fields[2] as String,
      fields[3] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, Agenda obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.judul)
      ..writeByte(1)
      ..write(obj.deskripsi)
      ..writeByte(2)
      ..write(obj.waktu)
      ..writeByte(3)
      ..write(obj.isDone);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AgendaAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
