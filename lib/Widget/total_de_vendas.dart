import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class TotalDeVendas extends StatelessWidget {

  final AsyncSnapshot student;
  TextEditingController valor = TextEditingController(text: '0');
  TextEditingController valorRecebido = TextEditingController();

  TotalDeVendas(this.student);
  double total = 0;
  double valorJaRecebido =0;



  @override
  Widget build(BuildContext context) {

    if(student.hasData)
      pegarDadosPagamento();

    final _fieldStale = TextStyle(color: Colors.deepOrange, fontSize: 20);
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

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: InkWell(
        onTap: (){},
        child: Card(
          child: ExpansionTile(
              title: Text('A receber', style: _fieldStale,),
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(left: 16,right: 16,top: 8,bottom: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    TextFormField(
                      readOnly: true,
                      style: _fieldStale,
                      decoration: _buildDecoratiom("Valor Total"),
                      controller: valor,

                    ),
                    SizedBox(height: 10,),
                    TextFormField(
                      readOnly: true,
                      style: _fieldStale,
                      decoration: _buildDecoratiom("Valor Recebido"),
                      controller: valorRecebido,

                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  pegarDadosPagamento() async {
    FirebaseUser user = await FirebaseAuth.instance.currentUser();
    String uid = user.uid;
    var now = new DateTime.now();
    var comparar = new DateTime(now.year,now.month,30);
    var inicio = new DateTime(now.year, now.month-1, now.day).add(Duration(days: 6));

    for (DocumentSnapshot doc in student.data) {
      String data = doc.data["dataCobranca"].toString();
      String dataIni = doc.data["dataInicio"].toString();
      String dataPri = doc.data["dataPrimeiroDia"].toString();
      String plano = doc.data["plano"];
      String aux = plano.replaceAll(" ", "");
      var y = data.split(" ");
      var x = dataPri.split(" ");
      var w = dataIni.split(" ");
      String b = y[0];
      String c = w[0];
      String b2 = x[0];
      String c2 = x[1];
      var aux2 = b.split("-");
      var aux3 = b2.split("-");
      var aux4 = c.split("-");
      var cobranca = new DateTime(
          int.parse(aux2[0]), int.parse(aux2[1]), int.parse(aux2[2]));
      var ini = new DateTime(
          int.parse(aux3[0]), int.parse(aux3[1]), int.parse(aux3[2]));
      var aindaValidoMax = new DateTime(now.year,now.month,30);
      var aindaValidoMin = new DateTime(now.year,now.month,1);
      var valido = new DateTime(
          int.parse(aux4[0]), int.parse(aux4[1]), int.parse(aux4[2]));
      print(valido.toString()+aindaValidoMax.toString());
      if (int.parse(doc.data["quantidade"]) > 0 &&
          (cobranca.isBefore(comparar) ||
              cobranca.isAtSameMomentAs(comparar))) {
        //print(aux);

        QuerySnapshot list = await Firestore.instance.collection("pacote")
            .where(
            "idPersonal", isEqualTo: user.uid)
            .where("type", isEqualTo: aux)
            .getDocuments();
        var a = list.documents.map((f) {
          return f.data["price"];
        });
        a.forEach((f) {
          if (f != null) {
            total = total + double.parse(f);
            valor.text = total.toStringAsFixed(2);
          }
        });
      }
      if((int.parse(doc.data["quantidade"]) >0 || 
          (valido.isBefore(aindaValidoMax) && 
          valido.isAfter(aindaValidoMin))) &&
          (inicio.isAfter(ini))
      ){
        QuerySnapshot list2 = await Firestore.instance.collection("pacote")
            .where(
            "idPersonal", isEqualTo: user.uid)
            .where("type", isEqualTo: aux)
            .getDocuments();
        var a2 = list2.documents.map((f) {
          return f.data["price"];
        });
        a2.forEach((f) {
          if (f != null) {
            valorJaRecebido = valorJaRecebido+double.parse(f);
          }
        });
      }
    }

    valorJaRecebido = valorJaRecebido - total;

    valorRecebido.text = valorJaRecebido.toStringAsFixed(2);


  }

}
