import 'package:hive/hive.dart';

part 'devices.g.dart'; // هذا السطر مهم جدًا

@HiveType(typeId: 1) // typeId فريد لكل كائن
class Device extends HiveObject {
  // يجب أن يمتد من HiveObject
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final DeviceType type;

  @HiveField(3)
  DeviceStatus status;

  @HiveField(4)
  String? customerName;

  @HiveField(5)
  DateTime? bookingEndTime;

  @HiveField(6)
  int halfHourPlayersSINGLE;

  @HiveField(7)
  int fullHourPlayersSINGLE;

  @HiveField(8)
  int halfHourPlayersMULTI;

  @HiveField(9)
  int fullHourPlayersMULTI;

  @HiveField(10)
  int vrGame;

  @HiveField(11)
  int vrTime;
  @HiveField(12)
  List<String> waitingList = [];
  @HiveField(13)
  int wheelsgame;

  @HiveField(14)
  int wheelsTime;
  @HiveField(15)
  int hourAndHalfPlayersSingle;

  @HiveField(16)
  int hourAndHalfPlayersMulti;
  @HiveField(17)
  DateTime? bookingStartTime;
  Device({
    required this.id,
    required this.name,
    required this.type,
    this.status = DeviceStatus.available,
    this.customerName,
    this.bookingEndTime,
    List<String>? waitingList,
    this.halfHourPlayersSINGLE = 0,
    this.fullHourPlayersSINGLE = 0,
    this.halfHourPlayersMULTI = 0,
    this.fullHourPlayersMULTI = 0,
    this.vrGame = 0,
    this.vrTime = 0,
    this.wheelsgame = 0,
    this.wheelsTime = 0,
    this.hourAndHalfPlayersMulti = 0,
    this.hourAndHalfPlayersSingle = 0,
    this.bookingStartTime,
  }) : waitingList = waitingList ?? [];
}

// يجب أيضًا إنشاء Adapters للـ Enums
@HiveType(typeId: 2)
enum DeviceType {
  @HiveField(0)
  playstation,

  @HiveField(1)
  vr,
  @HiveField(2)
  wheels,
}

@HiveType(typeId: 3)
enum DeviceStatus {
  @HiveField(0)
  available,

  @HiveField(1)
  busy,
}
