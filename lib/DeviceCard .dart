import 'package:flutter/material.dart';
import 'package:gamedom/devices.dart';

class DeviceCard extends StatelessWidget {
  final Device device;
  final VoidCallback onTap;

  const DeviceCard({
    super.key,
    required this.device,
    required this.onTap,
  });

  Widget build(BuildContext context) {
    final isAvailable = device.status == DeviceStatus.available;
    final cardColor = isAvailable ? Colors.green.shade900 : Colors.red.shade900;
    final borderColor = isAvailable ? Colors.greenAccent : Colors.redAccent;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Card(
        elevation: 4,
        color: cardColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(color: borderColor, width: 1.5),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),

          // 🔽 --- الحل هنا: تعديل الـ Column ده --- 🔽
          child: Column(
            // 1. شيلنا mainAxisAlignment
            // 2. شيلنا كل الـ flex والـ Flexible
            children: [
              // أيقونة ونوع الجهاز
              Expanded(
                // <-- بقى Expanded عادي
                child: _buildDeviceIcon(),
              ),

              // اسم الجهاز
              Padding(
                // <-- بقى Padding عادي
                padding: const EdgeInsets.symmetric(vertical: 4), // مسافة بسيطة
                child: Text(
                  device.name,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),

              // حالة الجهاز (العداد)
              Expanded(
                // <-- بقى Expanded عادي
                child: _buildDeviceStatus(isAvailable),
              ),

              // زر قائمة الانتظار
              // ده هنسيبه زي ما هو لأنه واخد ارتفاع ثابت ومظبوط
              _buildWaitingListButton(context),
            ],

            // الإحصائيات (للبلايستيشن فقط)
            // if (device.type == DeviceType.playstation)
            //   Expanded(
            //     flex: 3,
            //     child: _buildPlayStationStats(),
            //   ),

            // زر قائمة الانتظار
          ),
          // 🔼 --- نهاية الحل --- 🔼
        ),
      ),
    );
  }

  Widget _buildDeviceIcon() {
    IconData icon;
    String label;
    Color iconColor;

    switch (device.type) {
      case DeviceType.playstation:
        icon = Icons.sports_esports;
        label = "PS";
        iconColor = Colors.blueAccent;
        break;
      case DeviceType.vr:
        icon = Icons.remove_red_eye_rounded;
        label = "VR";
        iconColor = Colors.purpleAccent;
        break;
      case DeviceType.wheels:
        icon = Icons.drive_eta_sharp;
        label = "Wheels";
        iconColor = Colors.orangeAccent;
        break;
      default:
        icon = Icons.devices;
        label = "Device";
        iconColor = Colors.white70;
    }

    return FittedBox(
      fit: BoxFit.contain,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: 28,
            color: iconColor,
          ),
          Text(
            label,
            style: TextStyle(
              color: iconColor,
              fontSize: 9,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  // في ملف DeviceCard.dart

  // في ملف DeviceCard.dart

  Widget _buildDeviceStatus(bool isAvailable) {
    if (isAvailable) {
      return Center(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
          decoration: BoxDecoration(
            color: Colors.green.withOpacity(0.2),
            borderRadius: BorderRadius.circular(15),
            border: Border.all(color: Colors.greenAccent, width: 1),
          ),
          child: const Text(
            'متاح',
            style: TextStyle(
              color: Colors.greenAccent,
              fontSize: 11,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      );
    } else {
      // --- الجهاز مشغول ---
      final bool isOpenTime = device.bookingStartTime != null;

      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // اسم العميل
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.person, size: 12, color: Colors.white70),
              const SizedBox(width: 2),
              Flexible(
                child: Text(
                  device.customerName ?? 'محجوز',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 11,
                  ),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
              ),
            ],
          ),
          const SizedBox(height: 2),
          // العداد
          StreamBuilder<int>(
            stream: Stream.periodic(const Duration(seconds: 1), (_) => 1),
            builder: (context, snapshot) {
              if (isOpenTime) {
                // --- الحالة 1: وقت مفتوح (عد تصاعدي) ---
                final difference =
                    DateTime.now().difference(device.bookingStartTime!);

                final hours = difference.inHours;
                final minutes = difference.inMinutes % 60;
                final seconds = difference.inSeconds % 60;

                final formatted =
                    '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';

                return Text(
                  formatted,
                  style: const TextStyle(
                    color: Colors.tealAccent,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'monospace',
                  ),
                );
              } else {
                // --- الحالة 2: وقت محدد (اللوجيك القديم) ---

                // 🔽 --- الحل هنا --- 🔽
                // هنتأكد إن وقت النهاية مش null قبل ما نستخدمه
                if (device.bookingEndTime == null) {
                  // دي الحالة الشبحية اللي بتحصل لجزء من الثانية
                  // هنعرض أي حاجة مؤقتة لحد ما الـ Card كله يتحدث
                  return const Text(
                    '00:00',
                    style: TextStyle(
                      color: Colors.grey,
                      fontFamily: 'monospace',
                    ),
                  );
                }
                // 🔼 --- نهاية الحل --- 🔼

                // لو الكود وصل هنا، يبقى bookingEndTime أكيد موجود
                final difference =
                    device.bookingEndTime!.difference(DateTime.now());

                if (difference.isNegative) {
                  return const Text(
                    'انتهى',
                    style: TextStyle(
                      color: Colors.orange,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  );
                }

                final minutes = difference.inMinutes;
                final seconds = difference.inSeconds % 60;
                final formatted =
                    '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';

                return Text(
                  formatted,
                  style: const TextStyle(
                    color: Colors.yellowAccent,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'monospace',
                  ),
                );
              }
            },
          ),
        ],
      );
    }
  }

  // Widget _buildPlayStationStats() {
  //   return Container(
  //     padding: const EdgeInsets.all(4),
  //     margin: const EdgeInsets.symmetric(vertical: 2),
  //     decoration: BoxDecoration(
  //       color: Colors.black26,
  //       borderRadius: BorderRadius.circular(6),
  //     ),
  //     child: Column(
  //       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
  //       children: [
  //         // السينجل
  //         _buildCompactStatsRow(
  //           "سينجل",
  //           device.halfHourPlayersSINGLE,
  //           device.fullHourPlayersSINGLE,
  //           Colors.blue,
  //         ),
  //         const SizedBox(height: 2),
  //         // المالتي
  //         _buildCompactStatsRow(
  //           "مالتي",
  //           device.halfHourPlayersMULTI,
  //           device.fullHourPlayersMULTI,
  //           Colors.green,
  //         ),
  //       ],
  //     ),
  //   );
  // }

  // Widget _buildCompactStatsRow(
  //     String label, int halfHour, int fullHour, Color color) {
  //   return Row(
  //     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
  //     children: [
  //       // نص ساعة
  //       _buildCompactStatItem(halfHour, "½س", color),
  //       // النوع
  //       Text(
  //         label,
  //         style: const TextStyle(
  //           color: Colors.white70,
  //           fontSize: 9,
  //         ),
  //       ),
  //       // ساعة كاملة
  //       _buildCompactStatItem(fullHour, "1س", color.withOpacity(0.7)),
  //     ],
  //   );
  // }

  // Widget _buildCompactStatItem(int count, String label, Color color) {
  //   return Container(
  //     padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
  //     decoration: BoxDecoration(
  //       color: color.withOpacity(0.15),
  //       borderRadius: BorderRadius.circular(4),
  //     ),
  //     child: Row(
  //       mainAxisSize: MainAxisSize.min,
  //       children: [
  //         Text(
  //           '$count',
  //           style: TextStyle(
  //             color: color,
  //             fontSize: 11,
  //             fontWeight: FontWeight.bold,
  //           ),
  //         ),
  //         const SizedBox(width: 2),
  //         Text(
  //           label,
  //           style: TextStyle(
  //             color: color.withOpacity(0.8),
  //             fontSize: 8,
  //           ),
  //         ),
  //       ],
  //     ),
  //   );
  // }

  Widget _buildWaitingListButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 28,
      child: TextButton(
        style: TextButton.styleFrom(
          padding: EdgeInsets.zero,
          backgroundColor: Colors.amber.withOpacity(0.2),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(6),
            side: BorderSide(color: Colors.amber.withOpacity(0.4), width: 1),
          ),
        ),
        onPressed: () => _showWaitingListDialog(context),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.people,
              size: 14,
              color: Colors.white,
            ),
            const SizedBox(width: 4),
            const Text(
              'Waiting List',
              style: TextStyle(
                color: Colors.white,
                fontSize: 10,
              ),
            ),
            if (device.waitingList.isNotEmpty) ...[
              const SizedBox(width: 4),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
                decoration: BoxDecoration(
                  color: Colors.orange,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  '${device.waitingList.length}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 9,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  void _showWaitingListDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) {
        return StatefulBuilder(
          builder: (context, setState) {
            final TextEditingController nameController =
                TextEditingController();

            return AlertDialog(
              backgroundColor: Colors.grey.shade900,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              title: Row(
                children: [
                  const Icon(Icons.people, color: Colors.amber, size: 20),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      ' Waiting List - ${device.name}',
                      style: const TextStyle(color: Colors.white, fontSize: 16),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              content: SizedBox(
                width: double.maxFinite,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // قائمة الأسماء
                    if (device.waitingList.isEmpty)
                      Container(
                        padding: const EdgeInsets.all(20),
                        child: const Text(
                          'مفيش حد مستني ',
                          style: TextStyle(color: Colors.white70, fontSize: 14),
                        ),
                      )
                    else
                      Container(
                        constraints: const BoxConstraints(maxHeight: 200),
                        child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: device.waitingList.length,
                          itemBuilder: (context, index) {
                            return Card(
                              color: Colors.grey.shade800,
                              margin: const EdgeInsets.symmetric(vertical: 3),
                              child: ListTile(
                                dense: true,
                                leading: CircleAvatar(
                                  radius: 15,
                                  backgroundColor: Colors.amber,
                                  child: Text(
                                    '${index + 1}',
                                    style: const TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12,
                                    ),
                                  ),
                                ),
                                title: Text(
                                  device.waitingList[index],
                                  style: const TextStyle(
                                      color: Colors.white, fontSize: 14),
                                ),
                                trailing: IconButton(
                                  icon: const Icon(Icons.delete_outline,
                                      color: Colors.red, size: 20),
                                  onPressed: () {
                                    setState(() {
                                      device.waitingList.removeAt(index);
                                      device.save();
                                    });
                                  },
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    const SizedBox(height: 12),
                    // حقل إضافة اسم جديد
                    TextField(
                      controller: nameController,
                      style: const TextStyle(color: Colors.white, fontSize: 14),
                      decoration: InputDecoration(
                        labelText: 'أدخل اسم الشخص',
                        labelStyle: const TextStyle(
                            color: Colors.white70, fontSize: 13),
                        prefixIcon: const Icon(Icons.person_add,
                            color: Colors.amber, size: 20),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(color: Colors.amber),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(color: Colors.grey.shade600),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide:
                              const BorderSide(color: Colors.amber, width: 2),
                        ),
                        filled: true,
                        fillColor: Colors.grey.shade800,
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 8),
                      ),
                      onSubmitted: (value) {
                        if (value.trim().isNotEmpty) {
                          setState(() {
                            device.waitingList.add(value.trim());
                            nameController.clear();
                            device.save();
                          });
                        }
                      },
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  child: const Text(
                    'إغلاق',
                    style: TextStyle(color: Colors.white70, fontSize: 13),
                  ),
                  onPressed: () => Navigator.pop(context),
                ),
                ElevatedButton.icon(
                  icon: const Icon(Icons.add, size: 18),
                  label: const Text('إضافة', style: TextStyle(fontSize: 13)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.amber,
                    foregroundColor: Colors.black,
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onPressed: () {
                    if (nameController.text.trim().isNotEmpty) {
                      setState(() {
                        device.waitingList.add(nameController.text.trim());
                        nameController.clear();
                        device.save();
                      });
                    }
                  },
                ),
              ],
            );
          },
        );
      },
    );
  }
}
