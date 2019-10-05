import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:brasil_fields/brasil_fields.dart';
import 'package:personal_trainer/time.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class AgendarTreinoScreen extends StatefulWidget{
  final DocumentSnapshot agendar;
  AgendarTreinoScreen ({this.agendar});

_AgendarTreinoScreenState createState() => _AgendarTreinoScreenState(agendar);

}

class _AgendarTreinoScreenState extends State<AgendarTreinoScreen> with AutomaticKeepAliveClientMixin{
  _AgendarTreinoScreenState(DocumentSnapshot agendar);

  TimeState t1 = new TimeState();
  final controllerCpf = TextEditingController();
  final controllerDate = TextEditingController();
  final controllerTime = TextEditingController();

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return Scaffold(
      appBar: AppBar(title: Text("Agendar Treino"),
      backgroundColor: Colors.deepOrange,
      actions: <Widget>[
        StreamBuilder<bool>(
            builder: (context, snapshot) {
              return IconButton(icon: Icon(Icons.save),
                onPressed: (){},
              );
            }
          )

      ],

      ),
      body: Container(
        padding: EdgeInsets.all(15),
        child: ListView(
          children: <Widget>[
            TextFormField(
              controller: controllerCpf,
              decoration: _buildDecoration("CPF:"),
              inputFormatters:[
                WhitelistingTextInputFormatter.digitsOnly,
                CpfInputFormatter(),
              ],

            ),
            SizedBox(height: 8.0),

            TextFormField(
              controller: controllerDate,
              decoration: _buildDecorationDate("Data:"),
              keyboardType: TextInputType.numberWithOptions(),
              inputFormatters: [
                WhitelistingTextInputFormatter.digitsOnly,
                DataInputFormatter(),
              ],
            ),
            SizedBox(height: 8.0), 

            TextFormField(
              controller: controllerTime,
              decoration: _buildDecorationTime("Horario:"),
              keyboardType: TextInputType.numberWithOptions(),                            
              inputFormatters: [
                WhitelistingTextInputFormatter.digitsOnly, 
                LengthLimitingTextInputFormatter(4)                                                    
              ],
            ),
            SizedBox(height: 8.0),

            TextFormField(
              decoration: _buildDecoration("Academia:"),
            ),

          ],
        ),
        
      ),
      
    );
    
  }

  InputDecoration _buildDecoration(String label) {
      return InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: Colors.deepOrange[700]),
        suffixIcon: IconButton(
          icon: Icon(Icons.search),
          onPressed: (){
            consultarCpf(context);
          }
                          
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.orange, width: 1.0),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.orange, width: 1.0),
        ),
      );
    }

    InputDecoration _buildDecorationDate(String label) {
      return InputDecoration(
        labelText: label,
        suffixIcon: IconButton(
          icon: Icon(Icons.calendar_today),
          onPressed: () async => 
          controllerDate.text = await t1.selectDate(context) as String,        
                   
        ),
        labelStyle: TextStyle(color: Colors.deepOrange[700]),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.orange, width: 1.0),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.orange, width: 1.0),
        ),
      );
    }

    InputDecoration _buildDecorationTime(String label){
            return InputDecoration(
              labelText: label,
              counterText: null,
              suffixIcon: IconButton(
                icon: Icon(Icons.access_time),
                onPressed: () async =>
                controllerTime.text = await t1.selectTime(context) as String,
              
        ),
        labelStyle: TextStyle(color: Colors.deepOrange[700]),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.orange, width: 1.0),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.orange, width: 1.0),
        ),
      );
    }

//man dps tem q add aquele codigo q tu fez de pegar só os alunos do email logado no momento aqui.
    consultarCpf(BuildContext context) async{
      FirebaseAuth.instance.currentUser();

      QuerySnapshot list = await Firestore.instance.collection("student").where(
      "cpf", isEqualTo: controllerCpf.text).getDocuments();
     
        var teste1 = list.documents.map((doc) => doc.data['cpf']);
        var teste2 = list.documents.map((doc) => doc.data['name']);
        var teste3 = list.documents.map((doc) => doc.data['email']);
        var teste4 = list.documents.map((doc) => doc.data['phone']);
        var concatenar = "CPF: $teste1 \n" + "Nome: $teste2 \n" + "Email: $teste3 \n" + "Telefone: $teste4 \n"; 
        var concatenar2 = concatenar.replaceAll('(','');
        var concatenar3 = concatenar2.replaceAll(')','');
        exibirDialogAluno(concatenar3);     
    }

    exibirDialogAluno(String concatenar){
      Alert(
      context: context,
      title: "Dados do Aluno",
      content: Container(
        child:
      Text(concatenar),
      ),
      buttons: [
        DialogButton(
          child: Text(
            "Cancelar",
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
          onPressed: () { 
            Navigator.pop(context);
            controllerCpf.text = "";
          },
          color: Color.fromRGBO(189, 13, 13, 1.0),
        ), 
        DialogButton(
          child: Text(
            "Confirmar",
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
          onPressed: () => Navigator.pop(context),
            color: Color.fromRGBO(30, 200, 30, 1.0)
        )
      ],
    ).show();
      
    }

  @override
  bool get wantKeepAlive => true;
}


