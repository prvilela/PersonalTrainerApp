import 'package:apppersonaltrainer/common/custom_drawer/custom_drawer.dart';
import 'package:apppersonaltrainer/models/calendar_manager.dart';
import 'package:apppersonaltrainer/models/student_manager.dart';
import 'package:apppersonaltrainer/screens/calendar/components/calendar_tile.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CalendarScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: CustomDrawer(),
      appBar: AppBar(
        title: const Text('Agenda'),
        centerTitle: true,
        elevation: 0,
      ),
      body: Consumer2<CalendarManager, StudentManager>(
        builder: (_, calendarManager, studentManager, __) {
          final students = studentManager
              .filteredStudentByWeekday(calendarManager.diaSemana);
          if (students != []) {
            print('not null students');
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    IconButton(
                        icon: Icon(Icons.arrow_back),
                        onPressed: calendarManager.subDiaSemana),
                    Expanded(
                        child: Text(
                      calendarManager.dia,
                      textAlign: TextAlign.center,
                    )),
                    IconButton(
                        icon: Icon(Icons.arrow_forward),
                        onPressed: calendarManager.addDiaSemana),
                  ],
                ),
                ListView.builder(
                    shrinkWrap: true,
                    itemCount: students.length,
                    itemBuilder: (context, index) {
                      return CalendarTile(students[index]);
                    }),
              ],
            );
          } else {
            print('null students');
            return Text('NO alunos;');
          }
        },
      ),
    );
  }
}
