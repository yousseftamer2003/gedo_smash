import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:food2go_app/constants/colors.dart';
import 'package:food2go_app/view/screens/Auth/login_screen.dart';
import 'package:food2go_app/view/screens/onboarding_screens/widget/onboarding_content.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class Onboarding extends StatefulWidget {
  const Onboarding({super.key});

  @override
  State<Onboarding> createState() => _OnboardingState();
}

class _OnboardingState extends State<Onboarding> {
  final PageController _pageController = PageController();
  int _currentIndex = 0;

  Future<void> _completeOnboarding() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isNewUser', false); // Mark user as not new

    Navigator.pushReplacement(
      // ignore: use_build_context_synchronously
      context,
      MaterialPageRoute(builder: (context) => const LoginScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          PageView(
            controller: _pageController,
            onPageChanged: (index) {
              setState(() {
                _currentIndex = index;
              });
            },
            children: const [
              OnboardingContent(
                image: 'assets/images/f1.png',
                title: 'Your Meal In An Instant',
                subtitle:
                    'Order Your Favorite Meal From Your Favorite Restaurants '
                    'And Have It Delivered Wherever You Are, With The Click Of A Button',
              ),
              OnboardingContent(
                image: 'assets/images/second.png',
                title: 'Save Your Time And Effort',
                subtitle: 'Enjoy a unique dining experience with '
                    'exclusive offers and Great discounts',
              ),
              OnboardingContent(
                image: 'assets/images/third.png',
                title: 'A Unique Dining Experience',
                subtitle: 'Enjoy a unique dining experience with '
                    'exclusive offers and Great discounts',
              ),
            ],
          ),
          Positioned(
            bottom: 130,
            right: MediaQuery.sizeOf(context).width / 2.4,
            child: SmoothPageIndicator(
              controller: _pageController,
              count: 3,
              effect: const WormEffect(
                dotWidth: 16.0,
                dotHeight: 6.0,
                activeDotColor: maincolor,
                dotColor: Colors.white,
              ),
            ),
          ),
          Positioned(
            bottom: 80,
            right: MediaQuery.sizeOf(context).width / 2.4,
            child: TextButton(
              onPressed: () {
                if (_currentIndex == 2) {
                  _completeOnboarding(); // Complete onboarding and navigate to Login
                } else {
                  _pageController.nextPage(
                    duration: const Duration(milliseconds: 500),
                    curve: Curves.easeInOut,
                  );
                }
              },
              child: const Text(
                'Next',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
