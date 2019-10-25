import 'package:flutter/material.dart';
import 'dart:math';
import 'models.dart';

class DayScheduleDetailsPage extends StatelessWidget {
  final DaySchedule schedule;

  DayScheduleDetailsPage({this.schedule});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Open Times"),
      ),
      body: schedule == null || schedule.schedules.length == 0
          ? Center(
              child: Text("No Time Schedules"),
            )
          : ListView(
              children: schedule.schedules
                  .map((sc) => ListTile(
                        title: Text(
                            "Opening Time : ${toFixNumberString(sc.min.hours.toInt(), 2)}:${toFixNumberString(sc.min.minutes.toInt(), 2)} - ${toFixNumberString(sc.max.hours.toInt(), 2)}:${toFixNumberString(sc.max.minutes.toInt(), 2)}"),
                      ))
                  .toList()),
    );
  }

  static String toFixNumberString(int val, int digitCount) {
    var str = "";

    for (var i = 1; i < digitCount; i++) {
      if (pow(10, digitCount - i) > val) {
        str += "0";
      }
    }
    return str + val.toString();
  }
}
