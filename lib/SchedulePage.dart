import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:pawsportion/widget/ScheduleTile.dart';
import 'dart:convert';
import 'ScheduleItem.dart';
import 'package:pawsportion/widget/ScheduleTile.dart';
import 'package:pawsportion/widget/ScheduleButton.dart';
import 'AddSchedulePage.dart';

class SchedulePage extends StatefulWidget {
  @override
  _SchedulePageState createState() => _SchedulePageState();
}

class _SchedulePageState extends State<SchedulePage> {
<<<<<<< HEAD
  final List<ScheduleItem> _schedules = [
    ScheduleItem(
        time: '07:00',
        portions: 15,
        enabled: true,
        repeatDays: List.generate(7, (index) => true)),
    ScheduleItem(
        time: '12:00',
        portions: 15,
        enabled: true,
        repeatDays: List.generate(7, (index) => true)),
    ScheduleItem(
        time: '16:00',
        portions: 15,
        enabled: false,
        repeatDays: List.generate(7, (index) => true)),
    ScheduleItem(
        time: '20:00',
        portions: 15,
        enabled: false,
        repeatDays: List.generate(7, (index) => true)),
  ];
=======
  List<ScheduleItem> _schedules = [];
  bool _isLoading = true;
>>>>>>> 38cae59a8da769089290464d5a8d10d691475ed2

  @override
  void initState() {
    super.initState();
    _fetchSchedules();
  }

  Future<void> _fetchSchedules() async {
    final url = Uri.https('pawsportion-0-default-rtdb.firebaseio.com', 'schedules-list.json');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      final List<ScheduleItem> loadedSchedules = [];

      data.forEach((key, value) {
        if (value is Map<String, dynamic> && value.containsKey('time')) {
          loadedSchedules.add(ScheduleItem(
            id: value['id'] ?? key,
            time: value['time'],
            portions: value['portions'],
            enabled: value['enabled'],
            repeatDays: List<bool>.from(value['repeatDays']),
          ));
        } else if (value is Map<String, dynamic>) {
          value.forEach((subKey, subValue) {
            if (subValue is Map<String, dynamic> && subValue.containsKey('time')) {
              loadedSchedules.add(ScheduleItem(
                id: subValue['id'] ?? subKey,
                time: subValue['time'],
                portions: subValue['portions'],
                enabled: subValue['enabled'],
                repeatDays: List<bool>.from(subValue['repeatDays']),
              ));
            }
          });
        }
      });

      setState(() {
        _schedules = loadedSchedules;
        _sortSchedulesByTime();
        _isLoading = false;
      });
    } else {
      print('Failed to fetch schedules: ${response.statusCode}');
      setState(() {
        _isLoading = false;
      });
    }
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

  void _updateScheduleStatus(bool newValue, ScheduleItem schedule) {
    setState(() {
      schedule.enabled = newValue;
    });
    // Update status in Firebase (optional)
  }

  Future<void> _navigateToAddSchedulePage(BuildContext context) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => AddSchedulePage()),
    );

    if (result != null && result is ScheduleItem) {
      setState(() {
        _schedules.add(result);
        _sortSchedulesByTime();
      });
    }
  }

<<<<<<< HEAD
  Future<void> _navigateToEditSchedulePage(
      BuildContext context, int index) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddSchedulePage(schedule: _schedules[index]),
      ),
    );
=======
 Future<void> _navigateToEditSchedulePage(BuildContext context, ScheduleItem schedule) async {
  final result = await Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => AddSchedulePage(schedule: schedule)),
  );
>>>>>>> 38cae59a8da769089290464d5a8d10d691475ed2

  if (result != null && result is ScheduleItem) {
    setState(() {
      final index = _schedules.indexWhere((s) => s.id == schedule.id);
      if (index != -1) {
        _schedules[index] = result;
        _sortSchedulesByTime();
      }
    });
     } else if (result == DELETE_SIGNAL) {
    final url = Uri.https('pawsportion-0-default-rtdb.firebaseio.com', 'schedules-list/${schedule.id}.json');
    final response = await http.delete(url);

    if (response.statusCode == 200) {
      setState(() {
        _schedules.removeWhere((s) => s.id == schedule.id);
      });
    } else {
      print('Failed to delete schedule: ${response.statusCode} - ${response.body}');
    }
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Schedules'),
        backgroundColor: Color(0xFFD79A3D),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: _schedules.length,
              itemBuilder: (context, index) {
                final schedule = _schedules[index];
                return GestureDetector(
                  onTap: () => _navigateToEditSchedulePage(context, schedule),
                  child: ScheduleTile(
                    schedule: schedule,
                    onChanged: (newValue) {
                      _updateScheduleStatus(newValue, schedule);
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
    );
  }
}
