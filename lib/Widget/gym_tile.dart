import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:personal_trainer/screens/gym_screen.dart';

class GymTile extends StatelessWidget {

  final DocumentSnapshot gym;

  GymTile(this.gym);

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
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                   Text(
                      'Endereço',
                      textAlign: TextAlign.start,
                      style: TextStyle(color: Colors.orange[700], fontSize: 16)
                    ),
                   Text(
                      gym.data["rua"],
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(color: Colors.orange[700], fontSize: 16)
                    ),
                    SizedBox(height: 4,),
                    _buildRow("Telefone: ", gym.data["phone"],1),
                    SizedBox(height: 4,),
                    _buildRow("Preço: ", gym.data["preco"],1),
                    SizedBox(height: 4,),
                    _buildRow("Horário Semanal: ", gym.data["horarioSemanaA"].toString()+" - "+ gym.data["horarioSemanaF"].toString(),1),
                    SizedBox(height: 4,),
                    _buildRow("Horário de Sábado: ", gym.data["horarioSabadoA"].toString()+" - "+gym.data["horarioSabadoF"].toString(),1),
                    SizedBox(height: 4,),
                    _buildRow("Horário de Domingo: ", gym.data["horarioDomingoA"].toString()+" - "+gym.data["horarioDomingoF"].toString(),1),

                    Container(
                      child: FlatButton(
                        onPressed: (){
                          Navigator.of(context).push(
                            MaterialPageRoute(
                                builder: (context)=> GymScreen(
                                  gym: gym,
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
  Widget _buildRow(String text,String data, int lines){
    final _fieldStale = TextStyle(color: Colors.orange[700], fontSize: 16);
    return Row(
      children: <Widget>[
        Text(text, style: _fieldStale,maxLines: lines,),
        Text(data, style: _fieldStale, maxLines: lines,)
      ],
    );
  }
}
