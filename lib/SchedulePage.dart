import 'package:flutter/material.dart';
import 'package:pawsportion/AddSchedulePage.dart';
import 'package:pawsportion/schedulepage.dart';
import 'package:pawsportion/widget/ScheduleButton.dart';

class SchedulePage extends StatefulWidget {
  const SchedulePage({Key? key});

  @override
  _SchedulePageState createState() => _SchedulePageState();
}

class _SchedulePageState extends State<SchedulePage> {
  final List<ScheduleItem> _schedules = [
    ScheduleItem(time: '07:00', portions: 15, enabled: true),
    ScheduleItem(time: '12:00', portions: 15, enabled: true),
    ScheduleItem(time: '16:00', portions: 15, enabled: false),
    ScheduleItem(time: '20:00', portions: 15, enabled: false),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Schedule',
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: true,
        backgroundColor: Color(0xFFD79A3D),
        iconTheme: IconThemeData(color: Colors.black),
      ),
      body: Padding(
        padding: EdgeInsets.only(top: 50.0, bottom: 80.0),
        child: ListView.builder(
          itemCount: _schedules.length,
          itemBuilder: (context, index) {
            return ScheduleTile(
              schedule: _schedules[index],
              onChanged: (bool value) {
                setState(() {
                  _schedules[index].enabled = value;
                });
              },
            );
          },
        ),
      ),
      floatingActionButton: ScheduleButton(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
