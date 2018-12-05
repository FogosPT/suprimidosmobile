class Supressed {
  String line;
  String type;
  String vendor;
  String begin;
  String end;
  String startTime;
  String endTime;
  int timestamp;

  Supressed({
    this.line,
    this.type,
    this.vendor,
    this.begin,
    this.end,
    this.timestamp,
    this.startTime,
    this.endTime,
  });

  String get direction => '$begin > $end';
  int get time => this.timestamp;

  factory Supressed.fromJson(Map<String, dynamic> map) {
    return new Supressed(
      line: map['line'],
      type: map['type'],
      vendor: map['vendor'],
      begin: map['begin'],
      end: map['end'],
      timestamp: map['timestamp'],
      startTime: map['startTime'],
      endTime: map['endTime'],
    );
  }
}
