import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:jollypodcast/constants.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigateToLogin();
  }

  void _navigateToLogin() async {
    // Wait for 3 seconds (you can adjust this duration)
    await Future.delayed(const Duration(seconds: 3));

    // Check if widget is still mounted before navigating
    if (mounted) {
      context.go(kLoginPath);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox.expand(
        child: Image.asset("assets/images/splash.png", fit: BoxFit.cover),
      ),
    );
  }
}

