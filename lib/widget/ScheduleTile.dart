import 'package:flutter/material.dart';
import 'package:pawsportion/ScheduleItem.dart';

class ScheduleTile extends StatelessWidget {
  final ScheduleItem schedule;
  final ValueChanged<bool> onChanged;

  ScheduleTile({required this.schedule, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      padding: EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Color(0xFFA59D6F),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                schedule.time,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              Text(
                '${_getRepeatDays()} | ${schedule.portions} Portions',
                style: TextStyle(fontSize: 15, color: Colors.white),
              ),
            ],
          ),
          Switch(
            value: schedule.enabled,
            onChanged: onChanged,
            activeTrackColor: Colors.green[100],
            thumbColor: MaterialStateProperty.resolveWith<Color>((states) {
              if (states.contains(MaterialState.selected)) {
                return Colors.green;
              }
              return Colors.grey;
            }),
          ),
        ],
      ),
    );
  }

  String _getRepeatDays() {
    List<String> days = [];
    List<String> dayNames = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];

    for (int i = 0; i < schedule.repeatDays.length; i++) {
      if (schedule.repeatDays[i]) {
        days.add(dayNames[i]);
      }
    }

    if (days.length == 7) {
      return 'Daily';
    } else {
      return days.join(', ');
    }
  }
}
