String getDayName(int i) {
  return _dayMapping[i]!;
}

Map<int, String> _dayMapping = {
  DateTime.monday: "MONDAY",
  DateTime.tuesday: "TUESDAY",
  DateTime.wednesday: "WEDNESDAY",
  DateTime.thursday: "THURSDAY",
  DateTime.friday: "FRIDAY",
};