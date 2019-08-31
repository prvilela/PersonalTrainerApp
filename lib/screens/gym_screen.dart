import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:brasil_fields/brasil_fields.dart';
import 'package:personal_trainer/blocs/gym_bloc.dart';

class GymScreen extends StatefulWidget {

  final DocumentSnapshot gym;

  GymScreen({this.gym});

  @override
  _GymScreenState createState() => _GymScreenState(gym);
}

class _GymScreenState extends State<GymScreen> {

  final GymBloc _gymBloc;

  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  _GymScreenState(DocumentSnapshot gym):
      _gymBloc = GymBloc(gym);

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
          stream: _gymBloc.outCreated,
          builder: (context, snapshot) {
            return Text(snapshot.data ? "Editar Academia":"Cadastrar Academia");
          }
        ),
        backgroundColor: Colors.deepOrange,
        centerTitle: true,
        actions: <Widget>[
         StreamBuilder<bool>(
            stream: _gymBloc.outCreated,
            initialData: false,
            builder: (context,snapshot){
              if(snapshot.data)
                return StreamBuilder<bool>(
                    stream: _gymBloc.outLoading,
                    initialData: false,
                    builder: (context, snapshot) {
                      //remover academia (colocar confirma ação futuramente)
                      return IconButton(icon: Icon(Icons.remove),
                        onPressed: snapshot.data ? null : (){
                          _gymBloc.deleteGym();
                          Navigator.of(context).pop();
                        },
                      );
                    }
                );
              else return Container();
            },
          ),
          //salvar academia
          StreamBuilder<bool>(
            stream: _gymBloc.outLoading,
            builder: (context, snapshot) {
              return IconButton(icon: Icon(Icons.save),
                onPressed: saveGym,
              );
            }
          )
        ],
      ),
      body: Form(
          key: _formKey,
          child: StreamBuilder<Map>(
            stream: _gymBloc.outData,
            builder: (context, snapshot) {
              if(!snapshot.hasData) return Container();
              return ListView(
                padding: EdgeInsets.all(16),
                children: <Widget>[
                  TextFormField(
                    style: _fieldStale,
                    initialValue: snapshot.data["name"],
                    decoration: _buildDecoratiom("Nome"),
                    onSaved: _gymBloc.saveName,
                  ),
                  SizedBox(height: 8.0), //Adicionar espaçamento entre os TextFields
              
                  TextFormField(
                    style: _fieldStale,
                    initialValue: snapshot.data["phone"],
                    decoration: _buildDecoratiom("Telefone"),
                    //onSaved: _gymBloc.saveName,
                  ),
                  SizedBox(height: 8.0),

                  TextFormField(
                    style: _fieldStale,
                    initialValue: snapshot.data["endereço"],
                    decoration: _buildDecoratiom("Endereço"),
                    //onSaved: _gymBloc.saveName,
                  ),
                 
                ],
              );
            }
          )
      ),
    );

  }

  void saveGym() async{
    _formKey.currentState.save();

    _scaffoldKey.currentState.showSnackBar(
      SnackBar(
          content: Text("Salvando academia...",
            style: TextStyle(color: Colors.white),
          ),
        duration: Duration(minutes: 1),
        backgroundColor: Colors.deepOrange,
      )
    );

    bool success = await _gymBloc.saveGym();

    _scaffoldKey.currentState.removeCurrentSnackBar();
    _scaffoldKey.currentState.showSnackBar(
      SnackBar(
          content: Text(success ? "Academia salva":"Erro ao salvar",
            style: TextStyle(color: Colors.white),
          ),
        backgroundColor: Colors.deepOrange,
      )
    );
  }
}
