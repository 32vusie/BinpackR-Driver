import 'package:binpack_residents/views/global/onboarding/widgets/onboardingDataWidget.dart';
import 'package:flutter/material.dart';

class OnboardingPage extends StatelessWidget {
  final PageController pageController;
  final int currentIndex;
  final ValueChanged<int> onPageChanged;

  const OnboardingPage({
    super.key,
    required this.pageController,
    required this.currentIndex,
    required this.onPageChanged,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: double.infinity,
      child: PageView.builder(
        controller: pageController,
        itemCount: onboardingData.length,
        onPageChanged: onPageChanged,
        itemBuilder: (context, index) {
          bool isMobile = MediaQuery.of(context).size.width < 600;

          return Padding(
            padding: const EdgeInsets.all(20.0),
            child: isMobile
                ? Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: 200,
                        child: Image.asset(
                          onboardingData[index]['top_image']!,
                          fit: BoxFit.cover,
                        ),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        onboardingData[index]['text']!,
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                    ],
                  )
                : Row(
                    children: [
                      Expanded(
                        child: Image.asset(
                          onboardingData[index]['top_image']!,
                          fit: BoxFit.cover,
                        ),
                      ),
                      const SizedBox(width: 20),
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              onboardingData[index]['text']!,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
          );
        },
      ),
    );
  }
}
