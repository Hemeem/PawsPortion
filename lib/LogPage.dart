import 'package:flutter/material.dart';

class LogPage extends StatelessWidget {
  const LogPage({Key? key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Log',
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: true,
        backgroundColor: Color(0xFFD79A3D),
        iconTheme: IconThemeData(color: Colors.black), // Mengatur warna AppBar
      ),
    );
  }
}
