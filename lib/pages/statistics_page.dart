import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class StatisticsPage extends StatelessWidget {
  const StatisticsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final habits =
        ModalRoute.of(context)!.settings.arguments
            as List<Map<String, dynamic>>? ??
        [];

    int doneCount = habits.where((h) => h['done'] == true).length;
    int notDoneCount = habits.length - doneCount;

    return Scaffold(
      appBar: AppBar(title: const Text('Statistik Habit'), centerTitle: true),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              const Text(
                'Progress Mingguan',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              Expanded(
                child: PieChart(
                  PieChartData(
                    sections: [
                      PieChartSectionData(
                        value: doneCount.toDouble(),
                        color: Colors.green,
                        title: 'Selesai',
                      ),
                      PieChartSectionData(
                        value: notDoneCount.toDouble(),
                        color: Colors.red,
                        title: 'Belum',
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
