// ignore_for_file: deprecated_member_use, library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:share_plus/share_plus.dart';
import 'package:flutter/services.dart';
import 'dart:async';

class SOSFloatingButton extends StatefulWidget {
  final List<EmergencyContact> contacts;
  final VoidCallback? onClose;

  const SOSFloatingButton({
    super.key,
    required this.contacts,
    this.onClose,
  });

  @override
  _SOSFloatingButtonState createState() => _SOSFloatingButtonState();
}

class _SOSFloatingButtonState extends State<SOSFloatingButton>
    with SingleTickerProviderStateMixin {
  bool _isExpanded = false;
  bool _isLoading = false;
  Position? _currentPosition;
  String? _locationError;
  late AnimationController _animationController;
  late Animation<double> _expandAnimation;
  Timer? _pulseTimer;
  bool _isPulsing = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _expandAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );
    
    // Auto-expand the SOS button on load
    _toggleExpanded();
    
    // Start location fetching immediately
    _fetchLocation();
    
    // Start the pulsing effect
    _startPulseAnimation();
  }

  void _startPulseAnimation() {
    _pulseTimer = Timer.periodic(const Duration(milliseconds: 800), (timer) {
      if (mounted) {
        setState(() {
          _isPulsing = !_isPulsing;
        });
      }
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    _pulseTimer?.cancel();
    super.dispose();
  }

  void _toggleExpanded() {
    setState(() {
      _isExpanded = !_isExpanded;
      if (_isExpanded) {
        _animationController.forward();
        HapticFeedback.mediumImpact(); // Add haptic feedback
      } else {
        _animationController.reverse();
        if (widget.onClose != null) {
          widget.onClose!();
        }
      }
    });
  }

  Future<void> _fetchLocation() async {
    setState(() {
      _isLoading = true;
      _locationError = null;
    });
    
    try {
      // Check location permissions
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          setState(() {
            _locationError = 'Location permissions are denied';
            _isLoading = false;
          });
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        setState(() {
          _locationError = 'Location permissions are permanently denied';
          _isLoading = false;
        });
        return;
      }

      // Get current position
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);

      setState(() {
        _currentPosition = position;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _locationError = 'Error getting location: $e';
        _isLoading = false;
      });
    }
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  Future<void> _callEmergencyService() async {
    final Uri phoneUri = Uri(scheme: 'tel', path: '119'); // Using 119 as requested
    
    try {
      HapticFeedback.heavyImpact(); // Strong haptic feedback for emergency call
      if (await canLaunchUrl(phoneUri)) {
        await launchUrl(phoneUri);
      } else {
        _showErrorSnackBar('Could not launch emergency call');
      }
    } catch (e) {
      _showErrorSnackBar('Error: $e');
    }
  }

  Future<void> _contactWithLocation(EmergencyContact contact) async {
    // If we haven't fetched the location yet, try again
    if (_currentPosition == null && _locationError == null) {
      await _fetchLocation();
    }
    
    String locationMessage;
    
    if (_currentPosition != null) {
      locationMessage = 'EMERGENCY: I need help! My current location is: https://maps.google.com/?q=${_currentPosition!.latitude},${_currentPosition!.longitude}';
    } else {
      locationMessage = 'EMERGENCY: I need help! (Unable to share precise location)';
    }

    // For SMS option
    final Uri smsUri = Uri(
      scheme: 'sms',
      path: contact.phoneNumber,
      queryParameters: {'body': locationMessage},
    );

    try {
      HapticFeedback.mediumImpact(); // Add haptic feedback
      if (await canLaunchUrl(smsUri)) {
        await launchUrl(smsUri);
      } else {
        // Fallback to sharing options
        await Share.share(
          locationMessage,
          subject: 'Emergency SOS from PhysioConnect',
        );
      }
    } catch (e) {
      _showErrorSnackBar('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      right: 20,
      bottom: 80,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          // Expanded contacts list
          SizeTransition(
            sizeFactor: _expandAnimation,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Card(
                elevation: 8,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                color: Colors.white,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                      decoration: BoxDecoration(
                        color: Colors.red.shade100,
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(16),
                          topRight: Radius.circular(16),
                        ),
                      ),
                      child: Column(
                        children: [
                          const Text(
                            'EMERGENCY ASSISTANCE',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: Colors.red,
                            ),
                          ),
                          if (_isLoading)
                            Padding(
                              padding: const EdgeInsets.only(top: 8.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SizedBox(
                                    width: 16,
                                    height: 16,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      valueColor: AlwaysStoppedAnimation<Color>(Colors.red.shade800),
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    'Fetching your location...',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.red.shade800,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          if (_locationError != null)
                            Padding(
                              padding: const EdgeInsets.only(top: 8.0),
                              child: Text(
                                _locationError!,
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.red.shade800,
                                ),
                              ),
                            ),
                          if (_currentPosition != null)
                            Padding(
                              padding: const EdgeInsets.only(top: 8.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.location_on,
                                    size: 16,
                                    color: Colors.green.shade800,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    'Location ready',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.green.shade800,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                        ],
                      ),
                    ),
                    
                    // Emergency services call button (prominent)
                    Container(
                      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                      child: ElevatedButton.icon(
                        onPressed: _callEmergencyService,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 8),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          minimumSize: const Size(double.infinity, 0),
                        ),
                        icon: const Icon(Icons.phone_in_talk, size: 24),
                        label: const Text(
                          'CALL 119 - EMERGENCY',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    
                    const Divider(height: 1),
                    
                    Container(
                      padding: const EdgeInsets.only(top: 8),
                      child: const Text(
                        'Contact Emergency Contacts',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                          color: Colors.black87,
                        ),
                      ),
                    ),
                    
                    // Contact list
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                      child: Column(
                        children: widget.contacts.map((contact) => Card(
                          margin: const EdgeInsets.only(bottom: 8),
                          elevation: 2,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                            side: BorderSide(
                              color: contact.contactType == ContactType.hospital
                                ? Colors.blue.shade200
                                : Colors.green.shade200,
                              width: 1,
                            ),
                          ),
                          child: ListTile(
                            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                            leading: CircleAvatar(
                              backgroundColor: contact.contactType == ContactType.hospital
                                ? Colors.blue.shade100
                                : Colors.green.shade100,
                              child: Icon(
                                contact.contactType == ContactType.hospital
                                    ? Icons.local_hospital
                                    : Icons.person,
                                color: contact.contactType == ContactType.hospital
                                    ? Colors.blue.shade800
                                    : Colors.green.shade800,
                              ),
                            ),
                            title: Text(
                              contact.name,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            subtitle: Text(contact.phoneNumber),
                            trailing: Icon(
                              Icons.message,
                              color: Colors.orange.shade700,
                            ),
                            onTap: () => _contactWithLocation(contact),
                          ),
                        )).toList(),
                      ),
                    ),
                    
                    // Close button
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: TextButton.icon(
                        onPressed: _toggleExpanded,
                        icon: const Icon(Icons.close),
                        label: const Text('Close'),
                        style: TextButton.styleFrom(
                          foregroundColor: Colors.grey.shade700,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          
          // Main SOS button
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            height: 60,
            width: 60,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: _isExpanded ? Colors.grey : Colors.red,
              boxShadow: [
                BoxShadow(
                  color: _isPulsing && !_isExpanded
                      ? Colors.red.withOpacity(0.7)
                      : Colors.black.withOpacity(0.2),
                  blurRadius: _isPulsing && !_isExpanded ? 20 : 10,
                  spreadRadius: _isPulsing && !_isExpanded ? 8 : 2,
                ),
              ],
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: _toggleExpanded,
                customBorder: const CircleBorder(),
                child: Center(
                  child: Icon(
                    _isExpanded ? Icons.close : Icons.warning_amber_rounded,
                    color: Colors.white,
                    size: 32,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class EmergencyContact {
  final String id;
  final String name;
  final String phoneNumber;
  final ContactType contactType;
  final String? notes;

  EmergencyContact({
    required this.id,
    required this.name,
    required this.phoneNumber,
    this.contactType = ContactType.personal,
    this.notes,
  });
}

enum ContactType { personal, hospital, police }

// Helper widget that can be used anywhere in the app
class SOSProvider extends StatelessWidget {
  final Widget child;
  final bool showFloatingButton;

  const SOSProvider({
    super.key,
    required this.child,
    this.showFloatingButton = true,
  });

  @override
  Widget build(BuildContext context) {
    // Sample contacts - in a real app, these would come from a provider or database
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

    return Stack(
      children: [
        child,
        if (showFloatingButton)
          Positioned(
            right: 20,
            bottom: 80,
            child: AnimatedSOSButton(contacts: contacts),
          ),
      ],
    );
  }
}

// A simpler SOS button that animates and expands
class AnimatedSOSButton extends StatefulWidget {
  final List<EmergencyContact> contacts;

  const AnimatedSOSButton({
    super.key,
    required this.contacts,
  });

  @override
  _AnimatedSOSButtonState createState() => _AnimatedSOSButtonState();
}

class _AnimatedSOSButtonState extends State<AnimatedSOSButton> {
  bool _isSOSActive = false;
  bool _isPulsing = false;
  Timer? _pulseTimer;

  @override
  void initState() {
    super.initState();
    _startPulseAnimation();
  }

  void _startPulseAnimation() {
    _pulseTimer = Timer.periodic(const Duration(milliseconds: 800), (timer) {
      if (mounted) {
        setState(() {
          _isPulsing = !_isPulsing;
        });
      }
    });
  }

  @override
  void dispose() {
    _pulseTimer?.cancel();
    super.dispose();
  }

  void _toggleSOS() {
    setState(() {
      _isSOSActive = !_isSOSActive;
      if (_isSOSActive) {
        HapticFeedback.mediumImpact();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // The SOS floating panel
        if (_isSOSActive)
          SOSFloatingButton(
            contacts: widget.contacts,
            onClose: () {
              setState(() {
                _isSOSActive = false;
              });
            },
          ),
          
        // If the SOS panel is not active, show the mini button
        if (!_isSOSActive)
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            height: 60,
            width: 60,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.red,
              boxShadow: [
                BoxShadow(
                  color: _isPulsing
                      ? Colors.red.withOpacity(0.7)
                      : Colors.black.withOpacity(0.2),
                  blurRadius: _isPulsing ? 20 : 10,
                  spreadRadius: _isPulsing ? 8 : 2,
                ),
              ],
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: _toggleSOS,
                customBorder: const CircleBorder(),
                child: const Center(
                  child: Icon(
                    Icons.warning_amber_rounded,
                    color: Colors.white,
                    size: 32,
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}