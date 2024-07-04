import 'package:flutter/material.dart';
import 'package:pawsportion/ScheduleItem.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:uuid/uuid.dart';
import 'package:pawsportion/AuthService.dart';

const String DELETE_SIGNAL = "DELETE";

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
      _selectedHour = int.parse(widget.schedule!.time.split(':')[0]);
      _selectedMinute = int.parse(widget.schedule!.time.split(':')[1]);
      _portions = widget.schedule!.portions;
      _isSelected = List.from(widget.schedule!.repeatDays);
    } else {
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
            Navigator.pop(context, null);
          },
        ),
        actions: [
          if (widget.schedule != null)
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
            _buildTimePicker(),
            SizedBox(height: 30),
            Divider(color: Colors.grey, height: 1, thickness: 1),
            SizedBox(height: 10),
            _buildRepeatPicker(),
            SizedBox(height: 30),
            Divider(color: Colors.grey, height: 1, thickness: 1),
            SizedBox(height: 10),
            _buildPortionPicker(),
          ],
        ),
      ),
    );
  }

  Widget _buildTimePicker() {
    return Expanded(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _buildTimeWheel(_selectedHour, 24, (index) {
            setState(() {
              _selectedHour = index;
            });
          }),
          Align(
            alignment: Alignment.center,
            child: Container(
              width: 1,
              height: 150,
              margin: EdgeInsets.only(bottom: 1),
              color: Colors.black,
            ),
          ),
          _buildTimeWheel(_selectedMinute, 60, (index) {
            setState(() {
              _selectedMinute = index;
            });
          }),
        ],
      ),
    );
  }

  Widget _buildTimeWheel(
      int initialItem, int itemCount, ValueChanged<int> onSelectedItemChanged) {
    return Expanded(
      child: ListWheelScrollView.useDelegate(
        itemExtent: 50,
        perspective: 0.005,
        diameterRatio: 1.5,
        onSelectedItemChanged: onSelectedItemChanged,
        controller: FixedExtentScrollController(initialItem: initialItem),
        childDelegate: ListWheelChildBuilderDelegate(
          builder: (context, index) {
            return Center(
              child: Text(
                index.toString().padLeft(2, '0'),
                style: TextStyle(
                  fontSize: 24,
                  color: initialItem == index ? Colors.black : Colors.grey,
                ),
              ),
            );
          },
          childCount: itemCount,
        ),
      ),
    );
  }

  Widget _buildRepeatPicker() {
    return Expanded(
      child: Column(
        children: [
          Text('Repeat', style: TextStyle(fontSize: 18)),
          SizedBox(height: 5),
          _buildRepeatChoiceChips(),
        ],
      ),
    );
  }

  Widget _buildRepeatChoiceChips() {
    return Column(
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

  Widget _buildPortionPicker() {
    return Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('Portion(s)', style: TextStyle(fontSize: 20)),
          SizedBox(height: 25),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                icon: Icon(Icons.remove_circle, color: Colors.red, size: 60),
                onPressed: () {
                  setState(() {
                    if (_portions > 1) _portions--;
                  });
                },
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
              IconButton(
                icon: Icon(Icons.add_circle, color: Colors.green, size: 60),
                onPressed: () {
                  setState(() {
                    _portions++;
                  });
                },
              ),
            ],
          ),
          SizedBox(height: 10),
          Text('1 Portion = 10g',
              style: TextStyle(fontSize: 17, color: Colors.grey)),
          SizedBox(height: 18),
        ],
      ),
    );
  }

final authService = AuthService();

Future<void> _updateSchedule(BuildContext context) async {
  final updatedSchedule = ScheduleItem(
    id: widget.schedule?.id ?? Uuid().v4(),
    time:
        '${_selectedHour.toString().padLeft(2, '0')}:${_selectedMinute.toString().padLeft(2, '0')}',
    portions: _portions,
    enabled: widget.schedule?.enabled ?? true,
    repeatDays: _isSelected,
  );

  final token = await authService.getToken();
  if (token == null) {
    print('Failed to get token');
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text('Failed to get token. Please try again.'),
    ));
    return;
  }

  final url = Uri.https(
    'pawsportion-0-default-rtdb.firebaseio.com',
    'schedules-list/${updatedSchedule.id}.json',
    {'auth': token},
  );

  final method = widget.schedule == null ? 'post' : 'put';
  final response = await (method == 'post' ? http.post : http.put)(
    url,
    headers: {'Content-Type': 'application/json'},
    body: json.encode(updatedSchedule.toJson()),
  );

  if (response.statusCode == 200) {
    print('Successfully saved schedule: ${updatedSchedule.toJson()}');
    Navigator.pop(context, updatedSchedule);
  } else {
    print('Failed to save schedule: ${response.statusCode} - ${response.body}');
  }
}

  Future<void> _deleteSchedule(BuildContext context) async {
    if (widget.schedule != null) {
      final token = await AuthService().getToken();
      if (token == null) {
        print('Failed to get token');
        return;
      }

      final url = Uri.https(
        'pawsportion-0-default-rtdb.firebaseio.com',
        'schedules-list/${widget.schedule!.id}.json',
        {'auth': token},
      );

      final response = await http.delete(url);

      if (response.statusCode == 200) {
        print(
            'Successfully deleted schedule: ${widget.schedule!.id}'); // Add this line for logging
        Navigator.pop(context, DELETE_SIGNAL);
      } else {
        print(
            'Failed to delete schedule: ${response.statusCode} - ${response.body}');
      }
    }
  }

  void _showDeleteConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Delete Schedule'),
          content: Text('Are you sure you want to delete this schedule?'),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Delete'),
              onPressed: () {
                Navigator.of(context).pop();
                _deleteSchedule(context);
              },
            ),
          ],
        );
      },
    );
  }
}

extension on ScheduleItem {
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'time': time,
      'portions': portions,
      'enabled': enabled,
      'repeatDays': repeatDays,
    };
  }
}
