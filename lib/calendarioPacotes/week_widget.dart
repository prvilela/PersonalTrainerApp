import 'package:flutter/material.dart';
import 'day_bar.dart';
import 'models.dart';

class WeekWidget extends StatelessWidget {
  final List<String> dayLabels;
  final double space;
  final TextStyle timeLabelTextStyle;
  final TextStyle dayLabelTextStyle;
  final double dayLabelOffset;
  final double hourLabelOffset;
  final List<DaySchedule> schedules;
  final Color highlightColor;
  final Color barBackgroundColor;
  final Color splitLineColor;
  final double barBorderRadius;
  final int hourLableCount;
  final Function onTapDay;

  WeekWidget(this.schedules,
      {this.dayLabels = const ["", "", "", "", "", "", ""],
      @required this.onTapDay,
      this.hourLableCount = 24,
      this.space = 8,
      this.timeLabelTextStyle = const TextStyle(
          fontWeight: FontWeight.w800,
          fontSize: 11,
          color: Color.fromARGB(255, 107, 107, 107)),
      this.dayLabelTextStyle = const TextStyle(
          fontWeight: FontWeight.w100,
          fontSize: 1,
          color: Color.fromARGB(255, 107, 107, 107)),
      this.highlightColor = const Color.fromARGB(255, 238, 31, 37),
      this.barBackgroundColor = const Color.fromARGB(255, 207, 207, 207),
      this.splitLineColor = const Color.fromARGB(255, 230, 230, 230),
      this.barBorderRadius = 0,
      this.dayLabelOffset = 10,
      this.hourLabelOffset = 10});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Container(
          // margin: EdgeInsets.only(top: 20),
          child: _buildHourWidgets(),
        ),
        SizedBox(
          width: hourLabelOffset,
        ),
        Expanded(
          child: _buildDayWidgets(),
        )
      ],
    );
  }

  Widget _buildHourWidgets() {
    return Column(
      children: <Widget>[
        Text(
          "",
          style: dayLabelTextStyle,
        ),
        SizedBox(
          height: dayLabelOffset,
        ),
        Expanded(
          child: Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: List.generate(hourLableCount + 1, (index) => index)
                  .map((i) => Text(
                        i == hourLableCount
                            ? ""
                            : "${(i * 24) ~/ hourLableCount}",
                        style: timeLabelTextStyle,
                      ))
                  .toList(),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDayWidgets() {
    var list = List<Widget>();
    for (var i = 0; i < dayLabels.length; i++) {
      list.add(_buildDayWidget(i));
      if (i < dayLabels.length - 1) {
        list.add(SizedBox(
          width: space,
        ));
      }
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.max,
      children: list,
    );
  }

  static List<Range> dayScheduleToRange(DaySchedule schedule) {
    if (schedule?.schedules == null) return [];
    List<TimeRange> correctedRanges = List();
    for (var sc in schedule.schedules) {
      if (sc.min.getTotalSeconds() > sc.max.getTotalSeconds()) {
        correctedRanges.add(TimeRange(sc.min, Time(24, 0)));
        correctedRanges.add(TimeRange(Time(0, 0), sc.max));
      } else {
        correctedRanges.add(sc);
      }
    }

    return correctedRanges
        .map((r) => Range(r.min.getTotalSeconds() / (3600 * 24.0),
            r.max.getTotalSeconds() / (3600 * 24.0)))
        .toList();
  }

  Widget _buildDayWidget(int index) {
    final highlights = schedules.length > index
        ? dayScheduleToRange(schedules[index])
        : List<Range>();
    return Expanded(
      child: Column(children: [
        Text(
          dayLabels[index],
          style: highlights.length > 0
              ? dayLabelTextStyle.copyWith(
                  color: highlightColor, fontWeight: FontWeight.w700)
              : dayLabelTextStyle,
        ),
        SizedBox(
          height: dayLabelOffset,
        ),
        Expanded(
          child: Container(
            child: Stack(
              fit: StackFit.expand,
              children: <Widget>[
                CustomPaint(
                  painter: DayBar(
                    highlights: highlights,
                    bgColor: barBackgroundColor,
                    highlightColor: highlightColor,
                    borderRadius: barBorderRadius,
                  ),
                ),
                Material(
                  clipBehavior: Clip.antiAlias,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(barBorderRadius)),
                  color: Color.fromARGB(0, 0, 0, 0),
                  child: InkWell(
                    onTap: () {
                      if (onTapDay != null) {
                        onTapDay(index);
                      }
                    },
                  ),
                )
              ],
            ),
            constraints: BoxConstraints.expand(),
          ),
        ),
        Text(
          "",
          style: timeLabelTextStyle,
        )
      ]),
    );
  }
}
