import 'package:flutter/material.dart';
import '../../widgets/blood_pressure_chart.dart';
import '../../widgets/blood_sugar_chart.dart';
import '../../widgets/heart_rate_chart.dart';
import '../../widgets/activity_chart.dart';
import '../../widgets/bmi_chart.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 16),
                Center(
                  child: RichText(
                    text: const TextSpan(
                      style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, letterSpacing: 1),
                      children: [
                        TextSpan(text: 'Chrono', style: TextStyle(color: Color(0xFF1ED760))),
                        TextSpan(text: 'Care', style: TextStyle(color: Color(0xFF0A4DA2))),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                // Profile Card
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    children: [
                      const CircleAvatar(
                        radius: 28,
                        backgroundImage: AssetImage('assets/mike_hussey.png'),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            Text('Mike Hussey', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                            SizedBox(height: 2),
                            Text('Diabetic + Hypertensive', style: TextStyle(fontSize: 13, color: Colors.black54)),
                            SizedBox(height: 2),
                            Text('18 June, 2025  |  11:00 AM', style: TextStyle(fontSize: 12, color: Colors.black38)),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: Color(0xFF1ED760),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Text('Stable', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12)),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                // Blood Pressure Graph
                Container(
                  width: double.infinity,
                  margin: const EdgeInsets.only(bottom: 16),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const BloodPressureChart(),
                ),
                // Blood Sugar Graph
                Container(
                  width: double.infinity,
                  margin: const EdgeInsets.only(bottom: 16),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const BloodSugarChart(),
                ),
                // Heart Rate Graph
                Container(
                  width: double.infinity,
                  margin: const EdgeInsets.only(bottom: 16),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const HeartRateChart(),
                ),
                // Activity Graph
                Container(
                  width: double.infinity,
                  margin: const EdgeInsets.only(bottom: 16),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const ActivityChart(),
                ),
                // BMI Graph
                Container(
                  width: double.infinity,
                  margin: const EdgeInsets.only(bottom: 16),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const BMIChart(),
                ),
                // Add more graph placeholders as needed
              ],
            ),
          ),
        ),
      ),
    );
  }
} 