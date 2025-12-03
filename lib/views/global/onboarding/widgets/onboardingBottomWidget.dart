import 'package:binpack_residents/views/auth/login_screen/login_screen.dart';
import 'package:binpack_residents/views/global/onboarding/widgets/onboardingDataWidget.dart';
import 'package:flutter/material.dart';

class OnboardingBottomBar extends StatelessWidget {
  final int currentIndex;
  final VoidCallback nextPage;

  const OnboardingBottomBar({
    super.key,
    required this.currentIndex,
    required this.nextPage,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: ElevatedButton(
        onPressed: () {
          if (currentIndex < onboardingData.length - 1) {
            nextPage();
          } else {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const LoginScreen()),
            );
          }
        },
        style: ElevatedButton.styleFrom(
          foregroundColor: Colors.white,
          backgroundColor: const Color.fromARGB(255, 8, 116, 13),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(150)),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 15.0),
          child: Text(
            currentIndex < onboardingData.length - 1 ? "Next" : "Get Started",
            style: const TextStyle(fontSize: 18),
          ),
        ),
      ),
    );
  }
}
