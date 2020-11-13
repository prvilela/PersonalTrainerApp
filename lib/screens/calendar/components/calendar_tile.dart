import 'package:apppersonaltrainer/common/build_row.dart';
import 'package:apppersonaltrainer/models/student.dart';
import 'package:flutter/material.dart';

class CalendarTile extends StatelessWidget {

  const CalendarTile(this.student);

  final Student student;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 4, 48, 4),
      child: InkWell(
        onTap: (){
          Navigator.of(context).pushNamed('/edit_student',arguments: student);
        },
        child: Card(
          child: Padding(
            padding: const EdgeInsets.only(left: 16, right: 16, top: 8, bottom: 8),
            child: Column(
              children: <Widget>[
                BuildRow(text: "Nome: ", data: student.name,),
                SizedBox(height: 4,),
                BuildRow(text: "Academia: ", data: student.gym,),
                SizedBox(height: 4,),
                BuildRow(text: "Horario ", data: student.days.horario,),
                SizedBox(height: 4,),
              ],
            ),
          ),
        ),
      ),
    );;
  }
}
