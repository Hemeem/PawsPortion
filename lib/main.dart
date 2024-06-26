import 'package:flutter/material.dart';
// import 'package:pawsportion/ConnectDevice.dart';
import 'package:pawsportion/onboarding_page.dart';
import 'mealpage.dart' as meal_page;
import 'schedulepage.dart' as schedule_page;
import 'logpage.dart' as log_page;
import 'bottom_navigation_bar.dart';  
 
void main() {
  runApp(PawsPortionFeederApp());
}

class PawsPortionFeederApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: OnboardingPage(), // Starting with the onboarding page
    );
  }
}

class MealPageWithBottomNav extends StatefulWidget {
  @override
  _MealPageWithBottomNavState createState() => _MealPageWithBottomNavState();
}

class _MealPageWithBottomNavState extends State<MealPageWithBottomNav> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    meal_page.MealPage(),
    schedule_page.SchedulePage(),
    log_page.LogPage(),
  ];

  void _onNavBarTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavBar(
        currentIndex: _currentIndex,
        onTap: _onNavBarTapped,
      ),
    );
  }
}
