import 'package:flutter/material.dart';
import 'app_coordinator.dart';
import 'tutorial_model.dart';
import 'splash_screen.dart';
import 'login_page.dart';
import 'signup_page.dart';
import 'pain_monitoring.dart';
import 'first_aid_screen.dart';
import 'tutorial_detail_screen.dart';
import 'pain_history_screen.dart';
import 'home_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PhysioConnect',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: const Color(0xFF33724B),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF33724B),
          primary: const Color(0xFF33724B),
        ),
        scaffoldBackgroundColor: Colors.white,
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF33724B),
          foregroundColor: Colors.white,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF33724B),
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const SplashScreen(),
        '/login': (context) => const LoginPage(),
        '/signup': (context) => const SignupPage(),
        '/home': (context) => const HomePage(),
        '/main': (context) => const AppCoordinator(),
        '/pain-monitoring': (context) => const PainMonitoringPage(),
        '/tutorials': (context) => const FirstAidScreen(),
        '/pain-history': (context) => PainHistoryScreen(
              painHistory: const [], // ✅ You will populate this later
            ),
      },
      onGenerateRoute: (settings) {
        if (settings.name == '/tutorial-detail') {
          final tutorial = settings.arguments as TutorialModel;
          return MaterialPageRoute(
            builder: (context) => TutorialDetailScreen(tutorial: tutorial),
          );
        }
        return null;
      },
    );
  }
}