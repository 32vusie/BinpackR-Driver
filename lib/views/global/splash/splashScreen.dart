import 'package:binpack_residents/views/auth/login_screen/login_screen.dart';
import 'package:binpack_residents/views/global/onboarding/onboarding_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:binpack_residents/utils/responsive_layout.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    // Animation setup
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeIn),
    );
    _controller.forward();

    _checkOnboardingStatus();
  }

  Future<void> _checkOnboardingStatus() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final bool isOnboardingShown = prefs.getBool('isOnboardingShown') ?? false;

    await Future.delayed(const Duration(seconds: 3));

    if (isOnboardingShown) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginScreen()),
      );
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const OnboardingScreen()),
      );
      await prefs.setBool('isOnboardingShown', true);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ResponsiveLayout(
        mobile: buildSplashContent(context, 24.0),
        tablet: buildSplashContent(context, 36.0),
        desktop: buildSplashContent(context, 48.0),
      ),
    );
  }

  Widget buildSplashContent(BuildContext context, double fontSize) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF1B5E20), // Dark green
            Color(0xFF4CAF50), // Lighter green
          ],
        ),
      ),
      alignment: Alignment.center,
      child: FadeTransition(
        opacity: _fadeAnimation,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.local_shipping, // Truck icon (temporary, you can change later)
              size: 100,
              color: Colors.white,
            ),
            const SizedBox(height: 20),
            Text(
              'Binpack Residents',
              style: TextStyle(
                fontSize: fontSize + 4,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
            Text(
              'A Clean Start',
              style: TextStyle(
                fontSize: fontSize,
                color: Colors.white70,
                fontWeight: FontWeight.normal,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}