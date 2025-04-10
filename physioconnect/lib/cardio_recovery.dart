// ignore_for_file: avoid_print

import 'package:flutter/material.dart';

class CardioRecoveryScreen extends StatefulWidget {
  const CardioRecoveryScreen({super.key});

  @override
  State<CardioRecoveryScreen> createState() => _CardioRecoveryScreenState();
}

class _CardioRecoveryScreenState extends State<CardioRecoveryScreen> {
  List<dynamic> workouts = [];
  
  bool? get kDebugMode => null;

  @override
  void initState() {
    super.initState();
    fetchCardioWorkouts();
  }

  Future<void> fetchCardioWorkouts() async {
    Uri.parse('http://localhost:5000/api/cardio-workouts'); // Replace with actual IP on real device
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF33724B),
        title: const Text("Cardio for Safe Recovery"),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: workouts.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemCount: workouts.length,
        itemBuilder: (context, index) {
          final workout = workouts[index];
          return _buildExerciseStep(
            workout['title'],
            workout['description'],
            workout['instructions'],
          );
        },
      ),
    );
  }

  Widget _buildExerciseStep(String title, String description, String instructions) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(Icons.check_circle, color: Color(0xFF33724B)),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  ),
                ],
              ),
              const SizedBox(height: 5),
              Text(description, style: const TextStyle(fontSize: 14, color: Colors.black87)),
              const SizedBox(height: 5),
              Text(instructions, style: const TextStyle(fontSize: 13, color: Colors.black54)),
            ],
          ),
        ),
      ),
    );
  }
}
