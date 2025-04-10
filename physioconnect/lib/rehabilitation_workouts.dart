import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;

class RehabilitationWorkoutsScreen extends StatefulWidget {
  const RehabilitationWorkoutsScreen({super.key});

  @override
  State<RehabilitationWorkoutsScreen> createState() => _RehabilitationWorkoutsScreenState();
}

class _RehabilitationWorkoutsScreenState extends State<RehabilitationWorkoutsScreen> {
  List<dynamic> workouts = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchWorkouts();
  }

  Future<void> fetchWorkouts() async {
    // Comment out HTTP request
    /*
    final uri = Uri.parse('http://192.168.8.140:5000/api/rehabilitation-workouts');
    try {
      final response = await http.get(uri);
      if (response.statusCode == 200) {
        setState(() {
          workouts = json.decode(response.body);
          isLoading = false;
        });
      } else {
        setState(() {
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
    }
    */
    
    // Use mock data instead
    setState(() {
      workouts = [
        {
          "id": 1,
          "title": "Post-Surgery Knee Recovery",
          "description": "Gentle exercises to rebuild strength after knee surgery",
          "bodyPart": "Lower Body",
          "duration": "15-20 minutes",
          "difficulty": "Beginner",
          "exercises": [
            {
              "name": "Quad Sets",
              "instructions": "Lie flat, tighten thigh muscles, hold for 5 seconds. Repeat 10 times.",
              "sets": 3,
              "reps": 10
            },
            {
              "name": "Heel Slides",
              "instructions": "Lie flat, slowly slide heel toward buttocks, then back. Repeat 10 times.",
              "sets": 3,
              "reps": 10
            },
            {
              "name": "Straight Leg Raises",
              "instructions": "Lie flat, straighten one leg and raise it 12 inches. Hold for 5 seconds, lower slowly.",
              "sets": 2,
              "reps": 8
            }
          ]
        },
        {
          "id": 2,
          "title": "Shoulder Rehabilitation",
          "description": "Recovery routine for rotator cuff injuries",
          "bodyPart": "Upper Body",
          "duration": "20 minutes",
          "difficulty": "Intermediate",
          "exercises": [
            {
              "name": "Pendulum Exercise",
              "instructions": "Lean forward, let arm hang down, make small circles with arm. 30 seconds clockwise, 30 counterclockwise.",
              "sets": 2,
              "reps": 1
            },
            {
              "name": "Wall Crawl",
              "instructions": "Face wall with arm extended, 'walk' fingers up wall as high as comfortable. Hold 10 seconds, return slowly.",
              "sets": 3,
              "reps": 8
            },
            {
              "name": "Rotator Cuff Strengthening",
              "instructions": "Hold resistance band, elbow at 90°, rotate arm outward. Hold 3 seconds, return slowly.",
              "sets": 3,
              "reps": 10
            }
          ]
        },
        {
          "id": 3,
          "title": "Lower Back Recovery",
          "description": "Gentle exercises for lower back pain and recovery",
          "bodyPart": "Core",
          "duration": "15 minutes",
          "difficulty": "Beginner",
          "exercises": [
            {
              "name": "Pelvic Tilts",
              "instructions": "Lie on back with knees bent, tighten abdominals and press lower back to floor. Hold 5 seconds, release.",
              "sets": 3,
              "reps": 10
            },
            {
              "name": "Bird Dog",
              "instructions": "On hands and knees, extend opposite arm and leg. Hold 5 seconds, return to start position.",
              "sets": 3,
              "reps": 8
            },
            {
              "name": "Bridge Exercise",
              "instructions": "Lie on back with knees bent, lift hips toward ceiling. Hold 10 seconds, lower slowly.",
              "sets": 3,
              "reps": 10
            }
          ]
        }
      ];
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF33724B),
        title: const Text("Rehabilitation Workouts"),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : workouts.isEmpty
              ? const Center(child: Text("No rehabilitation workouts found"))
              : ListView.builder(
                  padding: const EdgeInsets.all(16.0),
                  itemCount: workouts.length,
                  itemBuilder: (context, index) {
                    final workout = workouts[index];
                    return _buildWorkoutCard(workout);
                  },
                ),
    );
  }

  Widget _buildWorkoutCard(dynamic workout) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ExpansionTile(
        title: Text(
          workout['title'],
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Text(
              workout['description'],
              style: TextStyle(color: Colors.grey[700], fontSize: 14),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                _buildInfoChip(workout['bodyPart']),
                const SizedBox(width: 8),
                _buildInfoChip(workout['duration']),
                const SizedBox(width: 8),
                _buildInfoChip(workout['difficulty']),
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
                    fontSize: 15,
                  ),
                ),
                const SizedBox(height: 8),
                ...List.generate(
                  workout['exercises'].length,
                  (i) => _buildExerciseItem(workout['exercises'][i]),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoChip(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        // ignore: deprecated_member_use
        color: const Color(0xFF33724B).withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 12,
          color: Color(0xFF33724B),
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _buildExerciseItem(dynamic exercise) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.fitness_center, size: 18, color: Color(0xFF33724B)),
              const SizedBox(width: 8),
              Text(
                exercise['name'],
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 15,
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(left: 26),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 4),
                Text(
                  exercise['instructions'],
                  style: TextStyle(fontSize: 14, color: Colors.grey[700]),
                ),
                const SizedBox(height: 4),
                Text(
                  "${exercise['sets']} sets × ${exercise['reps']} reps",
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.grey[600],
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}