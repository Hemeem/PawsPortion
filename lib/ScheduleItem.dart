class ScheduleItem {
  String id;
  String time;
  int portions;
  bool enabled;
  List<bool> repeatDays;

  ScheduleItem({
    required this.id,
    required this.time,
    required this.portions,
    required this.enabled,
    required this.repeatDays,
  });
}
