// ignore_for_file: deprecated_member_use, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';
import 'sos_button.dart';

class PhysioBottomAppBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const PhysioBottomAppBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    // Sample emergency contacts - in a real app, these would come from a database or user profile
    final List<EmergencyContact> contacts = [
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

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildNavItem(
                context: context,
                icon: Icons.home_rounded,
                label: 'Home',
                index: 0,
              ),
              _buildNavItem(
                context: context,
                icon: Icons.calendar_month_rounded,
                label: 'Calendar',
                index: 1,
              ),
              _buildNavItem(
                context: context,
                icon: Icons.notifications_rounded,
                label: 'Notifications',
                index: 2,
              ),
              _buildSOSButton(context, contacts),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem({
    required BuildContext context,
    required IconData icon,
    required String label,
    required int index,
  }) {
    final bool isSelected = currentIndex == index;
    
    return InkWell(
      onTap: () => onTap(index),
      borderRadius: BorderRadius.circular(16),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected 
              ? const Color(0xFF33724B).withOpacity(0.1) 
              : Colors.transparent,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: isSelected 
                  ? const Color(0xFF33724B)
                  : Colors.grey.shade600,
              size: 24,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                color: isSelected 
                    ? const Color(0xFF33724B)
                    : Colors.grey.shade600,
                fontSize: 12,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSOSButton(BuildContext context, List<EmergencyContact> contacts) {
    return GestureDetector(
      onTap: () {
        _showEnhancedSOSDialog(context, contacts);
        HapticFeedback.mediumImpact(); // Add haptic feedback when SOS is tapped
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.red.shade400, Colors.red.shade700],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.red.withOpacity(0.3),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.emergency_rounded,
              color: Colors.white,
              size: 24,
            ),
            const SizedBox(height: 4),
            Text(
              'SOS',
              style: TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showEnhancedSOSDialog(BuildContext context, List<EmergencyContact> contacts) {
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
                context: context,
                icon: Icons.phone_rounded,
                label: 'Call 119 Now',
                color: Colors.red.shade700,
                onTap: () async {
                  Navigator.of(context).pop();
                  HapticFeedback.heavyImpact(); // Strong haptic feedback
                  
                  // Direct call to emergency services
                  final Uri phoneUri = Uri(scheme: 'tel', path: '119');
                  try {
                    if (await canLaunchUrl(phoneUri)) {
                      await launchUrl(phoneUri);
                    } else {
                      _showErrorSnackBar(context, 'Could not launch emergency call');
                    }
                  } catch (e) {
                    _showErrorSnackBar(context, 'Error: $e');
                  }
                },
              ),
              const SizedBox(height: 16),
              _buildEmergencyButton(
                context: context,
                icon: Icons.contact_emergency_rounded,
                label: 'Contact Emergency List',
                color: Colors.orange.shade700,
                onTap: () {
                  Navigator.of(context).pop();
                  HapticFeedback.mediumImpact();
                  
                  // Show the SOS floating button with expanded contacts
                  _activateSOSInterface(context, contacts);
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

  void _activateSOSInterface(BuildContext context, List<EmergencyContact> contacts) {
    // Create an overlay entry for the SOS button
    OverlayState overlayState = Overlay.of(context);
    OverlayEntry? overlayEntry;
    
    overlayEntry = OverlayEntry(
      builder: (context) {
        return SOSFloatingButton(
          contacts: contacts,
          onClose: () {
            // Remove the overlay when closed
            overlayEntry?.remove();
          },
        );
      },
    );
    
    // Insert the overlay
    overlayState.insert(overlayEntry);
  }

  void _showErrorSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
  
  Widget _buildEmergencyButton({
    required BuildContext context,
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