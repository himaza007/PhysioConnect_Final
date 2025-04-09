// ignore_for_file: deprecated_member_use, duplicate_ignore

import 'package:flutter/material.dart';
import 'bottom_app_bar.dart';
import 'selected_muscles_page.dart';

class MainBodyPartPage extends StatefulWidget {
  final String bodyPart;
  final bool isDarkMode;

  const MainBodyPartPage({
    super.key,
    required this.bodyPart,
    required this.isDarkMode,
  });

  @override
  State<MainBodyPartPage> createState() => _MainBodyPartPageState();
}

class _MainBodyPartPageState extends State<MainBodyPartPage> {
  int _currentNavIndex = 0; // For bottom navigation
  
  void navigateToMuscles(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SelectedMusclesPage(
          bodyPart: widget.bodyPart,
          isDarkMode: widget.isDarkMode,
          onSelectionComplete: (selectedBodyParts, selectedMuscles) {
            // You can handle selection result here if needed
          }, selectedBodyParts: [], selectedMuscles: [],
        ),
      ),
    );
  }

  void _onNavItemTapped(int index) {
    setState(() {
      _currentNavIndex = index;
    });
    // In a real app, you might want to handle navigation here
  }

  @override
  Widget build(BuildContext context) {
    String imagePath = 'assets/body_parts/body_part_${widget.bodyPart.toLowerCase()}.avif';

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        // ignore: deprecated_member_use
        backgroundColor: const Color(0xFF1F5F3A).withOpacity(0.8),
        elevation: 0,
        title: Text(
          widget.bodyPart,
          style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w600, color: Colors.white),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              // ignore: deprecated_member_use
              color: Colors.black.withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.arrow_back, color: Colors.white),
          ),
          onPressed: () => Navigator.pop(context),
        ),
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
                  // ignore: deprecated_member_use
                  Colors.black.withOpacity(0.5),
                  // ignore: deprecated_member_use
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
                        // ignore: deprecated_member_use
                        color: Colors.black.withOpacity(0.4),
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            // ignore: deprecated_member_use
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
      bottomNavigationBar: PhysioBottomAppBar(
        currentIndex: _currentNavIndex,
        onTap: _onNavItemTapped,
      ),
    );
  }
}