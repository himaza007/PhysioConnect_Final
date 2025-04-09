import 'package:flutter/material.dart';

// Calendar Page
class CalendarPage extends StatelessWidget {
  const CalendarPage({super.key}); // Use the super.key parameter

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.calendar_month_rounded,
              size: 80,
              color: const Color(0xFF33724B),
            ),
            const SizedBox(height: 16),
            const Text(
              'Calendar',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color(0xFF33724B),
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Your appointments and sessions will appear here',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Notifications Page
class NotificationsPage extends StatelessWidget {
  const NotificationsPage({super.key}); // Use the super.key parameter

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.notifications_rounded,
              size: 80,
              color: const Color(0xFF33724B),
            ),
            const SizedBox(height: 16),
            const Text(
              'Notifications',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color(0xFF33724B),
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Your alerts and reminders will appear here',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
