import 'package:flutter/material.dart';
import 'package:pawsportion/AddSchedulePage.dart';
import 'package:pawsportion/ScheduleItem.dart';
import 'package:pawsportion/widget/ScheduleButton.dart';
import 'package:pawsportion/widget/ScheduleTile.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class SchedulePage extends StatefulWidget {
  const SchedulePage({Key? key}) : super(key: key);

  @override
  _SchedulePageState createState() => _SchedulePageState();
}

class _SchedulePageState extends State<SchedulePage> {
  List<ScheduleItem> _schedules = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchSchedules();
  }

  Future<void> _fetchSchedules() async {
    final url = Uri.https(
        'pawsportion-0-default-rtdb.firebaseio.com', 'schedules-list.json');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final Map<String, dynamic> schedulesMap = json.decode(response.body);
      final List<ScheduleItem> loadedSchedules =
          schedulesMap.entries.map((entry) {
        return ScheduleItem(
          id: entry.key,
          time: entry.value['time'],
          portions: entry.value['portions'],
          enabled: entry.value['enabled'],
          repeatDays: List<bool>.from(entry.value['repeatDays']),
        );
      }).toList();

      setState(() {
        _schedules = loadedSchedules;
        _sortSchedulesByTime();
        _isLoading = false;
      });
    } else {
      setState(() {
        _isLoading = false;
      });
      print('Failed to load schedules: ${response.statusCode}');
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

  Future<void> _navigateToAddSchedulePage(BuildContext context) async {
    final newSchedule = await Navigator.push<ScheduleItem>(
      context,
      MaterialPageRoute(builder: (context) => AddSchedulePage()),
    );
    if (newSchedule != null) {
      setState(() {
        _schedules.add(newSchedule);
        _sortSchedulesByTime();
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
    await _deleteSchedule(index);
  } else if (result != null) {
    setState(() {
      _schedules[index] = result as ScheduleItem;
      _sortSchedulesByTime(); // Sort schedules after editing
    });
  }
}


Future<void> _updateScheduleInFirebase(ScheduleItem schedule) async {
  final url = Uri.https('pawsportion-0-default-rtdb.firebaseio.com', 'schedules-list/${schedule.id}.json');
  final response = await http.put(
    url,
    headers: {
      'Content-Type': 'application/json',
    },
    body: json.encode({
      'time': schedule.time,
      'portions': schedule.portions,
      'enabled': schedule.enabled,
      'repeatDays': schedule.repeatDays,
    }),
  );

  if (response.statusCode == 200) {
    print('Schedule updated successfully: ${response.body}');
  } else {
    print('Failed to update schedule: ${response.statusCode} - ${response.body}');
    // Optionally, show an error message to the user
  }
}

Future<void> _deleteSchedule(int index) async {
  final schedule = _schedules[index];
  final url = Uri.https('pawsportion-0-default-rtdb.firebaseio.com', 'schedules-list/${schedule.id}.json');
  final response = await http.delete(url);

  if (response.statusCode == 200) {
    print('Schedule deleted successfully: ${response.body}');
    setState(() {
      _schedules.removeAt(index);
    });
  } else {
    print('Failed to delete schedule: ${response.statusCode} - ${response.body}');
    // Optionally, show an error message to the user
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
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
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
