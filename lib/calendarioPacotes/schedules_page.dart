import 'package:flutter/material.dart';
import 'package:personal_trainer/calendarioPacotes/week_widget.dart';

import 'days_schedule.dart';
import 'models.dart';


class SchedulesPage extends StatefulWidget {
  @override
  _SchedulesPageState createState() => _SchedulesPageState();
}

class _SchedulesPageState extends State<SchedulesPage> {
  List<DaySchedule> _schedules = [
    DaySchedule([]),
    DaySchedule([
      TimeRange(
        Time(10, 30),
        Time(13, 30),
      ),
      TimeRange(
        Time(22, 0),
        Time(4, 0),
      ),
    ]),
    DaySchedule([
      TimeRange(
        Time(8, 30),
        Time(13, 30),
      ),
      TimeRange(
        Time(16, 0),
        Time(22, 0),
      ),
    ]),
    DaySchedule([
      TimeRange(
        Time(7, 00),
        Time(12, 00),
      ),
    ]),
    DaySchedule([
      TimeRange(
        Time(2, 00),
        Time(16, 00),
      ),
    ]),
    DaySchedule([
      TimeRange(
        Time(7, 00),
        Time(10, 00),
      ),
      TimeRange(
        Time(12, 00),
        Time(14, 00),
      ),
      TimeRange(
        Time(18, 00),
        Time(23, 30),
      ),
    ]),
    DaySchedule([]),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          color: Colors.white,
          padding: EdgeInsets.all(20),
          child: OrientationBuilder(
            builder: (c, o) {
              return WeekWidget(
                _schedules,
                hourLableCount: o == Orientation.portrait ? 24 : 12,
                space: o == Orientation.portrait ? 10 : 25,
                onTapDay: (index) {
                  showScheduleDetailsAt(context, index);
                },
              );
            },
          ),
          constraints: BoxConstraints.expand(),
        ),
      ));     
  }

  void showScheduleDetailsAt(BuildContext context, int index) {
    //Uncomment to prevent show Details Page at Sunday or Satuarday
    // if (index == 0 || index == 6) return;
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return DayScheduleDetailsPage(
        schedule: _schedules[index],
      );
    }));
  }
}
