class SupressedByWeek {
  String year;
  String month;
  String day;
  int count;

  int get timestamp =>
      DateTime(int.parse(year), int.parse(month), int.parse(day))
          .millisecondsSinceEpoch;

  String get dateString => '$day/$month/$year';

  SupressedByWeek({
    this.year,
    this.month,
    this.day,
    this.count,
  });

  factory SupressedByWeek.fromJson(Map<String, dynamic> map) {
    return new SupressedByWeek(
      year: map['year'],
      month: map['month'],
      day: map['day'],
      count: map['count'],
    );
  }
}
