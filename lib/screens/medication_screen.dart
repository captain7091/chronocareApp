import 'package:flutter/material.dart';

class MedicationScreen extends StatelessWidget {
  const MedicationScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Example medication data
    final medications = [
      {
        'name': 'Diuretics',
        'type': 'Injection',
        'days': 'Mon, Wed, Fri',
        'time': '10:00 AM',
      },
      {
        'name': 'Alfuzosin 10 Mg',
        'type': 'Medicine',
        'days': 'Mon, Wed, Fri',
        'time': '10:00 AM',
      },
      {
        'name': 'Lodoz 2.5 Tablet',
        'type': 'Medicine',
        'days': 'Mon, Wed, Fri',
        'time': '10:00 AM',
      },
      {
        'name': 'Amlovas-5',
        'type': 'Medicine',
        'days': 'Mon, Wed, Fri',
        'time': '10:00 AM',
      },
      {
        'name': 'DR Prol 50',
        'type': 'Medicine',
        'days': 'Mon, Wed, Fri',
        'time': '10:00 AM',
      },
    ];

    return Container(
      color: const Color(0xFFF8FAFC),
      child: Column(
        children: [
          const SizedBox(height: 32),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.0),
            child: Align(
              alignment: Alignment.center,
              child: Text(
                'My Medication',
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 22,
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 90),
              itemCount: medications.length,
              itemBuilder: (context, index) {
                final med = medications[index];
                return _MedicationCard(
                  name: med['name']!,
                  type: med['type']!,
                  days: med['days']!,
                  time: med['time']!,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _MedicationCard extends StatelessWidget {
  final String name;
  final String type;
  final String days;
  final String time;

  const _MedicationCard({
    required this.name,
    required this.type,
    required this.days,
    required this.time,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: const Color(0xFFE3F2FD),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.medication, size: 36, color: Color(0xFF1856B6)),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.radio_button_checked, color: Color(0xFFFFC700), size: 18),
                    const SizedBox(width: 4),
                    Text(
                      name,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text('Type: $type', style: const TextStyle(fontSize: 13, color: Colors.black87)),
                Text('Days: $days', style: const TextStyle(fontSize: 13, color: Colors.black87)),
                Text('Time: $time', style: const TextStyle(fontSize: 13, color: Colors.black87)),
              ],
            ),
          ),
          const SizedBox(width: 8),
          IconButton(
            icon: const Icon(Icons.edit, color: Color(0xFF21C17A), size: 26),
            onPressed: () {},
          ),
        ],
      ),
    );
  }
} 