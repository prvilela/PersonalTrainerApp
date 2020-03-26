import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:personal_trainer/blocs/pacote_bloc.dart';

class PacotesScreen extends StatefulWidget {

  final DocumentSnapshot pacote;

  PacotesScreen({this.pacote});

  @override
  _PacotesScreenState createState() => _PacotesScreenState(pacote);
}

class _PacotesScreenState extends State<PacotesScreen> {
  final PacoteBloc _pacoteBloc;
  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  _PacotesScreenState(DocumentSnapshot pacote):
      _pacoteBloc = PacoteBloc(pacote);

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

    final _fieldStale = TextStyle(color: Colors.orange[700], fontSize: 18);

    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: StreamBuilder<bool>(
          stream: _pacoteBloc.outCreated,
          initialData: false,
          builder: (context,snapshot){

            if(snapshot.data){
              _seg = true;
            }

            return Text(snapshot.data ? "Editar Pacote":"Cadastrar Pacote");

          },
        ),
        backgroundColor: Colors.deepOrange,
        centerTitle: true,
        actions: <Widget>[
          StreamBuilder<bool>(
            stream: _pacoteBloc.outCreated,
            initialData: false,
            builder: (context, snapshot){
              if(snapshot.data){
                return StreamBuilder<bool>(
                  stream: _pacoteBloc.outLoading,
                  initialData: false,
                    builder: (context, snapshot) {
                      return IconButton(icon: Icon(Icons.remove),
                        onPressed: snapshot.data ? null : (){
                          _pacoteBloc.deleteStudent();
                          Navigator.of(context).pop();
                        },
                      );
                    }
                );
              }
              else return Container();
            },
          ),
          StreamBuilder<bool>(
              stream: _pacoteBloc.outLoading,
              builder: (context, snapshot) {
                return IconButton(icon: Icon(Icons.save),
                  onPressed: savePacote,
                );
              }
          )
        ],
      ),
      body: Form(
        key: _formKey,
          child: StreamBuilder<Map>(
            stream: _pacoteBloc.outData,
            builder: (context, snapshot){
              if(_seg){
                inicializar(snapshot);
              }
              if(!snapshot.hasData) return Container();
              return ListView(
                padding: EdgeInsets.all(16),
                children: <Widget>[
                  TextFormField(
                    style: _fieldStale,
                    initialValue: snapshot.data["nameStudent"],
                    decoration: _buildDecoratiom("Nome Aluno"),
                    //controller: name,
                    onSaved: _pacoteBloc.saveNameStudent,
                    ),
                  SizedBox(height: 8.0),
                  TextFormField(
                    style: _fieldStale,
                    initialValue: snapshot.data["type"],
                    decoration: _buildDecoratiom("Tipo Pacote"),
                    //controller: name,
                    onSaved: _pacoteBloc.saveType,
                  ),
                  SizedBox(height: 8.0),
                  TextFormField(
                    style: _fieldStale,
                    initialValue: snapshot.data["price"],
                    decoration: _buildDecoratiom("Preço"),
                    //controller: name,
                    onSaved: _pacoteBloc.savePrice,
                  ),
                  SizedBox(height: 8.0),
                  TextFormField(
                    style: _fieldStale,
                    initialValue: snapshot.data["time"],
                    decoration: _buildDecoratiom("Horario"),
                    keyboardType: TextInputType.datetime,
                    //controller: name,
                    onSaved: _pacoteBloc.saveTime,
                  ),
                  SizedBox(height: 8.0),
                  TextFormField(
                    style: _fieldStale,
                    initialValue: snapshot.data["place"],
                    decoration: _buildDecoratiom("Local"),
                    //controller: name,
                    onSaved: _pacoteBloc.savePlace,
                  ),
                  SizedBox(height: 8.0),
                  TextFormField(
                    style: _fieldStale,
                    initialValue: snapshot.data["duration"],
                    decoration: _buildDecoratiom("Duração(em minutos)"),
                    keyboardType: TextInputType.datetime,
                    //controller: name,
                    onSaved: _pacoteBloc.saveDuration,
                  ),
                  SizedBox(height: 8.0),

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
                  FutureBuilder(
                      future: FirebaseAuth.instance.currentUser(),
                      builder: (context, AsyncSnapshot<FirebaseUser> snapshot) {
                        if (snapshot.hasData) {
                          _pacoteBloc.saveId(snapshot.data.uid);
                          return Text("");
                        }else
                          return null;
                      }

                  ),
                ],
              );
            },
          )
      ),
    );
  }

  void inicializar(AsyncSnapshot snapshot){
   if(snapshot.hasData){
     days["segunda"] = snapshot.data["days"]["segunda"];
     days["terca"] = snapshot.data["days"]["terca"];
     days["quarta"] = snapshot.data["days"]["quarta"];
     days["quinta"] = snapshot.data["days"]["quinta"];
     days["sexta"] = snapshot.data["days"]["sexta"];
     days["sabado"] = snapshot.data["days"]["sabado"];
     days["domingo"] = snapshot.data["days"]["domingo"];
   }
  }

  void savePacote() async {

    _pacoteBloc.saveDays(days);

    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();

      _scaffoldKey.currentState.showSnackBar(
          SnackBar(
            content: Text("Salvando pacote...",
              style: TextStyle(color: Colors.white),
            ),
            duration: Duration(minutes: 1),
            backgroundColor: Colors.black,
          )
      );

      bool success = await _pacoteBloc.savePacote();
      _scaffoldKey.currentState.removeCurrentSnackBar();
      _scaffoldKey.currentState.showSnackBar(
          SnackBar(
            content: Text(success ? "Pacote salvo" : "Erro ao salvar",
              style: TextStyle(color: Colors.white),
            ),
            backgroundColor: Colors.black,
          )
      );
    }
  }

}
