import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'add_manual_data_screen.dart';

class TrackerScreen extends StatefulWidget {
  const TrackerScreen({Key? key}) : super(key: key);

  @override
  State<TrackerScreen> createState() => _TrackerScreenState();
}

class _TrackerScreenState extends State<TrackerScreen> {
  List<Map<String, dynamic>> bpData = [];
  bool _isLoading = true;
  // _error variable hata diya
  double _barMaxHeight = 100;
  int _barMaxValue = 180;

  @override
  void initState() {
    super.initState();
    _fetchBPData();
  }

  Future<void> _fetchBPData() async {
    setState(() { _isLoading = true; });
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;
    final snapshot = await FirebaseFirestore.instance
        .collection('bp_tracker')
        .where('userId', isEqualTo: user.uid)
        .orderBy('timestamp', descending: true)
        .orderBy(FieldPath.documentId, descending: true)
        .get();
    setState(() {
      bpData = snapshot.docs.map((doc) {
        final data = doc.data();
        data['id'] = doc.id;
        return data;
      }).toList();
      _isLoading = false;
    });
  }

  Map<String, dynamic> _calculateSummary() {
    if (bpData.isEmpty) {
      return {'systolic': '--', 'diastolic': '--', 'pulse': '--'};
    }
    double systolicSum = 0, diastolicSum = 0, pulseSum = 0;
    int count = 0;
    for (var d in bpData) {
      if (d['systolic'] != null && d['diastolic'] != null && d['pulse'] != null) {
        systolicSum += d['systolic'];
        diastolicSum += d['diastolic'];
        pulseSum += d['pulse'];
        count++;
      }
    }
    if (count == 0) return {'systolic': '--', 'diastolic': '--', 'pulse': '--'};
    return {
      'systolic': (systolicSum / count).round().toString(),
      'diastolic': (diastolicSum / count).round().toString(),
      'pulse': (pulseSum / count).round().toString(),
    };
  }

  List<Map<String, dynamic>> _getChartData() {
    // Last 7 entries (reverse for chart)
    final chartData = bpData.take(7).toList().reversed.toList();
    return chartData;
  }

  @override
  Widget build(BuildContext context) {
    final summary = _calculateSummary();
    final chartData = _getChartData();
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: SafeArea(
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            'Tracker ',
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                          Icon(Icons.bolt, color: Color(0xFF21C17A), size: 24),
                        ],
                      ),
                      const SizedBox(height: 16),
                      // Blood Pressure Title and Icon
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: const [
                                  Text(
                                    'Blood Pressure',
                                    style: TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                    ),
                                  ),
                                  SizedBox(height: 4),
                                  Text(
                                    'Lifetime average summary',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 4.0),
                              child: Icon(Icons.bloodtype, color: Colors.redAccent, size: 48),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                      // Summary Card
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black12,
                                blurRadius: 8,
                                offset: Offset(0, 2),
                              ),
                            ],
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 12),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              _SummaryItem(title: 'Systolic', value: summary['systolic'], unit: 'mmHg'),
                              Container(
                                height: 40,
                                width: 1,
                                color: Colors.grey[300],
                              ),
                              _SummaryItem(title: 'Diastolic', value: summary['diastolic'], unit: 'mmHg'),
                              Container(
                                height: 40,
                                width: 1,
                                color: Colors.grey[300],
                              ),
                              _SummaryItem(title: 'Pulse', value: summary['pulse'], unit: 'BPM'),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      // Chart Card
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black12,
                                blurRadius: 8,
                                offset: Offset(0, 2),
                              ),
                            ],
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 12),
                          child: Column(
                            children: [
                              Text(
                                chartData.isNotEmpty && chartData.first['timestamp'] != null
                                    ? _getChartDateRange(chartData)
                                    : 'No Data',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              const SizedBox(height: 16),
                              SizedBox(
                                height: 160,
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: chartData.isNotEmpty
                                      ? chartData
                                          .map((d) => _BarChartBar(
                                                value: d['systolic'] ?? 0,
                                                label: d['systolic']?.toString() ?? '',
                                                maxValue: _barMaxValue,
                                                maxHeight: _barMaxHeight,
                                              ))
                                          .toList()
                                      : [
                                          for (int i = 0; i < 7; i++)
                                            const _BarChartBar(value: 0, label: '--', maxValue: 180, maxHeight: 100),
                                        ],
                                ),
                              ),
                              const SizedBox(height: 8),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: chartData.isNotEmpty
                                    ? chartData
                                        .map((d) => Text(
                                              _formatTimestamp(d['timestamp']).split('|').first.trim(),
                                              style: const TextStyle(fontSize: 11, color: Colors.grey),
                                            ))
                                        .toList()
                                    : [for (int i = 0; i < 7; i++) const Text('--', style: TextStyle(fontSize: 11, color: Colors.grey))],
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
                      // History Title
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 8.0),
                        child: Text(
                          'History',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      // History List
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4.0),
                        child: Column(
                          children: bpData.isNotEmpty
                              ? bpData
                                  .map((d) => _HistoryCard(
                                        systolic: d['systolic']?.toString() ?? '--',
                                        diastolic: d['diastolic']?.toString() ?? '--',
                                        pulse: d['pulse']?.toString() ?? '--',
                                        status: _getStatus(d['systolic'], d['diastolic']),
                                        contextText: d['note'] ?? '',
                                        date: _formatTimestamp(d['timestamp']),
                                      ))
                                  .toList()
                              : [
                                  const _HistoryCard(
                                    systolic: '--',
                                    diastolic: '--',
                                    pulse: '--',
                                    status: '--',
                                    contextText: '',
                                    date: '--',
                                  ),
                                ],
                        ),
                      ),
                      const SizedBox(height: 24),
                      // Add Manual Data Button
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () async {
                              await Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (_) => const AddManualDataScreen(),
                                ),
                              );
                              _fetchBPData();
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF1856B6),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              elevation: 2,
                            ),
                            child: const Text(
                              'Add Manual Data',
                              style: TextStyle(fontSize: 18, color: Colors.white),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 32),
                    ],
                  ),
                ),
              ),
      ),
    );
  }

  String _formatTimestamp(dynamic timestamp) {
    if (timestamp == null) return '--';
    final dt = timestamp is DateTime
        ? timestamp
        : (timestamp as Timestamp).toDate();
    return '${_monthShort(dt.month)} ${dt.day}, ${dt.year} | ${_formatTime(dt)}';
  }

  String _formatTime(DateTime dt) {
    final hour = dt.hour > 12 ? dt.hour - 12 : dt.hour;
    final ampm = dt.hour >= 12 ? 'PM' : 'AM';
    final min = dt.minute.toString().padLeft(2, '0');
    return '$hour:$min $ampm';
  }

  String _monthShort(int m) {
    const months = [
      '', 'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return months[m];
  }

  String _getStatus(int? sys, int? dia) {
    if (sys == null || dia == null) return '--';
    if (sys < 90 && dia < 60) return 'Hypotension';
    if (sys >= 90 && sys <= 119 && dia >= 60 && dia <= 79) return 'Normal';
    if (sys >= 120 && sys <= 129 && dia >= 60 && dia <= 79) return 'Elevated';
    if (sys >= 130 && sys <= 139 && dia >= 80 && dia <= 89) return 'Stage I';
    if (sys >= 140 && sys <= 180 && dia >= 90 && dia <= 120) return 'Stage II';
    if (sys > 180 && dia > 120) return 'Hypertensive';
    return '--';
  }

  String _getChartDateRange(List<Map<String, dynamic>> chartData) {
    if (chartData.isEmpty) return '';
    final first = chartData.first['timestamp'] as Timestamp?;
    final last = chartData.last['timestamp'] as Timestamp?;
    if (first == null || last == null) return '';
    final fdt = first.toDate();
    final ldt = last.toDate();
    return '${_monthShort(fdt.month)} ${fdt.day} - ${_monthShort(ldt.month)} ${ldt.day}, ${ldt.year}';
  }
}

class _SummaryItem extends StatelessWidget {
  final String title;
  final String value;
  final String unit;
  const _SummaryItem({required this.title, required this.value, required this.unit});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 22, color: Colors.black),
        ),
        const SizedBox(height: 2),
        Text(
          unit,
          style: const TextStyle(fontSize: 13, color: Colors.grey),
        ),
        const SizedBox(height: 6),
        Text(
          title,
          style: const TextStyle(fontSize: 14, color: Colors.black54),
        ),
      ],
    );
  }
}

class _BarChartBar extends StatelessWidget {
  final int value;
  final String label;
  final int maxValue;
  final double maxHeight;
  const _BarChartBar({required this.value, required this.label, this.maxValue = 180, this.maxHeight = 100});

  @override
  Widget build(BuildContext context) {
    final double barHeight = (value > 0 && maxValue > 0) ? (value / maxValue) * maxHeight + 20 : 20;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 6.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Container(
            width: 24,
            height: barHeight,
            decoration: BoxDecoration(
              color: const Color(0xFF21C17A),
              borderRadius: BorderRadius.circular(8),
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 4,
                  offset: Offset(0, 2),
                ),
              ],
            ),
          ),
          const SizedBox(height: 6),
          Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
        ],
      ),
    );
  }
}

class _HistoryCard extends StatelessWidget {
  final String systolic;
  final String diastolic;
  final String pulse;
  final String status;
  final String contextText;
  final String date;
  const _HistoryCard({
    required this.systolic,
    required this.diastolic,
    required this.pulse,
    required this.status,
    required this.contextText,
    required this.date,
  });

  Color _statusColor(String status) {
    switch (status) {
      case 'Normal':
        return const Color(0xFF21C17A);
      case 'Elevated':
        return Colors.orange;
      case 'Stage I':
        return Colors.amber;
      case 'Stage II':
        return Colors.redAccent;
      case 'Hypertensive':
        return Colors.red;
      case 'Hypotension':
        return Colors.blueGrey;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 6,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '$systolic / $diastolic',
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.black),
              ),
              Text('$pulse bpm', style: const TextStyle(fontSize: 13, color: Colors.grey)),
            ],
          ),
          const SizedBox(width: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              color: _statusColor(status),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              status,
              style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (contextText.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 2.0),
                    child: Text(contextText, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500)),
                  ),
                Text(date, style: const TextStyle(fontSize: 12, color: Colors.grey)),
              ],
            ),
          ),
          const Icon(Icons.chevron_right, color: Colors.grey),
        ],
      ),
    );
  }
} 