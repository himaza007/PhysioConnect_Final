// ignore_for_file: use_build_context_synchronously, deprecated_member_use

import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';

class CustomizedInjuryRemediesScreen extends StatefulWidget {
  const CustomizedInjuryRemediesScreen({super.key});

  @override
  State<CustomizedInjuryRemediesScreen> createState() =>
      _CustomizedInjuryRemediesScreenState();
}

class _CustomizedInjuryRemediesScreenState
    extends State<CustomizedInjuryRemediesScreen> {
  List remedies = [
    {'id': 1, 'title': 'Cold Therapy', 'description': 'Reduces inflammation and pain for acute injuries'},
    {'id': 2, 'title': 'Heat Therapy', 'description': 'Improves blood flow and reduces stiffness in chronic conditions'},
    {'id': 3, 'title': 'Compression Techniques', 'description': 'Controls swelling and provides support for injured areas'},
    {'id': 4, 'title': 'Elevation Methods', 'description': 'Reduces swelling by improving drainage from injured tissues'},
    {'id': 5, 'title': 'Gentle Stretching', 'description': 'Maintains flexibility and prevents stiffness during recovery'}
  ];

  @override
  void initState() {
    super.initState();
    // Removed HTTP call and using mock data instead
  }

  void _handleRemedyTap(int remedyId, String remedyTitle) async {
    // Mock data instead of HTTP request
    List groups = [
      {'id': 1, 'name': 'Upper Back'},
      {'id': 2, 'name': 'Lower Back'},
      {'id': 3, 'name': 'Shoulders'}
    ];
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(remedyTitle),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: groups.map((group) {
            return ListTile(
              leading:
                  const Icon(Icons.chevron_right, color: Color(0xFF33724B)),
              title: Text(group['name']),
              onTap: () {
                Navigator.of(context).pop();
                _showInstructions(group['id'], group['name']);
              },
            );
          }).toList(),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Close"),
          )
        ],
      ),
    );
  }

  void _showInstructions(int muscleGroupId, String name) async {
    // Mock data instead of HTTP request
    final data = {
      'instructions': 'Apply gentle stretching exercises for 15 minutes twice daily. Start with seated forward bends, followed by gentle twists. Avoid sudden movements and stop if pain increases.'
    };
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Instructions for $name"),
        content: Text(
          data['instructions'] ?? 'No instructions found.',
          style: const TextStyle(fontSize: 15),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Close"),
          )
        ],
      ),
    );
  }

  Widget _buildRemedyCard(
    BuildContext context, {
    required String title,
    required String description,
    required VoidCallback onTap,
  }) {
    return Card(
      color: Colors.white.withOpacity(0.9),
      margin: const EdgeInsets.symmetric(vertical: 6),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: const Icon(Icons.healing, color: Color(0xFF33724B)),
        title: Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
        ),
        subtitle: Text(description, style: const TextStyle(fontSize: 13)),
        onTap: onTap,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(65),
        child: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          centerTitle: true,
          title: const Text(
            "Customized Injury Remedies",
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Color(0xFF33724B),
            ),
          ),
          iconTheme: const IconThemeData(color: Color(0xFF33724B)),
        ),
      ),
      body: Stack(
        children: [
          // Background Gradient
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.white.withOpacity(0.1),
                  Colors.white.withOpacity(0.05),
                ],
              ),
            ),
          ),
          SafeArea(
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "These remedies consider factors such as the user's type of injury, acuteness, wounded area, and the progress in healing to provide personalized treatment plans or exercises tailored to an individual's recovery needs. Below are the key remedies users can access:",
                    style: TextStyle(fontSize: 15, color: Colors.black87),
                  ),
                  const SizedBox(height: 15),
                  Expanded(
                    child: remedies.isEmpty
                        ? const Center(child: CircularProgressIndicator())
                        : ListView.builder(
                            padding: EdgeInsets.zero,
                            itemCount: remedies.length,
                            itemBuilder: (context, index) {
                              final remedy = remedies[index];
                              return _buildRemedyCard(
                                context,
                                title: remedy['title'],
                                description: remedy['description'] ?? '',
                                onTap: () => _handleRemedyTap(
                                    remedy['id'], remedy['title']),
                              );
                            },
                          ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}