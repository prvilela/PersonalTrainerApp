import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:brasil_fields/brasil_fields.dart';
import 'package:personal_trainer/blocs/student_bloc.dart';

class StudentScreen extends StatefulWidget {

  final DocumentSnapshot student;

  StudentScreen({this.student});

  @override
  _StudentScreenState createState() => _StudentScreenState(student);
}

class _StudentScreenState extends State<StudentScreen> {

  final StudentBloc _studentBloc;

  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  _StudentScreenState(DocumentSnapshot student):
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

    final _fieldStale = TextStyle(color: Colors.orange[700], fontSize: 18);

    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: StreamBuilder<bool>(
          stream: _studentBloc.outCreated,
          builder: (context, snapshot) {
            return Text(snapshot.data ? "Editar Aluno":"Cadastrar Aluno");
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
                onPressed: saveStudent,
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
                    initialValue: snapshot.data["name"],
                    decoration: _buildDecoratiom("Nome"),
                    onSaved: _studentBloc.saveName,
                  ),
                  SizedBox(height: 8.0), //Adicionar espaçamento entre os TextFields
                  TextFormField(
                    style: _fieldStale,
                    initialValue: snapshot.data["birthday"],
                    decoration: _buildDecoratiom("Data de Nascimento"),
                    keyboardType: TextInputType.numberWithOptions(),
                    inputFormatters: [
                      WhitelistingTextInputFormatter.digitsOnly,
                      DataInputFormatter(),
                    ],
                    onSaved: _studentBloc.saveBirthday,
                    validator: (t){},
                  ),
                  SizedBox(height: 8.0),
                  TextFormField(
                    style: _fieldStale,
                    keyboardType: TextInputType.numberWithOptions(),
                    initialValue: snapshot.data["cpf"],
                    inputFormatters: [
                      WhitelistingTextInputFormatter.digitsOnly,
                      CpfInputFormatter(),
                    ],
                    decoration: _buildDecoratiom("CPF"),
                    onSaved: _studentBloc.saveCpf,
                    validator: (t){},
                  ),
                  SizedBox(height: 8.0),
                  TextFormField(
                    style: _fieldStale,
                    initialValue: snapshot.data["email"],
                    decoration: _buildDecoratiom("E-mail"),
                    onSaved: _studentBloc.saveEmail,
                    validator: (t){},
                  ),
                  SizedBox(height: 8.0),
                  TextFormField(
                    style: _fieldStale,
                    keyboardType: TextInputType.phone,
                    initialValue: snapshot.data["phone"],
                    inputFormatters: [
                      WhitelistingTextInputFormatter.digitsOnly,
                      TelefoneInputFormatter(digito_9: true),
                    ],
                    decoration: _buildDecoratiom("Telefone"),
                    onSaved: _studentBloc.savePhone,
                    validator: (t){},
                  ),
                  SizedBox(height: 8.0),
                  TextFormField(
                    style: _fieldStale,
                    initialValue: snapshot.data["goal"],
                    decoration: _buildDecoratiom("Objetivos"),
                    onSaved: _studentBloc.saveGoal,
                    validator: (t){},
                  ),
                  SizedBox(height: 8.0),
                  TextFormField(
                    style: _fieldStale,
                    initialValue: snapshot.data["restrictions"],
                    decoration: _buildDecoratiom("Restrições"),
                    maxLines: 4,
                    onSaved: _studentBloc.saveRestrictions,
                    validator: (t){},
                  ),
                ],
              );
            }
          )
      ),
    );

  }

  void saveStudent() async{
    _formKey.currentState.save();

    _scaffoldKey.currentState.showSnackBar(
      SnackBar(
          content: Text("Salvando aluno...",
            style: TextStyle(color: Colors.white),
          ),
        duration: Duration(minutes: 1),
        backgroundColor: Colors.deepOrange,
      )
    );

    bool success = await _studentBloc.saveStudent();

    _scaffoldKey.currentState.removeCurrentSnackBar();
    _scaffoldKey.currentState.showSnackBar(
      SnackBar(
          content: Text(success ? "Aluno salvo":"Erro ao salvar",
            style: TextStyle(color: Colors.white),
          ),
        backgroundColor: Colors.deepOrange,
      )
    );
  }
}
