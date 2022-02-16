// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'icon_stack.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class PositionedIconAdapter extends TypeAdapter<PositionedIcon> {
  @override
  final int typeId = 0;

  @override
  PositionedIcon read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return PositionedIcon(
      icon: fields[0] as IconData,
      size: fields[3] as double,
      x: fields[4] as double,
      y: fields[5] as double,
      family: fields[1] as String?,
      name: fields[2] as String?,
      color: fields[7] as Color?,
      angle: fields[6] as double,
      flip: fields[8] == null ? false : fields[8] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, PositionedIcon obj) {
    writer
      ..writeByte(9)
      ..writeByte(0)
      ..write(obj.icon)
      ..writeByte(1)
      ..write(obj.family)
      ..writeByte(2)
      ..write(obj.name)
      ..writeByte(3)
      ..write(obj.size)
      ..writeByte(4)
      ..write(obj.x)
      ..writeByte(5)
      ..write(obj.y)
      ..writeByte(6)
      ..write(obj.angle)
      ..writeByte(7)
      ..write(obj.color)
      ..writeByte(8)
      ..write(obj.flip);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PositionedIconAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class IconStackAdapter extends TypeAdapter<IconStack> {
  @override
  final int typeId = 1;

  @override
  IconStack read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return IconStack(
      (fields[1] as List).cast<PositionedIcon>(),
    )..currentIconIndex = fields[0] as int;
  }

  @override
  void write(BinaryWriter writer, IconStack obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.currentIconIndex)
      ..writeByte(1)
      ..write(obj.icons);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is IconStackAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class IconStackListAdapter extends TypeAdapter<IconStackList> {
  @override
  final int typeId = 2;

  @override
  IconStackList read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return IconStackList(
      (fields[0] as List).cast<IconStack>(),
    );
  }

  @override
  void write(BinaryWriter writer, IconStackList obj) {
    writer
      ..writeByte(1)
      ..writeByte(0)
      ..write(obj.iconStacks);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is IconStackListAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
