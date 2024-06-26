import 'package:flutter/material.dart';
import 'package:pawsportion/Notifications.dart';
import 'package:pawsportion/widget/FeedNotification.dart';
import 'package:pawsportion/widget/ManualFeedButton.dart';

class MealPage extends StatefulWidget {
  @override
  _MealPageState createState() => _MealPageState();
}

class _MealPageState extends State<MealPage> {
  int portion = 1; // Ensure starting portion is at least 1
  List<String> _notifications = [];
  

  void _incrementPortion() {
    setState(() {
      portion++;
    });
  }

  void _decrementPortion() {
    setState(() {
      if (portion > 1) portion--; // Prevent portion from going below 1
    });
  }

  void _viewNotifications() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => NotificationsPage(notifications: _notifications),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'PawsPortion Feeder',
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: true,
        backgroundColor: Color(0xFFD79A3D),
        iconTheme: IconThemeData(color: Colors.black),
        actions: [
          IconButton(
            icon: Icon(Icons.notifications),
            onPressed: _viewNotifications,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 20),
            FeedNotification(),
            SizedBox(height: 60),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Select Portions',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      icon: Icon(Icons.remove_circle, color: Colors.red, size: 50),
                      onPressed: _decrementPortion,
                    ),
                    SizedBox(width: 30),
                    Container(
                      width: 100,
                      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey, width: 2),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        '$portion',
                        style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    SizedBox(width: 20),
                    IconButton(
                      icon: Icon(Icons.add_circle, color: Colors.green, size: 50),
                      onPressed: _incrementPortion,
                    ),
                  ],
                ),
                SizedBox(height: 5),
                Text(
                  '1 Portion = 10g',
                  style: TextStyle(fontSize: 16),
                ),
              ],
            ),
            SizedBox(height: 80),
            ManualFeedButton(portion: portion), // Pass portion to the button
          ],
        ),
      ),
    );
  }
}
