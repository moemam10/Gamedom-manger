import 'package:flutter/material.dart';
import 'package:gamedom/gamedom.dart';
import 'package:gamedom/devices.dart'; // استيراد ملف الأجهزة
// استيراد ملف الـ enums
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';

// ** الخطوة 1: تأكد أن الدالة main هي async **
void main() async {
  // ** الخطوة 2: تأكد من وجود هذا السطر **
  WidgetsFlutterBinding.ensureInitialized();

  final directory = await getApplicationDocumentsDirectory();
  Hive.init(directory.path);

  // ** الخطوة 3: تسجيل كل الـ Adapters التي تم إنشاؤها **
  // إذا نسيت تسجيل أي واحد منها، سيحدث خطأ
  Hive.registerAdapter(DeviceAdapter());
  Hive.registerAdapter(DeviceTypeAdapter());
  Hive.registerAdapter(DeviceStatusAdapter());

  // ** الخطوة 4: افتح الـ Box وانتظر (await) حتى ينتهي **
  // هذا هو السطر الأهم لمنع الخطأ
  await Hive.openBox<Device>('devices');

  runApp(const Gamedom());
}
