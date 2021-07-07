import 'package:apppersonaltrainer/common/build_row.dart';
import 'package:apppersonaltrainer/models/plan.dart';
import 'package:apppersonaltrainer/models/planManager.dart';
import 'package:apppersonaltrainer/models/student.dart';
import 'package:flutter/material.dart';

class CalendarTile extends StatelessWidget {
  const CalendarTile(this.student, this.dia, this.plans);
  final Student student;
  final PlanManager plans;
  final dia;

  @override
  Widget build(BuildContext context) {
    var diaA;
    Plan plan = plans.findPlanByName(student.plano);
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

    var resto = plan.duration % 60;

    var horarioSplit = diaA.toString().split(":");
    
    int hour = int.parse(horarioSplit[0]);
    int min = int.parse(horarioSplit[1]) + resto;
    
    if(min == 60){
      min = 0;
      hour++;
    }else if(min >60) {
      min = min - 60;
      hour++;
    }

    double horas = (plan.duration - resto) /60;

    hour = hour + horas.toInt();

    if(hour == 24){
      hour = 0;
    }else if(hour > 24){
      hour = hour - 24;
    }

    String hourEnd = hour.toString()+":"+min.toString();

    if(min == 0){
      hourEnd = hourEnd+"0";
    }

    if(hour<10){
      hourEnd = "0"+hourEnd;
    }

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
                  text: "horário início: ",
                  data: diaA,
                ),
                SizedBox(
                  height: 4,
                ),
                BuildRow(
                  text: "horário fim: ",
                  data: hourEnd,
                ),
                SizedBox(
                  height: 4,
                ),
                BuildRow(
                  text: "plano: ",
                  data: plan.name,
                ),
                SizedBox(
                  height: 4,
                ),
                BuildRow(
                  text: "duração aula: ",
                  data: plan.duration.toString()+"min",
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
