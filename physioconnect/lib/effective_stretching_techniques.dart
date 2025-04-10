import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;

class EffectiveStretchingTechniquesScreen extends StatefulWidget {
  const EffectiveStretchingTechniquesScreen({super.key});

  @override
  State<EffectiveStretchingTechniquesScreen> createState() => _EffectiveStretchingTechniquesScreenState();
}

class _EffectiveStretchingTechniquesScreenState extends State<EffectiveStretchingTechniquesScreen> {
  List<dynamic> _techniques = [];

  @override
  void initState() {
    super.initState();
    fetchTechniques();
  }

  Future<void> fetchTechniques() async {
    // Comment out HTTP request and use mock data instead
    /*
    final uri = Uri.parse("http://192.168.8.140:5000/api/stretching-techniques"); // Use IP for real device
    final response = await http.get(uri);
    
    if (response.statusCode == 200) {
      setState(() {
        _techniques = json.decode(response.body);
      });
    } else {
      // Handle error
    }
    */
    
    // Use mock data instead
    setState(() {
      _techniques = [
        {
          "id": 1,
          "title": "Dynamic Stretching",
          "description": "Controlled movements that take you to the limits of your range of motion.",
          "instructions": "Perform each movement 10-12 times. Move slowly at first, then gradually increase speed."
        },
        {
          "id": 2,
          "title": "Static Stretching",
          "description": "Holding a position that lengthens a muscle for 15-60 seconds.",
          "instructions": "Hold each stretch for 30 seconds. Breathe deeply and avoid bouncing."
        },
        {
          "id": 3,
          "title": "PNF Stretching",
          "description": "Contract-relax technique that enhances flexibility through neurological mechanisms.",
          "instructions": "Contract the muscle for 5-6 seconds, then relax and stretch further for 30 seconds."
        },
        {
          "id": 4,
          "title": "Active Isolated Stretching",
          "description": "Brief stretches with controlled movements to increase range of motion.",
          "instructions": "Hold each position for 2 seconds, then release. Repeat 8-10 times for each stretch."
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
          "Effective Stretching Techniques",
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: _techniques.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _techniques.length,
              itemBuilder: (context, index) {
                final technique = _techniques[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 16),
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ExpansionTile(
                    title: Text(
                      technique['title'],
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    subtitle: Text(
                      technique['description'],
                      style: TextStyle(
                        color: Colors.grey[700],
                        fontSize: 14,
                      ),
                    ),
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "Instructions:",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              technique['instructions'],
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey[800],
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