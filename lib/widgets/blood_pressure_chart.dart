import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class BloodPressureChart extends StatelessWidget {
  final List<double> systolic;
  final List<double> diastolic;
  final List<String> days;
  const BloodPressureChart({Key? key, required this.systolic, required this.diastolic, required this.days}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Blood Pressure', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
        const SizedBox(height: 8),
        SizedBox(
          height: 140,
          child: BarChart(
            BarChartData(
              alignment: BarChartAlignment.spaceAround,
              maxY: 130,
              minY: 40,
              barTouchData: BarTouchData(enabled: false),
              titlesData: FlTitlesData(
                leftTitles: AxisTitles(
                  sideTitles: SideTitles(showTitles: true, reservedSize: 28),
                ),
                rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    getTitlesWidget: (value, meta) {
                      int idx = value.toInt();
                      if (idx >= 0 && idx < days.length) {
                        return Text(days[idx], style: const TextStyle(fontSize: 12));
                      }
                      return const SizedBox.shrink();
                    },
                    reservedSize: 20,
                  ),
                ),
              ),
              gridData: FlGridData(show: true, horizontalInterval: 20),
              borderData: FlBorderData(show: false),
              barGroups: List.generate(systolic.length, (i) {
                return BarChartGroupData(
                  x: i,
                  barRods: [
                    BarChartRodData(
                      toY: systolic[i],
                      fromY: diastolic[i],
                      color: const Color(0xFF1ED760),
                      width: 18,
                      borderRadius: BorderRadius.circular(6),
                    ),
                  ],
                );
              }),
            ),
          ),
        ),
        const SizedBox(height: 8),
        Row(
          children: const [
            Icon(Icons.circle, size: 10, color: Color(0xFF1ED760)),
            SizedBox(width: 4),
            Text('Normal', style: TextStyle(fontSize: 12)),
            SizedBox(width: 12),
            Icon(Icons.circle, size: 10, color: Colors.orange),
            SizedBox(width: 4),
            Text('Elevated', style: TextStyle(fontSize: 12)),
            SizedBox(width: 12),
            Icon(Icons.circle, size: 10, color: Colors.amber),
            SizedBox(width: 4),
            Text('Hypertension, Stage I', style: TextStyle(fontSize: 12)),
          ],
        ),
        const SizedBox(height: 4),
        const Text('Activity: Steps per day or exercise minutes', style: TextStyle(fontSize: 12, color: Colors.black54)),
      ],
    );
  }
} 