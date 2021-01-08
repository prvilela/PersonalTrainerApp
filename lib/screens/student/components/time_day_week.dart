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
                          print('Domingou');
                          final domingoHorario =
                              studentManager.filteredStudentByWeekday(7);
                          for (var user in domingoHorario) {
                            print(user.days.horarioDom);
                            var plan = planManager.findPlanByName(user.plano);

                            //BUSCA TODOS OS ALUNOS DE UM DIA DA SEMANA E DPS RETIRA UM POR UM DOS HORARIOS DISPONIVEIS
                            final studentsD =
                                studentManager.filteredStudentByWeekday(7);
                            print(studentsD);

                            for (var i = 0; i < studentsD.length; i++) {
                              listaHorario.remove(studentsD[i].days.horarioDom);
                              print(studentsD[i].days.horarioDom);
                            }
                          }
                          break;
                        case 'Seg':
                          print('Segundou');
                          final segundaHorario =
                              studentManager.filteredStudentByWeekday(1);
                          for (var user in segundaHorario) {
                            print(user.days.horarioSeg);
                            var plan = planManager.findPlanByName(user.plano);

                            final studentsS =
                                studentManager.filteredStudentByWeekday(1);
                            print(studentsS);

                            for (var i = 0; i < studentsS.length; i++) {
                              listaHorario.remove(studentsS[i].days.horarioSeg);
                              print(studentsS[i].days.horarioSeg);
                            }
                          }
                          break;
                        case 'Ter':
                          print('Terçou');
                          final tercaHorario =
                              studentManager.filteredStudentByWeekday(2);
                          for (var user in tercaHorario) {
                            print(user.days.horarioTer);
                            var plan = planManager.findPlanByName(user.plano);

                            final studentsT =
                                studentManager.filteredStudentByWeekday(2);
                            print(studentsT);

                            for (var i = 0; i < studentsT.length; i++) {
                              listaHorario.remove(studentsT[i].days.horarioTer);
                              print(studentsT[i].days.horarioTer);
                            }
                          }
                          break;
                        case 'Quar':
                          print('Quartou');
                          final quartaHorario =
                              studentManager.filteredStudentByWeekday(3);
                          for (var user in quartaHorario) {
                            print(user.days.horarioQuar);
                            var plan = planManager.findPlanByName(user.plano);

                            final studentsQ =
                                studentManager.filteredStudentByWeekday(3);
                            print(studentsQ);

                            for (var i = 0; i < studentsQ.length; i++) {
                              listaHorario
                                  .remove(studentsQ[i].days.horarioQuar);
                              print(studentsQ[i].days.horarioQuar);
                            }
                          }
                          break;
                        case 'Quin':
                          print('Quintou');
                          final quintaHorario =
                              studentManager.filteredStudentByWeekday(4);
                          for (var user in quintaHorario) {
                            print(user.days.horarioQuin);

                            final studentsQuin =
                                studentManager.filteredStudentByWeekday(4);
                            print(studentsQuin);

                            for (var i = 0; i < studentsQuin.length; i++) {
                              listaHorario
                                  .remove(studentsQuin[i].days.horarioQuin);
                              print(studentsQuin[i].days.horarioQuin);
                            }
                          }
                          break;
                        case 'Sex':
                          print('Sextou');
                          final sextaHorario =
                              studentManager.filteredStudentByWeekday(5);
                          for (var user in sextaHorario) {
                            print(user.days.horarioSex);

                            final studentsSex =
                                studentManager.filteredStudentByWeekday(5);
                            print(studentsSex);

                            for (var i = 0; i < studentsSex.length; i++) {
                              listaHorario
                                  .remove(studentsSex[i].days.horarioSex);
                              print(studentsSex[i].days.horarioSex);
                            }
                          }
                          break;
                        case 'Sab':
                          print('Sabadou');
                          final sabadoHorario =
                              studentManager.filteredStudentByWeekday(6);
                          for (var user in sabadoHorario) {
                            print(user.days.horarioSab);

                            final studentsSab =
                                studentManager.filteredStudentByWeekday(6);
                            print(studentsSab);

                            for (var i = 0; i < studentsSab.length; i++) {
                              listaHorario
                                  .remove(studentsSab[i].days.horarioSab);
                              print(studentsSab[i].days.horarioSab);
                            }
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
