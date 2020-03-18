class Range {
  final double min, max;
  Range(this.min, this.max);
}

class Time {
  double hours, minutes, seconds;
  Time(this.hours, this.minutes, {this.seconds = 0});

  int getTotalSeconds() {
    return (hours * 3600 + minutes * 60 + seconds).toInt();
  }
}

class TimeRange {
  final Time min, max;
  TimeRange(this.min, this.max);
}

class DaySchedule {
  final List<TimeRange> schedules;
  DaySchedule(this.schedules);
}
