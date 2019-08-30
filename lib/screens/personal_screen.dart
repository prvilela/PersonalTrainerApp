import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:personal_trainer/blocs/personal_bloc.dart';

class PersonalScreen extends StatefulWidget {

  final DocumentSnapshot personal;
  PersonalScreen({this.personal});

  @override
  _PersonalScreenState createState() => _PersonalScreenState(personal);
}

class _PersonalScreenState extends State<PersonalScreen> {

  final PersonalBloc _personalBloc;

  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  _PersonalScreenState(DocumentSnapshot personal):
      _personalBloc = PersonalBloc(personal);

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
          stream: _personalBloc.outCreated,
          builder: (context, snapshot) {
            return Text(snapshot.data ? "Editar Personal":"Cadastrar Aluno");
          }
        ),
        backgroundColor: Colors.deepOrange,
        centerTitle: true,
        actions: <Widget>[
         StreamBuilder<bool>(
            stream: _personalBloc.outCreated,
            initialData: false,
            builder: (context,snapshot){
              if(snapshot.data)
                return StreamBuilder<bool>(
                    stream: _personalBloc.outLoading,
                    initialData: false,
                    builder: (context, snapshot) {
                      return IconButton(icon: Icon(Icons.remove),
                        onPressed: snapshot.data ? null : (){
                          _personalBloc.deletePersonal();
                          Navigator.of(context).pop();
                        },
                      );
                    }
                );
              else return Container();
            },
          ),
          StreamBuilder<bool>(
            stream: _personalBloc.outLoading,
            builder: (context, snapshot) {
              return IconButton(icon: Icon(Icons.save),
                onPressed: savePersonal,
              );
            }
          )
        ],
      ),
      body: Form(
          key: _formKey,
          child: StreamBuilder<Map>(
            stream: _personalBloc.outData,
            builder: (context, snapshot) {
              if(!snapshot.hasData) return Container();
              return ListView(
                padding: EdgeInsets.all(16),
                children: <Widget>[
                  TextFormField(
                    style: _fieldStale,
                    initialValue: snapshot.data["email"],
                    decoration: _buildDecoratiom("Email"),
                    onSaved: _personalBloc.saveEmail,
                  ),
                  SizedBox(height: 8.0), //Adicionar espaçamento entre os TextFields
                  TextFormField(
                    style: _fieldStale,
                    initialValue: snapshot.data["password"],
                    decoration: _buildDecoratiom("Password"),
                    onSaved: _personalBloc.savePassword,
                    validator: (t){},
                  ),
                  SizedBox(height: 8.0),
                
                ],
              );
            }
          )
      ),
    );
  }

  void savePersonal() async{
    _formKey.currentState.save();

    _scaffoldKey.currentState.showSnackBar(
      SnackBar(
          content: Text("Salvando personal...",
            style: TextStyle(color: Colors.white),
          ),
        duration: Duration(minutes: 1),
        backgroundColor: Colors.deepOrange,
      )
    );

    bool success = await _personalBloc.savePersonal();

    _scaffoldKey.currentState.removeCurrentSnackBar();
    _scaffoldKey.currentState.showSnackBar(
      SnackBar(
          content: Text(success ? "Personal salvo":"Erro ao salvar",
            style: TextStyle(color: Colors.white),
          ),
        backgroundColor: Colors.deepOrange,
      )
    );
  }
}