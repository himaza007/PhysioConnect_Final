// ignore_for_file: deprecated_member_use, library_private_types_in_public_api, prefer_final_fields

import 'package:flutter/material.dart';
import 'bottom_app_bar.dart';

class NearbyFacilitiesScreen extends StatefulWidget {
  const NearbyFacilitiesScreen({super.key});

  @override
  _NearbyFacilitiesScreenState createState() => _NearbyFacilitiesScreenState();
}

class _NearbyFacilitiesScreenState extends State<NearbyFacilitiesScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  bool _isLoading = false;
  int _currentNavIndex = 0; // For bottom navigation
  int _selectedTabIndex = 0;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _tabController.addListener(_handleTabChange);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _handleTabChange() {
    if (_tabController.indexIsChanging) {
      setState(() {
        _selectedTabIndex = _tabController.index;
      });
    }
  }

  void _onNavItemTapped(int index) {
    if (index == _currentNavIndex) return;
    setState(() {
      _currentNavIndex = index;
    });
    Navigator.of(context).pop();
  }

  // Sample facility data
  List<Map<String, String>> getFacilitiesByType(int tabIndex) {
    switch (tabIndex) {
      case 0: // Hospitals
        return [
          {'name': 'City Memorial Hospital', 'distance': '1.2 km', 'rating': '4.8'},
          {'name': 'Community General Hospital', 'distance': '3.5 km', 'rating': '4.3'},
          {'name': 'Central Medical Center', 'distance': '5.7 km', 'rating': '4.5'},
          {'name': 'St. Luke\'s Hospital', 'distance': '7.2 km', 'rating': '4.7'},
          {'name': 'Valley Regional Hospital', 'distance': '8.9 km', 'rating': '4.1'},
        ];
      case 1: // Doctors
        return [
          {'name': 'Dr. Smith Family Practice', 'distance': '0.8 km', 'rating': '4.9'},
          {'name': 'Dr. Johnson Clinic', 'distance': '2.3 km', 'rating': '4.6'},
          {'name': 'Dr. Williams Medical Office', 'distance': '3.2 km', 'rating': '4.4'},
          {'name': 'Dr. Miller Healthcare', 'distance': '5.1 km', 'rating': '4.5'},
          {'name': 'Dr. Davis Family Medicine', 'distance': '6.3 km', 'rating': '4.2'},
        ];
      case 2: // Physiotherapists
        return [
          {'name': 'Elite Physical Therapy', 'distance': '1.5 km', 'rating': '4.7'},
          {'name': 'Motion Physiotherapy Center', 'distance': '2.7 km', 'rating': '4.5'},
          {'name': 'Recovery Rehab & Physio', 'distance': '4.3 km', 'rating': '4.8'},
          {'name': 'Active Life Physical Therapy', 'distance': '5.8 km', 'rating': '4.4'},
          {'name': 'Restore Physiotherapy', 'distance': '7.5 km', 'rating': '4.6'},
        ];
      default:
        return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: const Color(0xFF33724B),
        title: const Text(
          "Nearby Facilities Locator", 
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          color: Colors.white,
          onPressed: () => Navigator.of(context).pop(),
        ),
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.white,
          tabs: const [
            Tab(
              icon: Icon(Icons.local_hospital, color: Colors.white),
              child: Text(
                "Hospitals",
                style: TextStyle(color: Colors.white, fontSize: 13),
              ),
            ),
            Tab(
              icon: Icon(Icons.medical_services, color: Colors.white),
              child: Text(
                "Doctors",
                style: TextStyle(color: Colors.white, fontSize: 13),
              ),
            ),
            Tab(
              icon: Icon(Icons.healing, color: Colors.white),
              child: Text(
                "Physiotherapists",
                style: TextStyle(color: Colors.white, fontSize: 13),
              ),
            ),
          ],
        ),
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
          _isLoading
              ? const Center(child: CircularProgressIndicator(color: Colors.white))
              : Stack(
                  children: [
                    // Facility List View
                    Container(
                      margin: const EdgeInsets.only(top: 16, bottom: 70), // Space for bottom bar
                      child: Column(
                        children: [
                          // Info banner
                          Container(
                            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.1),
                                  blurRadius: 4,
                                  spreadRadius: 1,
                                  offset: const Offset(2, 2),
                                ),
                              ],
                            ),
                            child: Text(
                              _selectedTabIndex == 0
                                  ? "Showing nearby hospitals (within 49km)"
                                  : _selectedTabIndex == 1
                                      ? "Showing nearby doctors (within 49km)"
                                      : "Showing nearby physiotherapists (within 49km)",
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                fontSize: 14,
                                color: Colors.black87,
                              ),
                            ),
                          ),
                          
                          // Facilities list
                          Expanded(
                            child: ListView.builder(
                              padding: const EdgeInsets.all(16),
                              itemCount: getFacilitiesByType(_selectedTabIndex).length,
                              itemBuilder: (context, index) {
                                final facility = getFacilitiesByType(_selectedTabIndex)[index];
                                return _buildFacilityCard(
                                  facility['name'] ?? 'Unknown',
                                  facility['distance'] ?? 'Unknown',
                                  facility['rating'] ?? 'N/A',
                                  _selectedTabIndex,
                                );
                              },
                            ),
                          ),
                        ],
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
        ],
      ),
      bottomNavigationBar: PhysioBottomAppBar(
        currentIndex: _currentNavIndex,
        onTap: _onNavItemTapped,
      ),
    );
  }

  Widget _buildFacilityCard(String name, String distance, String rating, int facilityType) {
    IconData typeIcon;
    Color typeColor;
    
    // Set icon and color based on facility type
    if (facilityType == 0) { // Hospital
      typeIcon = Icons.local_hospital;
      typeColor = Colors.red;
    } else if (facilityType == 1) { // Doctor
      typeIcon = Icons.medical_services;
      typeColor = Colors.blue;
    } else { // Physiotherapist
      typeIcon = Icons.healing;
      typeColor = Colors.green;
    }
    
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        leading: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: typeColor.withOpacity(0.2),
            shape: BoxShape.circle,
          ),
          child: Icon(typeIcon, color: typeColor, size: 28),
        ),
        title: Text(
          name,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.location_on, size: 16, color: Colors.grey),
                const SizedBox(width: 4),
                Text(distance),
              ],
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                const Icon(Icons.star, size: 16, color: Colors.amber),
                const SizedBox(width: 4),
                Text(rating),
              ],
            ),
          ],
        ),
        trailing: IconButton(
          icon: const Icon(Icons.directions),
          color: const Color(0xFF33724B),
          onPressed: () {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Directions to $name'),
                duration: const Duration(seconds: 1),
              ),
            );
          },
        ),
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