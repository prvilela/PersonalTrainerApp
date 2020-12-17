import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:apppersonaltrainer/models/student.dart';
import 'package:apppersonaltrainer/models/student_manager.dart';
import './choose_dialog.dart';

class TimeDayWeek extends StatelessWidget {

  TimeDayWeek({ this.student, this.value});

  final Student student;
  final String value;
  final hora = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: TextFormField(
          readOnly: true,
          controller: hora,
          onSaved: (text) => student.plano = text,
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
                            names: studentManager.names,
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
