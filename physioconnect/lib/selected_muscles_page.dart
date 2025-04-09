import 'package:flutter/material.dart';

class SelectedMusclesPage extends StatelessWidget {
  final List<String> selectedBodyParts;
  final List<String> selectedMuscles;
  final bool isDarkMode;

  const SelectedMusclesPage({
    Key? key,
    required this.selectedBodyParts,
    required this.selectedMuscles,
    required this.isDarkMode,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: isDarkMode 
        ? const Color(0xFF06130D) 
        : const Color(0xFFEAF7FF),
      appBar: AppBar(
        backgroundColor: const Color(0xFF33724B),
        title: const Text(
          'Selected Muscles',
          style: TextStyle(
            fontSize: 22, 
            fontWeight: FontWeight.w600, 
            color: Colors.white
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'Body Parts: ${selectedBodyParts.join(", ")}',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: selectedMuscles.length,
              itemBuilder: (context, index) {
                return Card(
                  color: const Color(0xFF33724B).withOpacity(0.1),
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  child: ListTile(
                    title: Text(
                      selectedMuscles[index],
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    trailing: const Icon(
                      Icons.check_circle,
                      color: Color(0xFF33724B),
                    ),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: () {
                // You can add further actions here, like saving or processing muscles
                Navigator.popUntil(context, (route) => route.isFirst);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF33724B),
                padding: const EdgeInsets.symmetric(
                  horizontal: 40, 
                  vertical: 15
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              child: const Text(
                'Finish',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}