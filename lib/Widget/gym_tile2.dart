//Classe dedicada apenas para exibir as academias no momento de cadastrar o aluno

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:personal_trainer/screens/gym_screen.dart';
import 'package:personal_trainer/screens/student_screen.dart';

class GymTile2 extends StatelessWidget {
  StudentScreenState sss = new StudentScreenState(null);

  final DocumentSnapshot gym;

  GymTile2(this.gym);

  @override
  Widget build(BuildContext context) {

    final _fieldStale = TextStyle(color: Colors.deepOrange, fontSize: 20);

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: InkWell(
        onTap: (){},
        child: Card(
          child: ExpansionTile(
            leading: Icon(Icons.person, color: Colors.orange,),
            title:  Text(gym.data["name"],
              style: _fieldStale
            ),
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(left: 16,right: 16,top: 0,bottom: 8),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    _buildRow("Endereço: ", gym.data["location"]),         

                    Container(
                      child: FlatButton(
                        onPressed: (){
                          sss.atualizarNomeAcademia(gym.data["name"]);    
                          print(gym.data["name"]);
                          print("AAAAAAAAOOOOOOOOOOOOOO"); 
                          //Navigator.of(context).pop();                                      
                        },
                        textColor: Colors.orange,
                        child: Text("Selecionar", style: TextStyle(color: Colors.black),),
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
