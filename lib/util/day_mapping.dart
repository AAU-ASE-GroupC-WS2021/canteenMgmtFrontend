String getDayName(int i) {
  return _dayMapping[i] != null ? _dayMapping[i]! : "NOMENUDAY";
}

Map<int, String> _dayMapping = {
  DateTime.monday: "MONDAY",
  DateTime.tuesday: "TUESDAY",
  DateTime.wednesday: "WEDNESDAY",
  DateTime.thursday: "THURSDAY",
  DateTime.friday: "FRIDAY",
};