import 'package:flutter/material.dart';
import 'package:gamedom/devices.dart';

class DetailedStatsDialog extends StatelessWidget {
  final List<Device> devices;

  const DetailedStatsDialog({required this.devices, super.key});

  @override
  Widget build(BuildContext context) {
    // حساب إجماليات البلايستيشن
    int totalPsHalfSingle =
        devices.fold(0, (sum, d) => sum + d.halfHourPlayersSINGLE);
    int totalPsHalfMulti =
        devices.fold(0, (sum, d) => sum + d.fullHourPlayersMULTI);
    int totalPsFullSingle =
        devices.fold(0, (sum, d) => sum + d.halfHourPlayersSINGLE);
    int totalPsFullMulti =
        devices.fold(0, (sum, d) => sum + d.fullHourPlayersMULTI);
    int totalhourAndHalfPlayersSingle =
        devices.fold(0, (sum, d) => sum + d.hourAndHalfPlayersSingle);
    int totalhourAndHalfPlayersMulti = devices.fold(0,
        (sum, d) => sum + d.fullHourPlayersMULTI + d.hourAndHalfPlayersMulti);

    // حساب إجماليات الـ VR
    int totalVrGame = devices.fold(0, (sum, d) => sum + d.vrGame);

    int totalVrTime = devices.fold(0, (sum, d) => sum + d.vrTime);
    int totalWheelsGame = devices.fold(0, (sum, d) => sum + d.wheelsgame);

    int totalWheelsTime = devices.fold(0, (sum, d) => sum + d.wheelsTime);

    int totalPlayStation = (totalPsHalfSingle +
        totalPsHalfMulti +
        totalPsFullSingle +
        totalPsFullMulti +
        totalhourAndHalfPlayersMulti +
        totalhourAndHalfPlayersSingle);
    int totalVR = totalVrGame + totalVrTime;
    int totalWheels = totalWheelsGame + totalWheelsTime;
    int grandTotal = totalPlayStation + totalVR + totalWheels;

    return AlertDialog(
      title: const Text('إحصائيات مفصلة'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // إحصائيات البلايستيشن
            _buildSectionHeader(
                'بلايستيشن', Icons.gamepad_outlined, Colors.blue),
            _buildStatRow('نص ساعة سينجل', totalPsHalfSingle, Colors.blue),
            _buildStatRow('نص ساعة مالتي', totalPsHalfMulti, Colors.green),
            _buildStatRow('ساعة سينجل', totalPsFullSingle, Colors.orange),
            _buildStatRow('ساعة مالتي', totalPsFullMulti, Colors.purple),
            _buildStatRow('ساعة ونص سينجل', totalhourAndHalfPlayersSingle,
                const Color.fromARGB(255, 125, 118, 106)),
            _buildStatRow('ساعة ونص مالتي', totalhourAndHalfPlayersMulti,
                const Color.fromARGB(255, 182, 19, 19)),
            _buildTotalRow('إجمالي البلايستيشن', totalPlayStation),

            const Divider(),

            // إحصائيات الـ VR
            _buildSectionHeader(
                'الواقع الافتراضي', Icons.remove_red_eye, Colors.cyan),
            _buildStatRow('جيم ', totalVrGame, Colors.cyan),

            _buildStatRow('تلت ساعة ', totalVrTime, Colors.deepPurple),
            _buildTotalRow('إجمالي VR', totalVR),
            // إحصائيات الـ wheels
            _buildSectionHeader(' الدركسيون', Icons.drive_eta_rounded,
                const Color.fromARGB(255, 31, 27, 38)),
            _buildStatRow('جيم ', totalWheelsGame, Colors.cyan),

            _buildStatRow('تلت ساعة ', totalWheelsTime,
                const Color.fromARGB(255, 33, 196, 12)),
            _buildTotalRow('إجمالي الدركسيون', totalWheels),

            const Divider(thickness: 2),

            // الإجمالي الكلي
            _buildTotalRow('الإجمالي الكلي', grandTotal, isGrandTotal: true),
          ],
        ),
      ),
      actions: [
        TextButton(
          child: const Text('إغلاق'),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ],
    );
  }

  Widget _buildSectionHeader(String title, IconData icon, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icon, color: color),
          const SizedBox(width: 8),
          Text(title,
              style: TextStyle(
                  fontSize: 16, fontWeight: FontWeight.bold, color: color)),
        ],
      ),
    );
  }

  Widget _buildStatRow(String label, int count, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text('  $label'),
          Text('$count',
              style: TextStyle(fontWeight: FontWeight.bold, color: color)),
        ],
      ),
    );
  }

  Widget _buildTotalRow(String label, int count, {bool isGrandTotal = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: isGrandTotal ? 16 : 14,
              color: isGrandTotal ? Colors.green : null,
            ),
          ),
          Text(
            '$count',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: isGrandTotal ? 18 : 16,
              color: isGrandTotal ? Colors.green : Colors.blue,
            ),
          ),
        ],
      ),
    );
  }
}
