import 'package:binpack_residents/utils/responsive_layout.dart';
import 'package:binpack_residents/views/global/onboarding/widgets/onboardingBottomWidget.dart';
import 'package:binpack_residents/views/global/onboarding/widgets/onboardingDataWidget.dart';
import 'package:binpack_residents/views/global/onboarding/widgets/onboardingPageWidegt.dart';
import 'package:flutter/material.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  _OnboardingScreenState createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentIndex = 0;

  void _nextPage() {
    if (_currentIndex < onboardingData.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 500),
        curve: Curves.ease,
      );
    }
  }

  void _onPageChanged(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ResponsiveLayout(
        mobile: OnboardingPage(
          pageController: _pageController,
          currentIndex: _currentIndex,
          onPageChanged: _onPageChanged,
        ),
        tablet: OnboardingPage(
          pageController: _pageController,
          currentIndex: _currentIndex,
          onPageChanged: _onPageChanged,
        ),
        desktop: OnboardingPage(
          pageController: _pageController,
          currentIndex: _currentIndex,
          onPageChanged: _onPageChanged,
        ),
      ),
      bottomNavigationBar: OnboardingBottomBar(
        currentIndex: _currentIndex,
        nextPage: _nextPage,
      ),
    );
  }
}
