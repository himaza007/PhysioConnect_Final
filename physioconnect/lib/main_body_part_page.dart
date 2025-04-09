import 'package:flutter/material.dart';
import 'muscle_selection_page.dart';

class MainBodyPartPage extends StatelessWidget {
  final String bodyPart;
  final bool isDarkMode;

  const MainBodyPartPage({
    Key? key,
    required this.bodyPart,
    required this.isDarkMode,
  }) : super(key: key);

  void navigateToMuscles(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MuscleSelectionPage(
          bodyPart: bodyPart,
          isDarkMode: isDarkMode,
          onSelectionComplete: (selectedBodyParts, selectedMuscles) {
            // You can handle selection result here if needed
            // Now it accepts two parameters instead of one
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    String imagePath = 'assets/body_parts/body_part_${bodyPart.toLowerCase()}.avif';

    return Scaffold(
      backgroundColor: const Color(0xFF06130D),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1F5F3A),
        title: Text(
          bodyPart,
          style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w600, color: Colors.white),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(18),
              child: Image.asset(
                imagePath,
                fit: BoxFit.contain,
                width: double.infinity,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 30),
            child: ElevatedButton(
              onPressed: () => navigateToMuscles(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF1F5F3A),
                padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 14),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              child: const Text(
                "See Muscles",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
              ),
            ),
          )
        ],
      ),
    );
  }
}