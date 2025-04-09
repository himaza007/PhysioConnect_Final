import 'package:flutter/material.dart';
import 'bottom_app_bar.dart';
import 'home_page.dart';
// Import your placeholder pages
import 'placeholder_pages.dart';

class AppCoordinator extends StatefulWidget {
  const AppCoordinator({super.key});

  @override
  State<AppCoordinator> createState() => _AppCoordinatorState();
}

class _AppCoordinatorState extends State<AppCoordinator> {
  int _currentIndex = 0;
  
  // Pages with Flutter built-in icons
  final List<Widget> _pages = [
    const HomePage(),
    const CalendarPage(),
    const NotificationsPage(),
  ];

  final List<String> _titles = [
    '', // Empty string for homepage since it has its own title
    'Calendar',
    'Notifications'
  ];

  final List<IconData> _headerIcons = [
    Icons.person_outline,
    Icons.help_outline,
    Icons.settings_outlined
  ];

  void _onItemTapped(int index) {
    if (index < _pages.length) {
      setState(() {
        _currentIndex = index;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Add background image to scaffold
      extendBodyBehindAppBar: true,
      appBar: _currentIndex == 0 
        ? null // Don't show app bar on home page to avoid duplicate titles
        : AppBar(
            title: Text(
              _titles[_currentIndex],
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 22,
              ),
            ),
            backgroundColor: const Color(0xFF33724B),
            elevation: 0,
            actions: [
              IconButton(
                icon: Icon(_headerIcons[0], color: Colors.white),
                onPressed: () {
                  // Profile action
                },
              ),
              IconButton(
                icon: Icon(_headerIcons[1], color: Colors.white),
                onPressed: () {
                  // Help action
                },
              ),
              IconButton(
                icon: Icon(_headerIcons[2], color: Colors.white),
                onPressed: () {
                  // Settings action
                },
              ),
            ],
          ),
      body: Stack(
        children: [
          // Background image applied to all pages
          Image.asset(
            'assets/images/bg.jpg',
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
          // Page content
          _pages[_currentIndex],
        ],
      ),
      bottomNavigationBar: PhysioBottomAppBar(
        currentIndex: _currentIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}