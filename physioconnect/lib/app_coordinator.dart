// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'bottom_app_bar.dart';
import 'home_page.dart';
// Import your placeholder pages
import 'placeholder_pages.dart';
import 'sos_button.dart';
import 'package:url_launcher/url_launcher.dart';

class AppCoordinator extends StatefulWidget {
  const AppCoordinator({super.key});

  @override
  State<AppCoordinator> createState() => _AppCoordinatorState();
}

class _AppCoordinatorState extends State<AppCoordinator> {
  int _currentIndex = 0;
  bool _isSosActive = false;
  OverlayEntry? _sosOverlayEntry;
  
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

  // Sample emergency contacts for SOS feature - In a real app these would come from a user profile database
  final List<EmergencyContact> _emergencyContacts = [
    EmergencyContact(
      id: '1',
      name: 'John Doe (Family)',
      phoneNumber: '+1234567890',
      notes: 'Primary emergency contact',
    ),
    EmergencyContact(
      id: '2',
      name: 'Dr. Smith',
      phoneNumber: '+1987654321',
      contactType: ContactType.hospital,
      notes: 'Primary care physician',
    ),
    EmergencyContact(
      id: '3',
      name: 'Local Hospital',
      phoneNumber: '+1122334455',
      contactType: ContactType.hospital,
    ),
  ];

  void _onItemTapped(int index) {
    if (index < _pages.length) {
      setState(() {
        _currentIndex = index;
      });
    }
  }

  void _toggleSosInterface() {
    setState(() {
      _isSosActive = !_isSosActive;
    });
    
    if (_isSosActive) {
      _showSosInterface();
    } else {
      _removeSosInterface();
    }
  }

  void _showSosInterface() {
    HapticFeedback.mediumImpact(); // Provide haptic feedback when SOS is activated
    
    _sosOverlayEntry = OverlayEntry(
      builder: (context) {
        return SOSFloatingButton(
          contacts: _emergencyContacts,
          onClose: () {
            setState(() {
              _isSosActive = false;
            });
            _removeSosInterface();
          },
        );
      },
    );
    
    if (_sosOverlayEntry != null) {
      Overlay.of(context).insert(_sosOverlayEntry!);
    }
  }

  void _removeSosInterface() {
    _sosOverlayEntry?.remove();
    _sosOverlayEntry = null;
  }

  Future<void> _callEmergencyNumber() async {
    HapticFeedback.heavyImpact(); // Strong vibration for emergency call
    
    const String emergencyNumber = '119'; // Use 119 as requested
    final Uri phoneUri = Uri(scheme: 'tel', path: emergencyNumber);
    
    try {
      if (await canLaunchUrl(phoneUri)) {
        await launchUrl(phoneUri);
      } else {
        // Show error if couldn't launch
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Unable to call emergency services'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
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
                  _callEmergencyNumber();
                },
              ),
              const SizedBox(height: 16),
              _buildEmergencyButton(
                icon: Icons.contact_emergency_rounded,
                label: 'Contact Emergency List',
                color: Colors.orange.shade700,
                onTap: () {
                  Navigator.of(context).pop();
                  _toggleSosInterface();
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

  @override
  void dispose() {
    // Clean up the overlay entry if it exists
    _removeSosInterface();
    super.dispose();
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
          
          // Quick access SOS floating button
          Positioned(
            right: 20,
            bottom: 100, // Positioned above bottom bar
            child: _buildQuickSOSButton(),
          ),
        ],
      ),
      bottomNavigationBar: PhysioBottomAppBar(
        currentIndex: _currentIndex,
        onTap: _onItemTapped,
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
          onTap: _showEmergencyDialog,
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
}