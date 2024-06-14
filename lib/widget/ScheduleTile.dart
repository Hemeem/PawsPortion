import 'package:flutter/material.dart';

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
                    color: Colors.white),
              ),
              Text(
                'Daily | ${schedule.portions} Portions',
                style: TextStyle(fontSize: 16, color: Colors.white),
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
}

class ScheduleItem {
  String time;
  int portions;
  bool enabled;

  ScheduleItem(
      {required this.time, required this.portions, required this.enabled});
}
