import 'package:apppersonaltrainer/models/calendar_manager.dart';
import 'package:apppersonaltrainer/models/planManager.dart';
import 'package:apppersonaltrainer/models/times.dart';
import 'package:apppersonaltrainer/time.dart';
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
                          final studentsD =
                              studentManager.filteredStudentByWeekday(7);
                          for (var i = 0; i < studentsD.length; i++) {
                            print('aqui vai o hor domingo abaixo:');
                            listaHorario.remove(studentsD[i].days.horarioDom);
                            print(studentsD[i].days.horarioDom.toString());
                            var planoAluno =
                                planManager.findPlanByName(studentsD[i].plano);
                            print(planoAluno.duration);
                            print(
                                '-------- // --------'); //quo -> quociente e remain -> resto
                            var quo = quotient(planoAluno.duration, 30) - 1;
                            var remain = planoAluno.duration.remainder(30);
                            print(quo);
                            print(remain);
                            var tt = studentsD[i].days.horarioDom;
                            print(tt);
                            if (tt.isNotEmpty) {
                              var timeSplited = tt.split(':');
                              int hora = int.parse(timeSplited[0]);
                              int min = int.parse(timeSplited[1]);
                              print(hora);
                              print(min);

                              for (int x = 0; x < quo; x++) {
                                min = min + 30;
                                if (min == 60) {
                                  hora = hora + 1;
                                  min = 00;
                                }

                                var proximoHorario;
                                if (min == 0) {
                                  proximoHorario =
                                      hora.toString() + ':0' + min.toString();
                                  print(proximoHorario);
                                } else {
                                  proximoHorario =
                                      hora.toString() + ':' + min.toString();
                                  print(proximoHorario);
                                }
                                listaHorario.remove(proximoHorario);
                              }
                            }
                          }
                          break;

                        case 'Seg':
                          final studentsS =
                              studentManager.filteredStudentByWeekday(1);
                          for (var i = 0; i < studentsS.length; i++) {
                            print('aqui vai o hor segunda abaixo:');
                            listaHorario.remove(studentsS[i].days.horarioSeg);
                            print(studentsS[i].days.horarioSeg.toString());
                            var planoAluno =
                                planManager.findPlanByName(studentsS[i].plano);
                            print(planoAluno.duration);
                            print(
                                '-------- // --------'); //quo -> quociente e remain -> resto
                            var quo = quotient(planoAluno.duration, 30) - 1;
                            var remain = planoAluno.duration.remainder(30);
                            print(quo);
                            print(remain);
                            var tt = studentsS[i].days.horarioSeg;
                            print(tt);
                            if (tt.isNotEmpty) {
                              var timeSplited = tt.split(':');
                              int hora = int.parse(timeSplited[0]);
                              int min = int.parse(timeSplited[1]);
                              print(hora);
                              print(min);

                              for (int x = 0; x < quo; x++) {
                                min = min + 30;
                                if (min == 60) {
                                  hora = hora + 1;
                                  min = 00;
                                }

                                var proximoHorario;
                                if (min == 0) {
                                  proximoHorario =
                                      hora.toString() + ':0' + min.toString();
                                  print(proximoHorario);
                                } else {
                                  proximoHorario =
                                      hora.toString() + ':' + min.toString();
                                  print(proximoHorario);
                                }
                                listaHorario.remove(proximoHorario);
                              }
                            }
                          }
                          break;

                        case 'Ter':
                          final studentsT =
                              studentManager.filteredStudentByWeekday(2);
                          for (var i = 0; i < studentsT.length; i++) {
                            print('aqui vai o hor terça abaixo:');
                            listaHorario.remove(studentsT[i].days.horarioTer);
                            print(studentsT[i].days.horarioTer.toString());
                            var planoAluno =
                                planManager.findPlanByName(studentsT[i].plano);
                            print(planoAluno.duration);
                            print(
                                '-------- // --------'); //quo -> quociente e remain -> resto
                            var quo = quotient(planoAluno.duration, 30) - 1;
                            var remain = planoAluno.duration.remainder(30);
                            print(quo);
                            print(remain);
                            var tt = studentsT[i].days.horarioTer;
                            print(tt);
                            if (tt.isNotEmpty) {
                              var timeSplited = tt.split(':');
                              int hora = int.parse(timeSplited[0]);
                              int min = int.parse(timeSplited[1]);
                              print(hora);
                              print(min);

                              for (int x = 0; x < quo; x++) {
                                min = min + 30;
                                if (min == 60) {
                                  hora = hora + 1;
                                  min = 00;
                                }

                                var proximoHorario;
                                if (min == 0) {
                                  proximoHorario =
                                      hora.toString() + ':0' + min.toString();
                                  print(proximoHorario);
                                } else {
                                  proximoHorario =
                                      hora.toString() + ':' + min.toString();
                                  print(proximoHorario);
                                }
                                listaHorario.remove(proximoHorario);
                              }
                            }
                          }
                          break;

                        case 'Quar':
                          final studentsQ =
                              studentManager.filteredStudentByWeekday(3);
                          for (var i = 0; i < studentsQ.length; i++) {
                            print('aqui vai o hor quarta abaixo:');
                            listaHorario.remove(studentsQ[i].days.horarioQuar);
                            print(studentsQ[i].days.horarioQuar.toString());
                            var planoAluno =
                                planManager.findPlanByName(studentsQ[i].plano);
                            print(planoAluno.duration);
                            print(
                                '-------- // --------'); //quo -> quociente e remain -> resto
                            var quo = quotient(planoAluno.duration, 30) - 1;
                            var remain = planoAluno.duration.remainder(30);
                            print(quo);
                            print(remain);
                            var tt = studentsQ[i].days.horarioQuar;
                            print(tt);
                            if (tt.isNotEmpty) {
                              var timeSplited = tt.split(':');
                              int hora = int.parse(timeSplited[0]);
                              int min = int.parse(timeSplited[1]);
                              print(hora);
                              print(min);

                              for (int x = 0; x < quo; x++) {
                                min = min + 30;
                                if (min == 60) {
                                  hora = hora + 1;
                                  min = 00;
                                }

                                var proximoHorario;
                                if (min == 0) {
                                  proximoHorario =
                                      hora.toString() + ':0' + min.toString();
                                  print(proximoHorario);
                                } else {
                                  proximoHorario =
                                      hora.toString() + ':' + min.toString();
                                  print(proximoHorario);
                                }
                                listaHorario.remove(proximoHorario);
                              }
                            }
                          }
                          break;

                        case 'Quin':
                          final studentsQuin =
                              studentManager.filteredStudentByWeekday(4);
                          for (var i = 0; i < studentsQuin.length; i++) {
                            print('aqui vai o hor quinta abaixo:');
                            listaHorario
                                .remove(studentsQuin[i].days.horarioQuin);
                            print(studentsQuin[i].days.horarioQuin.toString());
                            var planoAluno = planManager
                                .findPlanByName(studentsQuin[i].plano);
                            print(planoAluno.duration);
                            print(
                                '-------- // --------'); //quo -> quociente e remain -> resto
                            var quo = quotient(planoAluno.duration, 30) - 1;
                            var remain = planoAluno.duration.remainder(30);
                            print(quo);
                            print(remain);
                            var tt = studentsQuin[i].days.horarioQuin;
                            print(tt);
                            if (tt.isNotEmpty) {
                              var timeSplited = tt.split(':');
                              int hora = int.parse(timeSplited[0]);
                              int min = int.parse(timeSplited[1]);
                              print(hora);
                              print(min);

                              for (int x = 0; x < quo; x++) {
                                min = min + 30;
                                if (min == 60) {
                                  hora = hora + 1;
                                  min = 00;
                                }

                                var proximoHorario;
                                if (min == 0) {
                                  proximoHorario =
                                      hora.toString() + ':0' + min.toString();
                                  print(proximoHorario);
                                } else {
                                  proximoHorario =
                                      hora.toString() + ':' + min.toString();
                                  print(proximoHorario);
                                }
                                listaHorario.remove(proximoHorario);
                              }
                            }
                          }
                          break;

                        case 'Sex':
                          final studentsSex =
                              studentManager.filteredStudentByWeekday(5);
                          for (var i = 0; i < studentsSex.length; i++) {
                            print('aqui vai o hor domingo abaixo:');
                            listaHorario.remove(studentsSex[i].days.horarioSex);
                            print(studentsSex[i].days.horarioSex.toString());
                            var planoAluno = planManager
                                .findPlanByName(studentsSex[i].plano);
                            print(planoAluno.duration);
                            print(
                                '-------- // --------'); //quo -> quociente e remain -> resto
                            var quo = quotient(planoAluno.duration, 30) - 1;
                            var remain = planoAluno.duration.remainder(30);
                            print(quo);
                            print(remain);
                            var tt = studentsSex[i].days.horarioSex;
                            print(tt);
                            if (tt.isNotEmpty) {
                              var timeSplited = tt.split(':');
                              int hora = int.parse(timeSplited[0]);
                              int min = int.parse(timeSplited[1]);
                              print(hora);
                              print(min);

                              for (int x = 0; x < quo; x++) {
                                min = min + 30;
                                if (min == 60) {
                                  hora = hora + 1;
                                  min = 00;
                                }

                                var proximoHorario;
                                if (min == 0) {
                                  proximoHorario =
                                      hora.toString() + ':0' + min.toString();
                                  print(proximoHorario);
                                } else {
                                  proximoHorario =
                                      hora.toString() + ':' + min.toString();
                                  print(proximoHorario);
                                }
                                listaHorario.remove(proximoHorario);
                              }
                            }
                          }
                          break;

                        case 'Sab':
                          final studentsSab =
                              studentManager.filteredStudentByWeekday(6);
                          for (var i = 0; i < studentsSab.length; i++) {
                            print('aqui vai o hor domingo abaixo:');
                            listaHorario.remove(studentsSab[i].days.horarioSab);
                            print(studentsSab[i].days.horarioSab.toString());
                            var planoAluno = planManager
                                .findPlanByName(studentsSab[i].plano);
                            print(planoAluno.duration);
                            print(
                                '-------- // --------'); //quo -> quociente e remain -> resto
                            var quo = quotient(planoAluno.duration, 30) - 1;
                            var remain = planoAluno.duration.remainder(30);
                            print(quo);
                            print(remain);
                            var tt = studentsSab[i].days.horarioSab;
                            print(tt);
                            if (tt.isNotEmpty) {
                              var timeSplited = tt.split(':');
                              int hora = int.parse(timeSplited[0]);
                              int min = int.parse(timeSplited[1]);
                              print(hora);
                              print(min);

                              for (int x = 0; x < quo; x++) {
                                min = min + 30;
                                if (min == 60) {
                                  hora = hora + 1;
                                  min = 00;
                                }

                                var proximoHorario;
                                if (min == 0) {
                                  proximoHorario =
                                      hora.toString() + ':0' + min.toString();
                                  print(proximoHorario);
                                } else {
                                  proximoHorario =
                                      hora.toString() + ':' + min.toString();
                                  print(proximoHorario);
                                }
                                listaHorario.remove(proximoHorario);
                              }
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
                      salvar(hora.text);
                    });
              },
            ),
          ),
          style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }

  quotient(int x, int y) {
    int q = x ~/ y;
    return q;
  }
}
