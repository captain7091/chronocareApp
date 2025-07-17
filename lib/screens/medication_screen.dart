import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class MedicationScreen extends StatefulWidget {
  const MedicationScreen({Key? key}) : super(key: key);

  @override
  State<MedicationScreen> createState() => _MedicationScreenState();
}

class _MedicationScreenState extends State<MedicationScreen> {
  List<Map<String, dynamic>> medications = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchMedications();
  }

  Future<void> _fetchMedications() async {
    setState(() { _isLoading = true; });
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;
    final snapshot = await FirebaseFirestore.instance
        .collection('medications')
        .where('userId', isEqualTo: user.uid)
        .get();
    setState(() {
      medications = snapshot.docs.map((doc) {
        final data = doc.data();
        data['id'] = doc.id;
        return data;
      }).toList();
      _isLoading = false;
    });
  }

  Future<void> _addMedication(Map<String, dynamic> med) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;
    final docRef = await FirebaseFirestore.instance.collection('medications').add({
      ...med,
      'userId': user.uid,
      'createdAt': FieldValue.serverTimestamp(),
    });
    med['id'] = docRef.id;
    setState(() {
      medications.add(med);
    });
  }

  Future<void> _updateMedication(int index, Map<String, dynamic> med) async {
    final id = medications[index]['id'];
    await FirebaseFirestore.instance.collection('medications').doc(id).update(med);
    setState(() {
      medications[index] = { ...med, 'id': id };
    });
  }

  void _showAddMedicationDialog() {
    final _nameController = TextEditingController();
    final _typeController = TextEditingController();
    final _daysController = TextEditingController();
    final _timeController = TextEditingController();
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Add Medication'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: _nameController,
                  decoration: const InputDecoration(labelText: 'Name'),
                ),
                TextField(
                  controller: _typeController,
                  decoration: const InputDecoration(labelText: 'Type'),
                ),
                TextField(
                  controller: _daysController,
                  decoration: const InputDecoration(labelText: 'Days (e.g. Mon, Wed, Fri)'),
                ),
                TextField(
                  controller: _timeController,
                  decoration: const InputDecoration(labelText: 'Time (e.g. 10:00 AM)'),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () async {
                if (_nameController.text.isNotEmpty &&
                    _typeController.text.isNotEmpty &&
                    _daysController.text.isNotEmpty &&
                    _timeController.text.isNotEmpty) {
                  final med = {
                    'name': _nameController.text,
                    'type': _typeController.text,
                    'days': _daysController.text,
                    'time': _timeController.text,
                  };
                  await _addMedication(med);
                  Navigator.of(context).pop();
                }
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }

  void _showEditMedicationDialog(int index) {
    final med = medications[index];
    final _nameController = TextEditingController(text: med['name']);
    final _typeController = TextEditingController(text: med['type']);
    final _daysController = TextEditingController(text: med['days']);
    final _timeController = TextEditingController(text: med['time']);
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Edit Medication'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: _nameController,
                  decoration: const InputDecoration(labelText: 'Name'),
                ),
                TextField(
                  controller: _typeController,
                  decoration: const InputDecoration(labelText: 'Type'),
                ),
                TextField(
                  controller: _daysController,
                  decoration: const InputDecoration(labelText: 'Days (e.g. Mon, Wed, Fri)'),
                ),
                TextField(
                  controller: _timeController,
                  decoration: const InputDecoration(labelText: 'Time (e.g. 10:00 AM)'),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () async {
                if (_nameController.text.isNotEmpty &&
                    _typeController.text.isNotEmpty &&
                    _daysController.text.isNotEmpty &&
                    _timeController.text.isNotEmpty) {
                  final med = {
                    'name': _nameController.text,
                    'type': _typeController.text,
                    'days': _daysController.text,
                    'time': _timeController.text,
                  };
                  await _updateMedication(index, med);
                  Navigator.of(context).pop();
                }
              },
              child: const Text('Update'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: Column(
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
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : ListView.builder(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 90),
                    itemCount: medications.length,
                    itemBuilder: (context, index) {
                      final med = medications[index];
                      return _MedicationCard(
                        name: med['name'] ?? '',
                        type: med['type'] ?? '',
                        days: med['days'] ?? '',
                        time: med['time'] ?? '',
                        onEdit: () => _showEditMedicationDialog(index),
                      );
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddMedicationDialog,
        backgroundColor: const Color(0xFF1856B6),
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}

class _MedicationCard extends StatelessWidget {
  final String name;
  final String type;
  final String days;
  final String time;
  final VoidCallback? onEdit;

  const _MedicationCard({
    required this.name,
    required this.type,
    required this.days,
    required this.time,
    this.onEdit,
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
            onPressed: onEdit,
          ),
        ],
      ),
    );
  }
} 