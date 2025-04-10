import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;

class BalanceStabilityScreen extends StatefulWidget {
  const BalanceStabilityScreen({super.key});

  @override
  State<BalanceStabilityScreen> createState() => _BalanceStabilityScreenState();
}

class _BalanceStabilityScreenState extends State<BalanceStabilityScreen> {
  List<dynamic> workouts = [];

  @override
  void initState() {
    super.initState();
    fetchBalanceWorkouts();
  }

  Future<void> fetchBalanceWorkouts() async {
    // Comment out HTTP request and use mock data
    /*
    final uri = Uri.parse('http://localhost:5000/api/balance-workouts'); // Use actual IP on real device
    try {
      final response = await http.get(uri);
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          workouts = data;
        });
      } else {
        if (kDebugMode) {
          if (kDebugMode) {
            print("Failed to load balance workouts: ${response.statusCode}");
          }
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print("Error fetching balance workouts: $e");
      }
    }
    */
    
    // Use mock data instead
    setState(() {
      workouts = [
        {
          "title": "Single Leg Stand",
          "description": "Improves balance and stability by focusing on one leg at a time.",
          "instructions": "Stand on one foot for 30 seconds, then switch. Try to maintain proper posture throughout."
        },
        {
          "title": "Balance Board Exercises",
          "description": "Challenges your stability using an unstable surface.",
          "instructions": "Start with 30 seconds of balancing, gradually increase to 60 seconds as ability improves."
        },
        {
          "title": "Heel-to-Toe Walk",
          "description": "Improves balance and coordination with controlled movement.",
          "instructions": "Walk in a straight line, placing the heel of one foot directly in front of the toes of the other foot."
        },
        {
          "title": "Standing Yoga Poses",
          "description": "Tree pose, warrior III, and eagle pose all improve balance.",
          "instructions": "Hold each pose for 30 seconds, focus on a fixed point to help maintain balance."
        },
        {
          "title": "Stability Ball Sits",
          "description": "Engages core muscles while challenging balance.",
          "instructions": "Sit on a stability ball with feet flat on the floor, gradually lift feet off the ground as stability improves."
        }
      ];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF33724B),
        title: const Text("Balance & Stability Training"),
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