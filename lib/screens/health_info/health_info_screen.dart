import 'package:flutter/material.dart';
import '../main_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class HealthInfoScreen extends StatefulWidget {
  const HealthInfoScreen({Key? key}) : super(key: key);

  @override
  State<HealthInfoScreen> createState() => _HealthInfoScreenState();
}

class _HealthInfoScreenState extends State<HealthInfoScreen> {
  final TextEditingController _healthInfoController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  String? _selectedGender;
  List<String> _selectedConditions = [];
  bool _isSaving = false;
  String? _errorMessage;

  final List<String> _genders = ['Male', 'Female', 'Other'];
  final List<String> _conditions = [
    'Diabetes',
    'Hypertension',
    'Heart Disease',
    'Asthma',
    'Other',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        toolbarHeight: 0, // Hide default appbar
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8),
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
              const Center(
                child: Text(
                  'Health Information',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.black),
                ),
              ),
              const SizedBox(height: 24),
              const Text('Health Info', style: TextStyle(fontWeight: FontWeight.w500)),
              const SizedBox(height: 8),
              TextField(
                controller: _healthInfoController,
                maxLines: 4,
                maxLength: 100,
                decoration: InputDecoration(
                  hintText: 'Write your health info',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  contentPadding: const EdgeInsets.all(16),
                  counterText: '',
                  filled: true,
                  fillColor: Colors.white,
                ),
              ),
              const SizedBox(height: 16),
              const Text('Age', style: TextStyle(fontWeight: FontWeight.w500)),
              const SizedBox(height: 8),
              TextField(
                controller: _ageController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  hintText: 'Enter your age',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                ),
              ),
              const SizedBox(height: 16),
              const Text('Gender', style: TextStyle(fontWeight: FontWeight.w500)),
              const SizedBox(height: 8),
              DropdownButtonFormField<String>(
                value: _selectedGender,
                items: _genders
                    .map((gender) => DropdownMenuItem(
                          value: gender,
                          child: Text(gender),
                        ))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedGender = value;
                  });
                },
                decoration: InputDecoration(
                  hintText: 'Select gender',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                ),
              ),
              const SizedBox(height: 16),
              const Text('Known Conditions', style: TextStyle(fontWeight: FontWeight.w500)),
              const SizedBox(height: 8),
              DropdownButtonFormField<String>(
                value: _selectedConditions.isEmpty ? null : _selectedConditions.first,
                items: _conditions
                    .map((condition) => DropdownMenuItem<String>(
                          value: condition,
                          child: Text(condition),
                        ))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedConditions = value != null ? [value] : [];
                  });
                },
                isExpanded: true,
                decoration: InputDecoration(
                  hintText: 'Select conditions',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                ),
              ),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isSaving ? null : () async {
                    setState(() {
                      _isSaving = true;
                      _errorMessage = null;
                    });
                    try {
                      final user = FirebaseAuth.instance.currentUser;
                      if (user == null) {
                        setState(() {
                          _errorMessage = 'User not logged in.';
                          _isSaving = false;
                        });
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('User not logged in.'), backgroundColor: Colors.red),
                        );
                        return;
                      }
                      await FirebaseFirestore.instance.collection('health_information').doc(user.uid).set({
                        'healthInfo': _healthInfoController.text.trim(),
                        'age': int.tryParse(_ageController.text.trim()),
                        'gender': _selectedGender,
                        'conditions': _selectedConditions,
                        'updatedAt': FieldValue.serverTimestamp(),
                      });
                      if (mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Health information saved successfully!'), backgroundColor: Colors.green),
                        );
                        Navigator.of(context).pushAndRemoveUntil(
                          MaterialPageRoute(builder: (_) => const MainScreen()),
                          (route) => false,
                        );
                      }
                    } catch (e) {
                      setState(() {
                        _errorMessage = 'Failed to save health information.';
                        _isSaving = false;
                      });
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(_errorMessage ?? 'Failed to save health information.'), backgroundColor: Colors.red),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF0A4DA2),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: _isSaving
                      ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                      : const Text('Save & Update', style: TextStyle(fontSize: 18, color: Colors.white)),
                ),
              ),
              if (_errorMessage != null)
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Text(
                    _errorMessage!,
                    style: const TextStyle(color: Colors.red, fontSize: 14),
                  ),
                ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
} 