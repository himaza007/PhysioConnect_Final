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
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    String imagePath = 'assets/body_parts/body_part_${bodyPart.toLowerCase()}.avif';

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: const Color(0xFF1F5F3A).withOpacity(0.8),
        elevation: 0,
        title: Text(
          bodyPart,
          style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w600, color: Colors.white),
        ),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          // Background Image
          Image.asset(
            'assets/bg.jpg',
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
          ),
          
          // Overlay for better readability
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.black.withOpacity(0.5),
                  Colors.black.withOpacity(0.7),
                ],
              ),
            ),
          ),
          
          // Content
          SafeArea(
            child: Column(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(18),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.4),
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.3),
                            blurRadius: 15,
                            spreadRadius: 2,
                          ),
                        ],
                      ),
                      padding: const EdgeInsets.all(20),
                      child: Image.asset(
                        imagePath,
                        fit: BoxFit.contain,
                        width: double.infinity,
                        errorBuilder: (context, error, stackTrace) {
                          print('Error loading image: $imagePath');
                          return const Center(
                            child: Icon(
                              Icons.broken_image,
                              color: Colors.white54,
                              size: 80,
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 30),
                  child: ElevatedButton(
                    onPressed: () => navigateToMuscles(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF1F5F3A),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 14),
                      elevation: 8,
                      shadowColor: const Color(0xFF1F5F3A).withOpacity(0.5),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      "See Muscles",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}