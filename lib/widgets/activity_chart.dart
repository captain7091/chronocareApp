import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class ActivityChart extends StatelessWidget {
  final List<double> steps;
  final List<String> days;
  const ActivityChart({Key? key, required this.steps, required this.days}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final int average = steps.isNotEmpty ? (steps.reduce((a, b) => a + b) ~/ steps.length) : 0;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Activity', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
        const SizedBox(height: 8),
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            const Text('Average ', style: TextStyle(fontWeight: FontWeight.w500, fontSize: 18, color: Colors.black)),
            Text('$average', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 24, color: Color(0xFFFF7043))),
            const Text(' Steps', style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16, color: Colors.black)),
          ],
        ),
        const SizedBox(height: 8),
        SizedBox(
          height: 140,
          child: BarChart(
            BarChartData(
              alignment: BarChartAlignment.spaceAround,
              maxY: 6500,
              minY: 0,
              barTouchData: BarTouchData(enabled: false),
              titlesData: FlTitlesData(
                leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                rightTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: 40,
                    getTitlesWidget: (value, meta) {
                      if (value % 2000 == 0) {
                        return Text(value.toInt().toString(), style: const TextStyle(fontSize: 12));
                      }
                      return const SizedBox.shrink();
                    },
                  ),
                ),
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
              gridData: FlGridData(show: true, horizontalInterval: 2000),
              borderData: FlBorderData(show: false),
              barGroups: List.generate(steps.length, (i) {
                return BarChartGroupData(
                  x: i,
                  barRods: [
                    BarChartRodData(
                      toY: steps[i],
                      color: const Color(0xFFFF7043),
                      width: 18,
                      borderRadius: BorderRadius.circular(6),
                    ),
                  ],
                );
              }),
            ),
          ),
        ),
      ],
    );
  }
} 