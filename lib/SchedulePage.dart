import 'package:flutter/material.dart';
import 'package:pawsportion/AddSchedulePage.dart';
import 'package:pawsportion/ScheduleItem.dart';
import 'package:pawsportion/widget/ScheduleButton.dart';
import 'package:pawsportion/widget/ScheduleTile.dart';

class SchedulePage extends StatefulWidget {
  const SchedulePage({Key? key}) : super(key: key);

  @override
  _SchedulePageState createState() => _SchedulePageState();
}

class _SchedulePageState extends State<SchedulePage> {
  final List<ScheduleItem> _schedules = [
    ScheduleItem(time: '07:00', portions: 15, enabled: true, repeatDays: List.generate(7, (index) => true)),
    ScheduleItem(time: '12:00', portions: 15, enabled: true, repeatDays: List.generate(7, (index) => true)),
    ScheduleItem(time: '16:00', portions: 15, enabled: false, repeatDays: List.generate(7, (index) => true)),
    ScheduleItem(time: '20:00', portions: 15, enabled: false, repeatDays: List.generate(7, (index) => true)),
  ];

  @override
  void initState() {
    super.initState();
    _sortSchedulesByTime(); // Sort schedules when the widget is initialized
  }

  void _sortSchedulesByTime() {
    _schedules.sort((a, b) {
      final timeA = TimeOfDay(
        hour: int.parse(a.time.split(':')[0]),
        minute: int.parse(a.time.split(':')[1]),
      );
      final timeB = TimeOfDay(
        hour: int.parse(b.time.split(':')[0]),
        minute: int.parse(b.time.split(':')[1]),
      );
      return timeA.hour.compareTo(timeB.hour) != 0
          ? timeA.hour.compareTo(timeB.hour)
          : timeA.minute.compareTo(timeB.minute);
    });
  }

  Future<void> _navigateToAddSchedulePage(BuildContext context) async {
    final newSchedule = await Navigator.push<ScheduleItem>(
      context,
      MaterialPageRoute(builder: (context) => AddSchedulePage()),
    );
    if (newSchedule != null) {
      setState(() {
        _schedules.add(newSchedule);
        _sortSchedulesByTime(); // Sort schedules after adding a new one
      });
    }
  }

  Future<void> _navigateToEditSchedulePage(BuildContext context, int index) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddSchedulePage(schedule: _schedules[index]),
      ),
    );

    if (result == DELETE_SIGNAL) {
      setState(() {
        _schedules.removeAt(index);
      });
    } else if (result != null) {
      setState(() {
        _schedules[index] = result as ScheduleItem;
        _sortSchedulesByTime(); // Sort schedules after editing
      });
    }
  }

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
      body: ListView.builder(
        itemCount: _schedules.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () => _navigateToEditSchedulePage(context, index),
            child: ScheduleTile(
              schedule: _schedules[index],
              onChanged: (bool value) {
                setState(() {
                  _schedules[index].enabled = value;
                });
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _navigateToAddSchedulePage(context),
        child: Icon(Icons.add),
        backgroundColor: Colors.green,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
