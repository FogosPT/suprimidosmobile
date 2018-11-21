class Supressed {
  String id;
  String line;
  String type;
  String vendor;
  String begin;
  String end;
  int timestamp;

  Supressed({
    this.id,
    this.line,
    this.type,
    this.vendor,
    this.begin,
    this.end,
    this.timestamp,
  });

  String get direction => '$begin > $end';

  factory Supressed.fromJson(Map<String, dynamic> map) {
    return new Supressed(
      id: map['id'],
      line: map['line'],
      type: map['type'],
      vendor: map['vendor'],
      begin: map['begin'],
      end: map['end'],
      timestamp: map['timestamp'],
    );
  }
}
