import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class PagamentosTile extends StatelessWidget {

  final DocumentSnapshot student;
  TextEditingController price = TextEditingController();
  TextEditingController quantidade = TextEditingController();
  TextEditingController total = TextEditingController();
  PagamentosTile(this.student);

  @override
  Widget build(BuildContext context) {
    final _fieldStale = TextStyle(color: Colors.deepOrange, fontSize: 20);

    pegarDadosPagamento();
    InputDecoration _buildDecoratiom(String label) {
      return InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: Colors.deepOrange[700]),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.orange, width: 1.0),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.orange, width: 1.0),
        ),
      );
    }

    quantidade.text = student.data["quantidade"];

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: InkWell(
        onTap: (){},
        child: Card(
          child: ExpansionTile(
            title: Text(student.data["name"],style: _fieldStale,),
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(left: 16,right: 16,top: 8,bottom: 8),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    TextFormField(
                      readOnly: true,
                      style: _fieldStale,
                      decoration: _buildDecoratiom("Preço"),
                      controller: price,

                    ),
                    SizedBox(height: 4,),
                    TextFormField(
                      readOnly: true,
                      style: _fieldStale,
                      decoration: _buildDecoratiom("Quantidade meses:"),
                      controller: quantidade,
                      onChanged: (text){
                        total = quantidade;
                      },
                    ),
                    SizedBox(height: 4,),
                    FlatButton.icon(
                        onPressed: (){
                          var now = new DateTime.now().add(new Duration(days: 30));
                          int q = int.parse(student.data["quantidade"])-1;
                          student.reference.updateData(
                              {"quantidade": q.toString(),
                                "dataInicio": student.data["dataCobranca"],
                                "dataCobranca": now.toString()
                              }
                              );
                        },
                        icon: Icon(Icons.payment),
                        label: Text("Pagar"))
                  ],
                ),
              )
            ],
          ),

        ),
      ),

    );
  }
  pegarDadosPagamento() async{
    FirebaseUser user = await FirebaseAuth.instance.currentUser();
    String uid = user.uid;
    String plano = student.data["plano"];
    String aux = plano.replaceAll(" ", "");
    print(aux);
    QuerySnapshot list = await Firestore.instance.collection("pacote").where("idPersonal", isEqualTo: user.uid).where("type", isEqualTo: aux).getDocuments();
    var a = list.documents.map((f){

        return f.data["price"];

    });
    a.forEach((f){
      if(f!=null){

        price.text = f;

      }
    });

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
