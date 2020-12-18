import 'package:apppersonaltrainer/common/build_row.dart';
import 'package:apppersonaltrainer/models/student.dart';
import 'package:flutter/material.dart';

class CalendarTile extends StatelessWidget {
  const CalendarTile(this.student, this.dia);
  final Student student;
  final dia;

  @override
  Widget build(BuildContext context) {
    var diaA;
    if (dia == 'DOMINGO') {
      diaA = student.days.horarioDom;
    }
    if (dia == 'SEGUNDA') {
      diaA = student.days.horarioSeg;
    }
    if (dia == 'TERÇA') {
      diaA = student.days.horarioTer;
    }
    if (dia == 'QUARTA') {
      diaA = student.days.horarioQuar;
    }
    if (dia == 'QUINTA') {
      diaA = student.days.horarioQuin;
    }
    if (dia == 'SEXTA') {
      diaA = student.days.horarioSex;
    }
    if (dia == 'SABADO') {
      diaA = student.days.horarioSab;
    }
    print(dia);
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 4, 48, 4),
      child: InkWell(
        onTap: () {
          Navigator.of(context).pushNamed('/edit_student', arguments: student);
        },
        child: Card(
          child: Padding(
            padding:
                const EdgeInsets.only(left: 16, right: 16, top: 8, bottom: 8),
            child: Column(
              children: <Widget>[
                BuildRow(
                  text: "Nome: ",
                  data: student.name,
                ),
                SizedBox(
                  height: 4,
                ),
                BuildRow(
                  text: "Academia: ",
                  data: student.gym,
                ),
                SizedBox(
                  height: 4,
                ),
                BuildRow(
                  text: "Academia: ",
                  data: diaA,
                ),
                SizedBox(
                  height: 4,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
