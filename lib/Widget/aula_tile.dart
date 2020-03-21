import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:personal_trainer/screens/agendarTreino_screen.dart';

class AulaTile extends StatelessWidget {
  final DocumentSnapshot aulas;
  AulaTile(this.aulas);

  @override
  Widget build(BuildContext context) {
    final _fieldStale = TextStyle(color: Colors.deepOrange, fontSize: 20);

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: InkWell(
        onTap: (){},
        child: Card(
          child: ExpansionTile(
            leading: Text(aulas.data["hora"], style: TextStyle(color: Colors.deepOrange, fontSize: 22)),
            title:  Text(aulas.data["name"] + " - " + aulas.data["academia"], 
              style: _fieldStale
            ),
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(left: 16,right: 16,top: 0,bottom: 8),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    _buildRow("CPF: ", aulas.data["cpf"]),
                    SizedBox(height: 4,),
                    _buildRow("Dia: ", aulas.data["data"]),
                    SizedBox(height: 4,),
                    _buildRow("Hora: ", aulas.data["hora"]),
                    SizedBox(height: 4,),
                    _buildRow("Academia: ", aulas.data["academia"]),
                    SizedBox(height: 4,),
                    _buildRow("Duração: ", aulas.data["duracao"]),
                    SizedBox(height: 4,),
                    _buildRow("Preço: ", aulas.data["preco"]),
                    
                    Container(
                      child: FlatButton(
                        onPressed: (){
                          Navigator.of(context).push(
                            MaterialPageRoute(
                                builder: (context)=> AgendarTreinoScreen(
                                  aulas: aulas,
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
    final _fieldStale = TextStyle(color: Colors.deepOrange, fontSize: 16);
    return Row(
      children: <Widget>[
        Text(text, style: _fieldStale,),
        Text(data, style: _fieldStale,)
      ],
    );
  }
}
