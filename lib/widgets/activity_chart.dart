import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class ActivityChart extends StatelessWidget {
  const ActivityChart({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List<double> steps = [4000, 5200, 800, 4100, 3000, 5000, 6000];
    final List<String> days = ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'];
    final int average = 2890;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Activity', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Icon(Icons.chevron_left, color: Colors.black54),
            const Text('June 18 – June 24, 2025', style: TextStyle(fontWeight: FontWeight.w500)),
            Icon(Icons.chevron_right, color: Colors.black54),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text('Average ', style: TextStyle(fontWeight: FontWeight.w500, fontSize: 18, color: Colors.black)),
            Text('$average', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24, color: Color(0xFFFF7043))),
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