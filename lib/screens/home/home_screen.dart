import 'dart:math';
import 'package:flutter/material.dart';
import '../../widgets/blood_pressure_chart.dart';
import '../../widgets/blood_sugar_chart.dart';
import '../../widgets/heart_rate_chart.dart';
import '../../widgets/activity_chart.dart';
import '../../widgets/bmi_chart.dart';
import 'package:provider/provider.dart';
import 'package:chronocare_app/providers/auth_provider.dart' as my_auth;

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  DateTime _startDate = DateTime(2025, 6, 18);
  DateTime _endDate = DateTime(2025, 6, 24);

  late List<double> _systolic;
  late List<double> _diastolic;
  late List<String> _bpDays;

  late List<double> _sugarLevels;
  late List<String> _sugarDays;

  late List<double> _heartRates;
  late List<String> _hrDays;

  late List<double> _steps;
  late List<String> _activityDays;

  late List<double> _bmiValues;
  late List<String> _bmiDays;

  @override
  void initState() {
    super.initState();
    _generateDummyData();
  }

  void _generateDummyData() {
    final rand = Random();
    _bpDays = List.generate(7, (i) => _startDate.add(Duration(days: i)).day.toString());
    _systolic = List.generate(7, (_) => 100 + rand.nextInt(30).toDouble());
    _diastolic = List.generate(7, (_) => 60 + rand.nextInt(15).toDouble());

    _sugarDays = List.generate(7, (i) => _startDate.add(Duration(days: i)).day.toString());
    _sugarLevels = List.generate(7, (_) => 90 + rand.nextInt(60).toDouble());

    _hrDays = List.generate(7, (i) => _startDate.add(Duration(days: i)).day.toString());
    _heartRates = List.generate(7, (_) => 70 + rand.nextInt(40).toDouble());

    _activityDays = ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'];
    _steps = List.generate(7, (_) => 800 + rand.nextInt(6000).toDouble());

    _bmiDays = List.generate(7, (i) => _startDate.add(Duration(days: i)).day.toString());
    _bmiValues = List.generate(7, (_) => 70 + rand.nextInt(40).toDouble());
  }

  void _changeDateRange(int direction) {
    setState(() {
      _startDate = _startDate.add(Duration(days: 7 * direction));
      _endDate = _endDate.add(Duration(days: 7 * direction));
      _generateDummyData();
    });
  }

  @override
  Widget build(BuildContext context) {
    final name = Provider.of<my_auth.AuthProvider>(context).displayName;
    String dateRangeLabel = '${_startDate.month}/${_startDate.day} – ${_endDate.month}/${_endDate.day}, ${_endDate.year}';
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
                          children: [
                            Text(name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                            const SizedBox(height: 2),
                            const Text('Diabetic + Hypertensive', style: TextStyle(fontSize: 13, color: Colors.black54)),
                            const SizedBox(height: 2),
                            Text(dateRangeLabel, style: const TextStyle(fontSize: 12, color: Colors.black38)),
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
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.chevron_left, color: Colors.black54),
                            onPressed: () => _changeDateRange(-1),
                          ),
                          Text(dateRangeLabel, style: const TextStyle(fontWeight: FontWeight.w500)),
                          IconButton(
                            icon: const Icon(Icons.chevron_right, color: Colors.black54),
                            onPressed: () => _changeDateRange(1),
                          ),
                        ],
                      ),
                      BloodPressureChart(systolic: _systolic, diastolic: _diastolic, days: _bpDays),
                    ],
                  ),
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
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.chevron_left, color: Colors.black54),
                            onPressed: () => _changeDateRange(-1),
                          ),
                          Text(dateRangeLabel, style: const TextStyle(fontWeight: FontWeight.w500)),
                          IconButton(
                            icon: const Icon(Icons.chevron_right, color: Colors.black54),
                            onPressed: () => _changeDateRange(1),
                          ),
                        ],
                      ),
                      BloodSugarChart(sugarLevels: _sugarLevels, days: _sugarDays),
                    ],
                  ),
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
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.chevron_left, color: Colors.black54),
                            onPressed: () => _changeDateRange(-1),
                          ),
                          Text(dateRangeLabel, style: const TextStyle(fontWeight: FontWeight.w500)),
                          IconButton(
                            icon: const Icon(Icons.chevron_right, color: Colors.black54),
                            onPressed: () => _changeDateRange(1),
                          ),
                        ],
                      ),
                      HeartRateChart(heartRates: _heartRates, days: _hrDays),
                    ],
                  ),
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
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.chevron_left, color: Colors.black54),
                            onPressed: () => _changeDateRange(-1),
                          ),
                          Text(dateRangeLabel, style: const TextStyle(fontWeight: FontWeight.w500)),
                          IconButton(
                            icon: const Icon(Icons.chevron_right, color: Colors.black54),
                            onPressed: () => _changeDateRange(1),
                          ),
                        ],
                      ),
                      ActivityChart(steps: _steps, days: _activityDays),
                    ],
                  ),
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
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.chevron_left, color: Colors.black54),
                            onPressed: () => _changeDateRange(-1),
                          ),
                          Text(dateRangeLabel, style: const TextStyle(fontWeight: FontWeight.w500)),
                          IconButton(
                            icon: const Icon(Icons.chevron_right, color: Colors.black54),
                            onPressed: () => _changeDateRange(1),
                          ),
                        ],
                      ),
                      BMIChart(bmiValues: _bmiValues, days: _bmiDays),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
} 