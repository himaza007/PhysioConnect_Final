// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;

class FlexibilityMobilityScreen extends StatefulWidget {
  const FlexibilityMobilityScreen({super.key});

  @override
  State<FlexibilityMobilityScreen> createState() => _FlexibilityMobilityScreenState();
}

class _FlexibilityMobilityScreenState extends State<FlexibilityMobilityScreen> {
  List<dynamic> workouts = [];

  @override
  void initState() {
    super.initState();
    fetchFlexibilityWorkouts();
  }

  Future<void> fetchFlexibilityWorkouts() async {
    // Comment out HTTP request and use mock data instead
    /*
    final uri = Uri.parse('http://192.168.8.140:5000/api/flexibility-workouts'); // Use your IP
    try {
      final response = await http.get(uri);
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          workouts = data;
        });
      } else {
        // Handle error
      }
    } catch (e) {
      // Handle exception
    }
    */
    
    // Use mock data instead
    setState(() {
      workouts = [
        {
          "id": 1,
          "title": "Joint Mobility Routine",
          "description": "Gentle movements to increase range of motion in major joints",
          "duration": "15 minutes",
          "difficulty": "Beginner",
          "exercises": [
            "Neck rotations - 10 each direction",
            "Shoulder circles - 12 each direction",
            "Wrist circles - 10 each direction",
            "Hip circles - 8 each direction",
            "Ankle rotations - 10 each direction"
          ]
        },
        {
          "id": 2,
          "title": "Full Body Flexibility",
          "description": "Comprehensive stretching routine for all major muscle groups",
          "duration": "25 minutes",
          "difficulty": "Intermediate",
          "exercises": [
            "Standing forward bend - 30 seconds",
            "Butterfly stretch - 45 seconds",
            "Seated twist - 30 seconds each side",
            "Quad stretch - 30 seconds each leg",
            "Chest opener - 30 seconds"
          ]
        },
        {
          "id": 3,
          "title": "Lower Back Relief",
          "description": "Targeted stretches to relieve lower back tension and improve mobility",
          "duration": "20 minutes",
          "difficulty": "Beginner",
          "exercises": [
            "Cat-cow stretch - 10 repetitions",
            "Child's pose - 45 seconds",
            "Piriformis stretch - 30 seconds each side",
            "Knees to chest - 30 seconds",
            "Supine twist - 30 seconds each side"
          ]
        },
        {
          "id": 4,
          "title": "Dynamic Stretching Sequence",
          "description": "Movement-based stretches to prepare for physical activity",
          "duration": "15 minutes",
          "difficulty": "Intermediate",
          "exercises": [
            "Walking lunges - 10 each leg",
            "Leg swings - 12 each leg",
            "Arm circles - 15 each direction",
            "Hip openers - 8 each side",
            "Torso twists - 10 each side"
          ]
        }
      ];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF33724B),
        title: const Text(
          "Flexibility & Mobility",
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: workouts.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: workouts.length,
              itemBuilder: (context, index) {
                final workout = workouts[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 16),
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ExpansionTile(
                    title: Text(
                      workout['title'],
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 4),
                        Text(
                          workout['description'],
                          style: TextStyle(
                            color: Colors.grey[700],
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 2),
                              decoration: BoxDecoration(
                                color: const Color(0xFF33724B).withOpacity(0.1),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                workout['duration'],
                                style: TextStyle(
                                  fontSize: 12,
                                  color: const Color(0xFF33724B),
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 2),
                              decoration: BoxDecoration(
                                color: const Color(0xFF33724B).withOpacity(0.1),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                workout['difficulty'],
                                style: TextStyle(
                                  fontSize: 12,
                                  color: const Color(0xFF33724B),
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "Exercises:",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                            ),
                            const SizedBox(height: 8),
                            ...List.generate(
                              workout['exercises'].length,
                              (i) => Padding(
                                padding: const EdgeInsets.only(bottom: 6),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text("• ",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold)),
                                    Expanded(
                                      child: Text(
                                        workout['exercises'][i],
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: Colors.grey[800],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
    );
  }
}