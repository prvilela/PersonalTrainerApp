import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:personal_trainer/Widget/pagamentos_tile.dart';
import 'package:personal_trainer/Widget/total_de_vendas.dart';
import 'package:personal_trainer/blocs/getStudent_bloc.dart';
import 'package:personal_trainer/home.dart';
class PagamentosTab extends StatefulWidget {
  @override
  _PagamentosTabState createState() => _PagamentosTabState();
}

class _PagamentosTabState extends State<PagamentosTab> with AutomaticKeepAliveClientMixin {

  final name = TextEditingController();
  final valor = TextEditingController();
  double total = 0;

  @override
  Widget build(BuildContext context) {
    super.build(context);


    final _studentBloc = BlocProvider.of<GetStudentBloc>(context);



    return Padding(
      padding: EdgeInsets.symmetric(vertical: 16),
      child: GestureDetector(
        onPanUpdate: (details){
          if (details.delta.dx < 0){
            print("Esquerda vai para tela da direita");
          }
          if (details.delta.dx > 0){
            print("Direita vai para tela da esquerda");
            //aqui oh
            Navigator.push(context,
              MaterialPageRoute(builder: (context) => TelaPrincipal()),
            );
          }
        },

        child: StreamBuilder<List>(
          stream: _studentBloc.outStudents,
          builder: (context,snapshot){
           // pegarDadosPagamento(snapshot);
            if(!snapshot.hasData){
              return Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation(Colors.deepOrange),
                ),
              );
            }else if(snapshot.data.length == 0){
              return Center(
                child: Text("Nenhum aluno encontrado!",
                  style: TextStyle(color: Colors.pinkAccent),
                ),
              );
            }else{
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Container(
                    child: TotalDeVendas(snapshot)
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 15),
                    child: Divider(color: Colors.grey[500],)
                  ),
                  Container(
                    margin: const EdgeInsets.only(left: 20, top: 8, bottom: 8),
                    child: Text("Vendas nos proximos 5 dias:",
                    style: TextStyle(color: Colors.deepOrange),
                    ),
                  ),
                  Expanded(
                    child: ListView.builder(

                      itemCount: snapshot.data.length,
                        itemBuilder: (context, index){

                          var now = new DateTime.now();
                          var maior = now.add(new Duration(days: 5));
                          var comparar = new DateTime(now.year,now.month,now.day);
                          var compararMaior = new DateTime(maior.year,maior.month,maior.day);
                          String data = snapshot.data[index]["dataCobranca"].toString();
                          var a = data.split(" ");
                          String b = a[0];
                          String c = a[1];
                          var aux = b.split("-");
                          var cobranca = new DateTime(int.parse(aux[0]),int.parse(aux[1]),int.parse(aux[2]));
                          //print(cobranca);
                          if(int.parse(snapshot.data[index]["quantidade"])>0 && (cobranca.isAfter(comparar)||cobranca.isAtSameMomentAs(comparar)) &&(cobranca.isBefore(compararMaior)||cobranca.isAtSameMomentAs(compararMaior))){
                            return PagamentosTile(snapshot.data[index],valor);
                          }else if(int.parse(snapshot.data[index]["quantidade"])>0 && (cobranca.isBefore(compararMaior)||cobranca.isAtSameMomentAs(compararMaior))){
                            return PagamentosTile(snapshot.data[index],valor);
                          }
                          return Text("");


                        }
                    ),
                  ),
                ],
              );
            }
          },
        ),

      ),
    );
  }

   pegarDadosPagamento(AsyncSnapshot student) async{
     FirebaseUser user = await FirebaseAuth.instance.currentUser();
     String uid = user.uid;

     if(student.hasData) {
       for (DocumentSnapshot doc in student.data) {


         String plano = doc['plano'];
         String aux = plano.replaceAll(" ", "");
         QuerySnapshot list = await Firestore.instance.collection("pacote").
         where("idPersonal", isEqualTo: user.uid)
             .where("type", isEqualTo: aux)
             .getDocuments();
         var a = list.documents.map((f) {
           return f.data["price"];
         });
         a.forEach((f) {
           if (f != null) {
             total = total + double.parse(f);
           }
         });
         valor.text = total.toString();

       }

     }


    /*
    String plano = student.data["plano"];
    print(plano);
    String aux = plano.replaceAll(" ", "");
    QuerySnapshot list = await Firestore.instance.collection("pacote").where("idPersonal", isEqualTo: user.uid).where("type", isEqualTo: aux).getDocuments();
    var a = list.documents.map((f){
      return f.data["price"];

    });
    a.forEach((f){
      if(f!=null){

        name.text = f;
      }
    });*/



  }

  @override
  bool get wantKeepAlive => true;

}

