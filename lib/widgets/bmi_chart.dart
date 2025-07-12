import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class BMIChart extends StatelessWidget {
  const BMIChart({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List<double> bmiValues = [70, 110, 90, 100, 80, 100, 95];
    final List<String> days = ['16', '17', '18', '19', '20', '21', '22'];
    final int highlightIndex = 1; // 17th, value 110

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('BMI', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
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
        SizedBox(
          height: 140,
          child: BarChart(
            BarChartData(
              alignment: BarChartAlignment.spaceAround,
              maxY: 110,
              minY: 0,
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
              barGroups: List.generate(bmiValues.length, (i) {
                final isHighlight = i == highlightIndex;
                return BarChartGroupData(
                  x: i,
                  barRods: [
                    BarChartRodData(
                      toY: bmiValues[i],
                      color: isHighlight ? const Color(0xFFFFEB3B) : const Color(0xFFFFF59D),
                      width: 18,
                      borderRadius: BorderRadius.circular(6),
                    ),
                  ],
                );
              }),
            ),
          ),
        ),
        // Highlighted value above the bar
        Stack(
          children: [
            SizedBox(height: 0),
            Positioned(
              left: 18.0 + highlightIndex * 38.0, // Adjust for bar position
              top: 0,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: Color(0xFFFFEB3B), width: 2),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 4,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: Text(
                  bmiValues[highlightIndex].toInt().toString(),
                  style: const TextStyle(
                    color: Color(0xFFFBC02D),
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
} 