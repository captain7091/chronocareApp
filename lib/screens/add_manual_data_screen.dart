import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AddManualDataScreen extends StatefulWidget {
  const AddManualDataScreen({Key? key}) : super(key: key);

  @override
  State<AddManualDataScreen> createState() => _AddManualDataScreenState();
}

class _AddManualDataScreenState extends State<AddManualDataScreen> {
  final _systolicController = TextEditingController();
  final _diastolicController = TextEditingController();
  final _pulseController = TextEditingController();
  final _noteController = TextEditingController();
  bool _isSaving = false;

  @override
  void dispose() {
    _systolicController.dispose();
    _diastolicController.dispose();
    _pulseController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  Future<void> _saveData() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;
    final systolic = int.tryParse(_systolicController.text.trim());
    final diastolic = int.tryParse(_diastolicController.text.trim());
    final pulse = int.tryParse(_pulseController.text.trim());
    final note = _noteController.text.trim();
    if (systolic == null || diastolic == null || pulse == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter valid numbers for all fields.'), backgroundColor: Colors.red),
      );
      return;
    }
    setState(() { _isSaving = true; });
    await FirebaseFirestore.instance.collection('bp_tracker').add({
      'userId': user.uid,
      'systolic': systolic,
      'diastolic': diastolic,
      'pulse': pulse,
      'note': note,
      'timestamp': FieldValue.serverTimestamp(),
    });
    setState(() { _isSaving = false; });
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Data saved successfully!'), backgroundColor: Colors.green),
      );
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 8),
                // AppBar Row
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                    const Expanded(
                      child: Center(
                        child: Text(
                          'Add Manual Data',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 22,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 40), // To balance the back button
                  ],
                ),
                const SizedBox(height: 8),
                // Date and Time Row (auto, for now)
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '${DateTime.now().month}/${DateTime.now().day}',
                      style: const TextStyle(fontSize: 15, color: Colors.black54),
                    ),
                    const SizedBox(width: 8),
                    const Text('|', style: TextStyle(fontSize: 15, color: Colors.black26)),
                    const SizedBox(width: 8),
                    Text(
                      TimeOfDay.now().format(context),
                      style: const TextStyle(fontSize: 15, color: Colors.black54),
                    ),
                    const SizedBox(width: 8),
                    const Icon(Icons.keyboard_arrow_down, color: Color(0xFF21C17A)),
                  ],
                ),
                const SizedBox(height: 16),
                // Input Card
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 8),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _InputValueField(
                        title: 'Systolic',
                        controller: _systolicController,
                        unit: 'mmHg',
                      ),
                      _InputValueField(
                        title: 'Diastolic',
                        controller: _diastolicController,
                        unit: 'mmHg',
                      ),
                      _InputValueField(
                        title: 'Pulse',
                        controller: _pulseController,
                        unit: 'BPM',
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                // Note
                const Text('Note', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: TextField(
                    controller: _noteController,
                    maxLines: 3,
                    maxLength: 100,
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Add your note here',
                      counterText: '',
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                // Normal Info Card (unchanged)
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Normal', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          _LegendDot(color: Color(0xFF4EC6E0)),
                          _LegendDot(color: Color(0xFF21C17A)),
                          _LegendDot(color: Color(0xFFF6C244)),
                          _LegendDot(color: Color(0xFFF89B4B)),
                          _LegendDot(color: Color(0xFFE05A4E)),
                        ],
                      ),
                      const SizedBox(height: 8),
                      _LegendRow(label: 'Hypotension', value: 'SYS < 90 & DIA < 60', color: Color(0xFF4EC6E0)),
                      _LegendRow(label: 'Normal', value: 'SYS 90–119 & DIA 60–79', color: Color(0xFF21C17A), bold: true),
                      _LegendRow(label: 'Elevated', value: 'SYS 120–129 & DIA 60–79', color: Color(0xFFF6C244)),
                      _LegendRow(label: 'Hypertension, Stage I', value: 'SYS 130–139 & DIA 80–89', color: Color(0xFFF89B4B)),
                      _LegendRow(label: 'Hypertension, Stage 2', value: 'SYS 140–180 & DIA 90–120', color: Color(0xFFE05A4E)),
                      _LegendRow(label: 'Hypertensive', value: 'SYS > 180 & DIA > 120', color: Color(0xFFE05A4E)),
                    ],
                  ),
                ),
                const SizedBox(height: 32),
                // Save Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _isSaving ? null : _saveData,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF1856B6),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    child: _isSaving
                        ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                        : const Text(
                            'Save',
                            style: TextStyle(fontSize: 18, color: Colors.white),
                          ),
                  ),
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _InputValueField extends StatelessWidget {
  final String title;
  final TextEditingController controller;
  final String unit;
  const _InputValueField({required this.title, required this.controller, required this.unit});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(title, style: const TextStyle(fontSize: 15, color: Colors.black54)),
        const SizedBox(height: 4),
        SizedBox(
          width: 60,
          child: TextField(
            controller: controller,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              isDense: true,
              contentPadding: EdgeInsets.symmetric(vertical: 8, horizontal: 8),
            ),
          ),
        ),
        const SizedBox(height: 2),
        Text(unit, style: const TextStyle(fontSize: 13, color: Colors.grey)),
      ],
    );
  }
}

class _LegendDot extends StatelessWidget {
  final Color color;
  const _LegendDot({required this.color});
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(right: 8),
      width: 24,
      height: 8,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(4),
      ),
    );
  }
}

class _LegendRow extends StatelessWidget {
  final String label;
  final String value;
  final Color color;
  final bool bold;
  const _LegendRow({required this.label, required this.value, required this.color, this.bold = false});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2.0),
      child: Row(
        children: [
          Container(
            width: 10,
            height: 10,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 8),
          Text(
            label,
            style: TextStyle(fontSize: 14, fontWeight: bold ? FontWeight.bold : FontWeight.normal),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              value,
              style: TextStyle(fontSize: 13, color: Colors.black54, fontWeight: bold ? FontWeight.bold : FontWeight.normal),
              textAlign: TextAlign.right,
            ),
          ),
        ],
      ),
    );
  }
} 