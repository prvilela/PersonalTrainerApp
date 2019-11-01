part of table_calendar;

/// Callback exposing currently selected day.
typedef void OnDaySelected(DateTime day, List events);

/// Callback exposing currently visible days (first and last of them).
typedef void OnVisibleDaysChanged(DateTime first, DateTime last);

/// Builder signature for any text that can be localized and formatted with `DateFormat`.
typedef String TextBuilder(DateTime date, dynamic locale);


/// Available day of week formats. `TableCalendar` will start the week with chosen day.
/// * `StartingDayOfWeek.monday`: Monday - Sunday
/// * `StartingDayOfWeek.sunday`: Sunday - Saturday
enum StartingDayOfWeek { monday, sunday }

/// Gestures available to interal `TableCalendar`'s logic.
enum AvailableGestures { none, verticalSwipe, horizontalSwipe, all }

/// Highly customizable, feature-packed Flutter Calendar with gestures, animations and multiple formats.
class TableCalendar extends StatefulWidget {
  final CalendarController calendarController;

  /// Locale to format `TableCalendar` dates with, for example: `'en_US'`.
  ///
  /// If nothing is provided, a default locale will be used.
  final dynamic locale;

  /// Contains a `List` of objects (eg. events) assigned to particular `DateTime`s.
  /// Each `DateTime` inside this `Map` should get its own `List` of above mentioned objects.
  final Map<DateTime, List> events;

  /// `List`s of holidays associated to particular `DateTime`s.
  /// This property allows you to provide custom holiday rules.
  final Map<DateTime, List> holidays;

  /// Called whenever any day gets tapped.
  final OnDaySelected onDaySelected;

  /// Called whenever any unavailable day gets tapped.
  /// Replaces `onDaySelected` for those days.
  final VoidCallback onUnavailableDaySelected;

  /// Initially selected DateTime. Usually it will be `DateTime.now()`.
  /// This property can be used to programmatically select a new date.
  ///
  /// If `TableCalendar` Widget gets rebuilt with a different `selectedDay` than previously,
  /// `onDaySelected` callback will run.
  ///
  /// To animate programmatic selection, use `animateProgSelectedDay` property.
  final DateTime initialSelectedDay;

  /// The first day of `TableCalendar`.
  /// Days before it will use `unavailableStyle` and run `onUnavailableDaySelected` callback.
  final DateTime startDay;

  /// The last day of `TableCalendar`.
  /// Days after it will use `unavailableStyle` and run `onUnavailableDaySelected` callback.
  final DateTime endDay;

  /// Used to show/hide Header.
  final bool headerVisible;

  /// Used for setting the height of `TableCalendar`'s rows.
  final double rowHeight;

  /// `TableCalendar` will start weeks with provided day.
  /// Use `StartingDayOfWeek.monday` for Monday - Sunday week format.
  /// Use `StartingDayOfWeek.sunday` for Sunday - Saturday week format.
  final StartingDayOfWeek startingDayOfWeek;

  /// `HitTestBehavior` for every day cell inside `TableCalendar`.
  final HitTestBehavior dayHitTestBehavior;

  /// Specify Gestures available to `TableCalendar`.
  /// If `AvailableGestures.none` is used, the Calendar will only be interactive via buttons.
  final AvailableGestures availableGestures;

  /// Style for `TableCalendar`'s content.
  final CalendarStyle calendarStyle;

  /// Style for DaysOfWeek displayed between `TableCalendar`'s Header and content.
  final DaysOfWeekStyle daysOfWeekStyle;

  /// Style for `TableCalendar`'s Header.
  final HeaderStyle headerStyle;

  /// Set of Builders for `TableCalendar` to work with.
  final CalendarBuilders builders;

  TableCalendar({
    Key key,
    @required this.calendarController,
    this.locale,
    this.events = const {},
    this.holidays = const {},
    this.onDaySelected,
    this.onUnavailableDaySelected,
    this.initialSelectedDay,
    this.startDay,
    this.endDay,
    this.headerVisible = true,
    this.rowHeight,
    this.startingDayOfWeek = StartingDayOfWeek.sunday,
    this.dayHitTestBehavior = HitTestBehavior.deferToChild,
    this.availableGestures = AvailableGestures.all,
    this.calendarStyle = const CalendarStyle(),
    this.daysOfWeekStyle = const DaysOfWeekStyle(),
    this.headerStyle = const HeaderStyle(),
    this.builders = const CalendarBuilders(),
  })  : assert(calendarController != null),
        super(key: key);

  @override
  _TableCalendarState createState() => _TableCalendarState();
}

class _TableCalendarState extends State<TableCalendar> with SingleTickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
  }

  void _selectedDayCallback(DateTime day) {
    if (widget.onDaySelected != null) {
      widget.onDaySelected(day, widget.calendarController.visibleEvents[_getEventKey(day)] ?? []);
    }
  }

  void _selectDay(DateTime day) {
    setState(() {
      widget.calendarController.setSelectedDay(day);
      _selectedDayCallback(day);
    });
  }


  void _onUnavailableDaySelected() {
    if (widget.onUnavailableDaySelected != null) {
      widget.onUnavailableDaySelected();
    }
  }

  bool _isDayUnavailable(DateTime day) {
    return (widget.startDay != null && day.isBefore(widget.startDay)) ||
        (widget.endDay != null && day.isAfter(widget.endDay));
  }

  DateTime _getEventKey(DateTime day) {
    return widget.calendarController.visibleEvents.keys
        .firstWhere((it) => widget.calendarController._isSameDay(it, day), orElse: () => null);
  }

  @override
  Widget build(BuildContext context) {
    final children = <Widget>[];

    if (widget.headerVisible) {
      children.addAll([
        const SizedBox(height: 6.0),
        _buildHeader(),
      ]);
    }

    children.addAll([
      const SizedBox(height: 10.0),
      _buildCalendarContent(),
      const SizedBox(height: 4.0),
    ]);

    return ClipRect(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: children,
      ),
    );
  }

//aqui hahsudasdujeur ajsdhasdhe ashdhasdh asdhayhgsdyqwedf
  Widget _buildHeader() {
    final children = [
      _CustomIconButton(
        icon: widget.headerStyle.leftChevronIcon,
        onTap: (){},
        margin: widget.headerStyle.leftChevronMargin,
        padding: widget.headerStyle.leftChevronPadding,
      ),
      Expanded(
        child: Text(
          widget.headerStyle.titleTextBuilder != null
              ? widget.headerStyle.titleTextBuilder(widget.calendarController.focusedDay, widget.locale)
              : DateFormat.yMMMM(widget.locale).format(widget.calendarController.focusedDay),
          style: widget.headerStyle.titleTextStyle,
          textAlign: widget.headerStyle.centerHeaderTitle ? TextAlign.center : TextAlign.start,
        ),
      ),
      _CustomIconButton(
        icon: widget.headerStyle.rightChevronIcon,
        //aqui tb ahsuhashahshasuhahshauhsuahushuas
        onTap: (){},
        margin: widget.headerStyle.rightChevronMargin,
        padding: widget.headerStyle.rightChevronPadding,
      ),
    ];

    if (widget.headerStyle.formatButtonVisible) {
      children.insert(2, const SizedBox(width: 8.0));
    }

    return Row(
      mainAxisSize: MainAxisSize.max,
      children: children,
    );
  }

  Widget _buildCalendarContent() {
      return AnimatedSwitcher(
        duration: const Duration(milliseconds: 350),
        transitionBuilder: (child, animation) {
          return SizeTransition(
            sizeFactor: animation,
            child: ScaleTransition(
              scale: animation,
              child: child,
            ),
          );
        },

      );
    }
  }