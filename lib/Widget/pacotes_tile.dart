import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:personal_trainer/screens/pacotes_screen.dart';

class PacotesTile extends StatelessWidget {

  final DocumentSnapshot pacotes;

  PacotesTile(this.pacotes);

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
            title:  Text("Plano: "+pacotes.data["type"],
                style: _fieldStale
            ),
            children: <Widget>[

              _buildRow("Preço: ", pacotes.data["price"]),
              SizedBox(height: 4,),
              _buildRow("Duração: ", pacotes.data["duration"]),

              Container(
                child: FlatButton(
                  onPressed: (){Navigator.of(context).push(
                        MaterialPageRoute(
                            builder: (context)=> PacotesScreen(
                              pacote: pacotes,
                            ))
                    );
                  },
                  textColor: Colors.orange,
                  child: Text("Editar"),
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
