import 'package:dressedat/core/supabase_client.dart';
import 'package:dressedat/features/auth/presentation/screens/login_screen.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkLogin();
  }

  void _checkLogin() async {
    // Wait 1 second for splash effect
    await Future.delayed(const Duration(seconds: 2));

    final user = supabase.auth.currentUser;

    if (!mounted) return;

    if (user != null) {
      // User already logged in, go to home
      Navigator.pushReplacementNamed(context, '/home');
    } else {
      // Not logged in, go to login screen
      Navigator.pushReplacementNamed(context, '/login');
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Text(
          'DressedAT',
          style: TextStyle(
            color: Colors.white,
            fontSize: 32,
            fontWeight: FontWeight.bold,
            letterSpacing: 2,
          ),
        ),
      ),
    );
  }
}
