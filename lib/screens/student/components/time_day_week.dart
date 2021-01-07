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
            suffixIcon: Consumer2<StudentManager, PlanManager>(
              builder: (_, studentManager, planManager, __) {
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
                            print(plan);

                            //só dar uma query com os horários do dia no banco e remover do listaHorario!!!!!!
                            List impro = ['12:00'];
                            listaHorario = impro;
                          }
                          break;
                        case 'Seg':
                          print('Segundou');
                          final segundaHorario =
                              studentManager.filteredStudentByWeekday(1);
                          for (var user in segundaHorario) {
                            print(user.days.horarioSeg);
                            var plan = planManager.findPlanByName(user.plano);
                            print(plan);
                            //listaHorario.remove(user.days.horarioSeg);
                          }
                          break;
                        case 'Ter':
                          print('Terçou');
                          final tercaHorario =
                              studentManager.filteredStudentByWeekday(2);
                          for (var user in tercaHorario) {
                            print(user.days.horarioTer);
                            var plan = planManager.findPlanByName(user.plano);
                            print(plan);
                            //listaHorario.remove(user.days.horarioTer);
                          }
                          break;
                        case 'Quar':
                          print('Quartou');
                          final quartaHorario =
                              studentManager.filteredStudentByWeekday(3);
                          for (var user in quartaHorario) {
                            print(user.days.horarioQuar);
                            var plan = planManager.findPlanByName(user.plano);
                            print(plan);
                          }
                          break;
                        case 'Quin':
                          print('Quintou');
                          final quintaHorario =
                              studentManager.filteredStudentByWeekday(4);
                          for (var user in quintaHorario) {
                            print(user.days.horarioQuin);
                          }
                          break;
                        case 'Sex':
                          print('Sextou');
                          final sextaHorario =
                              studentManager.filteredStudentByWeekday(5);
                          for (var user in sextaHorario) {
                            print(user.days.horarioSex);
                          }
                          break;
                        case 'Sab':
                          print('Sabadou');
                          final sabadoHorario =
                              studentManager.filteredStudentByWeekday(6);
                          for (var user in sabadoHorario) {
                            print(user.days.horarioSab);
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
