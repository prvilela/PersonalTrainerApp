import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:personal_trainer/screens/student_screen.dart';

class StudentTile extends StatelessWidget {

  final DocumentSnapshot student;

  StudentTile(this.student);

  @override
  Widget build(BuildContext context) {

    final _fieldStale = TextStyle(color: Colors.deepOrange, fontSize: 20);

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: InkWell(
        onTap: (){},
        child: Card(
          child: ExpansionTile(
            leading: Icon(Icons.person, color: Colors.deepOrange,),
            title:  Text(student.data["name"],  
              style: _fieldStale
            ),
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(left: 16,right: 16,top: 0,bottom: 8),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    _buildRow("CPF: ", student.data["cpf"]),
                    SizedBox(height: 4,),
                    _buildRow("Data de Nascimento: ", student.data["birthday"]),
                    SizedBox(height: 4,),
                    _buildRow("Sexo: ", student.data["gender"]),
                    SizedBox(height: 4,),
                    _buildRow("E-mail: ", student.data["email"]),
                    SizedBox(height: 4,),
                    _buildRow("Celular: ", student.data["phone"]),
                    SizedBox(height: 4,),
                    _buildRow("Objetivo: ", student.data["goal"]),
                    SizedBox(height: 4,),
                    _buildRow("Restrições: ", student.data["restrictions"]),
                    SizedBox(height: 4,),
                    _buildRow("Academia: ", student.data["gym"]),
                    SizedBox(height: 4,),
                    _buildRow("Status: ", student.data["status"]),
                    
                    Container(
                      child: FlatButton(
                        onPressed: (){
                          Navigator.of(context).push(
                            MaterialPageRoute(
                                builder: (context)=> StudentScreen(
                                  student: student,
                                ))
                          );
                        },
                        textColor: Colors.orange,
                        child: Text("Editar"),
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
  Widget _buildRow(String text,String data){
    final _fieldStale = TextStyle(color: Colors.orange[700], fontSize: 16);
    return Row(
      children: <Widget>[
        Text(text, style: _fieldStale,),
        Text(data, style: _fieldStale,)
      ],
    );
  }
}
