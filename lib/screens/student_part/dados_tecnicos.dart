import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:personal_trainer/blocs/student_bloc.dart';
import 'package:brasil_fields/brasil_fields.dart';
import 'package:personal_trainer/tabs/gym_tab.dart';
import 'package:personal_trainer/validators/student_validators.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

import '../../time.dart';

class DadosTecnicos extends StatefulWidget {

  Map<String, dynamic> campo;
  final DocumentSnapshot student;

  DadosTecnicos({this.student,this.campo});

  @override
  _DadosTecnicosState createState() => _DadosTecnicosState(student, campo);
}

class _DadosTecnicosState extends State<DadosTecnicos> with StudentValidator {

  final StudentBloc _studentBloc;
  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  GymTabState gts = new GymTabState();

  int campoStatus;
  TimeState t1 = new TimeState();
  TextEditingController academia = new TextEditingController();
  TextEditingController plano = new TextEditingController();
  TextEditingController data = new TextEditingController();
  TextEditingController hora = new TextEditingController();
  var retorno;

  bool _seg = false;
  Map<String, bool> days ={
    "segunda": false,
    "terca"  : false,
    "quarta" : false,
    "quinta" : false,
    "sexta"  : false,
    "sabado" : false,
    "domingo": false
  };

  Map<String, dynamic> campos;

  _DadosTecnicosState(DocumentSnapshot student, this.campos):
      _studentBloc = StudentBloc(student);

  @override
  Widget build(BuildContext context) {

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


    InputDecoration _buildDecorationGym(String label) {
      return InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: Colors.deepOrange[700]),
        suffixIcon: IconButton(
            icon: Icon(Icons.search),
            onPressed: (){
              listarAcademias(context);
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


    final _fieldStale = TextStyle(color: Colors.orange[700], fontSize: 18);


    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: StreamBuilder<bool>(
            stream: _studentBloc.outCreated,
            initialData: false,
            builder: (context, snapshot) {

              if(snapshot.data){
                _seg = true;
              }

              return Text("Cadastrar Aluno");
            }
        ),
        backgroundColor: Colors.deepOrange,
        centerTitle: true,
        actions: <Widget>[
          StreamBuilder<bool>(
            stream: _studentBloc.outCreated,
            initialData: false,
            builder: (context,snapshot){

              if(snapshot.data)
                return StreamBuilder<bool>(
                    stream: _studentBloc.outLoading,
                    initialData: false,
                    builder: (context, snapshot) {
                      return IconButton(icon: Icon(Icons.remove),
                        onPressed: snapshot.data ? null : (){
                          _studentBloc.deleteStudent();
                          Navigator.of(context).pop();
                        },
                      );
                    }
                );
              else return Container();
            },
          ),
          StreamBuilder<bool>(
              stream: _studentBloc.outLoading,
              builder: (context, snapshot) {
                return IconButton(icon: Icon(Icons.save),
                  onPressed: (){
                  _studentBloc.saveId(campos["id"]);
                  _studentBloc.saveBirthday(campos["data"]);
                  _studentBloc.saveCpf(campos["cpf"]);
                  _studentBloc.saveEmail(campos["email"]);
                  _studentBloc.saveGender(campos["sexo"]);
                  _studentBloc.saveName(campos["nome"]);
                  _studentBloc.savePhone(campos["celular"]);
                  _studentBloc.saveStatus(campos["status"]);
                  saveStudent();
                  },
                );
              }
          )
        ],
      ),
      body: Form(
          key: _formKey,
          child: StreamBuilder<Map>(
              stream: _studentBloc.outData,
              builder: (context, snapshot) {
                if(!snapshot.hasData) return Container();
                return ListView(
                  padding: EdgeInsets.all(16),
                  children: <Widget>[
                    TextFormField(
                      style: _fieldStale,
                      initialValue: snapshot.data["gym"],
                      decoration: _buildDecorationGym("Academia"),
                      onSaved: _studentBloc.saveGym,
                      //controller: academia,
                    ),
                    SizedBox(height: 8.0),

                    TextFormField(
                      initialValue: snapshot.data["hora"],
                      onSaved: _studentBloc.saveHora,
                      //controller: hora,
                      decoration: _buildDecorationTime("Horario:"),
                      keyboardType: TextInputType.numberWithOptions(),
                      inputFormatters: [
                        WhitelistingTextInputFormatter.digitsOnly,
                        LengthLimitingTextInputFormatter(4)
                      ],
                      //validator: validateHour,
                    ),
                    SizedBox(height: 8.0),

                    TextFormField(
                      style: _fieldStale,
                      initialValue: snapshot.data["goal"],
                      decoration: _buildDecoratiom("Objetivos"),
                      //controller: objetivos,
                      maxLines: 2,
                      onSaved: _studentBloc.saveGoal,
                    ),
                    SizedBox(height: 8.0),

                    TextFormField(
                      style: _fieldStale,
                      initialValue: snapshot.data["restrictions"],
                      decoration: _buildDecoratiom("Restrições"),
                      //controller: restrictions,
                      maxLines: 2,
                      onSaved: _studentBloc.saveRestrictions,
                    ),
                    SizedBox(height: 8.0),

                    TextFormField(
                      style: _fieldStale,
                      initialValue: snapshot.data["plano"],
                      decoration: _buildDecorationGym("Plano"),
                      onSaved: _studentBloc.savePlano,
                      //controller: plano,
                    ),
                    SizedBox(height: 8.0),
                    Text("Dias de aula:", style: TextStyle(color: Colors.orange[700]),),

                    Row(
                      children: <Widget>[
                        Text("Segunda", style: _fieldStale,),
                        Checkbox(
                          onChanged: (bool value) {
                            setState(() {
                              days["segunda"] = value;
                            });
                          },
                          value: days["segunda"],
                          activeColor: Colors.deepOrange,
                        ),
                        SizedBox(width: 6.0),
                        Text("Terça", style: _fieldStale,),
                        Checkbox(
                          onChanged: (bool value) {
                            setState(() {
                              days["terca"] = value;
                            });
                          },
                          value: days["terca"],
                          activeColor: Colors.deepOrange,
                        ),
                        SizedBox(width: 7.0),
                        Text("Quarta", style: _fieldStale,),
                        Checkbox(
                          onChanged: (bool value) {
                            setState(() {
                              days["quarta"] = value;
                            });
                          },
                          value: days["quarta"],
                          activeColor: Colors.deepOrange,
                        ),
                      ],
                    ),
                    Row(
                      children: <Widget>[
                        Text("Quinta", style: _fieldStale,),
                        Checkbox(
                          onChanged: (bool value) {
                            setState(() {
                              days["quinta"] = value;
                            });
                          },
                          value: days["quinta"],
                          activeColor: Colors.deepOrange,
                        ),
                        SizedBox(width: 8.0),
                        Text("Sexta", style: _fieldStale,),
                        Checkbox(
                          onChanged: (bool value) {
                            setState(() {
                              days["sexta"] = value;
                            });
                          },
                          value: days["sexta"],
                          activeColor: Colors.deepOrange,
                        ),
                        SizedBox(width: 8.0),
                        Text("Sabado", style: _fieldStale,),
                        Checkbox(
                          onChanged: (bool value) {
                            setState(() {
                              days["sabado"] = value;
                            });
                          },
                          value: days["sabado"],
                          activeColor: Colors.deepOrange,
                        ),
                      ],
                    ),

                    Row(
                      children: <Widget>[
                        Text("Domingo", style: _fieldStale,),
                        Checkbox(
                          onChanged: (bool value) {
                            setState(() {
                              days["domingo"] = value;
                            });
                          },
                          value: days["domingo"],
                          activeColor: Colors.deepOrange,
                        ),
                      ],
                    ),
                  ],
                );
              }

          )
      ),
    );
  }



  atualizarNomeAcademia(name){
    setState(() async {
      retorno = name;
      academia.text = await name;
    });

  }



  attCampoStatus(int value){
    setState(() {
      campoStatus = 0;
    });
    _studentBloc.saveStatus("Ativo");
  }

  attCampoStatus2(int value){
    setState(() {
      campoStatus = 1;
    });
    _studentBloc.saveStatus("Não Ativo");
  }


  void saveStudent() async {

    _studentBloc.saveDays(days);

    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();

      _scaffoldKey.currentState.showSnackBar(
          SnackBar(
            content: Text("Salvando aluno...",
              style: TextStyle(color: Colors.white),
            ),
            duration: Duration(minutes: 1),
            backgroundColor: Colors.black,
          )
      );

      bool success = await _studentBloc.saveStudent();
      _scaffoldKey.currentState.removeCurrentSnackBar();
      _scaffoldKey.currentState.showSnackBar(
          SnackBar(
            content: Text(success ? "Aluno salvo" : "Erro ao salvar",
              style: TextStyle(color: Colors.white),
            ),
            backgroundColor: Colors.black,
          )
      );

    }
  }

  InputDecoration _buildDecorationDate(String label) {
    return InputDecoration(
      labelText: label,
      suffixIcon: IconButton(
        icon: Icon(Icons.calendar_today),
        onPressed: () async =>
        data.text = await t1.selectDate(context) as String,

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
        hora.text = await t1.selectTime(context) as String,

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


  listarAcademias(BuildContext context) async{
    FirebaseUser user = await FirebaseAuth.instance.currentUser();
    String sid = user.uid;
    print(sid);
    QuerySnapshot list = await Firestore.instance.collection("gym").where("id", isEqualTo: sid).getDocuments();
    var names = list.documents.map((doc) => doc.data['name']);
    var concatenar1 = " $names";
    var concatenar2 = concatenar1.replaceAll('(','');
    var concatenar3 = concatenar2.replaceAll(')','');
    var concatenar4 = concatenar3.split(",");
    print(names);
    exibirAlertaAcademias(concatenar4);
  }

  exibirAlertaAcademias(names){
    Color color1 = Colors.black;
    Color color2 = Colors.deepOrange;
    Alert(
      context: context,
      title: "Academias cadastradas",
      content: Container(
          height: MediaQuery.of(context).size.height  * 0.4,
          width: MediaQuery.of(context).size.height  * 0.3,
          child:
          ListView.builder(
              shrinkWrap: true,
              itemCount: names.length,
              itemBuilder: (BuildContext context, int index){
                return
                  FlatButton(
                      textColor: color1,
                      highlightColor: Colors.orange,
                      child: Text(names[index], style: TextStyle(fontSize: 20,),),
                      onPressed: (){
                        var nome = names[index];
                        academia.text = "$nome";
                        setState(() {
                          names[index] = Colors.red;
                          color1 = color2;
                        });
                      }
                  );
              }

          )
      ),
      buttons: [
        DialogButton(
          child: Text(
            "Cancelar",
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
          onPressed: () {
            Navigator.pop(context);
            academia.text = "";
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



}
