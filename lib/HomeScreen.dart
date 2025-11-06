import 'dart:async';
import 'package:gamedom/total_stats_screen.dart';
import 'package:flutter/material.dart';
import 'package:gamedom/DeviceCard%20.dart';
import 'package:gamedom/devices.dart';
import 'package:gamedom/enums.dart';
import 'package:hive_flutter/hive_flutter.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // ** تم تغيير اسم القائمة لتوضيح أنها للحالة الأولية فقط **
  final List<Device> _initialDevices = [
    Device(id: 'ps1', name: 'بلايستيشن  Sal', type: DeviceType.playstation),
    Device(id: 'ps2', name: 'بلايستيشن GD Slim', type: DeviceType.playstation),
    Device(id: 'ps3', name: 'بلايستيشن GD Fat', type: DeviceType.playstation),
    Device(id: 'vr1', name: ' VR Blue', type: DeviceType.vr),
    Device(id: 'vr2', name: 'VR White', type: DeviceType.vr),
    Device(id: 'ًWheels', name: 'الدركسيون', type: DeviceType.wheels),
  ];

  Timer? _timer;

  @override
  void initState() {
    super.initState();

    _initializeData();
    _startTimer();
  }

  void _initializeData() {
    final deviceBox = Hive.box<Device>('devices');

    for (var device in _initialDevices) {
      if (!deviceBox.containsKey(device.id)) {
        deviceBox.put(device.id, device);
      }
    }
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      final now = DateTime.now();

      final deviceBox = Hive.box<Device>('devices');
      bool needsUpdate = false;

      for (var device in deviceBox.values) {
        if (device.status == DeviceStatus.busy &&
            device.bookingEndTime != null &&
            now.isAfter(device.bookingEndTime!)) {
          device.status = DeviceStatus.available;
          device.customerName = null;
          device.bookingEndTime = null;

          device.save();
          needsUpdate = true;
        }
      }
    });
  }

  List<GameMode> getModesForDevice(DeviceType type) {
    switch (type) {
      case DeviceType.playstation:
        return [GameMode.single, GameMode.multi];
      case DeviceType.vr:
      case DeviceType.wheels:
        return [GameMode.game, GameMode.time];
    }
  }

  void _resetAllCounters() {
    final deviceBox = Hive.box<Device>('devices');
    for (var device in deviceBox.values) {
      device.status = DeviceStatus.available;
      device.customerName = null;
      device.bookingEndTime = null;
      device.halfHourPlayersSINGLE = 0;
      device.fullHourPlayersSINGLE = 0;
      device.halfHourPlayersMULTI = 0;
      device.fullHourPlayersMULTI = 0;
      device.vrGame = 0;
      device.vrTime = 0;
      device.wheelsTime = 0;
      device.wheelsgame = 0;
      device.hourAndHalfPlayersMulti = 0;
      device.hourAndHalfPlayersSingle = 0;
      device.bookingStartTime = null;
      device.waitingList.clear();

      device.save();
    }
  }

  void _showResetConfirmationDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('RESET'),
          content: const Text('متأكد؟ مفيش تراجع يبني'),
          actions: [
            TextButton(
              child: const Text('كنسل'),
              onPressed: () => Navigator.of(context).pop(),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              child: const Text('متأكد'),
              onPressed: () {
                _resetAllCounters();
                Navigator.of(context).pop();
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _showBookingDialog(Device device) {
    final nameController = TextEditingController();
    final formKey = GlobalKey<FormState>();

    showDialog(
      context: context,
      builder: (context) {
        // 🔽 --- الحل بيبدأ من هنا --- 🔽
        return AlertDialog(
          title: Text('Book ${device.name}'),

          // 1. هنحط كل حاجة جوه Content عشان نقدر نعمل سكرول
          content: SingleChildScrollView(
            child: Form(
              key: formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min, // مهم جداً
                children: [
                  // 2. حقل الإدخال زي ما هو
                  TextFormField(
                    controller: nameController,
                    decoration: const InputDecoration(
                      labelText: "Name?",
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return ' pls enter the name ';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  const Divider(),

                  // 3. هننقل كل الأزرار هنا (جوه الـ Column)

                  if (device.type == DeviceType.playstation) ...[
                    // دي الأزرار بتاعتك القديمة، بس معدلة عشان تاخد العرض كامل
                    _buildBookingButton(
                      text: 'نص ساعة سينجل',
                      color: Colors.blue.shade400, // اللون اللي اخترناه
                      onPressed: () {
                        if (formKey.currentState!.validate()) {
                          _bookDevice(
                              device, nameController.text, 30, GameMode.single);
                          Navigator.of(context).pop();
                        }
                      },
                    ),
                    _buildBookingButton(
                      text: 'نص ساعة مالتي',
                      color: Colors.green.shade400, // اللون اللي اخترناه
                      onPressed: () {
                        if (formKey.currentState!.validate()) {
                          _bookDevice(
                              device, nameController.text, 30, GameMode.multi);
                          Navigator.of(context).pop();
                        }
                      },
                    ),
                    _buildBookingButton(
                      text: 'ساعة سينجل',
                      color: Colors.blue.shade600, // اللون اللي اخترناه
                      onPressed: () {
                        if (formKey.currentState!.validate()) {
                          _bookDevice(
                              device, nameController.text, 60, GameMode.single);
                          Navigator.of(context).pop();
                        }
                      },
                    ),
                    _buildBookingButton(
                      text: 'ساعة مالتي',
                      color: Colors.green.shade600, // اللون اللي اخترناه
                      onPressed: () {
                        if (formKey.currentState!.validate()) {
                          _bookDevice(
                              device, nameController.text, 60, GameMode.multi);
                          Navigator.of(context).pop();
                        }
                      },
                    ),
                    _buildBookingButton(
                      text: 'ساعه ونص سنجل',
                      color: Colors.blue.shade800, // اللون اللي اخترناه
                      onPressed: () {
                        if (formKey.currentState!.validate()) {
                          _bookDevice(
                              device, nameController.text, 90, GameMode.single);
                          Navigator.of(context).pop();
                        }
                      },
                    ),
                    _buildBookingButton(
                      text: 'ساعه ونص مالتي',
                      color: Colors.green.shade800, // اللون اللي اخترناه
                      onPressed: () {
                        if (formKey.currentState!.validate()) {
                          _bookDevice(
                              device, nameController.text, 90, GameMode.multi);
                          Navigator.of(context).pop();
                        }
                      },
                    ),

                    // ده الزرار الجديد
                    const Divider(),
                    _buildBookingButton(
                      text: 'وقت مفتوح (Open)',
                      color: Colors.teal, // لون مميز
                      onPressed: () {
                        if (formKey.currentState!.validate()) {
                          _bookOpenTimeDevice(device, nameController.text);
                          Navigator.of(context).pop();
                        }
                      },
                    ),
                  ] else if (device.type == DeviceType.vr) ...[
                    // أزرار الـ VR
                    _buildBookingButton(
                      text: 'جيم',
                      color: Colors.cyan,
                      onPressed: () {
                        if (formKey.currentState!.validate()) {
                          _bookDevice(
                              device, nameController.text, 5, GameMode.game);
                          Navigator.of(context).pop();
                        }
                      },
                    ),
                    _buildBookingButton(
                      text: 'تلت ساعة',
                      color: Colors.indigo,
                      onPressed: () {
                        if (formKey.currentState!.validate()) {
                          _bookDevice(
                              device, nameController.text, 25, GameMode.time);
                          Navigator.of(context).pop();
                        }
                      },
                    ),
                  ] else if (device.type == DeviceType.wheels) ...[
                    // أزرار الـ Wheels
                    _buildBookingButton(
                      text: 'جيم',
                      color: Colors.cyan,
                      onPressed: () {
                        if (formKey.currentState!.validate()) {
                          _bookDevice(
                              device, nameController.text, 10, GameMode.game);
                          Navigator.of(context).pop();
                        }
                      },
                    ),
                    _buildBookingButton(
                      text: 'نص ساعة',
                      color: Colors.indigo,
                      onPressed: () {
                        if (formKey.currentState!.validate()) {
                          _bookDevice(
                              device, nameController.text, 30, GameMode.time);
                          Navigator.of(context).pop();
                        }
                      },
                    ),
                  ],
                ],
              ),
            ),
          ),

          // 4. هنسيب زرار الإلغاء بس هو اللي في الـ actions
          actions: [
            TextButton(
              child: const Text('Cancel'),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        );
        // 🔼 --- الحل بينتهي هنا --- 🔼
      },
    );
  }

// 🔽 --- أضف الدالة المساعدة دي في ملف HomeScreen.dart --- 🔽
// دي دالة مساعدة عشان منكررش كود الأزرار
  Widget _buildBookingButton({
    required String text,
    required Color color,
    required VoidCallback onPressed,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          foregroundColor: Colors.white,
          minimumSize:
              const Size(double.infinity, 40), // <-- ده اللي بيخليه يملى العرض
          textStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
        ),
        onPressed: onPressed,
        child: Text(text),
      ),
    );
  }

  void _bookDevice(
      Device device, String customerName, int minutes, GameMode gameMode) {
    device.status = DeviceStatus.busy;
    device.customerName = customerName;
    device.bookingEndTime = DateTime.now().add(Duration(minutes: minutes));
    device.bookingStartTime = null;
    if (device.type == DeviceType.playstation) {
      if (minutes == 30 && gameMode == GameMode.single) {
        device.halfHourPlayersSINGLE++;
      } else if (minutes == 30 && gameMode == GameMode.multi)
        device.halfHourPlayersMULTI++;
      else if (minutes == 60 && gameMode == GameMode.single)
        device.fullHourPlayersSINGLE++;
      else if (minutes == 60 && gameMode == GameMode.multi)
        device.fullHourPlayersMULTI++;
      else if (minutes == 90 && gameMode == GameMode.single)
        device.hourAndHalfPlayersSingle++;
      else if (minutes == 90 && gameMode == GameMode.multi)
        device.hourAndHalfPlayersMulti++;
    } else if (device.type == DeviceType.vr) {
      if (gameMode == GameMode.game) device.vrGame++;
      if (gameMode == GameMode.time) device.vrTime++;
    } else if (device.type == DeviceType.wheels) {
      if (gameMode == GameMode.game) device.wheelsgame++;
      if (gameMode == GameMode.time) device.wheelsTime++;
    }

    device.save();
  }

  void _showEndOpenSessionDialog(Device device) {
    // 1. حساب الوقت اللي قضاه
    final duration = DateTime.now().difference(device.bookingStartTime!);
    final totalMinutes = duration.inMinutes;
    final hours = duration.inHours;
    final minutes = duration.inMinutes % 60;

    final String durationString =
        'الوقت: $hours س و $minutes د (إجمالي $totalMinutes دقيقة)';

    showDialog(
      context: context,
      barrierDismissible: false, // مينفعش يقفل غير لما يختار
      builder: (context) {
        return AlertDialog(
          title: Text('إنهاء الوقت - ${device.name}'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(durationString,
                  style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.tealAccent)),
              const Divider(),
              const Text('اختر الطريقة لحساب الوقت والإحصائيات:'),
              const SizedBox(height: 8),
              // قائمة بكل الاختيارات المتاحة
              Container(
                height: 300, // ارتفاع ثابت عشان الـ ListView
                width: double.maxFinite,
                child: ListView(
                  shrinkWrap: true,
                  children: [
                    // --- أزرار السينجل ---
                    _buildEndOpenSessionButton(context, device, 'نص ساعة سينجل',
                        30, GameMode.single, Colors.blue.shade400),
                    _buildEndOpenSessionButton(context, device, 'ساعة سينجل',
                        60, GameMode.single, Colors.blue.shade600),
                    _buildEndOpenSessionButton(
                        context,
                        device,
                        'ساعة ونص سينجل',
                        90,
                        GameMode.single,
                        Colors.blue.shade800),
                    const Divider(),
                    // --- أزرار المالتي ---
                    _buildEndOpenSessionButton(context, device, 'نص ساعة مالتي',
                        30, GameMode.multi, Colors.green.shade400),
                    _buildEndOpenSessionButton(context, device, 'ساعة مالتي',
                        60, GameMode.multi, Colors.green.shade600),
                    _buildEndOpenSessionButton(
                        context,
                        device,
                        'ساعة ونص مالتي',
                        90,
                        GameMode.multi,
                        Colors.green.shade800),
                  ],
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              child: const Text('إلغاء (خروج بدون إنهاء)'),
              onPressed: () => Navigator.of(context).pop(),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red, // لون أحمر عشان مميز
              ),
              child: const Text('إلغاء الحجز'),
              onPressed: () {
                
                device.status = DeviceStatus.available;
                device.customerName = null;
                device.bookingEndTime = null;
                device.bookingStartTime = null; // <-- أهم سطر
                device.save();

                Navigator.of(context).pop(); // اقفل الـ Dialog
              },
            ),
          ],
        );
      },
    );
  }


  Widget _buildEndOpenSessionButton(BuildContext context, Device device,
      String label, int minutes, GameMode gameMode, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
            backgroundColor: color, foregroundColor: Colors.white),
        child: Text(label),
        onPressed: () {
          _finalizeOpenSession(device, minutes, gameMode);
          Navigator.of(context).pop(); // إغلاق الـ Dialog
        },
      ),
    );
  }

// method بتسجل الإحصائيات وبتصفر الجهاز
  void _finalizeOpenSession(Device device, int minutes, GameMode gameMode) {
    // نفس لوجيك الإحصائيات بالظبط اللي في _bookDevice
    if (device.type == DeviceType.playstation) {
      if (minutes == 30 && gameMode == GameMode.single) {
        device.halfHourPlayersSINGLE++;
      } else if (minutes == 30 && gameMode == GameMode.multi)
        device.halfHourPlayersMULTI++;
      else if (minutes == 60 && gameMode == GameMode.single)
        device.fullHourPlayersSINGLE++;
      else if (minutes == 60 && gameMode == GameMode.multi)
        device.fullHourPlayersMULTI++;
      else if (minutes == 90 && gameMode == GameMode.single)
        device.hourAndHalfPlayersSingle++;
      else if (minutes == 90 && gameMode == GameMode.multi)
        device.hourAndHalfPlayersMulti++;
    }

    // تصفير الجهاز
    device.status = DeviceStatus.available;
    device.customerName = null;
    device.bookingEndTime = null;
    device.bookingStartTime = null; 

    device.save();
  }

  void _showAddToWaitingListDialog(Device device) {
    final controller = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("ِADD to Waiting   - ${device.name}"),
          content: TextField(
            controller: controller,
            decoration: InputDecoration(
              labelText: "Name ",
              border: OutlineInputBorder(),
            ),
          ),
          actions: [
            TextButton(
              child: Text("Cancel"),
              onPressed: () => Navigator.pop(context),
            ),
            ElevatedButton(
              child: Text("Add"),
              onPressed: () {
                if (controller.text.trim().isNotEmpty) {
                  device.waitingList.add(controller.text.trim());
                  device.save();

                  Navigator.of(context).pop();
                }
              },
            ),
          ],
        );
      },
    );
  }

  void _bookOpenTimeDevice(Device device, String customerName) {
    device.status = DeviceStatus.busy;
    device.customerName = customerName;
    device.bookingStartTime = DateTime.now(); // <-- أهم سطر: بنسجل وقت البدء
    device.bookingEndTime = null; // <-- بنلغي وقت النهاية
    device.save();
  }

  void _showEndSessionDialog(Device device) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Time out '),
          content: Text('  Sure?   "${device.customerName}"'),
          actions: [
            TextButton(
              child: const Text('No'),
              onPressed: () => Navigator.of(context).pop(),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              child: const Text(' Yes '),
              onPressed: () {
                device.status = DeviceStatus.available;
                device.customerName = null;
                device.bookingEndTime = null;

                device.save();
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('GAMEDOM'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.bar_chart),
            tooltip: 'Show The Details of the Day ',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => TotalStatsScreen(
                    devices: Hive.box<Device>('devices').values.toList(),
                    onReset: _showResetConfirmationDialog,
                  ),
                ),
              );
            },
          ),
        ],
      ),
      body: ValueListenableBuilder<Box<Device>>(
        valueListenable: Hive.box<Device>('devices').listenable(),
        builder: (context, box, _) {
          final devices = box.values.toList();

          if (devices.isEmpty) {
            return const Center(child: Text("يتم تحميل الأجهزة..."));
          }

          return Padding(
            padding: const EdgeInsets.all(12.0),
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 0.9,
              ),
              itemCount: devices.length,
              itemBuilder: (context, index) {
                final device = devices[index];
                return DeviceCard(
                  device: device,
                  onTap: () {
                    if (device.status == DeviceStatus.available) {
                      _showBookingDialog(device);
                    } else {
                      if (device.bookingStartTime != null) {
                        // ده وقت مفتوح، اعرض Dialog الحساب
                        _showEndOpenSessionDialog(device);
                      } else {
                        
                        _showEndSessionDialog(device);
                      }
                    }
                  },
                );
              },
            ),
          );
        },
      ),
    );
  }
}
