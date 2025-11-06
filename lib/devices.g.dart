// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'devices.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class DeviceAdapter extends TypeAdapter<Device> {
  @override
  final int typeId = 1;

  @override
  Device read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };

    return Device(
      id: fields[0] as String,
      name: fields[1] as String,
      type: fields[2] as DeviceType,
      status: fields[3] as DeviceStatus,
      customerName: fields[4] as String?,
      bookingEndTime: fields[5] as DateTime?,
      halfHourPlayersSINGLE: (fields[6] as int?) ?? 0,
      fullHourPlayersSINGLE: (fields[7] as int?) ?? 0,
      halfHourPlayersMULTI: (fields[8] as int?) ?? 0,
      fullHourPlayersMULTI: (fields[9] as int?) ?? 0,
      vrGame: (fields[10] as int?) ?? 0,
      vrTime: (fields[11] as int?) ?? 0,
      waitingList: (fields[12] as List?)?.cast<String>() ?? [],
      wheelsgame: (fields[13] as int?) ?? 0,
      wheelsTime: (fields[14] as int?) ?? 0,
      hourAndHalfPlayersSingle: (fields[15] as int?) ?? 0,
      hourAndHalfPlayersMulti: (fields[16] as int?) ?? 0,
    );
  }

  @override
  void write(BinaryWriter writer, Device obj) {
    writer
      ..writeByte(17)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.type)
      ..writeByte(3)
      ..write(obj.status)
      ..writeByte(4)
      ..write(obj.customerName)
      ..writeByte(5)
      ..write(obj.bookingEndTime)
      ..writeByte(6)
      ..write(obj.halfHourPlayersSINGLE)
      ..writeByte(7)
      ..write(obj.fullHourPlayersSINGLE)
      ..writeByte(8)
      ..write(obj.halfHourPlayersMULTI)
      ..writeByte(9)
      ..write(obj.fullHourPlayersMULTI)
      ..writeByte(10)
      ..write(obj.vrGame)
      ..writeByte(11)
      ..write(obj.vrTime)
      ..writeByte(12)
      ..write(obj.waitingList)
      ..writeByte(13)
      ..write(obj.wheelsgame)
      ..writeByte(14)
      ..write(obj.wheelsTime)
      ..writeByte(15)
      ..write(obj.hourAndHalfPlayersSingle)
      ..writeByte(16)
      ..write(obj.hourAndHalfPlayersMulti);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DeviceAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class DeviceTypeAdapter extends TypeAdapter<DeviceType> {
  @override
  final int typeId = 2;

  @override
  DeviceType read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return DeviceType.playstation;
      case 1:
        return DeviceType.vr;
      case 2:
        return DeviceType.wheels;
      default:
        return DeviceType.playstation;
    }
  }

  @override
  void write(BinaryWriter writer, DeviceType obj) {
    switch (obj) {
      case DeviceType.playstation:
        writer.writeByte(0);
        break;
      case DeviceType.vr:
        writer.writeByte(1);

        break;
      case DeviceType.wheels:
        // TODO: Handle this case.
        writer.writeByte(2);
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DeviceTypeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class DeviceStatusAdapter extends TypeAdapter<DeviceStatus> {
  @override
  final int typeId = 3;

  @override
  DeviceStatus read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return DeviceStatus.available;
      case 1:
        return DeviceStatus.busy;
      default:
        return DeviceStatus.available;
    }
  }

  @override
  void write(BinaryWriter writer, DeviceStatus obj) {
    switch (obj) {
      case DeviceStatus.available:
        writer.writeByte(0);
        break;
      case DeviceStatus.busy:
        writer.writeByte(1);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DeviceStatusAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
