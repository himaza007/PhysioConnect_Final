// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'understanding_muscle_strains.dart';
import 'effective_stretching_techniques.dart';
import 'rehabilitation_exercises.dart';
import 'preventing_common_sports_injuries.dart';
import 'bottom_app_bar.dart';

class EducationalResourcesScreen extends StatefulWidget {
  const EducationalResourcesScreen({super.key});

  @override
  State<EducationalResourcesScreen> createState() => _EducationalResourcesScreenState();
}

class _EducationalResourcesScreenState extends State<EducationalResourcesScreen> {
  int _currentNavIndex = 0; // For bottom navigation

  void _onNavItemTapped(int index) {
    if (index == _currentNavIndex) return;
    setState(() {
      _currentNavIndex = index;
    });
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: const Color(0xFF33724B),
        elevation: 0,
        centerTitle: true,
        title: const Text(
          "Educational Resources",
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Stack(
        children: [
          // Background image
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
                  Colors.black.withOpacity(0.4),
                  Colors.black.withOpacity(0.6),
                ],
              ),
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "To help users comprehend their injuries, the healing process, and preventative measures, this section provides extensive educational resources. This includes detailed information on various injuries, their causes, symptoms, and treatment options.",
                    style: TextStyle(fontSize: 15, color: Colors.white),
                  ),
                  const SizedBox(height: 15),
                  Expanded(
                    child: ListView(
                      padding: EdgeInsets.zero,
                      children: [
                        _buildResourceCard(
                          context,
                          title: "Understanding Muscle Strains",
                          description:
                              "Learn about muscle strains, their symptoms, and the best recovery practices.",
                          icon: Icons.fitness_center,
                          page: const UnderstandingMuscleStrainsScreen(),
                        ),
                        _buildResourceCard(
                          context,
                          title: "Effective Stretching Techniques",
                          description:
                              "Explore proper stretching methods to prevent injuries and improve flexibility.",
                          icon: Icons.directions_run,
                          page: const EffectiveStretchingTechniquesScreen(),
                        ),
                        _buildResourceCard(
                          context,
                          title: "Rehabilitation Exercises",
                          description:
                              "Discover key exercises that aid in the recovery process after an injury.",
                          icon: Icons.healing,
                          page: const RehabilitationExercisesScreen(),
                        ),
                        _buildResourceCard(
                          context,
                          title: "Preventing Common Sports Injuries",
                          description:
                              "Understand common sports injuries and how to avoid them with proper training.",
                          icon: Icons.sports_soccer,
                          page: const PreventingCommonSportsInjuriesScreen(),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          
          // Quick access SOS button
          Positioned(
            right: 20,
            bottom: 100, // Positioned above bottom bar
            child: _buildQuickSOSButton(),
          ),
        ],
      ),
      bottomNavigationBar: PhysioBottomAppBar(
        currentIndex: _currentNavIndex,
        onTap: _onNavItemTapped,
      ),
    );
  }

  Widget _buildResourceCard(BuildContext context,
      {required String title,
      required String description,
      required IconData icon,
      required Widget page}) {
    return Card(
      color: Colors.white.withOpacity(0.9),
      margin: const EdgeInsets.symmetric(vertical: 8),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        leading: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: const Color(0xFF33724B).withOpacity(0.2),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: const Color(0xFF33724B), size: 24),
        ),
        title: Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: Text(description, style: const TextStyle(fontSize: 14)),
        ),
        trailing: const Icon(Icons.arrow_forward_ios,
            size: 18, color: Color(0xFF33724B)),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => page),
          );
        },
      ),
    );
  }
  
  Widget _buildQuickSOSButton() {
    return Container(
      width: 58,
      height: 58,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          colors: [Colors.red.shade400, Colors.red.shade700],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.red.withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => _showEmergencyDialog(),
          customBorder: const CircleBorder(),
          child: const Center(
            child: Icon(
              Icons.emergency,
              color: Colors.white,
              size: 30,
            ),
          ),
        ),
      ),
    );
  }

  void _showEmergencyDialog() {
    showDialog(
      context: context,
      barrierDismissible: false, // Prevent dismissal by tapping outside
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.red.shade50,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.emergency_rounded,
                  color: Colors.red.shade700,
                  size: 28,
                ),
                const SizedBox(width: 8),
                const Text(
                  'Emergency SOS',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.red,
                  ),
                ),
              ],
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Are you experiencing a medical emergency?',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              const Text(
                'Choose an option below:',
                style: TextStyle(fontSize: 14),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              _buildEmergencyButton(
                icon: Icons.phone_rounded,
                label: 'Call 119 Now',
                color: Colors.red.shade700,
                onTap: () {
                  Navigator.of(context).pop();
                  // In a real app, this would call emergency services
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Calling emergency services...'),
                      backgroundColor: Colors.red,
                    ),
                  );
                },
              ),
              const SizedBox(height: 16),
              _buildEmergencyButton(
                icon: Icons.contact_emergency_rounded,
                label: 'Contact Emergency List',
                color: Colors.orange.shade700,
                onTap: () {
                  Navigator.of(context).pop();
                  // In a real app, this would show emergency contacts
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Opening emergency contacts...'),
                      backgroundColor: Colors.orange,
                    ),
                  );
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              style: TextButton.styleFrom(
                foregroundColor: Colors.grey.shade800,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
          ],
        );
      },
    );
  }

  Widget _buildEmergencyButton({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          elevation: 4,
        ),
        icon: Icon(
          icon,
          size: 28,
        ),
        label: Text(
          label,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}