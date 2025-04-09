// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'bottom_app_bar.dart';

class SelectedMusclesPage extends StatefulWidget {
  final List<String> selectedBodyParts;
  final List<String> selectedMuscles;
  final bool isDarkMode;

  // ignore: use_super_parameters
  const SelectedMusclesPage({
    Key? key,
    required this.selectedBodyParts,
    required this.selectedMuscles,
    required this.isDarkMode,
  }) : super(key: key);

  @override
  State<SelectedMusclesPage> createState() => _SelectedMusclesPageState();
}

class _SelectedMusclesPageState extends State<SelectedMusclesPage> {
  int _currentNavIndex = 0; // For bottom navigation

  void _onNavItemTapped(int index) {
    setState(() {
      _currentNavIndex = index;
    });
    // In a real app, you might want to handle navigation here
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: widget.isDarkMode 
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
        leading: IconButton(
          icon: Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.arrow_back, color: Colors.white),
          ),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'Body Parts: ${widget.selectedBodyParts.join(", ")}',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: widget.selectedMuscles.length,
              itemBuilder: (context, index) {
                return Card(
                  color: const Color(0xFF33724B).withOpacity(0.1),
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  child: ListTile(
                    title: Text(
                      widget.selectedMuscles[index],
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
      bottomNavigationBar: PhysioBottomAppBar(
        currentIndex: _currentNavIndex,
        onTap: _onNavItemTapped,
      ),
    );
  }
}