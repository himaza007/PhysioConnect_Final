import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key}); // Use super parameters

  @override
  LoginPageState createState() => LoginPageState(); // Make the State class public
}

class LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;

  Future<void> _login() async {
    // Validate inputs
    if (_emailController.text.trim().isEmpty ||
        _passwordController.text.trim().isEmpty) {
      // Check mounted before using context
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Email and password are required')),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final email = _emailController.text.trim();
      final password = _passwordController.text.trim();

      // Make the async request
      final response = await http.post(
        Uri.parse('http://10.0.2.2:5000/api/auth/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email, 'password': password}),
      );
      // Immediately check if we're still mounted after the async gap
      if (!mounted) return;

      final responseBody = jsonDecode(response.body);

      if (response.statusCode == 200) {
        // Double check we're still mounted
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(responseBody['message'] ?? 'Login successful')),
        );

        // Check one more time before navigation
        if (!mounted) return;
        Navigator.pushReplacementNamed(context, '/home');
      } else {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(responseBody['message'] ?? 'Login failed')),
        );
      }
    } catch (e) {
      // Check mounted before using context
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Network error: ${e.toString()}')),
      );
    } finally {
      // Safely stop loading spinner
      // ignore: control_flow_in_finally
      if (!mounted) return;
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF33724B),
        title: const Text('Login', style: TextStyle(color: Colors.white)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(
                labelText: 'Email',
                prefixIcon: Icon(Icons.email),
              ),
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: 'Password',
                prefixIcon: Icon(Icons.lock),
              ),
            ),
            const SizedBox(height: 24),
            _isLoading
                ? const CircularProgressIndicator()
                : ElevatedButton(
                    onPressed: _login, // Call _login without passing BuildContext
                    child: const Text('Login', style: TextStyle(fontSize: 18)),
                  ),
            const SizedBox(height: 8),
            TextButton(
              onPressed: () {
                Navigator.pushNamed(context, '/signup');
              },
              child: const Text(
                "Don't have an account? Sign up here",
                style: TextStyle(fontSize: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
