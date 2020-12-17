import 'package:apppersonaltrainer/models/times.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:apppersonaltrainer/models/student.dart';
import 'package:apppersonaltrainer/models/student_manager.dart';
import './choose_dialog.dart';

class TimeDayWeek extends StatelessWidget {

  TimeDayWeek({ this.student, this.value, this.initial});

  final Student student;
  final String value;
  final String initial;
  final hora = TextEditingController();

  Times times = Times();

  void salvar(String text){
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
    hora.text = initial ?? '';
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
            suffixIcon: Consumer<StudentManager>(
              builder: (_, studentManager, __) {
                return IconButton(
                    icon: Icon(Icons.search),
                    onPressed: () async {
                      final text = await showDialog(
                          context: context,
                          builder: (_) => ChooseDialog(
                            titulo: "Horarios Disponiveis",
                            names: times.times(),
                          ));
                      hora.text = text;
                    });
              },
            ),
          ),
          style: TextStyle(
              fontSize: 15, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }
}
