import 'package:flutter/material.dart';
import 'package:pawsportion/ScheduleItem.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:uuid/uuid.dart';

const String DELETE_SIGNAL = "DELETE"; // Define a constant signal for deletion

class AddSchedulePage extends StatefulWidget {
  final ScheduleItem? schedule;

  AddSchedulePage({this.schedule});

  @override
  _AddSchedulePageState createState() => _AddSchedulePageState();
}

class _AddSchedulePageState extends State<AddSchedulePage> {
  late int _selectedHour;
  late int _selectedMinute;
  late int _portions;
  late List<bool> _isSelected;

  @override
  void initState() {
    super.initState();
    if (widget.schedule != null) {
      // Editing an existing schedule
      _selectedHour = int.parse(widget.schedule!.time.split(':')[0]);
      _selectedMinute = int.parse(widget.schedule!.time.split(':')[1]);
      _portions = widget.schedule!.portions;
      _isSelected = List.from(widget.schedule!.repeatDays); // Use the existing repeatDays
    } else {
      // Adding a new schedule
      _selectedHour = 7;
      _selectedMinute = 0;
      _portions = 15;
      _isSelected = List.generate(7, (index) => false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.schedule != null ? 'Edit Schedule' : 'Add Schedule',
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: true,
        backgroundColor: Color(0xFFD79A3D),
        iconTheme: IconThemeData(color: Colors.black),
        leading: IconButton(
          icon: Icon(Icons.close),
          onPressed: () {
            Navigator.pop(context, null); // Return null to indicate cancel action
          },
        ),
        actions: [
          if (widget.schedule != null) // Show delete icon only when editing
            IconButton(
              icon: Icon(Icons.delete, color: Colors.red),
              onPressed: () {
                _showDeleteConfirmationDialog(context);
              },
            ),
          IconButton(
            icon: Icon(Icons.check),
            onPressed: () {
              _updateSchedule(context);
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            SizedBox(height: 6),
            Expanded(
              child: Column(
                children: [
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(
                          child: ListWheelScrollView.useDelegate(
                            itemExtent: 50,
                            perspective: 0.005,
                            diameterRatio: 1.5,
                            onSelectedItemChanged: (index) {
                              setState(() {
                                _selectedHour = index;
                              });
                            },
                            controller: FixedExtentScrollController(initialItem: _selectedHour),
                            childDelegate: ListWheelChildBuilderDelegate(
                              builder: (context, index) {
                                return Center(
                                  child: Text(
                                    index.toString().padLeft(2, '0'),
                                    style: TextStyle(
                                      fontSize: 24,
                                      color: _selectedHour == index ? Colors.black : Colors.grey,
                                    ),
                                  ),
                                );
                              },
                              childCount: 24,
                            ),
                          ),
                        ),
                        Align(
                          alignment: Alignment.center,
                          child: Container(
                            width: 1,
                            height: 150,
                            margin: EdgeInsets.only(bottom: 1),
                            color: Colors.black,
                          ),
                        ),
                        Expanded(
                          child: ListWheelScrollView.useDelegate(
                            itemExtent: 50,
                            perspective: 0.005,
                            diameterRatio: 1.5,
                            onSelectedItemChanged: (index) {
                              setState(() {
                                _selectedMinute = index;
                              });
                            },
                            controller: FixedExtentScrollController(initialItem: _selectedMinute),
                            childDelegate: ListWheelChildBuilderDelegate(
                              builder: (context, index) {
                                return Center(
                                  child: Text(
                                    index.toString().padLeft(2, '0'),
                                    style: TextStyle(
                                      fontSize: 24,
                                      color: _selectedMinute == index ? Colors.black : Colors.grey,
                                    ),
                                  ),
                                );
                              },
                              childCount: 60,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 30),
                  Divider(
                    color: Colors.grey,
                    height: 1,
                    thickness: 1,
                  ),
                ],
              ),
            ),
            Expanded(
              child: Column(
                children: [
                  SizedBox(height: 10),
                  Text('Repeat', style: TextStyle(fontSize: 18)),
                  SizedBox(height: 5),
                  Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _buildChoiceChip(0, 'Mon'),
                          SizedBox(width: 45),
                          _buildChoiceChip(1, 'Tue'),
                        ],
                      ),
                      SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _buildChoiceChip(2, 'Wed'),
                          SizedBox(width: 40),
                          _buildChoiceChip(3, 'Thu'),
                          SizedBox(width: 40),
                          _buildChoiceChip(4, 'Fri'),
                        ],
                      ),
                      SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _buildChoiceChip(5, 'Sat'),
                          SizedBox(width: 45),
                          _buildChoiceChip(6, 'Sun'),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: 30),
                  Divider(
                    color: Colors.grey,
                    height: 1,
                    thickness: 1,
                  ),
                ],
              ),
            ),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Portion(s)', style: TextStyle(fontSize: 20)),
                  SizedBox(height: 25),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: 80,
                        height: 70,
                        child: IconButton(
                          icon: Icon(Icons.remove_circle, color: Colors.red, size: 60),
                          onPressed: () {
                            setState(() {
                              if (_portions > 1) _portions--;
                            });
                          },
                        ),
                      ),
                      Container(
                        width: 80,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: Colors.black),
                        ),
                        padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                        child: Center(
                          child: Text(
                            _portions.toString(),
                            style: TextStyle(fontSize: 24),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 80,
                        height: 70,
                        child: IconButton(
                          icon: Icon(Icons.add_circle, color: Colors.green, size: 60),
                          onPressed: () {
                            setState(() {
                              _portions++;
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  Text('1 Portion = 10g', style: TextStyle(fontSize: 17, color: Colors.grey)),
                  SizedBox(height: 18),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildChoiceChip(int index, String label) {
    return ChoiceChip(
      label: Text(label),
      selected: _isSelected[index],
      onSelected: (bool selected) {
        setState(() {
          _isSelected[index] = selected;
        });
      },
      selectedColor: Colors.blue,
    );
  }

   void _updateSchedule(BuildContext context) async {
    final updatedSchedule = ScheduleItem(
      id: widget.schedule?.id ?? Uuid().v4(),
      time: '${_selectedHour.toString().padLeft(2, '0')}:${_selectedMinute.toString().padLeft(2, '0')}',
      portions: _portions,
      enabled: widget.schedule?.enabled ?? true,
      repeatDays: _isSelected,
    );

      final url = widget.schedule == null
        ? Uri.https('pawsportion-0-default-rtdb.firebaseio.com', 'schedules-list.json')
        : Uri.https('pawsportion-0-default-rtdb.firebaseio.com', 'schedules-list/${updatedSchedule.id}.json');
    
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
      },
      body: json.encode({
        'id': updatedSchedule.id,
        'time': updatedSchedule.time,
        'portions': updatedSchedule.portions,
        'enabled': updatedSchedule.enabled,
        'repeatDays': updatedSchedule.repeatDays,
      }),
    );

    if (response.statusCode == 200) {
      print('Schedule added successfully: ${response.body}');
      Navigator.pop(context, updatedSchedule);
    } else {
      print('Failed to save schedule: ${response.statusCode} - ${response.body}');
      // Optionally, show an error message to the user
    }
  }

 void _showDeleteConfirmationDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text('Delete Schedule'),
        content: Text('Are you sure you want to delete this schedule?'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context); // Close the dialog
            },
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context, DELETE_SIGNAL); // Signal to delete the schedule
              Navigator.pop(context, DELETE_SIGNAL); // Return to the previous screen
            },
            child: Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      );
    },
  );
}}