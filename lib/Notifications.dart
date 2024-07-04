import 'package:flutter/material.dart';

class NotificationsPage extends StatelessWidget {
  final List<String> notifications;

  NotificationsPage({required this.notifications});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Notifications',
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: true,
        backgroundColor: Color(0xFFD79A3D),
        iconTheme:
            IconThemeData(color: Colors.black), // Set back icon color to black
      ),
      body: ListView.builder(
        itemCount: notifications.length + 1, // Add 1 for the custom card
        itemBuilder: (context, index) {
          if (index == 0) {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 5,
                      blurRadius: 7,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
                child: Card(
                  color:
                      Color(0xFFF0A493), // Set the background color of the card
                  child: Padding(
                    padding: const EdgeInsets.all(
                        16.0), // Increase padding for larger size
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Stok makanan hampir habis!',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                            height: 8), // Add space between title and subtitle
                        Text(
                          'Isi kembali makanan, jangan sampai peliharaanmu kelaparan ^_^',
                          style: TextStyle(fontSize: 16),
                        ),
                        SizedBox(
                            height: 16), // Add space between subtitle and label
                        Text(
                          'June 2024',
                          style: TextStyle(fontSize: 14, color: Colors.black),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          } else {
            return ListTile(
              title: Text(
                  notifications[index - 1]), // Adjust index for custom card
            );
          }
        },
      ),
    );
  }
}
