// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'crop.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class CropAdapter extends TypeAdapter<Crop> {
  @override
  final int typeId = 3;

  @override
  Crop read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Crop(
      id: fields[0] as String,
      name: fields[1] as String,
      farmId: fields[2] as String,
      type: fields[3] as CropType,
      variety: fields[4] as String,
      plantingDate: fields[5] as DateTime,
      expectedHarvestDate: fields[6] as DateTime?,
      actualHarvestDate: fields[7] as DateTime?,
      area: fields[8] as double,
      status: fields[9] as CropStatus,
      imageUrls: (fields[10] as List).cast<String>(),
      notes: fields[11] as String?,
      createdAt: fields[12] as DateTime,
      updatedAt: fields[13] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, Crop obj) {
    writer
      ..writeByte(14)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.farmId)
      ..writeByte(3)
      ..write(obj.type)
      ..writeByte(4)
      ..write(obj.variety)
      ..writeByte(5)
      ..write(obj.plantingDate)
      ..writeByte(6)
      ..write(obj.expectedHarvestDate)
      ..writeByte(7)
      ..write(obj.actualHarvestDate)
      ..writeByte(8)
      ..write(obj.area)
      ..writeByte(9)
      ..write(obj.status)
      ..writeByte(10)
      ..write(obj.imageUrls)
      ..writeByte(11)
      ..write(obj.notes)
      ..writeByte(12)
      ..write(obj.createdAt)
      ..writeByte(13)
      ..write(obj.updatedAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CropAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class CropTypeAdapter extends TypeAdapter<CropType> {
  @override
  final int typeId = 4;

  @override
  CropType read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return CropType.cereal;
      case 1:
        return CropType.vegetable;
      case 2:
        return CropType.fruit;
      case 3:
        return CropType.legume;
      case 4:
        return CropType.root;
      case 5:
        return CropType.herb;
      case 6:
        return CropType.other;
      default:
        return CropType.cereal;
    }
  }

  @override
  void write(BinaryWriter writer, CropType obj) {
    switch (obj) {
      case CropType.cereal:
        writer.writeByte(0);
        break;
      case CropType.vegetable:
        writer.writeByte(1);
        break;
      case CropType.fruit:
        writer.writeByte(2);
        break;
      case CropType.legume:
        writer.writeByte(3);
        break;
      case CropType.root:
        writer.writeByte(4);
        break;
      case CropType.herb:
        writer.writeByte(5);
        break;
      case CropType.other:
        writer.writeByte(6);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CropTypeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class CropStatusAdapter extends TypeAdapter<CropStatus> {
  @override
  final int typeId = 5;

  @override
  CropStatus read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return CropStatus.planted;
      case 1:
        return CropStatus.growing;
      case 2:
        return CropStatus.flowering;
      case 3:
        return CropStatus.fruiting;
      case 4:
        return CropStatus.harvested;
      case 5:
        return CropStatus.failed;
      default:
        return CropStatus.planted;
    }
  }

  @override
  void write(BinaryWriter writer, CropStatus obj) {
    switch (obj) {
      case CropStatus.planted:
        writer.writeByte(0);
        break;
      case CropStatus.growing:
        writer.writeByte(1);
        break;
      case CropStatus.flowering:
        writer.writeByte(2);
        break;
      case CropStatus.fruiting:
        writer.writeByte(3);
        break;
      case CropStatus.harvested:
        writer.writeByte(4);
        break;
      case CropStatus.failed:
        writer.writeByte(5);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CropStatusAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
