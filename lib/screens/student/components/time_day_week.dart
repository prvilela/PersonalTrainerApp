import 'package:apppersonaltrainer/models/calendar_manager.dart';
import 'package:apppersonaltrainer/models/planManager.dart';
import 'package:apppersonaltrainer/models/times.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:apppersonaltrainer/models/student.dart';
import 'package:apppersonaltrainer/models/student_manager.dart';
import './choose_dialog.dart';

class TimeDayWeek extends StatelessWidget {
  TimeDayWeek({this.student, this.value, this.initial});

  final Student student;
  final String value;
  final String initial;
  final hora = TextEditingController();

  Times times = Times();

  void salvar(String text) {
    switch (value) {
      case 'Dom':
        student.days.horarioDom = text;
        break;
      case 'Seg':
        student.days.horarioSeg = text;
        break;
      case 'Ter':
        student.days.horarioTer = text;
        break;
      case 'Quar':
        student.days.horarioQuar = text;
        break;
      case 'Quin':
        student.days.horarioQuin = text;
        break;
      case 'Sex':
        student.days.horarioSex = text;
        break;
      case 'Sab':
        student.days.horarioSab = text;
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    List listaHorario = times.times();
    hora.text = initial ?? '';
    var dia = value.toString();
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: TextFormField(
          readOnly: true,
          controller: hora,
          onSaved: (text) => salvar(text),
          decoration: InputDecoration(
            hintText: 'Horario',
            border: InputBorder.none,
            suffixIcon: Consumer3<StudentManager, PlanManager, CalendarManager>(
              builder: (_, studentManager, planManager, calendarManager, __) {
                return IconButton(
                    icon: Icon(Icons.search),
                    onPressed: () async {
                      print(dia);
                      switch (dia) {
                        case 'Dom':
                          //BUSCA TODOS OS ALUNOS DE UM DIA DA SEMANA E DPS RETIRA UM POR UM DOS HORARIOS DISPONIVEIS
                          final studentsD =
                              studentManager.filteredStudentByWeekday(7);

                          for (var i = 0; i < studentsD.length; i++) {
                            listaHorario.remove(studentsD[i].days.horarioDom);
                            print(studentsD[i].days.horarioDom);
                            var planoAluno =
                                planManager.findPlanByName(studentsD[i].plano);
                            print(planoAluno.duration);
                            print('-------- // --------');
                          }
                          break;

                        case 'Seg':
                          final studentsS =
                              studentManager.filteredStudentByWeekday(1);

                          for (var i = 0; i < studentsS.length; i++) {
                            listaHorario.remove(studentsS[i].days.horarioSeg);
                            print(studentsS[i].days.horarioSeg);
                            var planoAluno =
                                planManager.findPlanByName(studentsS[i].plano);
                            print(planoAluno.duration);
                            print('-------- // --------');
                          }
                          break;

                        case 'Ter':
                          final studentsT =
                              studentManager.filteredStudentByWeekday(2);

                          for (var i = 0; i < studentsT.length; i++) {
                            listaHorario.remove(studentsT[i].days.horarioTer);
                            print(studentsT[i].days.horarioTer);
                            var planoAluno =
                                planManager.findPlanByName(studentsT[i].plano);
                            print(planoAluno.duration);
                            print('-------- // --------');
                          }
                          break;

                        case 'Quar':
                          final studentsQ =
                              studentManager.filteredStudentByWeekday(3);

                          for (var i = 0; i < studentsQ.length; i++) {
                            listaHorario.remove(studentsQ[i].days.horarioQuar);
                            print(studentsQ[i].days.horarioQuar);
                            var planoAluno =
                                planManager.findPlanByName(studentsQ[i].plano);
                            print(planoAluno.duration);
                            print('-------- // --------');
                          }
                          break;

                        case 'Quin':
                          final studentsQuin =
                              studentManager.filteredStudentByWeekday(4);

                          for (var i = 0; i < studentsQuin.length; i++) {
                            listaHorario
                                .remove(studentsQuin[i].days.horarioQuin);
                            print(studentsQuin[i].days.horarioQuin);
                            var planoAluno = planManager
                                .findPlanByName(studentsQuin[i].plano);
                            print(planoAluno.duration);
                            print('-------- // --------');
                          }
                          break;

                        case 'Sex':
                          final studentsSex =
                              studentManager.filteredStudentByWeekday(5);

                          for (var i = 0; i < studentsSex.length; i++) {
                            listaHorario.remove(studentsSex[i].days.horarioSex);
                            print(studentsSex[i].days.horarioSex);
                            var planoAluno = planManager
                                .findPlanByName(studentsSex[i].plano);
                            print(planoAluno.duration);
                            print('-------- // --------');
                          }
                          break;

                        case 'Sab':
                          final studentsSab =
                              studentManager.filteredStudentByWeekday(6);

                          for (var i = 0; i < studentsSab.length; i++) {
                            listaHorario.remove(studentsSab[i].days.horarioSab);
                            print(studentsSab[i].days.horarioSab);
                            var planoAluno = planManager
                                .findPlanByName(studentsSab[i].plano);
                            print(planoAluno.duration);
                            print('-------- // --------');
                          }
                          break;
                      }

                      final text = await showDialog(
                          context: context,
                          builder: (_) => ChooseDialog(
                                titulo: "Horarios Disponiveis",
                                names: listaHorario,
                              ));
                      print(listaHorario);
                      hora.text = text;
                    });
              },
            ),
          ),
          style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }
}
