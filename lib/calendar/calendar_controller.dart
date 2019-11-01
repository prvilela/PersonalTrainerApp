part of table_calendar;

const double _dxMax = 1.2;
const double _dxMin = -1.2;

typedef void _SelectedDayCallback(DateTime day);

/// Controller required for `TableCalendar`.
///
/// Should be created in `initState()`, and then disposed in `dispose()`:
/// ```dart
/// @override
/// void initState() {
///   super.initState();
///   _calendarController = CalendarController();
/// }
///
/// @override
/// void dispose() {
///   _calendarController.dispose();
///   super.dispose();
/// }
/// ```
class CalendarController {
  /// Currently focused day (used to determine which year/month should be visible).
  DateTime get focusedDay => _focusedDay;

  /// Currently selected day.
  DateTime get selectedDay => _selectedDay;

  /// List of currently visible days.
  List<DateTime> get visibleDays =>
      _includeInvisibleDays ? _visibleDays.value : _visibleDays.value.where((day) => !_isExtraDay(day)).toList();

  /// Map of currently visible events.
  Map<DateTime, List> get visibleEvents => Map.fromEntries(
        _events.entries.where((entry) {
          for (final day in visibleDays) {
            if (_isSameDay(day, entry.key)) {
              return true;
            }
          }

          return false;
        }),
      );

  Map<DateTime, List> _events;
  DateTime _focusedDay;
  DateTime _selectedDay;
  StartingDayOfWeek _startingDayOfWeek;
  ValueNotifier<List<DateTime>> _visibleDays;
  DateTime _previousFirstDay;
  DateTime _previousLastDay;
  int _pageId;
  double _dx;
  bool _includeInvisibleDays;
  _SelectedDayCallback _selectedDayCallback;

  void _init({
    @required Map<DateTime, List> events,
    @required Map<DateTime, List> holidays,
    @required DateTime initialDay,
    @required StartingDayOfWeek startingDayOfWeek,
    @required _SelectedDayCallback selectedDayCallback,
    @required OnVisibleDaysChanged onVisibleDaysChanged,
    @required bool includeInvisibleDays,
  }) {
    _events = events;
    _startingDayOfWeek = startingDayOfWeek;
    _selectedDayCallback = selectedDayCallback;
    _includeInvisibleDays = includeInvisibleDays;

    _pageId = 0;
    _dx = 0;

    final now = DateTime.now();
    _focusedDay = initialDay ?? DateTime(now.year, now.month, now.day);
    _selectedDay = _focusedDay;
    _previousFirstDay = _visibleDays.value.first;
    _previousLastDay = _visibleDays.value.last;

    if (onVisibleDaysChanged != null) {
      _visibleDays.addListener(() {
        if (!_isSameDay(_visibleDays.value.first, _previousFirstDay) ||
            !_isSameDay(_visibleDays.value.last, _previousLastDay)) {
          _previousFirstDay = _visibleDays.value.first;
          _previousLastDay = _visibleDays.value.last;
          onVisibleDaysChanged(
            _getFirstDay(includeInvisible: _includeInvisibleDays),
            _getLastDay(includeInvisible: _includeInvisibleDays),
          );
        }
      });
    }
  }

  /// Disposes the controller.
  /// ```dart
  /// @override
  /// void dispose() {
  ///   _calendarController.dispose();
  ///   super.dispose();
  /// }
  /// ```
  void dispose() {
    _visibleDays.dispose();
  }

  /// Sets selected day to a given `value`.
  /// Use `runCallback: true` if this should trigger `OnDaySelected` callback.
  void setSelectedDay(
    DateTime value, {
    //bool isProgrammatic = true,
    bool animate = true,
    bool runCallback = false,
  }) {
    if (animate) {
      if (value.isBefore(_getFirstDay(includeInvisible: false))) {
        _decrementPage();
      } else if (value.isAfter(_getLastDay(includeInvisible: false))) {
        _incrementPage();
      }
    }
    _selectedDay = value;
    _focusedDay = value;

  }

  /// Sets displayed month/year without changing the currently selected day.
  void setFocusedDay(DateTime value) {
    _focusedDay = value;
  }

  DateTime _getFirstDay({@required bool includeInvisible}) {
    if (!includeInvisible) {
      return _firstDayOfMonth(_focusedDay);
    } else {
      return _visibleDays.value.first;
    }
  }

  DateTime _getLastDay({@required bool includeInvisible}) {
    if (!includeInvisible) {
      return _lastDayOfMonth(_focusedDay);
    } else {
      return _visibleDays.value.last;
    }
  }

  void _decrementPage() {
    _pageId--;
    _dx = _dxMin;
  }

  void _incrementPage() {
    _pageId++;
    _dx = _dxMax;
  }

  List<DateTime> _daysInMonth(DateTime month) {
    final first = _firstDayOfMonth(month);
    final daysBefore = _startingDayOfWeek == StartingDayOfWeek.sunday ? first.weekday % 7 : first.weekday - 1;
    final firstToDisplay = first.subtract(Duration(days: daysBefore));

    final last = _lastDayOfMonth(month);
    var daysAfter = 7 - last.weekday;

    if (_startingDayOfWeek == StartingDayOfWeek.sunday) {
      // If the last day is Sunday (7) the entire week must be rendered
      if (daysAfter == 0) {
        daysAfter = 7;
      }
    } else {
      daysAfter++;
    }

    final lastToDisplay = last.add(Duration(days: daysAfter));
    return _daysInRange(firstToDisplay, lastToDisplay).toList();
  }

  List<DateTime> _daysInWeek(DateTime week) {
    final first = _firstDayOfWeek(week);
    final last = _lastDayOfWeek(week);

    return _daysInRange(first, last).toList();
  }

  DateTime _firstDayOfWeek(DateTime day) {
    day = DateTime.utc(day.year, day.month, day.day, 12);

    final decreaseNum = _startingDayOfWeek == StartingDayOfWeek.sunday ? day.weekday % 7 : day.weekday - 1;
    return day.subtract(Duration(days: decreaseNum));
  }

  DateTime _lastDayOfWeek(DateTime day) {
    day = DateTime.utc(day.year, day.month, day.day, 12);

    final increaseNum = _startingDayOfWeek == StartingDayOfWeek.sunday ? day.weekday % 7 : day.weekday - 1;
    return day.add(Duration(days: 7 - increaseNum));
  }

  DateTime _firstDayOfMonth(DateTime month) {
    return DateTime.utc(month.year, month.month, 1, 12);
  }

  DateTime _lastDayOfMonth(DateTime month) {
    final date =
        month.month < 12 ? DateTime.utc(month.year, month.month + 1, 1, 12) : DateTime.utc(month.year + 1, 1, 1, 12);
    return date.subtract(const Duration(days: 1));
  }

  DateTime _previousWeek(DateTime week) {
    return week.subtract(const Duration(days: 7));
  }

  DateTime _nextWeek(DateTime week) {
    return week.add(const Duration(days: 7));
  }

  DateTime _previousMonth(DateTime month) {
    if (month.month == 1) {
      return DateTime(month.year - 1, 12);
    } else {
      return DateTime(month.year, month.month - 1);
    }
  }

  DateTime _nextMonth(DateTime month) {
    if (month.month == 12) {
      return DateTime(month.year + 1, 1);
    } else {
      return DateTime(month.year, month.month + 1);
    }
  }

  Iterable<DateTime> _daysInRange(DateTime firstDay, DateTime lastDay) sync* {
    var temp = firstDay;

    while (temp.isBefore(lastDay)) {
      yield DateTime.utc(temp.year, temp.month, temp.day, 12);
      temp = temp.add(const Duration(days: 1));
    }
  }

  /// Returns true if `day` is currently selected.
  bool isSelected(DateTime day) {
    return _isSameDay(day, selectedDay);
  }

  /// Returns true if `day` is the same day as `DateTime.now()`.
  bool isToday(DateTime day) {
    return _isSameDay(day, DateTime.now());
  }

  bool _isSameDay(DateTime dayA, DateTime dayB) {
    return dayA.year == dayB.year && dayA.month == dayB.month && dayA.day == dayB.day;
  }

  bool _isWeekend(DateTime day) {
    return day.weekday == DateTime.saturday || day.weekday == DateTime.sunday;
  }

  bool _isExtraDay(DateTime day) {
    return _isExtraDayBefore(day) || _isExtraDayAfter(day);
  }

  bool _isExtraDayBefore(DateTime day) {
    return day.month < _focusedDay.month;
  }

  bool _isExtraDayAfter(DateTime day) {
    return day.month > _focusedDay.month;
  }

  int _clamp(int min, int max, int value) {
    if (value > max) {
      return max;
    } else if (value < min) {
      return min;
    } else {
      return value;
    }
  }
}