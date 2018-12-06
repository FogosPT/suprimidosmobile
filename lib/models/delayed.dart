class Delayed {
  String line;
  String type;
  String vendor;
  String begin;
  String end;
  int min;
  int max;
  int delay;
  int timestamp;

  Delayed({
    this.line,
    this.type,
    this.vendor,
    this.begin,
    this.end,
    this.min,
    this.max,
    this.delay,
    this.timestamp,
  });

  String get direction => '$begin > $end';
  int get time => this.timestamp;

  factory Delayed.fromJson(Map<String, dynamic> map) {
    return new Delayed(
      line: map['line'],
      type: map['type'],
      vendor: map['vendor'],
      begin: map['begin'],
      end: map['end'],
      min: map['min'],
      max: map['max'],
      delay: map['delay'],
      timestamp: map['timestamp'],
    );
  }
}
