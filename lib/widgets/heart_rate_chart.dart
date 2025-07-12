import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class HeartRateChart extends StatelessWidget {
  const HeartRateChart({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List<double> heartRates = [85, 72, 80, 78, 90, 88, 84];
    final List<String> days = ['16', '17', '18', '19', '20', '21', '22'];
    final int highlightIndex = 1; // 17th, value 72

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Hart Rate (bpm)', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
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
          child: LineChart(
            LineChartData(
              minY: 0,
              maxY: 110,
              gridData: FlGridData(show: true, horizontalInterval: 20),
              borderData: FlBorderData(show: false),
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
              lineBarsData: [
                LineChartBarData(
                  spots: List.generate(heartRates.length, (i) => FlSpot(i.toDouble(), heartRates[i])),
                  isCurved: true,
                  color: const Color(0xFF1565C0),
                  barWidth: 3,
                  isStrokeCapRound: true,
                  belowBarData: BarAreaData(
                    show: true,
                    gradient: LinearGradient(
                      colors: [
                        const Color(0xFF1565C0).withOpacity(0.4),
                        const Color(0xFF1565C0).withOpacity(0.05),
                      ],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                  ),
                  dotData: FlDotData(
                    show: true,
                    getDotPainter: (spot, percent, bar, index) {
                      return FlDotCirclePainter(
                        radius: 5,
                        color: Colors.white,
                        strokeWidth: 3,
                        strokeColor: const Color(0xFF1565C0),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
        // Highlighted value above the dot
        Stack(
          children: [
            SizedBox(height: 0),
            Positioned(
              left: 18.0 + highlightIndex * 38.0, // Adjust for dot position
              top: 0,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: Color(0xFF1565C0), width: 2),
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
                  heartRates[highlightIndex].toInt().toString(),
                  style: const TextStyle(
                    color: Color(0xFF1565C0),
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