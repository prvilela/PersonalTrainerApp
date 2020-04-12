import "package:flutter/material.dart";
import "dart:async";

import 'package:intl/intl.dart';

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
    DateTime picked = await showDatePicker(
        context: context,
        initialDate: date,
        firstDate: new DateTime(2018),
        lastDate: new DateTime(2030)
    );
    if (picked != null && picked != date)
    {
      print("Date Selected = ${picked.toString()}");
        date = picked;
        var data_formatada = DateFormat("dd-MM-yyyy").format(date); 
        return data_formatada.toString();
    }
  }
  

  Future<void>selectTime(BuildContext context) async {
    TimeOfDay picked = await showTimePicker(
        context: context,
        initialTime: time
    );
    if (picked != null && picked != time)
    {
      print("Time Selected = ${picked.toString()}");
        time = picked;
        var timeF = time.toString();
        var retorno = filtrarReturn(timeF);
        return retorno;
    }
  }

  filtrarReturn(String time){
    var resposta;
    resposta = time.replaceAll(new RegExp(r'[a-zA-Z()]'), '');
    return resposta;
  }

  @override
  Widget build(BuildContext context)
  {
    return  null;
  }
}