import 'package:flutter/material.dart';
import 'package:gamedom/devices.dart';

class TotalStatsScreen extends StatelessWidget {
  final List<Device> devices;
  final VoidCallback onReset;
  const TotalStatsScreen({
    required this.devices,
    super.key,
    required this.onReset,
  });

  @override
  Widget build(BuildContext context) {
  
    int totalPsHalfSingle =
        devices.fold(0, (sum, d) => sum + d.halfHourPlayersSINGLE);
  
    int totalPsHalfMulti =
        devices.fold(0, (sum, d) => sum + d.halfHourPlayersMULTI);
   
    int totalPsFullSingle =
        devices.fold(0, (sum, d) => sum + d.fullHourPlayersSINGLE);
    int totalPsFullMulti =
        devices.fold(0, (sum, d) => sum + d.fullHourPlayersMULTI);
    int totalhourAndHalfPlayersSingle =
        devices.fold(0, (sum, d) => sum + d.hourAndHalfPlayersSingle);
    int totalhourAndHalfPlayersMulti =
        devices.fold(0, (sum, d) => sum + d.hourAndHalfPlayersMulti);


    int totalVrGame = devices.fold(0, (sum, d) => sum + d.vrGame);
    
    int totalVrTime = devices.fold(0, (sum, d) => sum + d.vrTime);
    int totalWheelsGame = devices.fold(0, (sum, d) => sum + d.wheelsgame);

    int totalWheelsTime = devices.fold(0, (sum, d) => sum + d.wheelsTime);
    -
    double totalPlayStationIncome = (totalPsHalfSingle * 25) +
        (totalPsHalfMulti * 35) +
        (totalPsFullSingle * 40) +
        (totalPsFullMulti * 60) +
        (totalhourAndHalfPlayersSingle * 60) +
        (totalhourAndHalfPlayersMulti * 90); 
    double totalVRIncome = (totalVrGame * 15) + (totalVrTime * 50);
    
    double totalWheelsIncome = (totalWheelsGame * 20) + (totalWheelsTime * 60);
    double grandTotalIncome =
        totalPlayStationIncome + totalVRIncome + totalWheelsIncome;

    return Scaffold(
      appBar: AppBar(
        title: const Text('الإحصائيات الإجمالية'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // قسم البلايستيشن
            _buildSectionHeader(
                'بلايستيشن', Icons.gamepad_outlined, Colors.blueAccent),
            _buildStatRow('نص ساعة سينجل', totalPsHalfSingle, Colors.blue),
            _buildStatRow('نص ساعة مالتي', totalPsHalfMulti, Colors.green),
            _buildStatRow('ساعة سينجل', totalPsFullSingle, Colors.orange),
            _buildStatRow('ساعة مالتي', totalPsFullMulti, Colors.purple),
            _buildStatRow('ساعة ونص سينجل', totalhourAndHalfPlayersSingle,
                const Color.fromARGB(255, 89, 31, 159)),
            _buildStatRow('ساعة ونص مالتي', totalhourAndHalfPlayersMulti,
                const Color.fromARGB(255, 251, 109, 62)),
            _buildTotalRow(
                'إجمالي دخل البلايستيشن', totalPlayStationIncome, 'جنيه'),

            const SizedBox(height: 20),
            const Divider(),
            const SizedBox(height: 10),

            
            _buildSectionHeader(
                'الواقع الافتراضي (VR)', Icons.remove_red_eye, Colors.cyan),
            _buildStatRow('عدد مرات (جيم)', totalVrGame, Colors.cyan),
            _buildStatRow('عدد مرات (تلت ساعة)', totalVrTime, Colors.indigo),
            _buildTotalRow('إجمالي دخل VR', totalVRIncome, 'جنيه'),

            const SizedBox(height: 20),
            const Divider(thickness: 2),

           
            _buildSectionHeader(
                'الدركسيون', Icons.drive_eta_outlined, Colors.cyan),
            _buildStatRow('عدد مرات (جيم)', totalWheelsGame, Colors.cyan),
            _buildStatRow(
                'عدد مرات (تلت ساعة)', totalWheelsTime, Colors.indigo),
            _buildTotalRow('إجمالي دخل للدركسيون', totalWheelsIncome, 'جنيه'),

            const SizedBox(height: 20),
            const Divider(thickness: 2),
            const SizedBox(height: 10),

            
            _buildTotalRow('الإجمالي الكلي للدخل', grandTotalIncome, 'جنيه',
                isGrandTotal: true),
            const SizedBox(height: 50),
            const Divider(thickness: 2),
            const SizedBox(height: 10),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: onReset, // عند الضغط، يتم استدعاء الدالة التي تم تمريرها
        label: const Text('بدء يوم جديد'),
        icon: const Icon(Icons.refresh),
        backgroundColor: Colors.redAccent,
      ),
    );
  }

  Widget _buildSectionHeader(String title, IconData icon, Color color) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Icon(icon, color: color, size: 28),
          const SizedBox(width: 10),
          Text(title,
              style: TextStyle(
                  fontSize: 20, fontWeight: FontWeight.bold, color: color)),
        ],
      ),
    );
  }

  Widget _buildStatRow(String label, int count, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontSize: 16)),
          Text('$count',
              style: TextStyle(
                  fontWeight: FontWeight.bold, color: color, fontSize: 18)),
        ],
      ),
    );
  }

  Widget _buildTotalRow(String label, double total, String currency,
      {bool isGrandTotal = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: isGrandTotal ? 18 : 16,
              color: isGrandTotal ? Colors.greenAccent : null,
            ),
          ),
          Text(
            '${total.toStringAsFixed(2)} $currency',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: isGrandTotal ? 20 : 18,
              color: isGrandTotal ? Colors.greenAccent : Colors.amber,
            ),
          ),
        ],
      ),
    );
  }
}
