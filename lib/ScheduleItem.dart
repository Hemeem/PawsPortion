class ScheduleItem {
  final String id;
  final String time;
  final int portions;
  bool enabled;
  final List<bool> repeatDays;

  ScheduleItem({
    required this.id,
    required this.time,
    required this.portions,
    required this.enabled,
    required this.repeatDays,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'time': time,
      'portions': portions,
      'enabled': enabled,
      'repeatDays': repeatDays,
    };
  }

  copyWith({required bool enabled}) {}
}
