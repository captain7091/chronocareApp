import 'package:flutter/material.dart';
import 'add_manual_data_screen.dart';

class TrackerScreen extends StatelessWidget {
  const TrackerScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Top AppBar-like section
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
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
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
                    // Placeholder for blood drop icon
                    Padding(
                      padding: EdgeInsets.only(top: 4.0),
                      child: Icon(Icons.bloodtype, color: Colors.redAccent, size: 48),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              // Summary Card
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 12),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: const [
                      _SummaryItem(title: 'Systolic', value: '105', unit: 'mmHg'),
                      _SummaryItem(title: 'Diastolic', value: '73', unit: 'mmHg'),
                      _SummaryItem(title: 'Pulse', value: '76', unit: 'BPM'),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              // Chart Card
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 12),
                  child: Column(
                    children: [
                      const Text(
                        'June 18 - June 24, 2025',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 16),
                      SizedBox(
                        height: 120,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            _BarChartBar(value: 100, label: '65'),
                            _BarChartBar(value: 116, label: '65'),
                            _BarChartBar(value: 116, label: '64'),
                            _BarChartBar(value: 99, label: '60'),
                            _BarChartBar(value: 105, label: '63'),
                            _BarChartBar(value: 101, label: '61'),
                            _BarChartBar(value: 110, label: '61'),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
              // History Title
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.0),
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
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Column(
                  children: const [
                    _HistoryCard(
                      systolic: '104',
                      diastolic: '78',
                      pulse: '72',
                      status: 'Normal',
                      contextText: 'Relaxing',
                      date: 'Jun 18, 2025 | 10:44 AM',
                    ),
                    _HistoryCard(
                      systolic: '110',
                      diastolic: '80',
                      pulse: '72',
                      status: 'Normal',
                      contextText: 'Sitting',
                      date: 'Jun 17, 2025 | 9:20 AM',
                    ),
                    _HistoryCard(
                      systolic: '105',
                      diastolic: '74',
                      pulse: '72',
                      status: 'Normal',
                      contextText: 'At Work',
                      date: 'Jun 16, 2025 | 11:18 AM',
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              // Add Manual Data Button
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.0),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => const AddManualDataScreen(),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF1856B6),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 16),
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
    );
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
  const _BarChartBar({required this.value, required this.label});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Container(
          width: 18,
          height: (value * 1.0),
          decoration: BoxDecoration(
            color: const Color(0xFF21C17A),
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        const SizedBox(height: 6),
        Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
      ],
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

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
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
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
            decoration: BoxDecoration(
              color: const Color(0xFF21C17A),
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
                Text(contextText, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500)),
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