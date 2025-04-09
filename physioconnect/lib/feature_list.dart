// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'progress_tracking_screen.dart';
import 'nearby_facilities.dart';

class FeatureList extends StatelessWidget {
  const FeatureList({super.key});

  @override
  Widget build(BuildContext context) {
    final List<String> featureIcons = [
      "assets/icons/1.png",
      "assets/icons/2.png",
      "assets/icons/3.png",
      "assets/icons/4.png",
      "assets/icons/5.png",
      "assets/icons/6.png",
      "assets/icons/7.png",
      "assets/icons/8.png",
      "assets/icons/9.png",
      "assets/icons/10.png",
    ];

    final List<String> featureNames = [
      "Nearby Facility Locator",
      "Progress Tracking",
      "Pain Monitoring",
      "EPHR",
      "2D Model Pain Mapping",
      "Tokens",
      "Exercise Plans",
      "First Aid Tutorials",
      "Educational Resources",
      "Injury Remedies",
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 15,
        mainAxisSpacing: 15,
        childAspectRatio: 1.2,
      ),
      itemCount: featureIcons.length,
      itemBuilder: (context, index) {
        return GestureDetector(
          onTap: () {
            if (index == 1) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const AdvancedProgressTrackingScreen(),
                ),
              );
            } else if (index == 0) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const NearbyFacilitiesScreen(),
                ),
              );
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('${featureNames[index]} feature coming soon!'),
                  duration: const Duration(seconds: 1),
                ),
              );
            }
          },
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: const Color(0xFF33724B).withOpacity(0.3),
                width: 1,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFF33724B).withOpacity(0.2),
                    shape: BoxShape.circle,
                  ),
                  child: Image.asset(
                    featureIcons[index],
                    color: Colors.white,
                    width: 70,
                    height: 70,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  featureNames[index],
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
