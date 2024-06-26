import 'package:flutter/material.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:pawsportion/ConnnectDevice.dart';
import 'package:pawsportion/main.dart';
import 'mealpage.dart'; // Replace with the actual path if necessary

class OnboardingPage extends StatefulWidget {
  @override
  _OnboardingPageState createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  void _onPageChanged(int page) {
    setState(() {
      _currentPage = page;
    });
  }

 void _onSkipPressed() {
    _navigateToConnectDevicePage(context);
  }

  void _onNextPressed() {
    if (_currentPage < 2) {
      _pageController.nextPage(
        duration: Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      _navigateToConnectDevicePage(context);
    }
  }

  void _navigateToConnectDevicePage(BuildContext context) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => WelcomeDevicePage(),
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          PageView(
            controller: _pageController,
            onPageChanged: _onPageChanged,
            children: [
              OnboardingScreen(
                imageAsset: 'assets/onboarding1.jpg',
                title: 'Welcome to PawsPortion',
                description: 'Automate your pet feeding with ease.',
              ),
              OnboardingScreen(
                imageAsset: 'assets/onboarding2.jpg',
                title: 'Set Feeding Schedule',
                description: 'Create and customize feeding schedules for your pets.',
              ),
              OnboardingScreen(
                imageAsset: 'assets/onboarding3.jpg',
                title: 'Monitor Feedings',
                description: 'Keep track of feeding times and portions.',
              ),
            ],
          ),
          Positioned(
            bottom: 16,
            left: 16,
            right: 16,
            child: Column(
              children: [
                DotsIndicator(
                  dotsCount: 3,
                  position: _currentPage.toDouble(),
                  decorator: DotsDecorator(
                    activeColor: Color(0xFFD79A3D),
                  ),
                ),
                SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton(
                      onPressed: _onSkipPressed,
                      child: Text(
                        'Skip',
                        style: TextStyle(color: Colors.grey, fontSize: 16),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: _onNextPressed,
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(Color(0xFFD79A3D)),
                      ),
                      child: Text(
                        _currentPage < 2 ? 'Next' : 'Get Started',
                        style: TextStyle(fontSize: 16, color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class OnboardingScreen extends StatelessWidget {
  final String imageAsset;
  final String title;
  final String description;

  OnboardingScreen({
    required this.imageAsset,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset(imageAsset, height: 300),
        SizedBox(height: 40),
        Text(
          title,
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 20),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40.0),
          child: Text(
            description,
            style: TextStyle(fontSize: 16),
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }
}
