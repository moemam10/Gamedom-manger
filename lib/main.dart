import 'package:flutter/material.dart';
import 'package:gamedom/gamedom.dart';
import 'package:gamedom/devices.dart'; 

import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';


void main() async {

  WidgetsFlutterBinding.ensureInitialized();

  final directory = await getApplicationDocumentsDirectory();
  Hive.init(directory.path);

  
  Hive.registerAdapter(DeviceAdapter());
  Hive.registerAdapter(DeviceTypeAdapter());
  Hive.registerAdapter(DeviceStatusAdapter());

  
  await Hive.openBox<Device>('devices');

  runApp(const Gamedom());
}
