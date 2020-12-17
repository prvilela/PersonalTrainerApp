import 'package:apppersonaltrainer/common/build_row.dart';
import 'package:apppersonaltrainer/models/student.dart';
import 'package:flutter/material.dart';

class StudentTile extends StatelessWidget {

  const StudentTile(this.student);

  final Student student;

  @override
  Widget build(BuildContext context) {
    final _fieldStale = TextStyle(color: Theme.of(context).primaryColor, fontSize: 20);
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
                BuildRow(text: "E-mail: ", data: student.email,),
                SizedBox(height: 4,),
                BuildRow(text: "Celular: ", data: student.phone,),
                SizedBox(height: 4,),
                BuildRow(text: "Academia: ", data: student.gym,),
                SizedBox(height: 4,),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
