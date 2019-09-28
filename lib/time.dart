import "package:flutter/material.dart";
import "dart:async";

class Time extends StatefulWidget
{
  @override
  TimeState createState() => new TimeState();
}

class TimeState extends State<Time>
{

  DateTime date = new DateTime.now();
  TimeOfDay time = new TimeOfDay.now();

  Future<void> selectDate(BuildContext context) async
  {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: new DateTime(2019),
        firstDate: new DateTime(2018),
        lastDate: new DateTime(2030)
    );
    if (picked != null && picked != date)
    {
      print("Date Selected = ${picked.toString()}");
        date = picked;
        print(date);
        return date;
    }
  }

  Future<TimeOfDay>selectTime(BuildContext context) async
  {
    final TimeOfDay picked = await showTimePicker(
        context: context,
        initialTime: time
    );
    if (picked != null && picked != time)
    {
      print("Time Selected = ${picked.toString()}");
        time = picked;
        print(time);
        return time;
    }
  }

  @override
  Widget build(BuildContext context)
  {
    return  null;
  }
}